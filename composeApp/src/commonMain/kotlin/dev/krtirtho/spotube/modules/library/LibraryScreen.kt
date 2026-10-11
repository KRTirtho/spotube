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

package dev.krtirtho.spotube.modules.library


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyRow

import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.modules.downloads.DownloadsScreen
import dev.krtirtho.spotube.modules.library.album.LibraryAlbumsScreen
import dev.krtirtho.spotube.modules.library.artist.LibraryArtistsScreen
import dev.krtirtho.spotube.modules.library.local_tracks.LibraryLocalTracksScreen
import dev.krtirtho.spotube.modules.library.playlist.LibraryPlaylistsScreen
import dev.krtirtho.spotube.modules.shell.AppShellViewModel
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxSearchBroken
import org.koin.compose.koinInject
import org.koin.compose.viewmodel.koinViewModel

@Composable
fun LibraryScreen(
    libraryState: LibraryState = koinInject(),
    appShellViewModel: AppShellViewModel = koinViewModel()
) {
    val currentTab by libraryState.currentTab.collectAsState()
    val searchMode by libraryState.searchMode.collectAsState()
    val isLargeScreen = appShellViewModel.useSidebar()

    Column(modifier = Modifier.fillMaxSize()) {
        Column {
            ApplicationMainBar(
                backButton = false,
                title = {
                    if (!isLargeScreen) Text("Your Library")
                },
                actions = {
                    if (!isLargeScreen) {
                        MillenniumIconButton(
                            icon = Iconsax.IconsaxSearchBroken,
                            contentDescription = "Search",
                            onClick = {
                                libraryState.setSearchMode(!searchMode)
                            },
                            style = MillenniumIconButtonStyle.Quiet)
                    }
                }
            )
            if (!isLargeScreen)
                Column(
                    modifier = Modifier.padding(horizontal = 12.dp)
                ) {
                    Spacer(modifier = Modifier.height(4.dp))
                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        items(LibraryTab.entries.size) { index ->
                            val tab = LibraryTab.entries[index]
                            MillenniumButton(
                                onClick = { libraryState.onTabSelected(tab) },
                                style = if (currentTab == tab) {
                                    MillenniumButtonStyle.Primary
                                } else {
                                    MillenniumButtonStyle.Secondary
                                }) {
                                Text(tab.title)
                            }
                        }
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                }
        }

        Column(
            modifier = Modifier
                .weight(1f)
                .padding(horizontal = 12.dp)
        ) {
            when (currentTab) {
                LibraryTab.Playlists -> LibraryPlaylistsScreen(searchMode = isLargeScreen || searchMode)
                LibraryTab.Albums -> LibraryAlbumsScreen(searchMode = isLargeScreen || searchMode)
                LibraryTab.Artists -> LibraryArtistsScreen(searchMode = isLargeScreen || searchMode)
                LibraryTab.LocalTracks -> LibraryLocalTracksScreen(searchMode = isLargeScreen || searchMode)
                LibraryTab.Downloads -> DownloadsScreen()
            }
        }
    }
}