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
import kotlinx.serialization.Serializable

@Serializable
data class VideoSearchResult(
    val id: String,
    val title: String,
    val url: String,
    val uploader: String,
    val durationMs: Long,
    val thumbnailUrl: String
)

@Serializable
data class VideoInfo(
    val id: String,
    val title: String,
    val url: String,
    val uploader: String,
    val durationMs: Long,
    val thumbnailUrl: String,
    val audioStreams: List<AudioStream>,
    val videoStreams: List<AudioStream>
)

@Serializable
data class MediaStream(
    val url: String,
    val codec: String,
    val container: String,
    val bitrate: Int,
    val isAudio: Boolean,
    val isVideo: Boolean,
)