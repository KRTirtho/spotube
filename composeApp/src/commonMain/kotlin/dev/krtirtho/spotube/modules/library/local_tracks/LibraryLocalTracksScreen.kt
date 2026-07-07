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

package dev.krtirtho.spotube.modules.library.local_tracks

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.PlatformType
import dev.krtirtho.spotube.core.ui.base.TextField
import dev.krtirtho.spotube.getPlatform
import dev.krtirtho.spotube.modules.library.local_tracks.media.rememberLocalMediaPermissionState
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import dev.krtirtho.spotube.resources.iconsax.ArrowLeft3
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxFilterSearch
import dev.krtirtho.spotube.resources.iconsax.IconsaxFolderOpen
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusicCircle
import dev.krtirtho.spotube.resources.iconsax.IconsaxPlayCircle2
import dev.krtirtho.spotube.resources.iconsax.IconsaxRefreshRight
import dev.krtirtho.spotube.resources.iconsax.Play
import org.koin.compose.viewmodel.koinViewModel

@Composable
fun LibraryLocalTracksScreen(modifier: Modifier = Modifier, searchMode: Boolean = false) {
    val viewModel = koinViewModel<LibraryLocalTracksViewModel>()
    val state by viewModel.state.collectAsStateWithLifecycle()
    val permissionState = rememberLocalMediaPermissionState()
    val platformType = remember { getPlatform().type }
    val isAndroid = platformType == PlatformType.Android

    LaunchedEffect(permissionState.isGranted, isAndroid) {
        if (!isAndroid || permissionState.isGranted) {
            viewModel.refresh()
        }
    }

    val shellBottomInset = LocalAppShellBottomInset.current
    val contentPadding = remember(shellBottomInset) {
        PaddingValues(top = 16.dp, bottom = 16.dp + shellBottomInset)
    }

    Box(modifier = modifier.fillMaxWidth()) {
        Column(
            modifier = modifier.widthIn(max = 1280.dp).align(Alignment.TopCenter),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            AnimatedVisibility(searchMode) {
                TextField(
                    value = state.query,
                    onValueChange = viewModel::onQueryChange,
                    modifier = Modifier
                        .fillMaxWidth(),
                    placeholder = {
                        Text(
                            if (state.currentFolderPath == null) {
                                "Search folders or tracks"
                            } else {
                                "Search tracks in folder"
                            }
                        )
                    },
                    singleLine = true,
                    leadingIcon = {
                        Icon(
                            imageVector = Iconsax.IconsaxFilterSearch,
                            contentDescription = "Search"
                        )
                    },
                    trailingIcon = {
                        Icon(
                            imageVector = Iconsax.IconsaxRefreshRight,
                            contentDescription = "Refresh",
                            modifier = Modifier.clickable { viewModel.refresh() }
                        )
                    }
                )
            }

            if (state.currentFolderPath != null) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween,
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        IconButton(onClick = viewModel::navigateUp) {
                            Icon(imageVector = Iconsax.ArrowLeft3, contentDescription = "Back")
                        }
                        Text(viewModel.currentFolder()?.name ?: "Folder")
                    }
                    IconButton(onClick = {
                        viewModel.currentFolder()?.let { viewModel.playFolder(it.path) }
                    }) {
                        Icon(
                            imageVector = Iconsax.IconsaxPlayCircle2,
                            contentDescription = "Play folder"
                        )
                    }
                }
            }

            val folders = viewModel.visibleFolders()
            val tracks = viewModel.visibleTracks()

            if (isAndroid && !permissionState.isGranted) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(10.dp),
                    ) {
                        Text("Allow audio permission to show local tracks")
                        TextButton(onClick = permissionState.requestPermission) {
                            Text("Grant access")
                        }
                    }
                }
            } else if (state.isRefreshing && folders.isEmpty() && tracks.isEmpty()) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
            } else if (state.currentFolderPath == null) {
                if (folders.isEmpty()) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Text(state.error ?: "No local folders found")
                    }
                } else {
                    LazyColumn(contentPadding = contentPadding) {
                        items(folders, key = { it.path }) { folder ->
                            ListItem(
                                headlineContent = { Text(folder.name) },
                                supportingContent = { Text("${folder.trackCount} track(s)") },
                                leadingContent = {
                                    Icon(
                                        imageVector = Iconsax.IconsaxFolderOpen,
                                        contentDescription = null
                                    )
                                },
                                modifier = Modifier.clickable { viewModel.openFolder(folder.path) },
                            )
                        }
                    }
                }
            } else {
                if (tracks.isEmpty()) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Text("No tracks in this folder")
                    }
                } else {
                    LazyColumn(modifier = Modifier.fillMaxSize(), contentPadding = contentPadding) {
                        items(tracks, key = { it.path }) { track ->
                            ListItem(
                                headlineContent = { Text(track.name) },
                                supportingContent = {
                                    val artists =
                                        track.artists.joinToString().ifBlank { "Unknown artist" }
                                    val album = track.album?.takeIf { it.isNotBlank() }
                                    Text(if (album == null) artists else "$artists - $album")
                                },
                                leadingContent = {
                                    Icon(
                                        imageVector = Iconsax.IconsaxMusicCircle,
                                        contentDescription = null
                                    )
                                },
                                trailingContent = {
                                    IconButton(onClick = { viewModel.playTrack(track.path) }) {
                                        Icon(
                                            imageVector = Iconsax.Play,
                                            contentDescription = "Play"
                                        )
                                    }
                                },
                                modifier = Modifier.clickable { viewModel.playTrack(track.path) },
                            )
                        }
                    }
                }
            }
        }
    }
}
