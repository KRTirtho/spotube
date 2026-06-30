/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package dev.krtirtho.spotube.modules.downloads

import co.touchlab.kermit.Logger
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.paths.Paths
import dev.krtirtho.spotube.core.server.StreamInfo
import dev.krtirtho.spotube.core.server.StreamingUrlRepository
import dev.krtirtho.spotube.modules.settings.SettingsRepository
import io.ktor.client.HttpClient
import io.ktor.client.plugins.HttpTimeout
import io.ktor.client.request.get
import io.ktor.client.request.head
import io.ktor.client.request.headers
import io.ktor.client.statement.bodyAsChannel
import io.ktor.http.HttpHeaders
import io.ktor.http.contentLength
import io.ktor.utils.io.readRemaining
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.io.readByteArray
import okio.FileSystem
import okio.Path
import okio.Path.Companion.toPath
import okio.SYSTEM
import okio.buffer
import okio.use
import kotlin.time.Clock

data class DownloadItem(
    val id: String,
    val title: String,
    val artists: String,
    val album: String?,
    val status: DownloadStatus = DownloadStatus.Queued,
    val progress: Float = 0f,
    val totalBytes: Long = 0L,
    val downloadedBytes: Long = 0L,
    val errorMessage: String? = null,
    val track: MetadataTrack? = null,
)

sealed interface DownloadStatus {
    data object Queued : DownloadStatus
    data object Downloading : DownloadStatus
    data object Completed : DownloadStatus
    data class Failed(val error: String) : DownloadStatus
    data object Cancelled : DownloadStatus
}

class DownloadManager(
    private val settingsRepository: SettingsRepository,
    private val paths: Paths,
    private val streamingUrlRepository: StreamingUrlRepository
) {
    companion object {
        const val MAX_CONCURRENT_DOWNLOADS = 4
        private const val SEGMENT_COUNT = 4
        private const val CHUNK_SIZE = 256 * 1024
    }

    private val logger = Logger.withTag("DownloadManager")
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
    private val fileSystem = FileSystem.SYSTEM
    private val queueMutex = Mutex()

    private val httpClient = HttpClient {
        install(HttpTimeout) {
            requestTimeoutMillis = 300_000
            connectTimeoutMillis = 30_000
        }
        expectSuccess = false
    }

    private val downloadsMap = MutableStateFlow<Map<String, DownloadItem>>(emptyMap())

    val downloadsFlow: StateFlow<List<DownloadItem>> = downloadsMap
        .map { map -> map.values.sortedByDescending { it.id } }
        .stateIn(scope, SharingStarted.WhileSubscribed(5000), emptyList())

    private val cachedDownloadFolder = MutableStateFlow<String?>(null)

    private val activeJobs = mutableMapOf<String, Job>()

    init {
        scope.launch {
            settingsRepository.userSettings.collect { settings ->
                cachedDownloadFolder.value = settings.overloadedDownloadFolder
            }
        }
    }

    fun enqueue(track: MetadataTrack) {
        val timestamp = Clock.System.now().toEpochMilliseconds()
        val id = "${track.id}_$timestamp"
        val artistNames = track.artists.joinToString(", ") { it.name }

        val item = DownloadItem(
            id = id,
            title = track.title,
            artists = artistNames,
            album = track.album?.title,
            track = track,
        )

        downloadsMap.update { it + (id to item) }
        scope.launch { processQueue() }
    }

    fun cancel(id: String) {
        activeJobs[id]?.cancel()
        activeJobs.remove(id)
        downloadsMap.update { map ->
            map[id]?.let { item ->
                map + (id to item.copy(status = DownloadStatus.Cancelled))
            } ?: map
        }
        cleanupTempFiles(id)
    }

    fun retry(id: String) {
        val item = downloadsMap.value[id] ?: return
        if (item.status !is DownloadStatus.Failed && item.status != DownloadStatus.Cancelled) return

        downloadsMap.update { map ->
            map + (id to item.copy(
                status = DownloadStatus.Queued,
                progress = 0f,
                downloadedBytes = 0L,
                errorMessage = null,
            ))
        }
        scope.launch { processQueue() }
    }

    fun remove(id: String) {
        cancel(id)
        downloadsMap.update { it - id }
    }

    fun clearCompleted() {
        downloadsMap.update { map ->
            map.filter { it.value.status != DownloadStatus.Completed }
        }
    }

    private suspend fun processQueue() {
        queueMutex.withLock {
            while (true) {
                val activeCount = activeJobs.values.count { it.isActive }
                if (activeCount >= MAX_CONCURRENT_DOWNLOADS) break

                val nextItem =
                    downloadsMap.value.values.firstOrNull { it.status == DownloadStatus.Queued }
                        ?: break

                val id = nextItem.id
                downloadsMap.update { map ->
                    map + (id to nextItem.copy(status = DownloadStatus.Downloading))
                }

                val job = scope.launch { executeDownload(nextItem) }
                activeJobs[id] = job
            }
        }
    }

    private suspend fun executeDownload(item: DownloadItem) {
        val track = item.track ?: run {
            logger.e { "Download item has no track metadata" }
            downloadsMap.update { map ->
                map[item.id]?.let {
                    map + (item.id to it.copy(
                        status = DownloadStatus.Failed("No track metadata"),
                        errorMessage = "No track metadata",
                    ))
                } ?: map
            }
            return
        }

        try {
            val streamInfo = streamingUrlRepository.resolveStreamInfo(track)
            if (streamInfo == null) {
                logger.w { "Could not resolve stream URL for ${track.title}" }
                downloadsMap.update { map ->
                    map[item.id]?.let {
                        map + (item.id to it.copy(
                            status = DownloadStatus.Failed("Could not resolve stream URL"),
                            errorMessage = "Could not resolve stream URL. Try playing the track first.",
                        ))
                    } ?: map
                }
                return
            }

            val url = streamInfo.url

            val filename = buildFilename(item, streamInfo)

            val downloadDir = resolveDownloadDir()
            fileSystem.createDirectories(downloadDir)

            val tempDir = FileSystem.SYSTEM_TEMPORARY_DIRECTORY / "spotube_downloads".toPath()
            fileSystem.createDirectories(tempDir)

            val (totalSize, supportsRanges) = probeUrl(url)

            if (totalSize > 0 && supportsRanges) {
                executeMultiSegmentDownload(url, filename, item, tempDir, downloadDir, totalSize)
            } else {
                executeSingleConnectionDownload(url, filename, item, tempDir, downloadDir)
            }

            applyMetadata(item, filename, downloadDir)

            downloadsMap.update { map ->
                map[item.id]?.let {
                    map + (item.id to it.copy(status = DownloadStatus.Completed, progress = 1f))
                } ?: map
            }
        } catch (e: CancellationException) {
            downloadsMap.update { map ->
                map[item.id]?.let {
                    map + (item.id to it.copy(status = DownloadStatus.Cancelled))
                } ?: map
            }
            throw e
        } catch (e: Exception) {
            logger.e(e) { "Download failed: ${item.title}" }
            downloadsMap.update { map ->
                map[item.id]?.let {
                    map + (item.id to it.copy(
                        status = DownloadStatus.Failed(e.message ?: "Unknown error"),
                        errorMessage = e.message,
                    ))
                } ?: map
            }
        } finally {
            activeJobs.remove(item.id)
            processQueue()
        }
    }

    private suspend fun executeMultiSegmentDownload(
        url: String,
        filename: String,
        item: DownloadItem,
        tempDir: Path,
        downloadDir: Path,
        totalSize: Long,
    ) {
        val segmentSize = totalSize / SEGMENT_COUNT
        val segments = (0 until SEGMENT_COUNT).map { i ->
            val start = i * segmentSize
            val end = if (i == SEGMENT_COUNT - 1) totalSize - 1 else (i + 1) * segmentSize - 1
            Segment(index = i, start = start, end = end)
        }

        val segmentFiles = segments.map { segment ->
            tempDir / "${item.id}_seg${segment.index}.tmp"
        }

        coroutineScope {
            segments.mapIndexed { index, segment ->
                async {
                    downloadSegment(url, item, segment, segmentFiles[index], totalSize)
                }
            }.awaitAll()
        }

        val finalPath = downloadDir / filename.toPath()
        fileSystem.sink(finalPath).buffer().use { sink ->
            for (segmentFile in segmentFiles) {
                fileSystem.source(segmentFile).buffer().use { source ->
                    sink.writeAll(source)
                }
            }
        }

        segmentFiles.forEach { fileSystem.delete(it) }
    }

    private suspend fun downloadSegment(
        url: String,
        item: DownloadItem,
        segment: Segment,
        outputPath: Path,
        totalSize: Long,
    ) {
        val response = httpClient.get(url) {
            headers {
                append(HttpHeaders.Range, "bytes=${segment.start}-${segment.end}")
            }
        }
        val channel = response.bodyAsChannel()

        fileSystem.sink(outputPath).buffer().use { sink ->
            val packet = channel.readRemaining()
            val bytes = packet.readByteArray()
            packet.close()
            sink.write(bytes)

            updateProgress(item.id, bytes.size.toLong(), totalSize)
        }
    }

    private suspend fun executeSingleConnectionDownload(
        url: String,
        filename: String,
        item: DownloadItem,
        tempDir: Path,
        downloadDir: Path,
    ) {
        val tempFile = tempDir / "${item.id}.tmp"

        val response = httpClient.get(url)
        val totalSize = response.contentLength() ?: 0L
        val channel = response.bodyAsChannel()

        fileSystem.sink(tempFile).buffer().use { sink ->
            val packet = channel.readRemaining()
            val bytes = packet.readByteArray()
            packet.close()
            sink.write(bytes)

            updateProgress(item.id, bytes.size.toLong(), totalSize)
        }

        val finalPath = downloadDir / filename.toPath()
        fileSystem.copy(tempFile, finalPath)
        fileSystem.delete(tempFile)
    }

    private fun updateProgress(id: String, bytesJustRead: Long, totalSize: Long) {
        downloadsMap.update { map ->
            map[id]?.let { current ->
                val newDownloaded = current.downloadedBytes + bytesJustRead
                val progress = if (totalSize > 0) {
                    (newDownloaded.toFloat() / totalSize.toFloat()).coerceIn(0f, 1f)
                } else 0f
                map + (id to current.copy(
                    progress = progress,
                    downloadedBytes = newDownloaded,
                    totalBytes = totalSize,
                ))
            } ?: map
        }
    }

    private suspend fun probeUrl(url: String): Pair<Long, Boolean> {
        return try {
            val response = httpClient.head(url)
            val contentLength = response.contentLength() ?: 0L
            val acceptRanges = response.headers[HttpHeaders.AcceptRanges]
            val supportsRanges = acceptRanges?.equals("bytes", ignoreCase = true) == true
            Pair(contentLength, supportsRanges)
        } catch (e: Exception) {
            logger.w(e) { "HEAD request failed, falling back to single connection" }
            Pair(0L, false)
        }
    }

    private fun applyMetadata(item: DownloadItem, filename: String, downloadDir: Path) {
        val filePath = downloadDir / filename.toPath()
        if (!fileSystem.exists(filePath)) return

        // TODO: Write metadata/audio tags to the downloaded file.
        // This is the dedicated placeholder for metadata tagging.
        // Implementation should use a platform-specific audio tagging library
        // to write ID3 tags (MP3), MP4 atoms (M4A/AAC), Vorbis comments (OGG/FLAC), etc.
        //
        // Tags to write from the track metadata:
        //   - Title: item.title
        //   - Artist: item.artists
        //   - Album: item.album
        //   - Track number: item.track?.trackNumber
        //   - Disc number: item.track?.discNumber
        //   - Duration: item.track?.durationMs
        //   - Album art: item.track?.thumbnails (download and embed)
        //   - ISRC: item.track?.isrcCode
        //   - External URI: item.track?.externalUri
    }

    private fun resolveDownloadDir(): Path {
        val folder = cachedDownloadFolder.value
        return if (!folder.isNullOrBlank()) {
            folder.toPath()
        } else {
            paths.getUserDownloadsDirPath().toPath()
        }
    }

    private fun cleanupTempFiles(id: String) {
        try {
            val tempDir = FileSystem.SYSTEM_TEMPORARY_DIRECTORY / "spotube_downloads".toPath()
            if (fileSystem.exists(tempDir)) {
                fileSystem.list(tempDir).forEach { file ->
                    if (file.name.startsWith(id)) {
                        fileSystem.delete(file)
                    }
                }
            }
        } catch (e: Exception) {
            logger.w(e) { "Failed to cleanup temp files for $id" }
        }
    }

    private fun buildFilename(downloadItem: DownloadItem, streamInfo: StreamInfo): String {
        val safeTitle = downloadItem.title.sanitizeFilename()
        val safeArtist = downloadItem.artists.sanitizeFilename()
        val extension = streamInfo.container
        return "$safeArtist - $safeTitle.$extension"
    }

    private fun String.sanitizeFilename(): String {
        return this.replace(Regex("[^a-zA-Z0-9.\\-_' ]"), "_").take(200)
    }

    private data class Segment(val index: Int, val start: Long, val end: Long)
}
