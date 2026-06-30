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

package dev.krtirtho.spotube.core.newpipe

import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioStream
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.StreamProtocol
import io.ktor.http.Url
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.schabi.newpipe.extractor.ServiceList.YouTube
import org.schabi.newpipe.extractor.services.youtube.linkHandler.YoutubeSearchQueryHandlerFactory
import org.schabi.newpipe.extractor.stream.StreamInfoItem


actual class NewPipeService {
    actual suspend fun searchVideos(query: String): List<VideoSearchResult> {
        return withContext(Dispatchers.IO) {
            val extractor = YouTube.getSearchExtractor(
                query,
                mutableListOf(YoutubeSearchQueryHandlerFactory.MUSIC_SONGS),
                ""
            )
            extractor.fetchPage()
            val results = extractor.initialPage

            results.items.mapNotNull { item ->
                if (item is StreamInfoItem) {
                    VideoSearchResult(
                        id = Url(item.url).parameters["v"]
                            ?: throw IllegalArgumentException("Invalid YouTube URL: ${item.url}"),
                        title = item.name,
                        url = item.url,
                        uploader = item.uploaderName,
                        durationMs = item.duration,
                        thumbnailUrl = item.thumbnails.first().url,
                    )
                } else {
                    null
                }
            }
        }
    }

    actual suspend fun getVideoInfo(id: String): VideoInfo {
        return withContext(Dispatchers.IO) {
            val extractor = YouTube.getStreamExtractor("https://www.youtube.com/watch?v=$id")
            extractor.fetchPage()

            val audioStreams = extractor.audioStreams
                .mapNotNull { stream ->
                    AudioStream.Lossy(
                        url = stream.content,
                        codec = stream.codec,
                        container = stream.format!!.suffix,
                        bitrate = stream.bitrate,
                    )
                } + buildList {
                if (extractor.dashMpdUrl.isNotBlank()) add(
                    AudioStream.Lossy(
                        url = extractor.dashMpdUrl,
                        codec = "aac",
                        container = "mp4",
                        bitrate = 128_000,
                        protocol = StreamProtocol.DASH
                    )
                )
                if (extractor.hlsUrl.isNotBlank()) add(
                    AudioStream.Lossy(
                        url = extractor.hlsUrl,
                        codec = "aac",
                        container = "mp4",
                        bitrate = 128_000,
                        protocol = StreamProtocol.HLS
                    )
                )
            }


            val videoStreams = extractor.videoStreams
                .filter { stream -> stream.isUrl && stream.format != null }
                .map { stream ->
                    AudioStream.Lossy(
                        url = stream.content,
                        codec = stream.codec,
                        bitrate = stream.bitrate,
                        container = stream.format!!.suffix,
                    )
                }
            VideoInfo(
                id = id,
                title = extractor.name,
                url = extractor.url,
                uploader = extractor.uploaderName,
                durationMs = extractor.length,
                thumbnailUrl = extractor.thumbnails.first().url,
                // fallback to video streams if no audio streams are available
                audioStreams = audioStreams.ifEmpty {
                    videoStreams
                },
                videoStreams = videoStreams
            )
        }
    }
}