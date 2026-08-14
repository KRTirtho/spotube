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

package dev.krtirtho.spotube.core.zipline.plugin_apis.newpipe_yt

import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioFormat
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioQuality
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioSource
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.core.newpipe.NewPipeService
import dev.krtirtho.spotube.core.newpipe.VideoSearchResult
import org.koin.core.component.KoinComponent

class RealNewPipeAudioAPI : AudioAPI, KoinComponent {
    private val logger by injectLogger<RealNewPipeAudioAPI>()
    private val newPipeService = NewPipeService()

    companion object {
        private val youtubeIDRegex = Regex("^[a-zA-Z0-9_-]{11}$")
    }

    private val isrcProvider = ISRCProviders()

    private fun transformVideo(track: MetadataTrack, video: VideoSearchResult): AudioSource.Basic {
        var confidence = 0f

        val isTitleMatch = track.title.lowercase() in video.title.lowercase()
        val isArtistInTitle = track.artists.any { it.name.lowercase() in video.title.lowercase() }
        val isAlbumInTitle =
            track.album != null && track.album!!.title.lowercase() in video.title.lowercase()
        val isUploaderMatch =
            video.uploader.lowercase() in (track.artists.firstOrNull()?.name?.lowercase() ?: "")
        val isDurationMatch =
            video.durationMs in (track.durationMs - 30_000)..(track.durationMs + 30_000) // Duration within ±30 seconds

        if (isTitleMatch) confidence += 0.3f
        if (isUploaderMatch) confidence += 0.3f
        if (isDurationMatch) confidence += 0.2f // Duration within ±30 seconds
        if (isArtistInTitle) confidence += 0.1f
        if (isAlbumInTitle) confidence += 0.1f

        return AudioSource.Basic(
            id = video.id,
            title = video.title,
            artist = video.uploader,
            album = null,
            thumbnails = listOf(
                Thumbnail(
                    url = video.thumbnailUrl,
                    width = 300,
                    height = 300,
                )
            ),
            externalUri = "https://www.youtube.com/watch?v=${video.id}",
            confidence = confidence,
        )
    }

    override val supportedQualities: List<AudioFormat> = listOf(
        AudioFormat(
            codec = "opus", container = "webm", qualities = listOf(
                AudioQuality.Lossy(bitrate = 44_000),
                AudioQuality.Lossy(bitrate = 96_000),
                AudioQuality.Lossy(bitrate = 128_000),
                AudioQuality.Lossy(bitrate = 256_000),
            )
        ), AudioFormat(
            codec = "aac", container = "mp4", qualities = listOf(
                AudioQuality.Lossy(bitrate = 44_000),
                AudioQuality.Lossy(bitrate = 96_000),
                AudioQuality.Lossy(bitrate = 128_000),
                AudioQuality.Lossy(bitrate = 256_000),
            )
        )
    )

    override suspend fun getStreamsByTrack(track: MetadataTrack): List<AudioSource> {
        val isYouTubeUrl =
            track.externalUri != null && (track.externalUri!!.contains("youtube.com") || track.externalUri!!.contains(
                "youtu.be"
            ))
        val isYouTubeID = track.id.matches(youtubeIDRegex)


        logger.i {
            "Searching streams for track(${track.id}): ${track.title} by ${
                track.artists.joinToString(
                    ", "
                ) { it.name }
            }"
        }
        if (isYouTubeID || isYouTubeUrl) {
            logger.i { "Track has YouTube ID or URL, fetching video info directly" }
            return newPipeService.getVideoInfo(track.id).let { videoInfo ->
                listOf(
                    AudioSource.Streamed(
                        id = videoInfo.id,
                        title = videoInfo.title,
                        artist = videoInfo.uploader,
                        album = null,
                        thumbnails = listOf(
                            Thumbnail(
                                url = videoInfo.thumbnailUrl,
                                width = 300,
                                height = 300,
                            )
                        ),
                        externalUri = "https://www.youtube.com/watch?v=${videoInfo.id}",
                        confidence = 1.0f,
                        streams = videoInfo.audioStreams,
                    )
                )
            }
        }

        logger.i { "No YouTube ID or URL found, performing search with track metadata" }

        val isrcCode = track.isrcCode ?: isrcProvider.auto(track)
        val searchQuery = "${track.title} - ${track.artists.joinToString(", ") { it.name }}".trim()

        logger.i { "Searching for video with query: $searchQuery" }
        val videos = newPipeService.searchVideos(isrcCode ?: searchQuery)

        logger.i { "Found ${videos.size} videos with query: $searchQuery" }
        var sources = videos.map { transformVideo(track, it) }

        if (isrcCode != null && ((sources.size < 2 && sources.any { it.confidence < 0.3f }) || sources.isEmpty())) {
            logger.i { "ISRC search failed, fallback to title search" }
            val videos = newPipeService.searchVideos(searchQuery)
            sources = videos.map { transformVideo(track, it) }
        }

        logger.i { "Found ${sources.size} sources with confidence >= 0.3f" }

        // Return 5 highest to lowest confidence
        return sources.sortedByDescending { it.confidence }.take(5)
    }

    override suspend fun getStreamsOfAudioSource(source: AudioSource.Basic): List<AudioSource.Streamed> {
        return newPipeService.getVideoInfo(source.id).let { videoInfo ->
            listOf(
                AudioSource.Streamed(
                    id = videoInfo.id,
                    title = videoInfo.title,
                    artist = videoInfo.uploader,
                    album = null,
                    thumbnails = listOf(
                        Thumbnail(
                            url = videoInfo.thumbnailUrl,
                            width = 300,
                            height = 300,
                        )
                    ),
                    externalUri = "https://www.youtube.com/watch?v=${videoInfo.id}",
                    confidence = source.confidence,
                    streams = videoInfo.audioStreams
                )
            )
        }
    }
}