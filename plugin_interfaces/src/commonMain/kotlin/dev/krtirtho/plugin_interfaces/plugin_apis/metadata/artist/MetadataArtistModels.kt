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

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed class MetadataArtist {
    abstract val id: String
    abstract val name: String
    abstract val thumbnails: List<Thumbnail>
    abstract val externalUri: String?

    @Serializable
    @SerialName("base")
    data class Basic(
        override val id: String,
        override val name: String,
        override val thumbnails: List<Thumbnail>,
        override val externalUri: String?
    ) : MetadataArtist()

    @Serializable
    @SerialName("detailed")
    data class Detailed(
        val genres: List<String>,
        val biography: String?,
        val followersCount: Int?,
        override val id: String,
        override val name: String,
        override val thumbnails: List<Thumbnail>,
        override val externalUri: String?
    ) : MetadataArtist()
}

@Serializable
data class MetadataArtistOverview(
    val artist: MetadataArtist.Detailed,
    val top10Tracks: List<MetadataTrack>,
    val albums: PaginationResult<MetadataAlbum.Detailed>,
    val relatedArtists: PaginationResult<MetadataArtist.Basic>,
    val featuredPlaylists: PaginationResult<MetadataPlaylist>
)