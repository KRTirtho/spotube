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

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.input.TextFieldState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.composeunstyled.Text
import com.composeunstyled.currentWindowWidthBreakpoint
import dev.krtirtho.spotube.getPlatform
import dev.krtirtho.spotube.isDesktop
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.modules.downloads.DownloadsScreen
import dev.krtirtho.spotube.modules.library.album.LibraryAlbumsScreen
import dev.krtirtho.spotube.modules.library.artist.LibraryArtistsScreen
import dev.krtirtho.spotube.modules.library.local_tracks.LibraryLocalTracksScreen
import dev.krtirtho.spotube.modules.library.playlist.LibraryPlaylistsScreen
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxAddSquare
import dev.krtirtho.spotube.resources.iconsax.IconsaxCloseSquare
import dev.krtirtho.spotube.resources.iconsax.IconsaxRefreshRight
import dev.krtirtho.spotube.resources.iconsax.IconsaxSearchBroken
import org.jetbrains.compose.resources.StringResource
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.koinInject
import org.spotube.millennium.adaptive.WindowBreakpoints
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import org.spotube.millennium.composables.MillenniumTextField
import spotube.composeapp.generated.resources.*

@Composable
fun LibraryScreen(libraryState: LibraryState = koinInject()) {
    val state by libraryState.uiState.collectAsStateWithLifecycle()
    val expandedDesktop = getPlatform().isDesktop() &&
            (currentWindowWidthBreakpoint() isAtLeast WindowBreakpoints.Expanded)
    val focusManager = LocalFocusManager.current
    val keyboard = LocalSoftwareKeyboardController.current

    Column(Modifier.fillMaxSize()) {
        ApplicationMainBar(
            backButton = false,
            title = { LibraryToolbarTitle(state, expandedDesktop) },
            actions = {
                LibraryToolbarActions(
                    state = state,
                    expandedDesktop = expandedDesktop,
                    onOpenSearch = libraryState::openSearch,
                    onCloseSearch = {
                        focusManager.clearFocus()
                        keyboard?.hide()
                        libraryState.closeSearch()
                    },
                    onCreatePlaylist = libraryState::showCreatePlaylist,
                    onRefresh = libraryState::refreshLocalTracks
                )
            }
        )
        if (!expandedDesktop) {
            LazyRow(
                contentPadding = PaddingValues(horizontal = 12.dp, vertical = 8.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(LibraryTab.entries) { tab ->
                    MillenniumButton(
                        onClick = { libraryState.onTabSelected(tab) },
                        style = if (state.currentTab == tab) MillenniumButtonStyle.Primary else MillenniumButtonStyle.Secondary
                    ) { Text(stringResource(tab.titleResource)) }
                }
            }
        }
        Column(Modifier.weight(1f).padding(horizontal = 12.dp)) {
            when (state.currentTab) {
                LibraryTab.Playlists -> LibraryPlaylistsScreen(
                    showCreatePlaylist = state.showCreatePlaylist,
                    onDismissCreatePlaylist = libraryState::dismissCreatePlaylist
                )

                LibraryTab.Albums -> LibraryAlbumsScreen()
                LibraryTab.Artists -> LibraryArtistsScreen()
                LibraryTab.LocalTracks -> LibraryLocalTracksScreen()
                LibraryTab.Downloads -> DownloadsScreen()
            }
        }
    }
}

@Composable
internal fun LibraryToolbarTitle(state: LibraryToolbarUiState, expandedDesktop: Boolean) {
    if (!expandedDesktop && state.searchMode) {
        LibraryFilterField(
            state.searchState,
            state.currentTab.filterPlaceholder,
            Modifier.fillMaxWidth(),
            autoFocus = true
        )
    } else if (!expandedDesktop) {
        Text(stringResource(Res.string.library_screen_title))
    }
}

@Composable
internal fun RowScope.LibraryToolbarActions(
    state: LibraryToolbarUiState,
    expandedDesktop: Boolean,
    onOpenSearch: () -> Unit,
    onCloseSearch: () -> Unit,
    onCreatePlaylist: () -> Unit,
    onRefresh: () -> Unit
) {
    if (!expandedDesktop && state.searchMode) {
        MillenniumIconButton(
            icon = Iconsax.IconsaxCloseSquare,
            contentDescription = stringResource(Res.string.library_action_close_search),
            onClick = onCloseSearch,
            style = MillenniumIconButtonStyle.Quiet
        )
    } else {
        if (state.canFilter) {
            if (expandedDesktop) {
                LibraryFilterField(
                    state.searchState,
                    state.currentTab.filterPlaceholder,
                    Modifier.width(300.dp)
                )
            } else {
                MillenniumIconButton(
                    icon = Iconsax.IconsaxSearchBroken,
                    contentDescription = stringResource(Res.string.library_action_search),
                    onClick = onOpenSearch,
                    style = MillenniumIconButtonStyle.Quiet
                )
            }
        }
        if (state.canCreatePlaylist) {
            MillenniumIconButton(
                icon = Iconsax.IconsaxAddSquare,
                contentDescription = stringResource(Res.string.library_action_create_playlist),
                onClick = onCreatePlaylist,
                style = MillenniumIconButtonStyle.Quiet
            )
        }
        if (state.canRefresh) {
            MillenniumIconButton(
                icon = Iconsax.IconsaxRefreshRight,
                contentDescription = stringResource(Res.string.library_action_refresh_local_tracks),
                onClick = onRefresh,
                style = MillenniumIconButtonStyle.Quiet
            )
        }
    }
}

@Composable
private fun LibraryFilterField(
    state: TextFieldState,
    placeholder: StringResource,
    modifier: Modifier,
    autoFocus: Boolean = false
) {
    val focusRequester = remember { FocusRequester() }
    LaunchedEffect(autoFocus) {
        if (autoFocus) focusRequester.requestFocus()
    }
    MillenniumTextField(
        state = state,
        placeholder = stringResource(placeholder),
        minimumHeight = 36.dp,
        contentPadding = PaddingValues(horizontal = 10.dp, vertical = 8.dp),
        modifier = modifier.padding(vertical = 4.dp).focusRequester(focusRequester)
    )
}
