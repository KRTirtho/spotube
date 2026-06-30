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

import app.cash.zipline.ZiplineService
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult

const val MetadataTrackAPI_SERVICE_NAME = "MetadataTrackAPI"

interface MetadataTrackAPI : ZiplineService {
    suspend fun getTrack(id: String): MetadataTrack

    suspend fun savedTracks(
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataTrack>

    suspend fun isSavedTracks(ids: List<String>): List<Boolean>

    suspend fun saveTracks(ids: List<String>)
    suspend fun removeSavedTracks(ids: List<String>)

    suspend fun recommendationsBasedOnTracks(
        seedTrackIds: List<String>,
        limit: Int = 20
    ): List<MetadataTrack>
}