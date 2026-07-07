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

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseItem
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseSection
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.modules.plugin.PluginManager
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.mapNotNull
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.flow.scan
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent

sealed interface HomeScreenState {
    data object Loading : HomeScreenState

    sealed interface Data : HomeScreenState {
        val featuredItems: List<MetadataBrowseItem>
        val browseSections: List<MetadataBrowseSection>
        val paginationStrategy: PaginationStrategy?
        val totalItems: Int

        data class Loaded(
            override val featuredItems: List<MetadataBrowseItem>,
            override val browseSections: List<MetadataBrowseSection>,
            override val paginationStrategy: PaginationStrategy?,
            override val totalItems: Int,
        ) : Data {
            fun toLoadingMore(): LoadingMore = LoadingMore(
                featuredItems = featuredItems,
                browseSections = browseSections,
                paginationStrategy = paginationStrategy,
                totalItems = totalItems,
            )
        }

        data class LoadingMore(
            override val featuredItems: List<MetadataBrowseItem>,
            override val browseSections: List<MetadataBrowseSection>,
            override val paginationStrategy: PaginationStrategy?,
            override val totalItems: Int,
        ) : Data
    }

    data class Error(val message: String) : HomeScreenState
}

@OptIn(ExperimentalCoroutinesApi::class)
class HomeScreenViewModel(
    private val repository: HomeScreenRepository, private val pluginManager: PluginManager
) : ViewModel(), KoinComponent {
    private val logger by injectLogger<HomeScreenViewModel>()

    private val state = MutableStateFlow<HomeScreenState>(HomeScreenState.Loading)
    val uiState = state.asStateFlow()

    init {
        viewModelScope.launch {
            pluginManager.selectedMetadataPlugin
                .filterNotNull()
                .flatMapLatest { it.loggedInFlow }
                .distinctUntilChanged().collect {
                    loadInitialData()
                }
        }
    }

    private suspend fun loadInitialData() = runCatching {
        state.value = HomeScreenState.Loading
        val featuredItems = repository.featuredItems()
        val browseSections = repository.list()
        state.value = HomeScreenState.Data.Loaded(
            featuredItems = featuredItems ?: emptyList(),
            browseSections = browseSections?.items ?: emptyList(),
            paginationStrategy = browseSections?.nextPagination,
            totalItems = browseSections?.items?.size ?: 0,
        )
    }.onFailure { e ->
        logger.e(e) { "Failed to load home screen data" }
        state.value = HomeScreenState.Error(e.message ?: "Unknown error")
    }

    suspend fun loadMoreData() = runCatching {
        val currentState = state.value
        if (currentState is HomeScreenState.Data.Loaded && currentState.paginationStrategy != null) {
            state.value = currentState.toLoadingMore()
            val browseSectionsResult = repository.list(currentState.paginationStrategy)
            state.value = HomeScreenState.Data.Loaded(
                featuredItems = currentState.featuredItems,
                browseSections = currentState.browseSections + (browseSectionsResult?.items
                    ?: emptyList()),
                paginationStrategy = browseSectionsResult?.nextPagination,
                totalItems = currentState.totalItems,
            )
        }
    }.onFailure { e ->
        logger.e(e) { "Failed to load more home screen data" }
        state.value = HomeScreenState.Error(e.message ?: "Unknown error")
    }

    fun refresh() {
        viewModelScope.launch {
            repository.invalidateCaches()
            loadInitialData()
        }
    }
}