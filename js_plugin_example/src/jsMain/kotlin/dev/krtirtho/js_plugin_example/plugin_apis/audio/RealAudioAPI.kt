/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package dev.krtirtho.js_plugin_example.plugin_apis.audio

import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioFormat
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioQuality
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioSource
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioStream
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack

val urls = listOf(
    "https://cdn.pixabay.com/audio/2024/02/28/audio_d1a9995fc3.mp3",
    "https://cdn.pixabay.com/audio/2024/05/29/audio_f3a1d24f19.mp3",
    "https://cdn.pixabay.com/audio/2025/03/18/audio_9c95eb2557.mp3",
    "https://cdn.pixabay.com/audio/2023/06/02/audio_320a2e0f57.mp3",
    "https://cdn.pixabay.com/audio/2024/06/30/audio_0eb1f1f4ec.mp3",
    "https://cdn.pixabay.com/audio/2023/08/12/audio_5cdd274d4b.mp3",
    "https://cdn.pixabay.com/audio/2025/03/17/audio_a71887c1b8.mp3",
    "https://cdn.pixabay.com/audio/2026/03/25/audio_19c3c36ce2.mp3",
    "https://cdn.pixabay.com/audio/2023/06/25/audio_ded864e440.mp3"
)

class RealAudioAPI : AudioAPI {
    override val supportedQualities: List<AudioFormat> = listOf(
        AudioFormat(
            codec = "mp3", container = "mp3", qualities = listOf(
                AudioQuality.Lossy(bitrate = 128),
                AudioQuality.Lossy(bitrate = 320),
            )
        ),
        AudioFormat(
            codec = "mp3", container = "mp3", qualities = listOf(
                AudioQuality.Lossy(bitrate = 128),
                AudioQuality.Lossy(bitrate = 320),
            )
        ),
        AudioFormat(
            codec = "aac", container = "aac", qualities = listOf(
                AudioQuality.Lossy(bitrate = 160),
            )
        ),
    )

    override suspend fun getStreamsByTrack(track: MetadataTrack): List<AudioSource> {
        val title = track.title.ifBlank { "Unknown Track" }
        val artist = track.artists.firstOrNull()?.name ?: "Unknown Artist"
        val album = track.album?.title?.ifBlank { null }

        return listOf(
            AudioSource.Basic(
                id = "${track.id}-source-1",
                title = title,
                artist = artist,
                album = album,
                thumbnails = track.album?.thumbnails.orEmpty(),
                externalUri = track.externalUri,
                confidence = 0.98f,
            ),
            AudioSource.Basic(
                id = "${track.id}-source-2",
                title = "$title (Alternative)",
                artist = artist,
                album = album,
                thumbnails = track.album?.thumbnails.orEmpty(),
                externalUri = track.externalUri,
                confidence = 0.92f,
            )
        )
    }

    override suspend fun getStreamsOfAudioSource(source: AudioSource.Basic): List<AudioSource.Streamed> {
        val defaultDuration = 180_000L
        val primary = AudioSource.Streamed(
            id = source.id,
            title = source.title,
            artist = source.artist,
            album = source.album,
            thumbnails = source.thumbnails,
            externalUri = source.externalUri,
            confidence = source.confidence,
            streams = listOf(
                AudioStream.Lossy(
                    url = urls.random(),
                    codec = "mp3",
                    bitrate = 256000,
                    container = "mp3",
                ),
            ).shuffled()
        )

        return listOf(primary)
    }
}