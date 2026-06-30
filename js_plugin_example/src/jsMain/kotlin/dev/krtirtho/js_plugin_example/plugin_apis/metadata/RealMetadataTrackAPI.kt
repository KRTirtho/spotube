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

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrackAPI

class RealMetadataTrackAPI : MetadataTrackAPI {

    override suspend fun getTrack(id: String): MetadataTrack {
        return FakeMetadataStore.getTrack(id)
    }

    override suspend fun savedTracks(
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataTrack> {
        return FakeMetadataStore.paginate(FakeMetadataStore.savedTracks(), pagination)
    }

    override suspend fun isSavedTracks(ids: List<String>): List<Boolean> {
        return FakeMetadataStore.isSavedTracks(ids)
    }

    override suspend fun saveTracks(ids: List<String>) {
        FakeMetadataStore.saveTracks(ids)
    }

    override suspend fun removeSavedTracks(ids: List<String>) {
        FakeMetadataStore.removeSavedTracks(ids)
    }

    override suspend fun recommendationsBasedOnTracks(
        seedTrackIds: List<String>,
        limit: Int
    ): List<MetadataTrack> {
        return FakeMetadataStore.recommendationsBasedOnTracks(seedTrackIds, limit)
    }
}
