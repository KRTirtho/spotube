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

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUser
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
enum class MetadataSupportedSearchType {
    TRACK,
    ARTIST,
    ALBUM,
    PLAYLIST,
    USER,
    ALL
}

@Serializable
sealed class MetadataSearchResult{
    @Serializable
    @SerialName("track")
    data class Track(val data: MetadataTrack): MetadataSearchResult()

    @Serializable
    @SerialName("artist")
    data class Artist(val data: MetadataArtist.Basic): MetadataSearchResult()

    @Serializable
    @SerialName("album")
    data class Album(val data: MetadataAlbum.Basic): MetadataSearchResult()

    @Serializable
    @SerialName("playlist")
    data class Playlist(val data: MetadataPlaylist): MetadataSearchResult()

    @Serializable
    @SerialName("user")
    data class User(val data: MetadataUser): MetadataSearchResult()
}