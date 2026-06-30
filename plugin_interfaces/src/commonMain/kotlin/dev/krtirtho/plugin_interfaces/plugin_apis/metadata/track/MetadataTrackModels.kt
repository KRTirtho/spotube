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

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import kotlinx.serialization.Serializable

@Serializable
data class MetadataTrack(
    val id: String,
    val title: String,
    val durationMs: Long,
    val trackNumber: Int?,
    val discNumber: Int?,
    val artists: List<MetadataArtist.Basic>,
    val album: MetadataAlbum.Detailed?,
    val thumbnails: List<Thumbnail>?,
    val explicit: Boolean?,
    val popularity: Int?,
    val isrcCode: String?,
    val externalUri: String?
)