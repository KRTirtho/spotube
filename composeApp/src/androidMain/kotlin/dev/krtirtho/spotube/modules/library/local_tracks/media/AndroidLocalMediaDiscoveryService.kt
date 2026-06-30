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

package dev.krtirtho.spotube.modules.library.local_tracks.media

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.database.ContentObserver
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import dev.krtirtho.spotube.core.di.injectLogger
import org.koin.core.component.KoinComponent
import java.io.File
import java.util.Locale

class AndroidLocalMediaDiscoveryService(
    private val context: Context,
) : LocalMediaDiscoveryService, KoinComponent {
    val logger by injectLogger<AndroidLocalMediaDiscoveryService>()

    override suspend fun discoverFolders(roots: List<String>): List<LocalMediaFolder> {
        logger.i { "discoverFolders: start roots=${roots.size}" }
        if (!hasReadPermission()) {
            logger.w { "discoverFolders: missing media permission, returning empty result" }
            return emptyList()
        }

        val tracksByFolder = linkedMapOf<String, MutableList<LocalMediaTrack>>()
        val resolver = context.contentResolver
        val collection = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        var totalRows = 0
        var acceptedRows = 0
        var skippedNonAudioRows = 0
        var unknownFolderRows = 0
        var nullCursor = false

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.MIME_TYPE,
        ) + if (Build.VERSION.SDK_INT >= 29) {
            arrayOf(MediaStore.Audio.Media.RELATIVE_PATH)
        } else {
            emptyArray()
        }

        val sortOrder = "${MediaStore.Audio.Media.DATE_ADDED} DESC"

        logger.d { "discoverFolders: querying MediaStore with collection=${collection} projection=${projection.joinToString()} sortOrder=$sortOrder" }

        resolver.query(collection, projection, null, null, sortOrder)?.use { cursor ->
            val idCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val displayNameCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME)
            val titleCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val artistCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
            val albumCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
            val durationCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
            val mimeTypeCol = cursor.getColumnIndex(MediaStore.Audio.Media.MIME_TYPE)
            val relativePathCol = cursor.getColumnIndex(MediaStore.Audio.Media.RELATIVE_PATH)

            logger.d {
                "discoverFolders: query ok columns(mimeType=$mimeTypeCol, relativePath=$relativePathCol)"
            }

            while (cursor.moveToNext()) {
                totalRows += 1
                val id = cursor.getLong(idCol)
                val uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI.buildUpon()
                    .appendPath(id.toString())
                    .build()
                    .toString()

                val rawTitle = cursor.getString(titleCol).orEmpty().trim()
                val displayName = cursor.getString(displayNameCol).orEmpty().trim()
                val mimeType = if (mimeTypeCol >= 0) {
                    cursor.getString(mimeTypeCol).orEmpty().trim()
                } else {
                    ""
                }
                if (!isAudioCandidate(displayName, mimeType)) {
                    skippedNonAudioRows += 1
                    if (skippedNonAudioRows <= 5) {
                        logger.d {
                            "discoverFolders: skip row id=$id displayName=$displayName mimeType=$mimeType"
                        }
                    }
                    continue
                }

                val relativePath = if (relativePathCol >= 0) {
                    cursor.getString(relativePathCol).orEmpty().trim()
                } else {
                    "Unknown"
                }
                val folderPath = relativePath.ifBlank { "Unknown" }
                if (folderPath == "Unknown") unknownFolderRows += 1
                val artist = cursor.getString(artistCol).orEmpty()
                    .takeUnless { it.equals("<unknown>", true) }
                val album = cursor.getString(albumCol).orEmpty().takeUnless { it.isBlank() }
                val durationMs = cursor.getLong(durationCol).coerceAtLeast(0L)

                val name = rawTitle.ifBlank {
                    displayName.substringBeforeLast('.').takeIf { it.isNotBlank() } ?: displayName
                }

                val track = LocalMediaTrack(
                    path = uri,
                    name = name.ifBlank { "Unknown track" },
                    artists = listOfNotNull(artist),
                    durationMs = durationMs,
                    album = album,
                    coverBytes = null,
                )

                tracksByFolder.getOrPut(folderPath) { mutableListOf() }.add(track)
                acceptedRows += 1
            }
        } ?: run {
            nullCursor = true
        }

        if (nullCursor) {
            logger.w { "discoverFolders: MediaStore query returned null cursor" }
        }

        val mediaStoreFolders = tracksByFolder.entries
            .map { (folderPath, tracks) ->
                LocalMediaFolder(
                    path = folderPath,
                    name = normalizeFolderName(folderPath),
                    tracks = tracks.sortedBy { it.name.lowercase(Locale.getDefault()) },
                )
            }
            .sortedBy { it.name.lowercase(Locale.getDefault()) }

        val fallbackFolders = discoverFileSystemFallback(roots)
        val merged = mergeFolders(mediaStoreFolders, fallbackFolders)

        logger.i {
            "discoverFolders: done folders=${merged.size} mediaStoreFolders=${mediaStoreFolders.size} fallbackFolders=${fallbackFolders.size} tracks=$acceptedRows totalRows=$totalRows skippedNonAudio=$skippedNonAudioRows unknownFolderRows=$unknownFolderRows"
        }

        if (merged.isNotEmpty()) {
            val preview = merged.take(3).joinToString { "${it.name}:${it.trackCount}" }
            logger.d { "discoverFolders: folder preview=$preview" }
        }

        return merged
    }

    override fun observeChanges(
        roots: List<String>,
        onChanged: LocalMediaChangeCallback,
    ): LocalMediaObservation? {
        logger.i { "observeChanges: start roots=${roots.size}" }
        if (!hasReadPermission()) {
            logger.w { "observeChanges: missing media permission, observer not registered" }
            return null
        }

        val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean) {
                logger.d { "observeChanges: MediaStore changed selfChange=$selfChange" }
                onChanged()
            }
        }

        context.contentResolver.registerContentObserver(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            true,
            observer,
        )

        logger.i { "observeChanges: observer registered" }

        return LocalMediaObservation {
            context.contentResolver.unregisterContentObserver(observer)
            logger.i { "observeChanges: observer unregistered" }
        }
    }

    private fun hasReadPermission(): Boolean {
        val permission = if (Build.VERSION.SDK_INT >= 33) {
            Manifest.permission.READ_MEDIA_AUDIO
        } else {
            Manifest.permission.READ_EXTERNAL_STORAGE
        }

        val granted =
            context.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED
        logger.d { "hasReadPermission: permission=$permission granted=$granted" }
        return granted
    }

    private fun normalizeFolderName(path: String): String {
        return path.trimEnd('/', '\\').substringAfterLast('/').ifBlank {
            path.trimEnd('/', '\\').substringAfterLast('\\').ifBlank { "Unknown" }
        }
    }

    private fun isAudioCandidate(displayName: String, mimeType: String): Boolean {
        if (mimeType.startsWith("audio/", ignoreCase = true)) return true
        val extension = displayName.substringAfterLast('.', missingDelimiterValue = "")
            .lowercase(Locale.getDefault())
        return extension in SUPPORTED_EXTENSIONS
    }

    private fun discoverFileSystemFallback(roots: List<String>): List<LocalMediaFolder> {
        val candidateRoots = resolveCandidateRoots(roots)
        if (candidateRoots.isEmpty()) {
            logger.d { "discoverFileSystemFallback: no candidate roots" }
            return emptyList()
        }

        logger.d {
            "discoverFileSystemFallback: scanning roots=${candidateRoots.joinToString()}"
        }

        val tracksByFolder = linkedMapOf<String, MutableList<LocalMediaTrack>>()
        var scannedFiles = 0
        var acceptedFiles = 0

        candidateRoots.forEach { root ->
            scanDirectory(root) { file ->
                scannedFiles += 1
                val extension = file.extension.lowercase(Locale.getDefault())
                if (extension !in SUPPORTED_EXTENSIONS) return@scanDirectory
                acceptedFiles += 1

                val folderPath = file.parentFile?.absolutePath ?: "Unknown"
                val name = file.nameWithoutExtension.ifBlank { file.name }
                val track = LocalMediaTrack(
                    path = file.absolutePath,
                    name = name,
                    artists = emptyList(),
                    durationMs = 0L,
                    album = null,
                    coverBytes = null,
                )

                tracksByFolder.getOrPut(folderPath) { mutableListOf() }.add(track)
            }
        }

        val folders = tracksByFolder.entries
            .map { (folderPath, tracks) ->
                LocalMediaFolder(
                    path = folderPath,
                    name = normalizeFolderName(folderPath),
                    tracks = tracks.sortedBy { it.name.lowercase(Locale.getDefault()) },
                )
            }
            .sortedBy { it.name.lowercase(Locale.getDefault()) }

        logger.i {
            "discoverFileSystemFallback: scannedFiles=$scannedFiles acceptedFiles=$acceptedFiles folders=${folders.size}"
        }

        return folders
    }

    private fun resolveCandidateRoots(roots: List<String>): List<File> {
        val configured = roots.mapNotNull { raw ->
            val normalized = raw.trim()
            if (normalized.isBlank()) return@mapNotNull null
            File(normalized)
        }

        val defaults = listOfNotNull(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC),
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
            context.getExternalFilesDir(Environment.DIRECTORY_MUSIC),
            context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS),
        )

        return (configured + defaults)
            .map { it.absoluteFile }
            .distinctBy { it.absolutePath }
            .filter { it.exists() && it.isDirectory }
    }

    private fun scanDirectory(root: File, onFile: (File) -> Unit) {
        val queue = ArrayDeque<File>()
        queue.add(root)

        while (queue.isNotEmpty()) {
            val current = queue.removeFirst()
            val children = current.listFiles() ?: continue
            children.forEach { child ->
                if (child.isDirectory) {
                    queue.add(child)
                } else if (child.isFile) {
                    onFile(child)
                }
            }
        }
    }

    private fun mergeFolders(
        mediaStoreFolders: List<LocalMediaFolder>,
        fallbackFolders: List<LocalMediaFolder>,
    ): List<LocalMediaFolder> {
        if (fallbackFolders.isEmpty()) return mediaStoreFolders
        if (mediaStoreFolders.isEmpty()) return fallbackFolders

        val merged = linkedMapOf<String, MutableList<LocalMediaTrack>>()
        val seenTrackPaths = mutableSetOf<String>()

        (mediaStoreFolders + fallbackFolders).forEach { folder ->
            val bucket = merged.getOrPut(folder.path) { mutableListOf() }
            folder.tracks.forEach { track ->
                if (seenTrackPaths.add(track.path)) {
                    bucket.add(track)
                }
            }
        }

        return merged.entries
            .map { (path, tracks) ->
                LocalMediaFolder(
                    path = path,
                    name = normalizeFolderName(path),
                    tracks = tracks.sortedBy { it.name.lowercase(Locale.getDefault()) },
                )
            }
            .sortedBy { it.name.lowercase(Locale.getDefault()) }
    }

    companion object {
        private val SUPPORTED_EXTENSIONS = setOf(
            "mp3",
            "m4a",
            "aac",
            "flac",
            "wav",
            "ogg",
            "opus",
            "wma",
        )
    }
}
