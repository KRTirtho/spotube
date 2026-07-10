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

package dev.krtirtho.spotube.modules.library.playlist

import androidx.compose.foundation.clickable
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
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Text
import androidx.compose.material3.adaptive.currentWindowAdaptiveInfo
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.spotube.core.ui.base.OutlineButton
import dev.krtirtho.spotube.core.ui.base.TextField
import dev.krtirtho.spotube.modules.library.LibraryRepository
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxFilterSearch
import kotlinx.coroutines.launch
import org.koin.compose.koinInject

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddToPlaylistPicker(
    visible: Boolean,
    currentUserId: String?,
    onDismiss: () -> Unit,
    onPlaylistSelected: (String) -> Unit,
    modifier: Modifier = Modifier,
    libraryRepository: LibraryRepository = koinInject(),
    breakpointDp: Float = 600f,
) {
    if (!visible) return

    val adaptiveInfo = currentWindowAdaptiveInfo()
    val isLargeScreen = adaptiveInfo.windowSizeClass.minWidthDp >= breakpointDp

    var playlists by remember { mutableStateOf<List<MetadataPlaylist>>(emptyList()) }
    var isLoading by remember { mutableStateOf(true) }
    var searchQuery by remember { mutableStateOf("") }
    val scope = rememberCoroutineScope()

    LaunchedEffect(visible, currentUserId) {
        if (visible) {
            isLoading = true
            scope.launch {
                val result = libraryRepository.savedPlaylists()
                playlists = result?.items?.filter {
                    currentUserId != null && it.owner?.id == currentUserId
                } ?: emptyList()
                isLoading = false
            }
        }
    }

    val filteredPlaylists = remember(playlists, searchQuery) {
        if (searchQuery.isBlank()) {
            playlists
        } else {
            playlists.filter {
                it.title.contains(searchQuery, ignoreCase = true) ||
                    it.description?.contains(searchQuery, ignoreCase = true) == true
            }
        }
    }

    val content: @Composable () -> Unit = {
        Column(modifier = Modifier.fillMaxSize()) {
            TextField(
                value = searchQuery,
                onValueChange = { searchQuery = it },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 12.dp),
                placeholder = { Text("Search your playlists...") },
                singleLine = true,
                leadingIcon = {
                    Icon(
                        imageVector = Iconsax.IconsaxFilterSearch,
                        contentDescription = "Search",
                    )
                },
            )

            PlaylistPickerContent(
                playlists = filteredPlaylists,
                isLoading = isLoading,
                onPlaylistSelected = { playlistId ->
                    onPlaylistSelected(playlistId)
                    onDismiss()
                },
            )
        }
    }

    if (isLargeScreen) {
        AlertDialog(
            onDismissRequest = onDismiss,
            modifier = modifier,
            title = {
                Text("Add to Your Playlist")
            },
            text = {
                Box(modifier = Modifier.fillMaxWidth().height(400.dp)) {
                    content()
                }
            },
            confirmButton = {
                OutlineButton(onClick = onDismiss) {
                    Text("Cancel")
                }
            },
        )
    } else {
        ModalBottomSheet(
            onDismissRequest = onDismiss,
            dragHandle = null,
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp),
            ) {
                Text(
                    text = "Add to Your Playlist",
                    style = MaterialTheme.typography.headlineSmall,
                    modifier = Modifier.padding(bottom = 16.dp),
                )
                content()
            }
        }
    }
}

@Composable
private fun PlaylistPickerContent(
    playlists: List<MetadataPlaylist>,
    isLoading: Boolean,
    onPlaylistSelected: (String) -> Unit,
) {
    if (isLoading) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("Loading your playlists...")
        }
    } else if (playlists.isEmpty()) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text("You don't own any playlists yet.\nCreate one to add tracks.")
        }
    } else {
        LazyColumn(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(4.dp),
        ) {
            items(playlists, key = { it.id }) { playlist ->
                PlaylistPickerRow(
                    playlist = playlist,
                    onClick = { onPlaylistSelected(playlist.id) },
                )
            }
        }
    }
}

@Composable
private fun PlaylistPickerRow(
    playlist: MetadataPlaylist,
    onClick: () -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .clickable(onClick = onClick)
            .padding(horizontal = 8.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        val imageUrl = playlist.thumbnails.firstOrNull()?.url
        if (imageUrl != null) {
            AsyncImage(
                model = imageUrl,
                contentDescription = playlist.title,
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(8.dp)),
                contentScale = ContentScale.Crop,
            )
        } else {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(8.dp)),
                contentAlignment = Alignment.Center,
            ) {
                Text(
                    text = playlist.title.take(1).uppercase(),
                    style = MaterialTheme.typography.titleMedium,
                )
            }
        }

        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = playlist.title,
                style = MaterialTheme.typography.bodyLarge,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
            Text(
                text = "${playlist.trackCount} tracks",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}
