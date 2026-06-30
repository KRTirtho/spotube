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

package dev.krtirtho.spotube.core.zipline.plugin_apis.lrclib

import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.LyricsAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.LyricsLine
import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.LyricsResponse
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.defaultRequest
import io.ktor.client.plugins.logging.LogLevel
import io.ktor.client.plugins.logging.Logger
import io.ktor.client.plugins.logging.Logging
import io.ktor.client.plugins.logging.SIMPLE
import io.ktor.client.request.get
import io.ktor.http.userAgent
import io.ktor.serialization.kotlinx.json.json
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.withContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class LRCLibResponse(
    val id: Long,
    val trackName: String,
    val artistName: String,
    val albumName: String,
    val plainLyrics: String?,
    val syncedLyrics: String?,
)

class RealLRCLibLyricsAPI : LyricsAPI {
    private val httpClient = HttpClient {
        install(Logging) {
            level = LogLevel.ALL
            logger = Logger.SIMPLE
        }
        install(ContentNegotiation) {
            json(Json { ignoreUnknownKeys = true })
        }
        defaultRequest {
            url("https://lrclib.net/api/get")
            // TODO: Add the actual version of Spotube instead of hardcoding it
            userAgent("Spotube/v6.0.0 LRCLib Lyric Plugin")
        }
    }

    private suspend fun getLRCLibLyrics(track: MetadataTrack): LRCLibResponse? =
        withContext(Dispatchers.IO) {
            try {
                httpClient.get {
                    url {
                        parameters.append("track_name", track.title)
                        track.artists.firstOrNull()
                            ?.let { parameters.append("artist_name", it.name) }
                        track.album?.let { parameters.append("album_name", it.title) }
                        if (track.durationMs > 0) parameters.append(
                            "duration",
                            (track.durationMs / 1000).toString()
                        ) // Convert ms to seconds
                    }
                }.body<LRCLibResponse>()
            } catch (e: Exception) {
                null
            }
        }

    override suspend fun getLyrics(track: MetadataTrack): LyricsResponse? {
        val response = getLRCLibLyrics(track) ?: return null
        return LyricsResponse(
            syncedLyrics = response.syncedLyrics?.lines()?.mapNotNull { line ->
                val match = Regex("\\[(\\d{2}):(\\d{2}\\.\\d{2})]").find(line) ?: return@mapNotNull null
                val minutes = match.groupValues[1].toLongOrNull() ?: return@mapNotNull null
                val seconds = match.groupValues[2].toDoubleOrNull() ?: return@mapNotNull null
                val timeMs = (minutes * 60 * 1000 + (seconds * 1000)).toLong()
                val text = line.substring(match.range.last + 1).trim()
                LyricsLine(time = timeMs, text = text)
            },
            plainLyrics = response.plainLyrics,
        )
    }
}