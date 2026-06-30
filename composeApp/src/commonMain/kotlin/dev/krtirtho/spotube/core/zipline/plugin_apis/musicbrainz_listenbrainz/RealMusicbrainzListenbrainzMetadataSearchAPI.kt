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

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbumType
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search.MetadataSearchAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search.MetadataSearchResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.search.MetadataSupportedSearchType
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUser
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.listenbrainz.LBPlaylistSearchResponse
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzArtistEnricher
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRepository
import io.ktor.client.HttpClient
import io.ktor.client.request.get
import io.ktor.client.request.parameter
import io.ktor.client.request.url
import io.ktor.client.statement.bodyAsText
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.serialization.json.Json

class RealMusicbrainzListenbrainzMetadataSearchAPI(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val artistEnricher: MusicbrainzArtistEnricher,
    private val httpClient: HttpClient
): MetadataSearchAPI {
    private val json = Json { ignoreUnknownKeys = true; isLenient = true }

    override val supportedSearchTypes: List<MetadataSupportedSearchType> = listOf(
        MetadataSupportedSearchType.TRACK,
        MetadataSupportedSearchType.ARTIST,
        MetadataSupportedSearchType.ALBUM,
        MetadataSupportedSearchType.PLAYLIST,
    )

    override suspend fun search(query: String): List<MetadataSearchResult> = coroutineScope {
        val playlists = async { searchPlaylists(query, PaginationStrategy.Offset(offset = 0, limit = 5)).items }
        val tracks = async { searchTracks(query, PaginationStrategy.Offset(offset = 0, limit = 5)).items }
        val artists = async { searchArtists(query, PaginationStrategy.Offset(offset = 0, limit = 5)).items }
        val albums = async { searchAlbums(query, PaginationStrategy.Offset(offset = 0, limit = 5)).items }

        val results = mutableListOf<MetadataSearchResult>()
        results.addAll(playlists.await())
        results.addAll(tracks.await())
        results.addAll(artists.await())
        results.addAll(albums.await())
        results
    }

    override suspend fun searchTracks(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Track> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)

        val result = musicbrainzRepository.searchRecordings(
            query = query,
            limit = paging.limit,
            offset = paging.offset
        )
        val items = result.recordings.map { recording ->
            val release = recording.releases.firstOrNull()
            val releaseGroupId = release?.releaseGroup?.id ?: release?.id ?: recording.id
            
            val albumDetailed = MetadataAlbum.Detailed(
                id = releaseGroupId,
                title = release?.releaseGroup?.title ?: release?.title ?: recording.title, // Fallback
                description = null,
                thumbnails = listOf(
                    Thumbnail("https://coverartarchive.org/release-group/$releaseGroupId/front-250.jpg", 250, 250),
                    Thumbnail("https://coverartarchive.org/release-group/$releaseGroupId/front-500.jpg", 500, 500)
                ),
                albumType = MetadataAlbumType.Album, // Default
                artists = emptyList(), // Can populate if needed
                externalUri = "https://musicbrainz.org/release-group/$releaseGroupId",
                releaseDate = release?.date,
                genres = emptyList(),
                trackCount = release?.trackCount ?: 0
            )

            MetadataSearchResult.Track(
                data = MetadataTrack(
                    id = recording.id,
                    title = recording.title,
                    durationMs = recording.length?.toLong() ?: 0L,
                    trackNumber = null, 
                    discNumber = null,
                    artists = recording.artistCredit.mapNotNull { credit ->
                        credit.artist?.let { artist ->
                            MetadataArtist.Basic(
                                id = artist.id,
                                name = artist.name,
                                thumbnails = emptyList(),
                                externalUri = "https://musicbrainz.org/artist/${artist.id}"
                            )
                        }
                    },
                    album = albumDetailed,
                    explicit = recording.tags.any { it.name.contains("explicit", ignoreCase = true) },
                    popularity = null,
                    isrcCode = recording.isrcs.firstOrNull(),
                    externalUri = "https://musicbrainz.org/recording/${recording.id}",
                    thumbnails = null,
                )
            )
        }

        val nextOffset = if (paging.offset + paging.limit < result.count) {
            paging.offset + paging.limit
        } else null
        
        return PaginationResult(
            items = items,
            totalCount = result.count,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
        )
    }

    override suspend fun searchArtists(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Artist> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        val result = musicbrainzRepository.searchArtists(
            query = query,
            limit = paging.limit,
            offset = paging.offset
        )
        
        val artistIds = result.artists.map { it.id }
        val enriched = artistEnricher.getEnrichedArtists(artistIds)
        
        val items = enriched.map { (artist, images) ->
            MetadataSearchResult.Artist(
                data = MetadataArtist.Basic(
                    id = artist.id,
                    name = artist.name,
                    thumbnails = images.map { Thumbnail(it, 300, 300) },
                    externalUri = "https://musicbrainz.org/artist/${artist.id}"
                )
            )
        }

        val nextOffset = if (paging.offset + paging.limit < result.count) {
            paging.offset + paging.limit
        } else null
        
        return PaginationResult(
            items = items,
            totalCount = result.count,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
        )
    }

    override suspend fun searchAlbums(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Album> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        val result = musicbrainzRepository.searchReleaseGroups(
            query = query,
            limit = paging.limit,
            offset = paging.offset
        )
        
        val items = result.releaseGroups.map { group ->
            MetadataSearchResult.Album(
                data = MetadataAlbum.Basic(
                    id = group.id,
                    title = group.title,
                    description = null,
                    thumbnails = listOf(
                        Thumbnail("https://coverartarchive.org/release-group/${group.id}/front-250.jpg", 250, 250),
                        Thumbnail("https://coverartarchive.org/release-group/${group.id}/front-500.jpg", 500, 500)
                    ),
                    albumType = when (group.primaryType?.lowercase()) {
                        "album" -> MetadataAlbumType.Album
                        "single" -> MetadataAlbumType.Single
                        "compilation" -> MetadataAlbumType.Collection
                        else -> MetadataAlbumType.Album
                    },
                    artists = emptyList(), // Populate?
                    externalUri = "https://musicbrainz.org/release-group/${group.id}"
                )
            )
        }

        val nextOffset = if (paging.offset + paging.limit < result.count) {
            paging.offset + paging.limit
        } else null
        
        return PaginationResult(
            items = items,
            totalCount = result.count,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
        )
    }

    override suspend fun searchPlaylists(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.Playlist> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        try {
            val responseText = httpClient.get {
                url("https://api.listenbrainz.org/1/playlist/search")
                parameter("query", query)
                parameter("count", paging.limit)
                parameter("offset", paging.offset)
            }.bodyAsText()
            
            val response = json.decodeFromString<LBPlaylistSearchResponse>(responseText)
            
            val items = response.playlists.map { it.playlist }.map { playlist ->
                val id = playlist.identifier.substringAfterLast("/")
                MetadataSearchResult.Playlist(
                    data = MetadataPlaylist(
                        id = id,
                        title = playlist.title,
                        description = playlist.annotation,
                        thumbnails = emptyList(), // Listenbrainz search doesn't return playlist covers usually
                        trackCount = 0, // Not available in search result
                        owner = MetadataUser(
                            id = playlist.creator,
                            username = playlist.creator,
                            displayName = playlist.creator, 
                            thumbnails = emptyList(),
                            externalUri = "https://listenbrainz.org/user/${playlist.creator}"
                        ),
                        externalUri = "https://listenbrainz.org/playlist/$id"
                    )
                )
            }

            val nextOffset = if (paging.offset + paging.limit < response.count) {
                paging.offset + paging.limit
            } else null

            return PaginationResult(
                items = items,
                totalCount = response.count,
                nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
            )
        } catch (e: Exception) {
            e.printStackTrace()
            return PaginationResult(emptyList(), 0, null)
        }
    }

    override suspend fun searchUsers(
        query: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataSearchResult.User> {
         return PaginationResult(emptyList(), 0, null)
    }

}