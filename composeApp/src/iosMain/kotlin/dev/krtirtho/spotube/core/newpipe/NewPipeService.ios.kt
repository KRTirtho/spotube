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

import com.yushosei.newpipe.extractor.ServiceList.YouTube
import com.yushosei.newpipe.extractor.stream.AudioStream
import com.yushosei.newpipe.extractor.stream.StreamInfoItem
import com.yushosei.newpipe.extractor.youtube.linkHandler.YoutubeSearchQueryHandlerFactory
import io.ktor.http.Url
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.withContext

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
                        title = item.name,
                        url = item.url,
                        uploader = item.uploaderName ?: "Unknown",
                        durationMs = item.duration,
                        thumbnailUrl = item.thumbnails.first().url,
                        id = Url(item.url).parameters["v"]
                            ?: throw IllegalArgumentException("Invalid YouTube URL: ${item.url}")
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
            VideoInfo(
                title = extractor.name ?: "Unknown",
                url = extractor.url ?: "https://www.youtube.com/watch?v=$id",
                uploader = extractor.uploaderName,
                durationMs = extractor.length,
                thumbnailUrl = extractor.thumbnails.first().url,
                audioStreams = extractor.audioStreams()
                    .filter { stream -> stream.isUrl() && stream.format != null }
                    .map { stream ->
                        dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioStream.Lossy(
                            url = stream.content,
                            codec = stream.codec ?: "unknown",
                            bitrate = stream.bitrate,
                            container = stream.format?.suffix ?: "unknown",
                        )
                    },
                videoStreams = listOf(), // Not yet supported
                id = id
            )
        }
    }
}