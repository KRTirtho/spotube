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

package dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz

import app.cash.zipline.ZiplineService
import dev.krtirtho.plugin_interfaces.host_apis.PersistedStorageAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.core.CoreAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbumAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtistAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylistAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search.MetadataSearchAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrackAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUserAPI
import dev.krtirtho.spotube.core.webview.WebViewController
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.KtorMusicbrainzRepository
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzArtistEnricher
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.wikidata.WikidataRepository
import io.ktor.client.HttpClient
import kotlinx.coroutines.CoroutineScope
import kotlin.reflect.KClass

fun createMusicbrainzListenbrainzPluginAPIs(
    scope: CoroutineScope,
    httpClient: HttpClient,
    webViewController: WebViewController,
    persistedStorage: PersistedStorageAPI
): Map<KClass<*>, ZiplineService> {
    val repository = KtorMusicbrainzRepository(httpClient)
    val wikidataRepository = WikidataRepository(httpClient)
    val artistEnricher = MusicbrainzArtistEnricher(repository, wikidataRepository)

    return mapOf(
        CoreAPI::class to RealMusicbrainzListenbrainzCoreAPI(scope, webViewController, persistedStorage),
        MetadataBrowseAPI::class to RealMusicbrainzListenbrainzMetadataBrowseAPI(persistedStorage),
        MetadataPlaylistAPI::class to RealMusicbrainzListenbrainzMetadataPlaylistAPI(repository, persistedStorage),
        MetadataTrackAPI::class to RealMusicbrainzListenbrainzMetadataTrackAPI(repository, persistedStorage),
        MetadataAlbumAPI::class to RealMusicbrainzListenbrainzMetadataAlbumAPI(repository, persistedStorage),
        MetadataArtistAPI::class to RealMusicbrainzListenbrainzMetadataArtistAPI(repository, persistedStorage),
        MetadataSearchAPI::class to RealMusicbrainzListenbrainzMetadataSearchAPI(repository, artistEnricher, httpClient),
        MetadataUserAPI::class to RealMusicbrainsListenbrainzMetadataUserAPI(repository, persistedStorage)
    )
}