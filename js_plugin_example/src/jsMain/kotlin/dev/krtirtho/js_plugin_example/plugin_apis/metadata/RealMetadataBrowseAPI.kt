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

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseGenre
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseItem
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseSection
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult

class RealMetadataBrowseAPI : MetadataBrowseAPI {

    override suspend fun featured(): List<MetadataBrowseItem> {
        return FakeMetadataStore.getFeaturedItems()
    }

    override suspend fun genres(): List<MetadataBrowseGenre> {
        return listOf(
            MetadataBrowseGenre(id = "1", name = "Pop"),
            MetadataBrowseGenre(id = "2", name = "Rock"),
            MetadataBrowseGenre(id = "3", name = "Hip-Hop"),
            MetadataBrowseGenre(id = "4", name = "Jazz"),
            MetadataBrowseGenre(id = "5", name = "Classical")
        )
    }

    override suspend fun list(genreId: String, pagination: PaginationStrategy?): PaginationResult<MetadataBrowseSection> {
        return FakeMetadataStore.paginate(FakeMetadataStore.getBrowseSections(), pagination)
    }

    override suspend fun sublist(
        genreId: String,
        sectionId: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataBrowseItem> {
        return FakeMetadataStore.paginate(FakeMetadataStore.getBrowseSublist(sectionId), pagination)
    }
}
