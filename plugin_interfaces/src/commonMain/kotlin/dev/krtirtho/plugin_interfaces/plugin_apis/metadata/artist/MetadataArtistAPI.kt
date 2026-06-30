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

import app.cash.zipline.ZiplineService
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack

const val MetadataArtistAPI_SERVICE_NAME = "MetadataArtistAPI"

interface MetadataArtistAPI : ZiplineService {
    suspend fun getArtist(id: String): MetadataArtist.Detailed
    suspend fun getArtistTop10Tracks(id: String): List<MetadataTrack>
    suspend fun getArtistAlbums(
        id: String,
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataAlbum.Detailed>

    suspend fun savedArtists(pagination: PaginationStrategy? = null): PaginationResult<MetadataArtist.Detailed>

    suspend fun isSavedArtists(ids: List<String>): List<Boolean>
    suspend fun saveArtists(ids: List<String>)
    suspend fun removeSavedArtists(ids: List<String>)
}