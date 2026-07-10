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

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
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
import dev.krtirtho.spotube.modules.library.playlist.AddToPlaylistPicker
import kotlinx.coroutines.launch
import org.koin.compose.koinInject
import org.koin.compose.viewmodel.koinViewModel
import org.koin.core.parameter.parametersOf

@Composable
fun AlbumScreen(albumId: String) {
    val audioPlayerQueue: AudioPlayerQueue = koinInject()
    val audioPlayer: AudioPlayer = koinInject()
    val shareService: ShareService = koinInject()
    val downloadsViewModel: DownloadsViewModel = koinViewModel()
    val libraryRepository: LibraryRepository = koinInject()
    val scope = rememberCoroutineScope()
    val viewModel = koinViewModel<AlbumViewModel>(
        key = albumId,
        parameters = { parametersOf(albumId) }
    )
    val navigationCommands = koinInject<NavigationCommands>()
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val queue by audioPlayerQueue.queueFlow.collectAsStateWithLifecycle()
    val currentQueueEntry by audioPlayerQueue.currentQueueEntryFlow.collectAsStateWithLifecycle()
    val currentCollectionEntry by audioPlayerQueue.currentCollectionEntryFlow.collectAsStateWithLifecycle()
    val playerState by audioPlayer.playerStateFlow.collectAsStateWithLifecycle()
    val savedTrackIds by viewModel.savedTrackIds.collectAsStateWithLifecycle()
    val savedAlbumIds by viewModel.savedAlbumIds.collectAsStateWithLifecycle()
    var showAddToPlaylistPicker by remember { mutableStateOf(false) }
    var tracksToAddToPlaylist by remember { mutableStateOf<List<MetadataTrack>>(emptyList()) }
    var currentUserId by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(Unit) {
        currentUserId = libraryRepository.currentUser()?.id
    }

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
        if (action is TrackOptionsAction.AddToPlaylist) {
            tracksToAddToPlaylist = listOf(track)
            showAddToPlaylistPicker = true
        }
    }

    Scaffold(
        topBar = { ApplicationMainBar() }
    ) { innerPadding ->
        when (state) {
            is AlbumScreenState.Loading -> {
                TrackList(
                    modifier = Modifier.padding(innerPadding),
                    headerContent = {
                        SkeletonTree(true) {
                            CollectionDetails(
                                title = "Loading album...",
                                description = "",
                                imageURL = "",
                                ownerName = "Unknown artist",
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

            is AlbumScreenState.Error -> {
                ErrorDisplay(
                    errorMessage = (state as AlbumScreenState.Error).message,
                    onRetry = { viewModel.refresh() },
                    modifier = Modifier.padding(innerPadding),
                )
            }

            is AlbumScreenState.Data -> {
                val dataState = state as AlbumScreenState.Data
                val album = dataState.album
                val ownerName =
                    album?.artists?.joinToString { it.name }.orEmpty().ifBlank { "Unknown artist" }
                val ownerImageURL = album?.artists?.firstOrNull()?.thumbnails?.firstOrNull()?.url
                val firstArtistId = album?.artists?.firstOrNull()?.id

                TrackList(
                    modifier = Modifier.padding(innerPadding),
                    headerContent = {
                        CollectionDetails(
                            title = album?.title ?: "Loading album...",
                            description = album?.description ?: "${album?.albumType?.name.orEmpty()} • ${album?.releaseDate.orEmpty()}",
                            imageURL = album?.thumbnails?.firstOrNull()?.url.orEmpty(),
                            ownerName = ownerName,
                            ownerImageURL = ownerImageURL,
                            onOwnerClick = {
                                firstArtistId?.let {
                                    navigationCommands.navigateTo(
                                        Routes.Artist(it)
                                    )
                                }
                            },
                            onPlay = viewModel::playAlbum,
                            onShufflePlay = {},
                            onAddToQueue = viewModel::addAlbumToQueue,
                            isPlaying =
                                currentCollectionEntry?.id == albumId &&
                                        playerState == PlayerState.PLAYING,
                            isFollowing = savedAlbumIds.contains(albumId),
                            onFollowClick = viewModel::toggleSavedAlbum,
                        )
                    },
                    tracks = dataState.tracks,
                    error = null,
                    hasMore = dataState.nextPagination != null,
                    isLoading = state is AlbumScreenState.Loading && dataState.tracks.isEmpty(),
                    isLoadingNextPage = state is AlbumScreenState.Data.LoadingMore,
                    currentTrackId = (currentQueueEntry as? QueueEntry.StreamingTrack)?.track?.id,
                    isCurrentTrackPlaying = playerState == PlayerState.PLAYING,
                    onTrackClick = viewModel::playAlbumFromTrack,
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
                    onBulkAddToPlaylist = { tracks ->
                        tracksToAddToPlaylist = tracks
                        showAddToPlaylistPicker = true
                    },
                )
            }
        }

        AddToPlaylistPicker(
            visible = showAddToPlaylistPicker,
            currentUserId = currentUserId,
            onDismiss = { showAddToPlaylistPicker = false },
            onPlaylistSelected = { playlistId ->
                scope.launch {
                    libraryRepository.addTracksToPlaylist(
                        playlistId,
                        tracksToAddToPlaylist.map { it.id }
                    )
                }
            },
        )
    }
}
