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

import app.cash.zipline.ZiplineService
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult

const val MetadataSearchAPI_SERVICE_NAME = "MetadataSearchAPI"

interface MetadataSearchAPI : ZiplineService {
    val supportedSearchTypes: List<MetadataSupportedSearchType>

    suspend fun search(query: String): List<MetadataSearchResult>

    suspend fun searchTracks(
        query: String,
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataSearchResult.Track>

    suspend fun searchArtists(
        query: String,
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataSearchResult.Artist>

    suspend fun searchAlbums(
        query: String,
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataSearchResult.Album>

    suspend fun searchPlaylists(
        query: String,
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataSearchResult.Playlist>

    suspend fun searchUsers(
        query: String,
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataSearchResult.User>
}