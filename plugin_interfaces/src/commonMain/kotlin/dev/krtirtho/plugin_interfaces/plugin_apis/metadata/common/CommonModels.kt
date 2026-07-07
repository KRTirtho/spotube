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

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed interface PaginationStrategy {
    @Serializable
    @SerialName("Offset")
    data class Offset(val offset: Int, val limit: Int) : PaginationStrategy

    @Serializable
    @SerialName("Cursor")
    data class Cursor(val cursor: String?, val limit: Int) : PaginationStrategy

    @Serializable
    @SerialName("Page")
    data class Page(val page: Int, val pageSize: Int) : PaginationStrategy

    @Serializable
    @SerialName("Continuation")
    data class Continuation(val continuationToken: String?) : PaginationStrategy
}

@Serializable
data class PaginationResult<T>(
    val items: List<T>,
    val totalCount: Int,
    val nextPagination: PaginationStrategy?,
)

@Serializable
data class Thumbnail(
    val url: String,
    val width: Int,
    val height: Int
)