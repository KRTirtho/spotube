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

package dev.krtirtho.plugin_interfaces.plugin_apis.audio

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class AudioFormat(
    val codec: String,
    val container: String,
    val qualities: List<AudioQuality>
)

sealed interface AudioQuality {
    @Serializable
    @SerialName("lossy")
    data class Lossy(val bitrate: Int) : AudioQuality

    @Serializable
    @SerialName("lossless")
    data class Lossless(
        val sampleRate: Int,
        val channels: Int
    ) : AudioQuality
}

@Serializable
enum class StreamProtocol {
    HLS, DASH, PROGRESSIVE
}


@Serializable
sealed interface AudioStream {
    val url: String
    val codec: String
    val container: String
    val protocol: StreamProtocol

    @Serializable
    @SerialName("lossy")
    data class Lossy(
        override val url: String,
        override val codec: String,
        override val container: String,
        override val protocol: StreamProtocol = StreamProtocol.PROGRESSIVE,
        val bitrate: Int,
    ) : AudioStream

    @Serializable
    @SerialName("lossless")
    data class Lossless(
        override val url: String,
        override val codec: String,
        override val container: String,
        override val protocol: StreamProtocol = StreamProtocol.PROGRESSIVE,
        val sampleRate: Int,
        val channels: Int,
    ) : AudioStream
}

@Serializable
sealed class AudioSource {
    abstract val id: String
    abstract val title: String
    abstract val artist: String?
    abstract val album: String?
    abstract val thumbnails: List<Thumbnail>
    abstract val externalUri: String?
    abstract val confidence: Float // 0.0 to 1.0, indicating the confidence level of the match

    @Serializable
    @SerialName("basic")
    data class Basic(
        override val id: String,
        override val title: String,
        override val artist: String?,
        override val album: String?,
        override val thumbnails: List<Thumbnail>,
        override val externalUri: String?,
        override val confidence: Float,
    ) : AudioSource()

    @Serializable
    @SerialName("streamed")
    data class Streamed(
        override val id: String,
        override val title: String,
        override val artist: String?,
        override val album: String?,
        override val thumbnails: List<Thumbnail>,
        override val externalUri: String?,
        override val confidence: Float,
        val streams: List<AudioStream>
    ) : AudioSource() {
        fun toBasic(): Basic {
            return Basic(
                id = id,
                title = title,
                artist = artist,
                album = album,
                thumbnails = thumbnails,
                externalUri = externalUri,
                confidence = confidence
            )
        }
    }
}