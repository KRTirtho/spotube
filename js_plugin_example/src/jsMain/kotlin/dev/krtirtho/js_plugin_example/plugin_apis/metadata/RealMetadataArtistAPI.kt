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

package dev.krtirtho.js_plugin_example.plugin_apis.metadata

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtistAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack

class RealMetadataArtistAPI : MetadataArtistAPI {

    override suspend fun getArtist(id: String): MetadataArtist.Detailed {
        return FakeMetadataStore.getArtist(id)
    }

    override suspend fun getArtistTop10Tracks(id: String): List<MetadataTrack> {
        return FakeMetadataStore.getArtistTopTracks(id)
    }

    override suspend fun getArtistAlbums(
        id: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataAlbum.Detailed> {
        return FakeMetadataStore.paginate(FakeMetadataStore.getArtistAlbums(id), pagination)
    }

    override suspend fun savedArtists(
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataArtist.Detailed> {
        return FakeMetadataStore.paginate(FakeMetadataStore.savedArtists(), pagination)
    }

    override suspend fun isSavedArtists(ids: List<String>): List<Boolean> {
        return FakeMetadataStore.isSavedArtists(ids)
    }

    override suspend fun saveArtists(ids: List<String>) {
        FakeMetadataStore.saveArtists(ids)
    }

    override suspend fun removeSavedArtists(ids: List<String>) {
        FakeMetadataStore.removeSavedArtists(ids)
    }
}
