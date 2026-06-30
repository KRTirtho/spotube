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
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search.MetadataSearchAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search.MetadataSearchResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search.MetadataSupportedSearchType

class RealMetadataSearchAPI : MetadataSearchAPI {

    override val supportedSearchTypes: List<MetadataSupportedSearchType> = listOf(
        MetadataSupportedSearchType.ALL,
        MetadataSupportedSearchType.TRACK,
        MetadataSupportedSearchType.ARTIST,
        MetadataSupportedSearchType.ALBUM,
        MetadataSupportedSearchType.PLAYLIST,
        MetadataSupportedSearchType.USER,
    )

    override suspend fun search(query: String): List<MetadataSearchResult> {
        return FakeMetadataStore.search(query)
    }

    override suspend fun searchTracks(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Track> {
        return FakeMetadataStore.paginate(FakeMetadataStore.searchTracks(query), pagination)
    }

    override suspend fun searchArtists(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Artist> {
        return FakeMetadataStore.paginate(FakeMetadataStore.searchArtists(query), pagination)
    }

    override suspend fun searchAlbums(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Album> {
        return FakeMetadataStore.paginate(FakeMetadataStore.searchAlbums(query), pagination)
    }

    override suspend fun searchPlaylists(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Playlist> {
        return FakeMetadataStore.paginate(FakeMetadataStore.searchPlaylists(query), pagination)
    }

    override suspend fun searchUsers(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.User> {
        return FakeMetadataStore.paginate(FakeMetadataStore.searchUsers(query), pagination)
    }
}
