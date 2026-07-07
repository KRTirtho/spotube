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

package dev.krtirtho.spotube.core.navigation

import androidx.navigation3.runtime.NavKey
import dev.krtirtho.spotube.modules.artist.ArtistScreen
import dev.krtirtho.spotube.modules.album.AlbumScreen
import dev.krtirtho.spotube.modules.home.HomeScreen
import dev.krtirtho.spotube.modules.library.LibraryScreen
import dev.krtirtho.spotube.modules.lyrics.LyricsScreen
import dev.krtirtho.spotube.modules.playlist.PlaylistScreen
import dev.krtirtho.spotube.modules.plugin.PluginScreen
import dev.krtirtho.spotube.modules.saved_tracks.SavedTracksScreen
import dev.krtirtho.spotube.modules.search.SearchScreen
import dev.krtirtho.spotube.modules.settings.SettingsScreen
import dev.krtirtho.spotube.modules.webview.WebViewScreen
import kotlinx.serialization.Serializable
import org.koin.compose.viewmodel.koinViewModel
import org.koin.core.annotation.KoinExperimentalAPI
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.module
import org.koin.dsl.navigation3.navigation

@Serializable
sealed interface Routes : NavKey {
    @Serializable
    data object Home : Routes

    @Serializable
    data object Library : Routes

    @Serializable
    data object Search : Routes

    @Serializable
    data object Settings : Routes

    @Serializable
    data object Plugins : Routes

    @Serializable
    data object WebView: Routes

    @Serializable
    data object Lyrics: Routes

    @Serializable
    data class Playlist(val playlistId: String): Routes

    @Serializable
    data class Artist(val artistId: String): Routes

    @Serializable
    data class Album(val albumId: String): Routes

    @Serializable
    data object SavedTracks: Routes
}

@OptIn(KoinExperimentalAPI::class)
val navigationModule = module {
    singleOf(::NavigationCommands)
    navigation<Routes.Home> {
        HomeScreen(viewModel = koinViewModel())
    }
    navigation<Routes.Search> {
        SearchScreen()
    }
    navigation<Routes.Library> {
        LibraryScreen()
    }
    navigation<Routes.Settings> {
        SettingsScreen(pluginManager = get(), settingsViewModel = koinViewModel())
    }
    navigation<Routes.Plugins> {
        PluginScreen(pluginManager = get())
    }
    navigation<Routes.WebView> {
        WebViewScreen(get())
    }
    navigation<Routes.Playlist> {
        PlaylistScreen(it.playlistId)
    }
    navigation<Routes.Artist> {
        ArtistScreen(it.artistId)
    }
    navigation<Routes.Album> {
        AlbumScreen(it.albumId)
    }
    navigation<Routes.Lyrics> {
        LyricsScreen(viewModel = koinViewModel())
    }
    navigation<Routes.SavedTracks> {
        SavedTracksScreen()
    }
}

