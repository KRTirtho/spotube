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
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbumAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack

class RealMetadataAlbumAPI : MetadataAlbumAPI {

    override suspend fun getAlbum(id: String): MetadataAlbum.Detailed {
        return FakeMetadataStore.getAlbum(id)
    }

    override suspend fun getTrackAlbum(track: MetadataTrack): MetadataAlbum.Detailed {
        TODO("Not yet implemented")
    }

    override suspend fun getAlbumTracks(
        id: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataTrack> {
        return FakeMetadataStore.paginate(FakeMetadataStore.getAlbumTracks(id), pagination)
    }

    override suspend fun savedAlbums(
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataAlbum.Detailed> {
        return FakeMetadataStore.paginate(FakeMetadataStore.savedAlbums(), pagination)
    }

    override suspend fun isSavedAlbums(ids: List<String>): List<Boolean> {
        return FakeMetadataStore.isSavedAlbums(ids)
    }

    override suspend fun saveAlbums(ids: List<String>) {
        FakeMetadataStore.saveAlbums(ids)
    }

    override suspend fun removeSavedAlbums(ids: List<String>) {
        FakeMetadataStore.removeSavedAlbums(ids)
    }
}
