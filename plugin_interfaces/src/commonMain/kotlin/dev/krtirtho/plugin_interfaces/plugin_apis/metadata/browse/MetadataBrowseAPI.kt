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

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse

import app.cash.zipline.ZiplineService
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult

const val MetadataBrowseAPI_SERVICE_NAME = "MetadataBrowseAPI"

interface MetadataBrowseAPI: ZiplineService {
    suspend fun featured(): List<MetadataBrowseItem>
    suspend fun genres(): List<MetadataBrowseGenre>
    suspend fun list(genreId: String, pagination: PaginationStrategy? = null): PaginationResult<MetadataBrowseSection>
    suspend fun sublist(genreId: String, sectionId: String, pagination: PaginationStrategy? = null): PaginationResult<MetadataBrowseItem>
}