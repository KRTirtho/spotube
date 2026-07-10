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

package dev.krtirtho.spotube.modules.playlist

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.audioplayer.AudioPlayer
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.PlayerState
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.core.share.ShareService
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.core.ui.component.CollectionDetails
import dev.krtirtho.spotube.core.ui.component.ErrorDisplay
import dev.krtirtho.spotube.core.ui.component.TrackList
import dev.krtirtho.spotube.core.ui.component.TrackOptionsAction
import dev.krtirtho.spotube.core.ui.component.TrackOptionsState
import dev.krtirtho.spotube.core.ui.misc.SkeletonTree
import dev.krtirtho.spotube.modules.downloads.DownloadsViewModel
import dev.krtirtho.spotube.modules.library.LibraryRepository
import dev.krtirtho.spotube.modules.library.playlist.PlaylistFormData
import dev.krtirtho.spotube.modules.library.playlist.PlaylistFormSheet
import org.koin.compose.koinInject
import org.koin.compose.viewmodel.koinViewModel
import org.koin.core.parameter.parametersOf

@Composable
fun PlaylistScreen(playlistId: String) {
    val audioPlayerQueue: AudioPlayerQueue = koinInject()
    val audioPlayer: AudioPlayer = koinInject()
    val shareService: ShareService = koinInject()
    val downloadsViewModel: DownloadsViewModel = koinViewModel()
    val viewModel = koinViewModel<PlaylistViewModel>(
        key = playlistId,
        parameters = { parametersOf(playlistId) }
    )
    val navigationCommands = koinInject<NavigationCommands>()
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val queue by audioPlayerQueue.queueFlow.collectAsStateWithLifecycle()
    val currentQueueEntry by audioPlayerQueue.currentQueueEntryFlow.collectAsStateWithLifecycle()
    val currentCollectionEntry by audioPlayerQueue.currentCollectionEntryFlow.collectAsStateWithLifecycle()
    val playerState by audioPlayer.playerStateFlow.collectAsStateWithLifecycle()
    val savedPlaylistIds by viewModel.savedPlaylistIds.collectAsStateWithLifecycle()
    val currentUserId by viewModel.currentUserId.collectAsStateWithLifecycle()
    var showEditPlaylist by remember { mutableStateOf(false) }

    fun handleTrackOptionsAction(track: MetadataTrack, action: TrackOptionsAction) {
        viewModel.handleTrackOptionsAction(track, action)
        if (action is TrackOptionsAction.Share) {
            val uri = track.externalUri?.takeIf { it.isNotBlank() }
            if (uri != null) {
                shareService.share(uri, track.title)
            }
        }
        if (action is TrackOptionsAction.Download) {
            downloadsViewModel.downloadTrack(track)
        }
    }

    Scaffold(
        topBar = { ApplicationMainBar() }
    ) { innerPadding ->
        when (state) {
            is PlaylistScreenState.Loading -> {
                TrackList(
                    modifier = Modifier.padding(innerPadding),
                    headerContent = {
                        SkeletonTree(true){
                            CollectionDetails(
                                title = "Loading playlist...",
                                description = "",
                                imageURL = "",
                                ownerName = "Unknown",
                                ownerImageURL = null,
                                onOwnerClick = {},
                                onPlay = {},
                                onShufflePlay = {},
                                onAddToQueue = {},
                                isPlaying = false,
                                isFollowing = false,
                                onFollowClick = {},
                            )
                        }
                    },
                    tracks = emptyList(),
                    error = null,
                    hasMore = false,
                    isLoading = true,
                    isLoadingNextPage = false,
                    currentTrackId = null,
                    isCurrentTrackPlaying = false,
                    onTrackClick = {},
                    onLoadNextPage = {},
                    onArtistClick = { navigationCommands.navigateTo(Routes.Artist(it.id)) },
                    onAlbumClick = { navigationCommands.navigateTo(Routes.Album(it.id)) },
                    onTrackOptionsAction = { _, _ -> },
                    trackOptionsState = { TrackOptionsState() },
                )
            }

            is PlaylistScreenState.Error -> {
                ErrorDisplay(
                    errorMessage = (state as PlaylistScreenState.Error).message,
                    onRetry = { viewModel.refresh() },
                    modifier = Modifier.padding(innerPadding),
                )
            }

            is PlaylistScreenState.Data -> {
                val dataState = state as PlaylistScreenState.Data
                val playlist = dataState.playlist
                val owner = playlist?.owner
                val ownerName = owner?.displayName ?: owner?.username ?: "Unknown"
                val ownerImageURL = owner?.thumbnails?.firstOrNull()?.url

                val isOwner = currentUserId != null && playlist?.owner?.id == currentUserId

                val savedTrackIds by viewModel.savedTrackIds.collectAsStateWithLifecycle()


                fun getTrackOptionsState(track: MetadataTrack): TrackOptionsState {
                    val currentTrackId = (currentQueueEntry as? QueueEntry.StreamingTrack)?.track?.id
                    val queueTrackIds = queue.mapNotNull { entry ->
                        (entry as? QueueEntry.StreamingTrack)?.track?.id
                    }.toSet()
                    return TrackOptionsState(
                        isInQueue = queueTrackIds.contains(track.id),
                        isCurrentlyPlaying = track.id == currentTrackId,
                        isFavorite = savedTrackIds.contains(track.id),
                        isBlacklisted = false,
                    )
                }

                TrackList(
                    modifier = Modifier.padding(innerPadding),
                    headerContent = {
                        CollectionDetails(
                            title = playlist?.title ?: "Loading playlist...",
                            description = playlist?.description.orEmpty(),
                            imageURL = playlist?.thumbnails?.firstOrNull()?.url.orEmpty(),
                            ownerName = ownerName,
                            ownerImageURL = ownerImageURL,
                            onOwnerClick = {},
                            onPlay = viewModel::playPlaylist,
                            onShufflePlay = {},
                            onAddToQueue = viewModel::addPlaylistToQueue,
                            isPlaying =
                                currentCollectionEntry?.id == playlistId &&
                                    playerState == PlayerState.PLAYING,
                            isFollowing = savedPlaylistIds.contains(playlistId),
                            onFollowClick = viewModel::toggleSavedPlaylist,
                            showFollowButton = playlistId != "saved_tracks",
                            onEdit = if (isOwner) { { showEditPlaylist = true } } else null,
                        )
                    },
                    tracks = dataState.tracks,
                    error = null,
                    hasMore = dataState.nextPagination != null,
                    isLoading = state is PlaylistScreenState.Loading && dataState.tracks.isEmpty(),
                    isLoadingNextPage = state is PlaylistScreenState.Data.LoadingMore,
                    currentTrackId = (currentQueueEntry as? QueueEntry.StreamingTrack)?.track?.id,
                    isCurrentTrackPlaying = playerState == PlayerState.PLAYING,
                    onTrackClick = viewModel::playPlaylistFromTrack,
                    onLoadNextPage = viewModel::loadNextTracksPage,
                    onArtistClick = { navigationCommands.navigateTo(Routes.Artist(it.id)) },
                    onAlbumClick = { navigationCommands.navigateTo(Routes.Album(it.id)) },
                    onTrackOptionsAction = ::handleTrackOptionsAction,
                    trackOptionsState = ::getTrackOptionsState,
                    onBulkDownload = { tracks ->
                        downloadsViewModel.downloadTracks(tracks)
                    },
                    onBulkAddToQueue = { tracks ->
                        viewModel.addTracksToQueue(tracks)
                    },
                    onBulkPlayNext = { tracks ->
                        viewModel.playTracksNext(tracks)
                    },
                )
            }
        }

        val dataState = state as? PlaylistScreenState.Data
        val playlist = (dataState as? PlaylistScreenState.Data.Loaded)?.playlist
        PlaylistFormSheet(
            visible = showEditPlaylist,
            onDismiss = { showEditPlaylist = false },
            isEditing = true,
            initialData = playlist?.let {
                PlaylistFormData(
                    name = it.title,
                    description = it.description.orEmpty(),
                    isPublic = true,
                    isCollaborating = false,
                    imagePreviewUrl = it.thumbnails.firstOrNull()?.url,
                )
            },
            onSubmit = { data ->
                viewModel.updatePlaylist(
                    name = data.name,
                    description = data.description.ifBlank { null },
                    isPublic = data.isPublic,
                    isCollaborating = data.isCollaborating,
                    imageBase64 = data.imageBase64.ifBlank { null },
                )
            },
        )
    }
}
