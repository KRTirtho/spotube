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

package dev.krtirtho.spotube.modules.library.album

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.modules.library.LibraryRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent

sealed interface LibraryAlbumsState {
    data object Loading : LibraryAlbumsState

    sealed interface Data : LibraryAlbumsState {
        val query: String
        val allItems: List<MetadataAlbum.Detailed>
        val items: List<MetadataAlbum.Detailed>
        val nextPagination: PaginationStrategy?

        data class Loaded(
            override val query: String = "",
            override val allItems: List<MetadataAlbum.Detailed> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
        ) : Data {
            override val items: List<MetadataAlbum.Detailed>
                get() = if (query.isNotBlank()) {
                    allItems.filter { album ->
                        album.title.contains(query, ignoreCase = true) ||
                                album.artists.any { artist ->
                                    artist.name.contains(query, ignoreCase = true)
                                }
                    }
                } else {
                    allItems
                }

            fun toLoadingMore(): LoadingMore = LoadingMore(
                query = query,
                allItems = allItems,
                nextPagination = nextPagination,
            )
        }

        data class LoadingMore(
            override val query: String = "",
            override val allItems: List<MetadataAlbum.Detailed> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
        ) : Data {
            override val items: List<MetadataAlbum.Detailed>
                get() = if (query.isNotBlank()) {
                    allItems.filter { album ->
                        album.title.contains(query, ignoreCase = true) ||
                                album.artists.any { artist ->
                                    artist.name.contains(query, ignoreCase = true)
                                }
                    }
                } else {
                    allItems
                }
        }
    }

    data class Error(val message: String) : LibraryAlbumsState
}

@OptIn(ExperimentalCoroutinesApi::class)
class LibraryAlbumsViewModel(
    private val repository: LibraryRepository,
) : ViewModel(), KoinComponent {
    private val logger by injectLogger<LibraryAlbumsViewModel>()

    private val _state = MutableStateFlow<LibraryAlbumsState>(LibraryAlbumsState.Loading)
    val uiState: StateFlow<LibraryAlbumsState> = _state.asStateFlow()

    init {
        viewModelScope.launch {
            combine(
                repository.pluginManager.selectedMetadataPlugin
                    .filterNotNull()
                    .flatMapLatest { it.loggedInFlow }
                    .distinctUntilChanged(),
                repository.savedAlbumIdsFlow
            ) { _, _ -> }.collect {
                loadInitialData()
            }
        }
    }

    private suspend fun loadInitialData() = runCatching {
        _state.value = LibraryAlbumsState.Loading
        val result = repository.savedAlbums()
        _state.value = LibraryAlbumsState.Data.Loaded(
            allItems = result?.items ?: emptyList(),
            nextPagination = result?.nextPagination,
        )
    }.onFailure { e ->
        logger.e(e) { "Failed to load albums" }
        _state.value = LibraryAlbumsState.Error(e.message ?: "Unknown error")
    }

    suspend fun loadMoreData() = runCatching {
        val currentState = _state.value
        if (currentState is LibraryAlbumsState.Data.Loaded && currentState.nextPagination != null) {
            _state.value = currentState.toLoadingMore()
            val result = repository.savedAlbums(currentState.nextPagination)
            _state.value = LibraryAlbumsState.Data.Loaded(
                query = currentState.query,
                allItems = currentState.allItems + (result?.items ?: emptyList()),
                nextPagination = result?.nextPagination,
            )
        }
    }.onFailure { e ->
        logger.e(e) { "Failed to load more albums" }
        _state.value = LibraryAlbumsState.Error(e.message ?: "Unknown error")
    }

    fun onQueryChange(query: String) {
        val currentState = _state.value
        if (currentState is LibraryAlbumsState.Data) {
            _state.value = when (currentState) {
                is LibraryAlbumsState.Data.Loaded -> currentState.copy(query = query)
                is LibraryAlbumsState.Data.LoadingMore -> currentState.copy(query = query)
            }
        }
    }

    fun refresh() {
        viewModelScope.launch {
            repository.invalidateCaches()
            loadInitialData()
        }
    }
}
