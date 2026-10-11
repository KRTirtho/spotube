/*
 * Copyright (C) 2026 Kingmor Roy Tirtho and Spotube Contributors
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


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumDialog
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import org.spotube.millennium.composables.MillenniumIndeterminateProgress
import org.spotube.millennium.composables.MillenniumModalBottomSheet
import org.spotube.millennium.composables.MillenniumTextField
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.SheetDetent
import com.composeunstyled.Text
import com.composeunstyled.rememberModalBottomSheetState
import org.spotube.millennium.adaptive.currentWindowAdaptiveInfo
import androidx.compose.foundation.text.input.rememberTextFieldState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.modules.library.LibraryRepository
import dev.krtirtho.spotube.modules.search.SearchRepository
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxCheckCircle
import dev.krtirtho.spotube.resources.iconsax.IconsaxFilterSearch
import dev.krtirtho.spotube.resources.iconsax.IconsaxSearch
import kotlinx.coroutines.flow.drop
import kotlinx.coroutines.launch
import org.koin.compose.koinInject

@Composable
fun AddTracksToPlaylistDialog(
    visible: Boolean,
    playlistId: String,
    onDismiss: () -> Unit,
    modifier: Modifier = Modifier,
    searchRepository: SearchRepository = koinInject(),
    libraryRepository: LibraryRepository = koinInject(),
    breakpointDp: Float = 600f) {
    if (!visible) return

    val adaptiveInfo = currentWindowAdaptiveInfo()
    val isLargeScreen = adaptiveInfo.windowSizeClass.minWidthDp >= breakpointDp

    var query by remember { mutableStateOf("") }
    var searchResults by remember { mutableStateOf<List<MetadataTrack>>(emptyList()) }
    var isSearching by remember { mutableStateOf(false) }
    var hasSearched by remember { mutableStateOf(false) }
    var addingTrackIds by remember { mutableStateOf<Set<String>>(emptySet()) }
    var addedTrackIds by remember { mutableStateOf<Set<String>>(emptySet()) }
    val scope = rememberCoroutineScope()
    val queryState = rememberTextFieldState(query)

    LaunchedEffect(queryState) {
        snapshotFlow { queryState.text.toString() }
            .drop(1)
            .collect { query = it }
    }

    LaunchedEffect(visible) {
        if (!visible) {
            query = ""
            searchResults = emptyList()
            hasSearched = false
            addingTrackIds = emptySet()
            addedTrackIds = emptySet()
        }
    }

    val handleSearch = {
        if (query.isNotBlank() && !isSearching) {
            isSearching = true
            hasSearched = true
            scope.launch {
                val result = searchRepository.searchTracks(query)
                searchResults = result.items.map { it.data }
                isSearching = false
            }
        }
    }

    val handleAddTrack = { track: MetadataTrack ->
        if (!addingTrackIds.contains(track.id) && !addedTrackIds.contains(track.id)) {
            addingTrackIds = addingTrackIds + track.id
            scope.launch {
                libraryRepository.addTracksToPlaylist(playlistId, listOf(track.id))
                addingTrackIds = addingTrackIds - track.id
                addedTrackIds = addedTrackIds + track.id
            }
        }
    }

    val content: @Composable () -> Unit = {
        Column(
            modifier = Modifier.fillMaxSize(),
            verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically) {
                MillenniumTextField(
                    state = queryState,
                    label = "Search",
                    modifier = Modifier.weight(1f),
                    placeholder = "Search tracks...")
                MillenniumIconButton(
                    icon = Iconsax.IconsaxSearch,
                    contentDescription = "Search",
                    onClick = handleSearch,
                    style = MillenniumIconButtonStyle.Secondary)
            }

            when {
                isSearching -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f),
                        contentAlignment = Alignment.Center) {
                        MillenniumIndeterminateProgress()
                    }
                }
                hasSearched && searchResults.isEmpty() -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f),
                        contentAlignment = Alignment.Center) {
                        Text("No tracks found")
                    }
                }
                searchResults.isNotEmpty() -> {
                    LazyColumn(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f),
                        verticalArrangement = Arrangement.spacedBy(4.dp)) {
                        items(searchResults, key = { it.id }) { track ->
                            TrackSearchResultRow(
                                track = track,
                                isAdding = addingTrackIds.contains(track.id),
                                isAdded = addedTrackIds.contains(track.id),
                                onAdd = { handleAddTrack(track) })
                        }
                    }
                }
                else -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f),
                        contentAlignment = Alignment.Center) {
                        Text("Search for tracks to add")
                    }
                }
            }
        }
    }

    if (isLargeScreen) {
        MillenniumDialog(
            visible = true,
            onDismissRequest = onDismiss,
            title = "Add Tracks to Playlist",
            modifier = modifier) {
            Box(modifier = Modifier.fillMaxWidth().height(500.dp)) {
                content()
            }
            MillenniumButton(onClick = onDismiss) {
                Text("Done")
            }
        }
    } else {
        val sheetState = rememberModalBottomSheetState(initialDetent = SheetDetent.FullyExpanded)
        MillenniumModalBottomSheet(state = sheetState) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp)
                    .height(600.dp)) {
                Text(
                    text = "Add Tracks to Playlist",
                    style = AppTheme.typography.headlineSmall,
                    modifier = Modifier.padding(bottom = 16.dp))
                content()
            }
        }
    }
}

@Composable
private fun TrackSearchResultRow(
    track: MetadataTrack,
    isAdding: Boolean,
    isAdded: Boolean,
    onAdd: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .padding(horizontal = 8.dp, vertical = 6.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)) {
        val imageUrl = track.album?.thumbnails?.firstOrNull()?.url
        if (imageUrl != null) {
            AsyncImage(
                model = imageUrl,
                contentDescription = track.title,
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(6.dp)),
                contentScale = ContentScale.Crop)
        } else {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(6.dp)),
                contentAlignment = Alignment.Center) {
                Text(
                    text = track.title.take(1).uppercase(),
                    style = AppTheme.typography.titleMedium)
            }
        }

        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = track.title,
                style = AppTheme.typography.bodyLarge,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis)
            Text(
                text = track.artists.joinToString(", ") { it.name },
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurfaceVariant,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis)
        }

        when {
            isAdded -> {
                MillenniumIcon(
                    imageVector = Iconsax.IconsaxCheckCircle,
                    contentDescription = "Added",
                    tint = AppTheme.colors.primary,
                    modifier = Modifier.size(24.dp))
            }
            isAdding -> {
                MillenniumIndeterminateProgress(
                    modifier = Modifier.size(24.dp))
            }
            else -> {
                MillenniumButton(
                    onClick = onAdd,
                    style = MillenniumButtonStyle.Secondary) {
                    Text("Add")
                }
            }
        }
    }
}
