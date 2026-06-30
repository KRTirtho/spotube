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

package dev.krtirtho.spotube.core.server

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.paths.Paths
import io.ktor.http.ContentType
import io.ktor.http.Headers
import io.ktor.http.HeadersBuilder
import io.ktor.http.HttpHeaders
import io.ktor.http.HttpStatusCode
import io.ktor.http.content.OutgoingContent
import io.ktor.server.application.ApplicationCall
import io.ktor.server.response.respond
import io.ktor.utils.io.writeFully
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import okio.FileSystem
import okio.Path
import okio.Path.Companion.toPath
import okio.SYSTEM
import okio.buffer
import okio.use

@Serializable
internal data class CacheIndex(
    val entries: List<CacheEntry> = emptyList()
)

@Serializable
internal data class CacheEntry(
    val trackId: String,
    val filename: String,
    val sizeBytes: Long,
    val createdAtMs: Long,
    val contentType: String = "application/octet-stream",
)

internal class CacheManager(
    private val paths: Paths,
    private val resolveCacheFolder: () -> String?,
    private val resolveSizeLimitMB: () -> Long,
    private val fileSystem: FileSystem = FileSystem.SYSTEM,
    private val cacheMutex: Mutex = Mutex(),
    private val json: Json = Json { ignoreUnknownKeys = true },
) {
    companion object {
        private val cacheIndexFileName = "cache_index.json".toPath()
    }

    fun resolveCacheDir(): Path {
        val folder = resolveCacheFolder()
        return if (!folder.isNullOrBlank()) {
            folder.toPath()
        } else {
            paths.getMusicCacheDirPath().toPath()
        }
    }

    private fun getCacheIndexPath(): Path = resolveCacheDir() / cacheIndexFileName

    fun readCacheIndex(): CacheIndex {
        val indexPath = getCacheIndexPath()
        if (!fileSystem.exists(indexPath)) return CacheIndex()
        return runCatching {
            fileSystem.source(indexPath).buffer().use { source ->
                json.decodeFromString<CacheIndex>(source.readUtf8())
            }
        }.getOrDefault(CacheIndex())
    }

    fun writeCacheIndex(index: CacheIndex) {
        val indexPath = getCacheIndexPath()
        fileSystem.createDirectories(indexPath.parent ?: resolveCacheDir())
        fileSystem.sink(indexPath).buffer().use { sink ->
            sink.writeUtf8(json.encodeToString(index))
        }
    }

    fun findCachedEntry(trackId: String): Pair<Path, CacheEntry>? {
        val index = readCacheIndex()
        val entry = index.entries.firstOrNull { it.trackId == trackId } ?: return null
        val filePath = resolveCacheDir() / entry.filename.toPath()
        return if (fileSystem.exists(filePath)) filePath to entry else null
    }

    fun resolveCacheFilename(track: MetadataTrack, contentType: String?): String {
        val artists = track.artists.joinToString(", ") { it.name }.sanitizeFilenamePart()
        val title = track.title.sanitizeFilenamePart()
        val ext = contentTypeToExtension(contentType)
        return "$artists - $title.$ext"
    }

    suspend fun evictIfNeeded() {
        val limitMB = resolveSizeLimitMB()
        if (limitMB <= 0L) return

        cacheMutex.withLock {
            val cacheDir = resolveCacheDir()
            if (!fileSystem.exists(cacheDir)) return

            val index = readCacheIndex()
            val sorted = index.entries.sortedBy { it.createdAtMs }.toMutableList()

            var totalSize = sorted.sumOf { it.sizeBytes }
            val limitBytes = limitMB * 1024 * 1024

            while (totalSize > limitBytes && sorted.isNotEmpty()) {
                val entry = sorted.removeFirst()
                val filePath = cacheDir / entry.filename.toPath()
                if (fileSystem.exists(filePath)) {
                    fileSystem.delete(filePath)
                }
                totalSize -= entry.sizeBytes
            }

            writeCacheIndex(index.copy(entries = sorted))
        }
    }

    suspend fun commitCacheEntry(
        trackId: String,
        filename: String,
        allBytes: ByteArray,
        contentType: String,
    ) {
        val entry = CacheEntry(
            trackId = trackId,
            filename = filename,
            sizeBytes = allBytes.size.toLong(),
            createdAtMs = kotlin.time.Clock.System.now().toEpochMilliseconds(),
            contentType = contentType,
        )
        cacheMutex.withLock {
            val index = readCacheIndex()
            writeCacheIndex(CacheIndex(
                entries = index.entries.filter { it.trackId != trackId } + entry
            ))
        }
    }

    suspend fun serveCacheHead(call: ApplicationCall, entry: CacheEntry) {
        call.respond(object : OutgoingContent.NoContent() {
            override val status: HttpStatusCode = HttpStatusCode.OK
            override val headers: Headers = HeadersBuilder().apply {
                append(HttpHeaders.ContentType, entry.contentType)
                append(HttpHeaders.ContentLength, entry.sizeBytes.toString())
                append(HttpHeaders.AcceptRanges, "bytes")
            }.build()
            override val contentLength: Long = entry.sizeBytes
            override val contentType: ContentType = entry.toContentType()
        })
    }

    suspend fun serveCacheGet(call: ApplicationCall, filePath: Path, entry: CacheEntry) {
        val fileSize = entry.sizeBytes
        val rangeHeader = call.request.headers[HttpHeaders.Range]

        if (rangeHeader != null) {
            val range = parseRange(rangeHeader, fileSize)
            if (range != null) {
                val (start, end) = range
                val length = end - start + 1
                val contentRange = "bytes $start-$end/$fileSize"
                fileSystem.source(filePath).buffer().use { source ->
                    source.skip(start)
                    val bytes = source.readByteArray(length)
                    call.respond(object : OutgoingContent.WriteChannelContent() {
                        override val status: HttpStatusCode = HttpStatusCode.PartialContent
                        override val contentLength: Long = bytes.size.toLong()
                        override val contentType: ContentType = entry.toContentType()
                        override val headers: Headers = HeadersBuilder().apply {
                            append(HttpHeaders.ContentRange, contentRange)
                            append(HttpHeaders.AcceptRanges, "bytes")
                        }.build()
                        override suspend fun writeTo(channel: io.ktor.utils.io.ByteWriteChannel) {
                            channel.writeFully(bytes)
                        }
                    })
                }
                return
            }
            call.respond(object : OutgoingContent.NoContent() {
                override val status: HttpStatusCode = HttpStatusCode.RequestedRangeNotSatisfiable
                override val headers: Headers = HeadersBuilder().apply {
                    append(HttpHeaders.ContentRange, "bytes */$fileSize")
                }.build()
            })
            return
        }

        fileSystem.source(filePath).buffer().use { source ->
            val bytes = source.readByteArray()
            call.respond(object : OutgoingContent.WriteChannelContent() {
                override val status: HttpStatusCode = HttpStatusCode.OK
                override val contentLength: Long = bytes.size.toLong()
                override val contentType: ContentType = entry.toContentType()
                override val headers: Headers = HeadersBuilder().apply {
                    append(HttpHeaders.AcceptRanges, "bytes")
                }.build()
                override suspend fun writeTo(channel: io.ktor.utils.io.ByteWriteChannel) {
                    channel.writeFully(bytes)
                }
            })
        }
    }
}

internal fun parseRange(rangeHeader: String, fileSize: Long): Pair<Long, Long>? {
    val match = Regex("""bytes=(\d*)-(\d*)""").find(rangeHeader) ?: return null
    val startStr = match.groupValues[1]
    val endStr = match.groupValues[2]
    if (startStr.isEmpty() && endStr.isEmpty()) return null

    val start = startStr.toLongOrNull() ?: 0L
    val end = if (endStr.isNotEmpty()) endStr.toLongOrNull() ?: (fileSize - 1) else (fileSize - 1)

    if (start >= fileSize || start > end) return null
    return start to end.coerceAtMost(fileSize - 1)
}

internal fun CacheEntry.toContentType(): ContentType =
    runCatching { ContentType.parse(contentType) }.getOrDefault(ContentType.Application.OctetStream)

internal fun contentTypeToExtension(contentType: String?): String {
    return when {
        contentType == null -> "dat"
        "webm" in contentType -> "webm"
        "ogg" in contentType || "opus" in contentType -> "ogg"
        "mp4" in contentType || "m4a" in contentType || "aac" in contentType -> "m4a"
        "mpeg" in contentType || "mp3" in contentType -> "mp3"
        "flac" in contentType -> "flac"
        "wav" in contentType -> "wav"
        else -> "dat"
    }
}

internal fun String.sanitizeFilenamePart(): String {
    return this.replace(Regex("""[/\\:*?"<>|]"""), "_").take(200).trim()
}
