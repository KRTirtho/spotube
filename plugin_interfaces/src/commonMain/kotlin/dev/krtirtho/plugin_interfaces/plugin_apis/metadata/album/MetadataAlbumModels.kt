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

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
enum class MetadataAlbumType {
    Single,
    Album,
    Collection
}

@Serializable
sealed class MetadataAlbum {
    abstract val id: String
    abstract val title: String
    abstract val description: String?
    abstract val thumbnails: List<Thumbnail>
    abstract val albumType: MetadataAlbumType
    abstract val artists: List<MetadataArtist.Basic>
    abstract val externalUri: String?

    @Serializable
    @SerialName("base")
    data class Basic(
        override val id: String,
        override val title: String,
        override val description: String?,
        override val thumbnails: List<Thumbnail>,
        override val albumType: MetadataAlbumType,
        override val artists: List<MetadataArtist.Basic>,
        override val externalUri: String?

    ) : MetadataAlbum()

    @Serializable
    @SerialName("detailed")
    data class Detailed(
        val releaseDate: String?,
        val genres: List<String>,
        val trackCount: Int,
        override val id: String,
        override val title: String,
        override val description: String?,
        override val thumbnails: List<Thumbnail>,
        override val albumType: MetadataAlbumType,
        override val artists: List<MetadataArtist.Basic>,
        override val externalUri: String?
    ) : MetadataAlbum()
}