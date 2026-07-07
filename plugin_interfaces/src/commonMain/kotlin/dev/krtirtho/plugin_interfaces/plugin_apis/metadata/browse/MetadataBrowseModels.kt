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

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUser
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed interface MetadataBrowseItem {
    @Serializable
    @SerialName("track")
    data class Track(val data: MetadataTrack) : MetadataBrowseItem

    @Serializable
    @SerialName("album")
    data class Album(val data: MetadataAlbum.Basic) : MetadataBrowseItem

    @Serializable
    @SerialName("artist")
    data class Artist(val data: MetadataArtist.Basic) : MetadataBrowseItem

    @Serializable
    @SerialName("playlist")
    data class Playlist(val data: MetadataPlaylist) : MetadataBrowseItem

    @Serializable
    @SerialName("user")
    data class User(val data: MetadataUser) : MetadataBrowseItem
}

@Serializable
data class MetadataBrowseSection(
    val title: String,
    val description: String? = null,
    val items: List<MetadataBrowseItem>,
    val moreLink: String? = null
)

@Serializable
data class MetadataBrowseGenre(
    val id: String,
    val name: String,
)