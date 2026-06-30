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

package dev.krtirtho.spotube.modules.artist

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilledIconButton
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.FilledTonalIconButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import coil3.compose.AsyncImage
import compose.icons.FeatherIcons
import compose.icons.feathericons.Heart
import compose.icons.feathericons.Play
import compose.icons.feathericons.PlusSquare
import compose.icons.feathericons.User
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.audioplayer.AudioPlayer
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.PlayerState
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.core.share.ShareService
import dev.krtirtho.spotube.core.ui.component.AlbumCard
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.core.ui.component.TrackList
import dev.krtirtho.spotube.core.ui.component.TrackOptionsAction
import dev.krtirtho.spotube.core.ui.component.TrackOptionsState
import dev.krtirtho.spotube.core.ui.component.cards.PlayableCard
import dev.krtirtho.spotube.core.ui.misc.SkeletonTree
import dev.krtirtho.spotube.core.ui.misc.TextWithShimmer
import dev.krtirtho.spotube.core.ui.misc.shimmerApply
import dev.krtirtho.spotube.modules.downloads.DownloadsViewModel
import dev.krtirtho.spotube.modules.library.LibraryRepository
import org.koin.compose.koinInject
import org.koin.compose.viewmodel.koinViewModel
import org.koin.core.parameter.parametersOf
import kotlin.math.roundToInt

@Composable
fun ArtistScreen(artistId: String) {
    val audioPlayerQueue: AudioPlayerQueue = koinInject()
    val audioPlayer: AudioPlayer = koinInject()
    val shareService: ShareService = koinInject()
    val downloadsViewModel: DownloadsViewModel = koinViewModel()
    val viewModel = koinViewModel<ArtistViewModel>(
        key = artistId,
        parameters = { parametersOf(artistId) }
    )
    val navigationCommands = koinInject<NavigationCommands>()

    val artistInfo by viewModel.artistInfo.collectAsStateWithLifecycle()
    val topTracksState by viewModel.topTracks.collectAsStateWithLifecycle()
    val albumsState by viewModel.albums.collectAsStateWithLifecycle()
    val queue by audioPlayerQueue.queueFlow.collectAsStateWithLifecycle()
    val currentQueueEntry by audioPlayerQueue.currentQueueEntryFlow.collectAsStateWithLifecycle()
    val playerState by audioPlayer.playerStateFlow.collectAsStateWithLifecycle()
    val savedTrackIds by viewModel.savedTrackIds.collectAsStateWithLifecycle()
    val savedArtistIds by viewModel.savedArtistIds.collectAsStateWithLifecycle()

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

    val artist = artistInfo.artist

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
        TrackList(
            modifier = Modifier.padding(innerPadding),
            headerContent = {
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    verticalArrangement = Arrangement.spacedBy(20.dp),
                ) {
                    ArtistHeaderCard(
                        artist = artist,
                        isSaved = savedArtistIds.contains(artistId),
                        isLoading = artistInfo.isLoading,
                        isSaving = artistInfo.isSaving,
                        error = artistInfo.error,
                        onFollowClick = viewModel::toggleSavedArtist,
                    )

                    ArtistAlbumsSection(
                        albums = albumsState.items,
                        isLoading = albumsState.isLoading,
                        error = albumsState.error,
                        hasMore = albumsState.hasNextPage,
                        onViewAll = viewModel::loadNextAlbumsPage,
                    )

                    TopTracksHeader(
                        onPlay = viewModel::playTopTracks,
                        onAddToQueue = viewModel::addTopTracksToQueue,
                    )
                }
            },
            tracks = topTracksState.items,
            error = topTracksState.error,
            hasMore = false,
            isLoading = topTracksState.isLoading && topTracksState.items.isEmpty(),
            isLoadingNextPage = false,
            currentTrackId = (currentQueueEntry as? QueueEntry.StreamingTrack)?.track?.id,
            isCurrentTrackPlaying = playerState == PlayerState.PLAYING,
            onTrackClick = viewModel::playTopTracksFromTrack,
            onTrackOptionsAction = ::handleTrackOptionsAction,
            trackOptionsState = ::getTrackOptionsState,
            onArtistClick = { trackArtist -> navigationCommands.navigateTo(Routes.Artist(trackArtist.id)) },
            onAlbumClick = { album -> navigationCommands.navigateTo(Routes.Album(album.id)) },
            onLoadNextPage = { },
            simplified = true,
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

@Composable
private fun ArtistHeaderCard(
    artist: MetadataArtist.Detailed?,
    isSaved: Boolean,
    isLoading: Boolean,
    isSaving: Boolean,
    error: String?,
    onFollowClick: () -> Unit,
) {
    BoxWithConstraints(modifier = Modifier.fillMaxWidth()) {
        val isCompact = maxWidth < 600.dp

        SkeletonTree(isLoading = isLoading) {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 12.dp, vertical = 8.dp),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceContainer,
                ),
                shape = RoundedCornerShape(20.dp),
            ) {
                if (isCompact) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        verticalArrangement = Arrangement.spacedBy(14.dp),
                        horizontalAlignment = Alignment.CenterHorizontally,
                    ) {
                        ArtistAvatar(
                            artist = artist,
                            size = 180.dp,
                        )

                        ArtistMeta(
                            artist = artist,
                            isCompact = true,
                        )

                        ArtistHeaderActions(
                            isSaved = isSaved,
                            isSaving = isSaving,
                            onFollowClick = onFollowClick,
                        )

                        error?.let {
                            TextWithShimmer(
                                text = it,
                                color = MaterialTheme.colorScheme.error,
                                style = MaterialTheme.typography.bodyMedium,
                            )
                        }
                    }
                } else {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(20.dp),
                        horizontalArrangement = Arrangement.spacedBy(20.dp),
                        verticalAlignment = Alignment.Top,
                    ) {
                        ArtistAvatar(
                            artist = artist,
                            size = 220.dp,
                        )

                        Column(
                            modifier = Modifier.weight(1f),
                            verticalArrangement = Arrangement.spacedBy(14.dp),
                        ) {
                            ArtistMeta(
                                artist = artist,
                                isCompact = false,
                            )

                            ArtistHeaderActions(
                                isSaved = isSaved,
                                isSaving = isSaving,
                                onFollowClick = onFollowClick,
                            )

                            error?.let {
                                TextWithShimmer(
                                    text = it,
                                    color = MaterialTheme.colorScheme.error,
                                    style = MaterialTheme.typography.bodyMedium,
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun ArtistAvatar(
    artist: MetadataArtist.Detailed?,
    size: androidx.compose.ui.unit.Dp,
) {
    Box(
        modifier = Modifier
            .size(size)
            .clip(CircleShape)
            .background(MaterialTheme.colorScheme.surfaceContainerHighest)
            .shimmerApply(),
        contentAlignment = Alignment.Center,
    ) {
        val imageUrl = artist?.thumbnails?.firstOrNull()?.url.orEmpty()
        if (imageUrl.isNotBlank()) {
            AsyncImage(
                model = imageUrl,
                contentDescription = artist?.name ?: "Artist",
                modifier = Modifier.fillMaxSize(),
                contentScale = ContentScale.Crop,
            )
        } else {
            Icon(
                imageVector = FeatherIcons.User,
                contentDescription = artist?.name ?: "Artist",
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(size * 0.4f),
            )
        }
    }
}

@Composable
private fun ArtistMeta(
    artist: MetadataArtist.Detailed?,
    isCompact: Boolean,
) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = if (isCompact) Alignment.CenterHorizontally else Alignment.Start,
        verticalArrangement = Arrangement.spacedBy(10.dp),
    ) {
        TextWithShimmer(
            text = artist?.name ?: "Loading artist...",
            style = if (isCompact) MaterialTheme.typography.headlineSmall else MaterialTheme.typography.headlineLarge,
            fontWeight = FontWeight.SemiBold,
            textAlign = if (isCompact) androidx.compose.ui.text.style.TextAlign.Center else androidx.compose.ui.text.style.TextAlign.Start,
            maxLines = 2,
            overflow = TextOverflow.Ellipsis,
        )

        artist?.let {
            TextWithShimmer(
                text = buildString {
                    append(formatFollowers(it.followersCount))
                    if (it.genres.isNotEmpty()) {
                        append(" • ")
                        append(it.genres.joinToString(", "))
                    }
                },
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = if (isCompact) androidx.compose.ui.text.style.TextAlign.Center else androidx.compose.ui.text.style.TextAlign.Start,
            )
        }

        artist?.biography?.takeIf { it.isNotBlank() }?.let {
            TextWithShimmer(
                text = it,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                maxLines = if (isCompact) 4 else 6,
                overflow = TextOverflow.Ellipsis,
                textAlign = if (isCompact) androidx.compose.ui.text.style.TextAlign.Center else androidx.compose.ui.text.style.TextAlign.Start,
            )
        }
    }
}

@Composable
private fun ArtistHeaderActions(
    isSaved: Boolean,
    isSaving: Boolean,
    onFollowClick: () -> Unit,
) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(10.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        if (isSaved) {
            FilledTonalButton(onClick = onFollowClick, enabled = !isSaving) {
                TextWithShimmer("Following", modifier = Modifier.width(65.dp), textAlign = TextAlign.Center)
            }
        } else {
            Button(onClick = onFollowClick, enabled = !isSaving) {
                TextWithShimmer("Follow", modifier = Modifier.width(65.dp), textAlign = TextAlign.Center)
            }
        }
    }
}

@Composable
private fun ArtistAlbumsSection(
    albums: List<MetadataAlbum.Detailed>,
    isLoading: Boolean,
    error: String?,
    hasMore: Boolean,
    onViewAll: () -> Unit,
) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            TextWithShimmer(
                text = "Albums",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
            )

            TextButton(
                onClick = onViewAll,
                enabled = hasMore && !isLoading,
            ) {
                TextWithShimmer("View all")
            }
        }

        if (isLoading && albums.isEmpty()) {
            LazyRow(
                modifier = Modifier.fillMaxWidth(),
                contentPadding = PaddingValues(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalAlignment = Alignment.Top,
            ) {
                items(4) {
                    SkeletonTree(true) {
                        PlayableCard(
                            title = "Album Title",
                            subtitle = "Artist Name",
                            imageURL = "https://placehold.co/600x400",
                        )
                    }
                }
            }
        } else if (error != null && albums.isEmpty()) {
            TextWithShimmer(
                text = error,
                modifier = Modifier.padding(horizontal = 16.dp),
                color = MaterialTheme.colorScheme.error,
            )
        } else if (albums.isEmpty()) {
            TextWithShimmer(
                text = "No albums found",
                modifier = Modifier.padding(horizontal = 16.dp),
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        } else {
            val rowState = rememberLazyListState()
            LazyRow(
                state = rowState,
                modifier = Modifier.fillMaxWidth(),
                contentPadding = PaddingValues(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalAlignment = Alignment.Top,
            ) {
                items(albums, key = { it.id }) { album ->
                    AlbumCard(album = album)
                }
            }
        }
    }
}

@Composable
private fun TopTracksHeader(
    onPlay: () -> Unit,
    onAddToQueue: () -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween,
    ) {
        TextWithShimmer(
            text = "Top Tracks",
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.SemiBold,
        )

        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            FilledIconButton(onClick = onPlay) {
                Icon(
                    imageVector = FeatherIcons.Play,
                    contentDescription = "Play top tracks",
                )
            }
            FilledTonalIconButton(onClick = onAddToQueue) {
                Icon(
                    imageVector = FeatherIcons.PlusSquare,
                    contentDescription = "Add top tracks to queue",
                )
            }
        }
    }
}

private fun formatFollowers(count: Int?): String {
    if (count == null) return "Followers unavailable"
    return when {
        count >= 1_000_000_000 -> "${formatAbbreviatedCount(count, 1_000_000_000)}B followers"
        count >= 1_000_000 -> "${formatAbbreviatedCount(count, 1_000_000)}M followers"
        count >= 1_000 -> "${formatAbbreviatedCount(count, 1_000)}K followers"
        else -> "$count followers"
    }
}

private fun formatAbbreviatedCount(count: Int, divisor: Int): String {
    val scaled = count / divisor.toDouble()
    val rounded = (scaled * 10).roundToInt() / 10.0
    return if (rounded % 1.0 == 0.0) {
        rounded.toInt().toString()
    } else {
        rounded.toString()
    }
}

