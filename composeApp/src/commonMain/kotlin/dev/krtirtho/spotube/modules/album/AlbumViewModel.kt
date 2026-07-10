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

package dev.krtirtho.spotube.modules.album

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.core.playback.CollectionPlaybackHelper
import dev.krtirtho.spotube.core.ui.component.TrackOptionsAction
import dev.krtirtho.spotube.modules.library.LibraryRepository
import dev.krtirtho.spotube.modules.saved_tracks.SavedTracksRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent

sealed interface AlbumScreenState {
    data object Loading : AlbumScreenState

    sealed interface Data : AlbumScreenState {
        val album: MetadataAlbum.Detailed?
        val isSaved: Boolean
        val tracks: List<MetadataTrack>
        val nextPagination: PaginationStrategy?
        val isSaving: Boolean

        data class Loaded(
            override val album: MetadataAlbum.Detailed? = null,
            override val isSaved: Boolean = false,
            override val tracks: List<MetadataTrack> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
            override val isSaving: Boolean = false,
        ) : Data {
            fun toLoadingMore(): LoadingMore = LoadingMore(
                album = album,
                isSaved = isSaved,
                tracks = tracks,
                nextPagination = nextPagination,
                isSaving = isSaving,
            )
        }

        data class LoadingMore(
            override val album: MetadataAlbum.Detailed? = null,
            override val isSaved: Boolean = false,
            override val tracks: List<MetadataTrack> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
            override val isSaving: Boolean = false,
        ) : Data
    }

    data class Error(val message: String) : AlbumScreenState
}

@OptIn(ExperimentalCoroutinesApi::class)
class AlbumViewModel(
    private val albumId: String,
    private val repository: AlbumRepository,
    private val savedTracksRepository: SavedTracksRepository,
    private val libraryRepository: LibraryRepository,
    private val playbackHelper: CollectionPlaybackHelper,
    private val audioPlayerQueue: AudioPlayerQueue,
) : ViewModel(), KoinComponent {
    private val logger by injectLogger<AlbumViewModel>()

    private val _state = MutableStateFlow<AlbumScreenState>(AlbumScreenState.Loading)
    val uiState: StateFlow<AlbumScreenState> = _state.asStateFlow()
    val savedAlbumIds
        get() = libraryRepository.savedAlbumIdsFlow

    init {
        viewModelScope.launch {
            repository.pluginManager.selectedMetadataPlugin
                .filterNotNull()
                .flatMapLatest { it.loggedInFlow }
                .distinctUntilChanged()
                .collect {
                    loadInitialData()
                }
        }
    }

    private suspend fun loadInitialData() = runCatching {
        _state.value = AlbumScreenState.Loading
        val albumInfo = repository.getAlbumInfo(albumId)
        val tracksResult = repository.getAlbumTracks(albumId)
        tracksResult?.items?.let { savedTracksRepository.isSavedTracks(it.map { item -> item.id }) }
        _state.value = AlbumScreenState.Data.Loaded(
            album = albumInfo?.first,
            isSaved = albumInfo?.second ?: false,
            tracks = tracksResult?.items ?: emptyList(),
            nextPagination = tracksResult?.nextPagination,
        )
    }.onFailure { e ->
        logger.e(e) { "Failed to load album" }
        _state.value = AlbumScreenState.Error(e.message ?: "Unknown error")
    }

    suspend fun loadMoreTracks() = runCatching {
        val currentState = _state.value
        if (currentState is AlbumScreenState.Data.Loaded && currentState.nextPagination != null) {
            _state.value = currentState.toLoadingMore()
            val result = repository.getAlbumTracks(albumId, currentState.nextPagination)
            result?.items?.let { savedTracksRepository.isSavedTracks(it.map { item -> item.id }) }
            _state.value = AlbumScreenState.Data.Loaded(
                album = currentState.album,
                isSaved = currentState.isSaved,
                tracks = currentState.tracks + (result?.items ?: emptyList()),
                nextPagination = result?.nextPagination,
                isSaving = currentState.isSaving,
            )
        }
    }.onFailure { e ->
        logger.e(e) { "Failed to load more tracks" }
        _state.value = AlbumScreenState.Error(e.message ?: "Unknown error")
    }

    fun loadNextTracksPage() {
        viewModelScope.launch {
            loadMoreTracks()
        }
    }

    fun toggleSavedAlbum() {
        viewModelScope.launch {
            val isLiked =
                libraryRepository.isSavedAlbums(listOf(albumId)).firstOrNull() ?: false
            if (isLiked) {
                libraryRepository.removeSavedAlbums(listOf(albumId))
            } else {
                libraryRepository.saveAlbums(listOf(albumId))
            }
        }
    }

    fun playAlbum() {
        viewModelScope.launch { playbackHelper.playAlbum(albumId) }
    }

    fun addAlbumToQueue() {
        viewModelScope.launch { playbackHelper.addAlbumToQueue(albumId) }
    }

    fun playAlbumFromTrack(track: MetadataTrack) {
        viewModelScope.launch { playbackHelper.playAlbumFromTrack(albumId, track) }
    }

    fun refresh() {
        viewModelScope.launch {
            repository.invalidateCaches()
            loadInitialData()
        }
    }

    fun handleTrackOptionsAction(track: MetadataTrack, action: TrackOptionsAction) {
        viewModelScope.launch {
            when (action) {
                is TrackOptionsAction.StartRadio -> {}
                is TrackOptionsAction.PlayNext -> {
                    val queue = audioPlayerQueue.getQueue()
                    val queueIndex = queue.indexOfFirst { entry ->
                        (entry as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
                    }
                    if (queueIndex >= 0) {
                        audioPlayerQueue.removeFromQueue(queue[queueIndex])
                    }
                    audioPlayerQueue.addToQueue(QueueEntry.StreamingTrack(track = track, url = ""))
                    val newQueue = audioPlayerQueue.getQueue()
                    val newIndex = newQueue.indexOfFirst { e ->
                        (e as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
                    }
                    if (newIndex > 0) {
                        audioPlayerQueue.move(newIndex, 0)
                    }
                }

                is TrackOptionsAction.AddToQueue -> {
                    audioPlayerQueue.addToQueue(QueueEntry.StreamingTrack(track = track, url = ""))
                }

                is TrackOptionsAction.RemoveFromQueue -> {
                    val queue = audioPlayerQueue.getQueue()
                    queue.find { entry ->
                        (entry as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
                    }?.let { audioPlayerQueue.removeFromQueue(it) }
                }

                is TrackOptionsAction.ToggleFavorite -> {
                    val savedIds = savedTrackIds.value
                    if (savedIds.contains(track.id)) {
                        savedTracksRepository.removeSavedTracks(listOf(track.id))
                    } else {
                        savedTracksRepository.saveTracks(listOf(track.id))
                    }
                }

                is TrackOptionsAction.Download -> {}
                is TrackOptionsAction.ToggleBlacklist -> {}
                is TrackOptionsAction.Share -> {}
                is TrackOptionsAction.AddToPlaylist -> {}
            }
        }
    }

    fun addTracksToQueue(tracks: List<MetadataTrack>) {
        viewModelScope.launch {
            val entries = tracks.map { QueueEntry.StreamingTrack(track = it, url = "") }
            audioPlayerQueue.addAllToQueue(entries)
        }
    }

    fun playTracksNext(tracks: List<MetadataTrack>) {
        viewModelScope.launch {
            val entries = tracks.map { QueueEntry.StreamingTrack(track = it, url = "") }
            audioPlayerQueue.addAllAfterCurrent(entries)
        }
    }

    val savedTrackIds
        get() = savedTracksRepository.savedTracksIdsFlow

    private fun MetadataTrack.matchesTrack(other: MetadataTrack): Boolean {
        if (id.isNotBlank() && other.id.isNotBlank()) return id == other.id
        return title == other.title &&
                durationMs == other.durationMs &&
                album?.id == other.album?.id &&
                artists.map { it.id.ifBlank { it.name } } == other.artists.map { it.id.ifBlank { it.name } }
    }
}
