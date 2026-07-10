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

package dev.krtirtho.spotube.modules.library.playlist

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
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

sealed interface LibraryPlaylistsState {
    data object Loading : LibraryPlaylistsState

    sealed interface Data : LibraryPlaylistsState {
        val query: String
        val allItems: List<MetadataPlaylist>
        val items: List<MetadataPlaylist>
        val nextPagination: PaginationStrategy?

        data class Loaded(
            override val query: String = "",
            override val allItems: List<MetadataPlaylist> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
        ) : Data {
            override val items: List<MetadataPlaylist>
                get() = if (query.isNotBlank()) {
                    allItems.filter {
                        it.title.contains(query, ignoreCase = true) ||
                            (it.description?.contains(query, ignoreCase = true) == true)
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
            override val allItems: List<MetadataPlaylist> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
        ) : Data {
            override val items: List<MetadataPlaylist>
                get() = if (query.isNotBlank()) {
                    allItems.filter {
                        it.title.contains(query, ignoreCase = true) ||
                            (it.description?.contains(query, ignoreCase = true) == true)
                    }
                } else {
                    allItems
                }
        }
    }

    data class Error(val message: String) : LibraryPlaylistsState
}

@OptIn(ExperimentalCoroutinesApi::class)
class LibraryPlaylistsViewModel(
    private val repository: LibraryRepository,
) : ViewModel(), KoinComponent {
    private val logger by injectLogger<LibraryPlaylistsViewModel>()

    private val _state = MutableStateFlow<LibraryPlaylistsState>(LibraryPlaylistsState.Loading)
    val uiState: StateFlow<LibraryPlaylistsState> = _state.asStateFlow()

    init {
        viewModelScope.launch {
            combine(
                repository.pluginManager.selectedMetadataPlugin
                    .filterNotNull()
                    .flatMapLatest { it.loggedInFlow }
                    .distinctUntilChanged(),
                repository.savedPlaylistIdsFlow
            ) { _, _ -> }.collect {
                loadInitialData()
            }
        }
    }

    private suspend fun loadInitialData() = runCatching {
        _state.value = LibraryPlaylistsState.Loading
        val result = repository.savedPlaylists()
        _state.value = LibraryPlaylistsState.Data.Loaded(
            allItems = result?.items ?: emptyList(),
            nextPagination = result?.nextPagination,
        )
    }.onFailure { e ->
        logger.e(e) { "Failed to load playlists" }
        _state.value = LibraryPlaylistsState.Error(e.message ?: "Unknown error")
    }

    suspend fun loadMoreData() = runCatching {
        val currentState = _state.value
        if (currentState is LibraryPlaylistsState.Data.Loaded && currentState.nextPagination != null) {
            _state.value = currentState.toLoadingMore()
            val result = repository.savedPlaylists(currentState.nextPagination)
            _state.value = LibraryPlaylistsState.Data.Loaded(
                query = currentState.query,
                allItems = currentState.allItems + (result?.items ?: emptyList()),
                nextPagination = result?.nextPagination,
            )
        }
    }.onFailure { e ->
        logger.e(e) { "Failed to load more playlists" }
        _state.value = LibraryPlaylistsState.Error(e.message ?: "Unknown error")
    }

    fun onQueryChange(query: String) {
        val currentState = _state.value
        if (currentState is LibraryPlaylistsState.Data) {
            _state.value = when (currentState) {
                is LibraryPlaylistsState.Data.Loaded -> currentState.copy(query = query)
                is LibraryPlaylistsState.Data.LoadingMore -> currentState.copy(query = query)
            }
        }
    }

    fun refresh() {
        viewModelScope.launch {
            repository.invalidateCaches()
            loadInitialData()
        }
    }

    fun createPlaylist(
        name: String,
        description: String?,
        isPublic: Boolean,
        isCollaborating: Boolean,
        imageBase64: String,
        trackIds: List<String>,
    ) {
        viewModelScope.launch {
            runCatching {
                repository.createPlaylist(
                    name = name,
                    description = description,
                    isPublic = isPublic,
                    isCollaborating = isCollaborating,
                    imageBase64 = imageBase64,
                    trackIds = trackIds,
                )
            }.onFailure { e ->
                logger.e(e) { "Failed to create playlist" }
            }.onSuccess {
                repository.invalidateCaches()
                loadInitialData()
            }
        }
    }
}
