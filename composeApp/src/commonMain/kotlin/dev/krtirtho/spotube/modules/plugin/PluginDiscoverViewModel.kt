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

package dev.krtirtho.spotube.modules.plugin

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.spotube.core.di.injectLogger
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent

data class PluginDiscoverState(
    val repos: List<GitHubRepo> = emptyList(),
    val currentPage: Int = 1,
    val hasMore: Boolean = true,
    val isLoading: Boolean = false,
    val isLoadingMore: Boolean = false,
    val error: String? = null,
    val installingRepoId: Long? = null,
    val isInitialLoaded: Boolean = false,
)

class PluginDiscoverViewModel(
    private val pluginManager: PluginManager,
) : ViewModel(), KoinComponent {

    private val logger by injectLogger<PluginDiscoverViewModel>()
    private val gitHubRepo = GitHubPluginRepository()

    private val _allRepos = mutableListOf<GitHubRepo>()
    private val _paginationInfo = PaginationInfo()

    private val _state = MutableStateFlow(PluginDiscoverState())
    val state: StateFlow<PluginDiscoverState> = _state.asStateFlow()

    private class PaginationInfo(
        var currentPage: Int = 1,
        var hasMore: Boolean = true,
        var totalCount: Int = 0,
    )

    init {
        viewModelScope.launch {
            pluginManager.state.collect { pluginState ->
                if (pluginState is PluginManagerStates.Data) {
                    val installedUrls = pluginState.plugins.mapNotNull { it.repository.takeIf { r -> r.isNotBlank() } }.toSet()
                    _state.update {
                        it.copy(repos = _allRepos.filter { repo -> repo.htmlUrl !in installedUrls })
                    }
                }
            }
        }
        loadFirstPage()
    }

    private fun filterInstalled(repos: List<GitHubRepo>): List<GitHubRepo> {
        val pluginState = pluginManager.state.value
        if (pluginState !is PluginManagerStates.Data) return repos
        val installedUrls = pluginState.plugins.mapNotNull { it.repository.takeIf { r -> r.isNotBlank() } }.toSet()
        return repos.filter { it.htmlUrl !in installedUrls }
    }

    private fun loadFirstPage() {
        viewModelScope.launch {
            _state.update { it.copy(isLoading = true, error = null) }
            runCatching {
                gitHubRepo.searchSpotubePlugins(page = 1)
            }.onSuccess { response ->
                _allRepos.clear()
                _allRepos.addAll(response.items)
                _paginationInfo.currentPage = 1
                _paginationInfo.totalCount = response.totalCount
                _paginationInfo.hasMore = _allRepos.size < response.totalCount
                _state.update {
                    it.copy(
                        repos = filterInstalled(response.items),
                        currentPage = 1,
                        hasMore = _paginationInfo.hasMore,
                        isLoading = false,
                        isInitialLoaded = true,
                    )
                }
            }.onFailure { e ->
                logger.e(e) { "Failed to load plugins" }
                _state.update {
                    it.copy(
                        isLoading = false,
                        error = e.message,
                        isInitialLoaded = true,
                    )
                }
            }
        }
    }

    fun loadNextPage() {
        val current = _state.value
        if (current.isLoadingMore || !current.hasMore) return
        viewModelScope.launch {
            val nextPage = _paginationInfo.currentPage + 1
            _state.update { it.copy(isLoadingMore = true, error = null) }
            runCatching {
                gitHubRepo.searchSpotubePlugins(page = nextPage)
            }.onSuccess { response ->
                _allRepos.addAll(response.items)
                _paginationInfo.currentPage = nextPage
                _paginationInfo.hasMore = _allRepos.size < response.totalCount
                _state.update {
                    it.copy(
                        repos = filterInstalled(_allRepos),
                        currentPage = nextPage,
                        hasMore = _paginationInfo.hasMore,
                        isLoadingMore = false,
                    )
                }
            }.onFailure { e ->
                logger.e(e) { "Failed to load more plugins" }
                _state.update { it.copy(isLoadingMore = false, error = e.message) }
            }
        }
    }

    fun installPlugin(repo: GitHubRepo) {
        if (_state.value.installingRepoId != null) return
        _state.update { it.copy(installingRepoId = repo.id, error = null) }
        viewModelScope.launch {
            runCatching {
                val parts = repo.fullName.split("/")
                val url = gitHubRepo.getLatestReleaseSmplugUrl(parts[0], parts[1])
                    ?: throw IllegalStateException("No .smplug asset found in latest release")
                pluginManager.addPluginFromURL(url)
            }.onFailure { e ->
                logger.e(e) { "Failed to install plugin" }
                _state.update { it.copy(error = e.message) }
            }
            _state.update { it.copy(installingRepoId = null) }
        }
    }

    fun installPluginFromUrl(url: String, repoId: Long) {
        if (_state.value.installingRepoId != null) return
        _state.update { it.copy(installingRepoId = repoId, error = null) }
        viewModelScope.launch {
            runCatching {
                pluginManager.addPluginFromURL(url)
            }.onFailure { e ->
                logger.e(e) { "Failed to install plugin" }
                _state.update { it.copy(error = e.message) }
            }
            _state.update { it.copy(installingRepoId = null) }
        }
    }

    suspend fun getReleases(owner: String, repo: String): List<GitHubRelease> {
        return gitHubRepo.getReleases(owner, repo)
    }

    override fun onCleared() {
        gitHubRepo.close()
        super.onCleared()
    }
}
