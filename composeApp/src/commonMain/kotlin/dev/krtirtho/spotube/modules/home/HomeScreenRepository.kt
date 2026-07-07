/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package dev.krtirtho.spotube.modules.home

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseItem
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseSection
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.spotube.modules.plugin.PluginManager
import io.github.reactivecircus.cache4k.Cache
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch


@OptIn(ExperimentalCoroutinesApi::class)
class HomeScreenRepository(
    private val pluginManager: PluginManager
) {
    val scope = CoroutineScope(Dispatchers.Default + SupervisorJob())

    val plugin
        get() = pluginManager.selectedMetadataPlugin.value

    private val featuredItemCache = Cache.Builder<String, List<MetadataBrowseItem>>().build()
    private val browseItemCache =
        Cache.Builder<PaginationStrategy, PaginationResult<MetadataBrowseSection>>().build()
    private val sublistItemCache =
        Cache.Builder<Pair<String, PaginationStrategy>, PaginationResult<MetadataBrowseItem>>()
            .build()

    init {
        scope.launch {
            pluginManager.selectedMetadataPlugin
                .filterNotNull()
                .flatMapLatest { it.loggedInFlow }
                .distinctUntilChanged()
                .collect {
                    invalidateCaches()
                }
        }
    }

    fun invalidateCaches() {
        featuredItemCache.invalidateAll()
        browseItemCache.invalidateAll()
        sublistItemCache.invalidateAll()
    }

    suspend fun featuredItems() = plugin?.let { plugin ->
        featuredItemCache.get("featured_items") {
            pluginManager.withScope {
                plugin.use {
                    metadataBrowseAPI.featured()
                }
            }
        }
    }

    suspend fun list(paginationStrategy: PaginationStrategy? = null) =
        plugin?.let { plugin ->
            browseItemCache.get(
                key = paginationStrategy ?: PaginationStrategy.Offset(0, 20)
            ) {
                pluginManager.withScope {
                    plugin.use {
                        metadataBrowseAPI.list(paginationStrategy)
                    }
                }
            }
        }

    suspend fun sublist(
        parentId: String,
        paginationStrategy: PaginationStrategy? = null
    ) = plugin?.let { plugin ->
        sublistItemCache.get(
            parentId to (paginationStrategy ?: PaginationStrategy.Offset(
                0,
                20
            ))
        ) {
            pluginManager.withScope {
                plugin.use {
                    metadataBrowseAPI.sublist(parentId, paginationStrategy)
                }
            }
        }
    }
}