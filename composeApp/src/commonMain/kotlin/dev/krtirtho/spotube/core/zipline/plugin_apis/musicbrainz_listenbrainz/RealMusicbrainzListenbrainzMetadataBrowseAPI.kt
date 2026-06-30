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

import arrow.core.Either
import com.kroegerama.openapi.kmp.gen.companion.AuthPlugin.Plugin.authKeys
import dev.krtirtho.plugin_interfaces.host_apis.PersistedStorageAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseItem
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.browse.MetadataBrowseSection
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUser
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.listenbrainz.Api
import dev.krtirtho.spotube.listenbrainz.Auth
import dev.krtirtho.spotube.listenbrainz.api.LbCoreApi
import dev.krtirtho.spotube.listenbrainz.api.LbMiscApi
import dev.krtirtho.spotube.listenbrainz.api.LbPlaylistsApi
import dev.krtirtho.spotube.listenbrainz.api.LbStatsApi
import dev.krtirtho.spotube.listenbrainz.models.AllowedStatisticsRange
import dev.krtirtho.spotube.listenbrainz.models.Mode
import dev.krtirtho.spotube.listenbrainz.models.Playlist
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlin.time.Clock
import org.koin.core.component.KoinComponent

class RealMusicbrainzListenbrainzMetadataBrowseAPI(
    private val persistedStorage: PersistedStorageAPI,
) : MetadataBrowseAPI, KoinComponent {
    private val logger by injectLogger<RealMusicbrainzListenbrainzMetadataBrowseAPI>()
    private var cachedUsername: String? = null

    @Serializable
    private data class LbRadioPlaylistCacheEntry(
        val cachedAtEpochMs: Long,
        val playlist: MetadataPlaylist,
    )

    @Serializable
    private data class BrowseSectionsCacheEntry(
        val cachedAtEpochMs: Long,
        val sections: List<BrowseSectionData>,
    )

    private val cacheJson = Json {
        ignoreUnknownKeys = true
        encodeDefaults = true
    }

    @Serializable
    private data class BrowseSectionData(
        val id: String,
        val title: String,
        val description: String? = null,
        val moreLink: String? = null,
        val items: List<MetadataBrowseItem>,
    )

    private data class MoodSeed(
        val key: String,
        val tag: String,
        val title: String,
        val annotation: String,
    )

    companion object {
        private const val SECTION_TOP_ARTIST_RADIOS = "top-artist-radios"
        private const val SECTION_MOOD_PLAYLISTS = "mood-playlists"
        private const val SECTION_CREATED_FOR = "created-for-playlists"
        private const val LB_RADIO_CACHE_TTL_MS = 3L * 24 * 60 * 60 * 1000
        private const val LB_RADIO_CACHE_KEY_PREFIX = "lb_radio_playlist_cache"
        private const val BROWSE_SECTIONS_CACHE_KEY_PREFIX = "lb_browse_sections_cache"

        private val moodSeeds = listOf(
            MoodSeed("chill", "ambient", "Chill playlist", "Yo chill my friend!"),
            MoodSeed("energetic", "energetic", "Pump it up!", "Get ready to move!"),
            MoodSeed("happy", "upbeat", "Happy Vibes", "Feel good tunes to brighten your day!"),
            MoodSeed("sad", "melancholy", "Melancholy Moments", "For those reflective times."),
            MoodSeed("focus", "instrumental", "Focus Beats", "Concentration is key."),
            MoodSeed("workout", "electronic", "Workout Jams", "Get pumped with these beats!"),
            MoodSeed("party", "dance", "Party Anthems", "Let's get this party started!"),
            MoodSeed("romantic", "romantic", "Romantic Evenings", "For those special moments."),
        )
    }

    override suspend fun featured(): List<MetadataBrowseItem> {
        logger.i("featured(): Starting to build featured items")
        try {
            val sections = buildSections()
            logger.d("featured(): Built ${sections.size} sections")
            val result = sections.flatMap { it.items }.take(12)
            logger.i("featured(): Returning ${result.size} featured items")
            return result
        } catch (e: Exception) {
            logger.e(e) { "featured(): Error building featured items" }
            return emptyList()
        }
    }

    override suspend fun list(pagination: PaginationStrategy?): PaginationResult<MetadataBrowseSection> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        logger.i("list(): Starting with offset=${paging.offset}, pageSize=${paging.limit}")
        try {
            val sections = buildSections()
            logger.d("list(): Built ${sections.size} total sections")
            val items = sections
                .drop(paging.offset)
                .take(paging.limit)
                .map {
                    MetadataBrowseSection(
                        title = it.title,
                        description = it.description,
                        items = it.items,
                        moreLink = it.moreLink,
                    )
                }

            val nextOffset = if (paging.offset + items.size < sections.size) {
                paging.offset + paging.limit
            } else {
                null
            }

            logger.d("list(): Returning ${items.size} items, nextOffset=$nextOffset")
            return PaginationResult(
                items = items,
                totalCount = sections.size,
                nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
            )
        } catch (e: Exception) {
            logger.e(e) { "list(): Error fetching paginated sections" }
            return PaginationResult(
                items = emptyList(),
                totalCount = 0,
                nextPagination = null,
            )
        }
    }

    override suspend fun sublist(
        sectionId: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataBrowseItem> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        logger.i("sublist(): Fetching section=$sectionId with offset=${paging.offset}, pageSize=${paging.limit}")
        try {
            val allSections = buildSections()
            logger.d("sublist(): Built ${allSections.size} total sections")
            val sectionItems = allSections.firstOrNull { it.id == sectionId }?.items ?: emptyList()
            logger.d("sublist(): Found ${sectionItems.size} items in section $sectionId")

            val items = sectionItems.drop(paging.offset).take(paging.limit)
            val nextOffset = if (paging.offset + items.size < sectionItems.size) {
                paging.offset + paging.limit
            } else {
                null
            }

            logger.d("sublist(): Returning ${items.size} paginated items, nextOffset=$nextOffset")
            return PaginationResult(
                items = items,
                totalCount = sectionItems.size,
                nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
            )
        } catch (e: Exception) {
            logger.e(e) { "sublist(): Error fetching sublist for section=$sectionId" }
            return PaginationResult(
                items = emptyList(),
                totalCount = 0,
                nextPagination = null,
            )
        }
    }

    private suspend fun buildSections(): List<BrowseSectionData> {
        logger.d("buildSections(): Starting section building process")
        val username = try {
            val user = requireUsername()
            logger.d("buildSections(): Successfully resolved username: $user")
            user
        } catch (e: Exception) {
            logger.w(e) { "buildSections(): Failed to retrieve username, returning empty sections" }
            return emptyList()
        }

        val nowEpochMs = Clock.System.now().toEpochMilliseconds()
        val sectionsCacheKey = buildBrowseSectionsCacheKey(username)
        val cachedSections = readCachedBrowseSections(sectionsCacheKey)
        if (cachedSections != null) {
            val ageMs = nowEpochMs - cachedSections.cachedAtEpochMs
            if (ageMs <= LB_RADIO_CACHE_TTL_MS) {
                logger.d("buildSections(): Returning cached sections for key=$sectionsCacheKey (ageMs=$ageMs)")
                return cachedSections.sections
            }
            logger.d("buildSections(): Cached sections stale for key=$sectionsCacheKey (ageMs=$ageMs), rebuilding")
        }

        return try {
            logger.d("buildSections(): Building Top Artist Radios section...")
            val topArtistRadios = buildTopArtistRadiosSection(username)
            logger.d("buildSections(): Built Top Artist Radios with ${topArtistRadios.items.size} items")

            logger.d("buildSections(): Building Mood Playlists section...")
            val moodPlaylists = buildMoodPlaylistsSection(username)
            logger.d("buildSections(): Built Mood Playlists with ${moodPlaylists.items.size} items")

            logger.d("buildSections(): Building Created For section...")
            val createdFor = buildCreatedForSection(username)
            logger.d("buildSections(): Built Created For with ${createdFor.items.size} items")

            val sections = listOf(topArtistRadios, moodPlaylists, createdFor)
            writeCachedBrowseSections(
                key = sectionsCacheKey,
                entry = BrowseSectionsCacheEntry(
                    cachedAtEpochMs = nowEpochMs,
                    sections = sections,
                )
            )
            logger.i("buildSections(): Successfully built ${sections.size} sections with ${sections.sumOf { it.items.size }} total items")
            sections
        } catch (e: Exception) {
            logger.e(e) { "buildSections(): Failed to build fresh sections" }
            if (cachedSections != null) {
                logger.w("buildSections(): Returning stale cached sections for key=$sectionsCacheKey")
                cachedSections.sections
            } else {
                emptyList()
            }
        }
    }

    private suspend fun buildTopArtistRadiosSection(username: String): BrowseSectionData {
        logger.d("buildTopArtistRadiosSection(): Fetching top artists for user: $username")
        try {
            val artistsResult = LbStatsApi.topArtistsForUser(
                userName = username,
                count = 10,
                offset = 0,
                range = AllowedStatisticsRange.QUARTER,
            )
            val artists = when (artistsResult) {
                is Either.Left -> {
                    val error = artistsResult.value
                    logger.e("buildTopArtistRadiosSection(): Failed to fetch top artists: $error")
                    throw error
                }

                is Either.Right -> artistsResult.value.data.payload.artists
            }
            logger.d("buildTopArtistRadiosSection(): Retrieved ${artists.size} top artists")

            val playlists = artists.mapNotNull { artist ->
                val mbid = artist.artistMbid?.toString() ?: return@mapNotNull null
                val name = artist.artistName ?: return@mapNotNull null
                logger.d("buildTopArtistRadiosSection(): Generating radio playlist for artist: $name (mbid: $mbid)")

                generateLbRadioPlaylist(
                    prompt = "artist:($mbid)",
                    mode = Mode.EASY,
                    title = "$name Radio",
                    annotation = "A radio playlist based on $name's music",
                    imageUrl = null,
                )
            }
            logger.d("buildTopArtistRadiosSection(): Generated ${playlists.size} radio playlists")

            return BrowseSectionData(
                id = SECTION_TOP_ARTIST_RADIOS,
                title = "Top Artist Radios",
                moreLink = "https://listenbrainz.org/explore/lb-radio",
                items = playlists.map { MetadataBrowseItem.Playlist(it) },
            )
        } catch (e: Exception) {
            logger.e(e) { "buildTopArtistRadiosSection(): Error building top artist radios section" }
            return BrowseSectionData(
                id = SECTION_TOP_ARTIST_RADIOS,
                title = "Top Artist Radios",
                items = emptyList(),
            )
        }
    }

    private suspend fun buildMoodPlaylistsSection(username: String): BrowseSectionData {
        logger.d("buildMoodPlaylistsSection(): Starting to build mood playlists (count: ${moodSeeds.size})")
        try {
            val playlists = moodSeeds.mapNotNull { mood ->
                logger.d("buildMoodPlaylistsSection(): Generating playlist for mood: ${mood.title} (tag: ${mood.tag})")
                generateLbRadioPlaylist(
                    prompt = "tag:(${mood.tag}) stats:$username::all_time",
                    mode = Mode.HARD,
                    title = mood.title,
                    annotation = mood.annotation,
                    imageUrl = "https://res.cloudinary.com/dszpk1pk9/image/upload/t_media_lib_thumb/spotube-plugin-musicbrainz-listenbrainz/moods/${mood.key}.webp",
                )
            }
            logger.d("buildMoodPlaylistsSection(): Successfully generated ${playlists.size} mood playlists")

            return BrowseSectionData(
                id = SECTION_MOOD_PLAYLISTS,
                title = "Based on your mood",
                moreLink = "https://listenbrainz.org/explore/lb-radio",
                items = playlists.map { MetadataBrowseItem.Playlist(it) },
            )
        } catch (e: Exception) {
            logger.e(e) { "buildMoodPlaylistsSection(): Error building mood playlists section" }
            return BrowseSectionData(
                id = SECTION_MOOD_PLAYLISTS,
                title = "Based on your mood",
                items = emptyList(),
            )
        }
    }

    private suspend fun buildCreatedForSection(username: String): BrowseSectionData {
        logger.d("buildCreatedForSection(): Fetching playlists created for user: $username")
        try {
            val playlistsResult = LbPlaylistsApi.playlistsCreatedForUser(
                playlistUserName = username,
                count = 25,
                offset = 0,
            )
            val playlists = when (playlistsResult) {
                is Either.Left -> {
                    val error = playlistsResult.value
                    logger.e("buildCreatedForSection(): Failed to fetch created playlists: $error")
                    throw error
                }

                is Either.Right -> playlistsResult.value.data.playlists.orEmpty()
            }
            logger.d("buildCreatedForSection(): Retrieved ${playlists.size} playlists")

            val items = playlists.mapNotNull { wrapper ->
                val playlist = wrapper.playlist ?: return@mapNotNull null
                val title = playlist.title.orEmpty()
                val imageName = if (title.contains("Weekly Exploration", ignoreCase = true)) {
                    "weekly-exploration"
                } else {
                    "weekly-jams"
                }
                logger.d("buildCreatedForSection(): Processing playlist: $title (imageName: $imageName)")
                val imageUrl =
                    "https://res.cloudinary.com/dszpk1pk9/image/upload/t_media_lib_thumb/spotube-plugin-musicbrainz-listenbrainz/created_for/${imageName}.webp"
                playlist.toMetadataPlaylist(thumbnailOverride = imageUrl)
            }
            logger.d("buildCreatedForSection(): Successfully processed ${items.size} playlists")

            return BrowseSectionData(
                id = SECTION_CREATED_FOR,
                title = "Created for you",
                moreLink = "https://listenbrainz.org/user/$username/recommendations/",
                items = items.map { MetadataBrowseItem.Playlist(it) },
            )
        } catch (e: Exception) {
            logger.e(e) { "buildCreatedForSection(): Error building created for section" }
            return BrowseSectionData(
                id = SECTION_CREATED_FOR,
                title = "Created for you",
                items = emptyList(),
            )
        }
    }

    private suspend fun generateLbRadioPlaylist(
        prompt: String,
        mode: Mode,
        title: String,
        annotation: String?,
        imageUrl: String?,
    ): MetadataPlaylist? {
        logger.d("generateLbRadioPlaylist(): Generating playlist with prompt='$prompt', mode=$mode, title='$title'")
        val nowEpochMs = Clock.System.now().toEpochMilliseconds()
        val cacheKey = buildLbRadioCacheKey(prompt = prompt, mode = mode)
        val cachedEntry = readCachedLbRadioPlaylist(cacheKey)
        if (cachedEntry != null) {
            val ageMs = nowEpochMs - cachedEntry.cachedAtEpochMs
            if (ageMs <= LB_RADIO_CACHE_TTL_MS) {
                logger.d("generateLbRadioPlaylist(): Cache hit for key=$cacheKey (ageMs=$ageMs)")
                return cachedEntry.playlist
            }
            logger.d("generateLbRadioPlaylist(): Cache stale for key=$cacheKey (ageMs=$ageMs), refreshing")
        }

        try {
            val lbRadioResult = LbMiscApi.lbRadio(prompt = prompt, mode = mode) {
                authKeys(
                    Auth.ApiKeyAuth.ID,
                )
            }
            val lbRadio = when (lbRadioResult) {
                is Either.Left -> {
                    val error = lbRadioResult.value
                    logger.e("generateLbRadioPlaylist(): API call failed with error: $error")
                    throw error
                }

                is Either.Right -> lbRadioResult.value.data
            }
            val playlist = lbRadio.payload.jspf.playlist ?: run {
                logger.w("generateLbRadioPlaylist(): No playlist data in response for prompt='$prompt'")
                return null
            }
            val modeId = mode.name.lowercase()
            val syntheticId = "lb-radio-playlist-$prompt-$modeId"

            val normalizedPlaylist = playlist.copy(
                identifier = "https://listenbrainz.org/playlist/$syntheticId",
                title = title,
                annotation = annotation ?: playlist.annotation,
            )

            val result = normalizedPlaylist.toMetadataPlaylist(thumbnailOverride = imageUrl)
            if (result != null) {
                writeCachedLbRadioPlaylist(
                    key = cacheKey,
                    entry = LbRadioPlaylistCacheEntry(
                        cachedAtEpochMs = nowEpochMs,
                        playlist = result,
                    )
                )
            }
            logger.d("generateLbRadioPlaylist(): Successfully generated playlist: $title")
            return result
        } catch (e: Exception) {
            logger.e(e) { "generateLbRadioPlaylist(): Error generating playlist for prompt='$prompt'" }
            if (cachedEntry != null) {
                logger.w("generateLbRadioPlaylist(): Returning stale cache for key=$cacheKey due to API failure")
                return cachedEntry.playlist
            }
            return null
        }
    }

    private fun buildLbRadioCacheKey(prompt: String, mode: Mode): String {
        val promptHash = prompt.hashCode().toUInt().toString(16)
        return "$LB_RADIO_CACHE_KEY_PREFIX:${mode.name.lowercase()}:$promptHash"
    }

    private fun buildBrowseSectionsCacheKey(username: String): String {
        val usernameHash = username.lowercase().hashCode().toUInt().toString(16)
        return "$BROWSE_SECTIONS_CACHE_KEY_PREFIX:$usernameHash"
    }

    private suspend fun readCachedLbRadioPlaylist(key: String): LbRadioPlaylistCacheEntry? {
        val raw = persistedStorage.getString(key) ?: return null
        return runCatching {
            cacheJson.decodeFromString<LbRadioPlaylistCacheEntry>(raw)
        }.onFailure { throwable ->
            logger.w(throwable) { "readCachedLbRadioPlaylist(): Corrupt cache entry for key=$key, removing" }
            persistedStorage.remove(key)
        }.getOrNull()
    }

    private suspend fun writeCachedLbRadioPlaylist(key: String, entry: LbRadioPlaylistCacheEntry) {
        runCatching {
            persistedStorage.putString(key, cacheJson.encodeToString(entry))
        }.onFailure { throwable ->
            logger.w(throwable) { "writeCachedLbRadioPlaylist(): Failed to persist cache for key=$key" }
        }
    }

    private suspend fun readCachedBrowseSections(key: String): BrowseSectionsCacheEntry? {
        val raw = persistedStorage.getString(key) ?: return null
        return runCatching {
            cacheJson.decodeFromString<BrowseSectionsCacheEntry>(raw)
        }.onFailure { throwable ->
            logger.w(throwable) { "readCachedBrowseSections(): Corrupt cache entry for key=$key, removing" }
            persistedStorage.remove(key)
        }.getOrNull()
    }

    private suspend fun writeCachedBrowseSections(key: String, entry: BrowseSectionsCacheEntry) {
        runCatching {
            persistedStorage.putString(key, cacheJson.encodeToString(entry))
        }.onFailure { throwable ->
            logger.w(throwable) { "writeCachedBrowseSections(): Failed to persist cache for key=$key" }
        }
    }

    private fun Playlist.toMetadataPlaylist(thumbnailOverride: String? = null): MetadataPlaylist? {
        val identifier = identifier ?: return null
        val id = identifier.substringAfterLast('/').takeIf { it.isNotBlank() } ?: return null
        val creator = creator ?: "Unknown"

        return MetadataPlaylist(
            id = id,
            title = title ?: "Untitled",
            description = annotation,
            thumbnails = listOf(
                Thumbnail(
                    url = thumbnailOverride
                        ?: "https://ui-avatars.com/api/?name=${title ?: "Playlist"}&background=random",
                    width = 300,
                    height = 300
                )
            ),
            trackCount = track?.size ?: 0,
            externalUri = identifier,
            owner = MetadataUser(
                id = creator,
                username = creator,
                displayName = creator,
                thumbnails = emptyList(),
                externalUri = "https://listenbrainz.org/user/$creator/",
            ),
        )
    }

    private suspend fun requireUsername(): String {
        logger.d("requireUsername(): Checking for cached username")
        cachedUsername?.let {
            logger.d("requireUsername(): Using cached username: $it")
            return it
        }

        logger.d("requireUsername(): Retrieving auth token from persistent storage")
        val auth = Auth.ApiKeyAuth {
            val token =
                persistedStorage.getString("listenbrainz_auth_token") ?: run {
                    logger.w("requireUsername(): No auth token found in persistent storage")
                    return@ApiKeyAuth null
                }
            logger.d("requireUsername(): Auth token retrieved, length: ${token.length}")
            if (token.startsWith("Token ", ignoreCase = true)) token else "Token $token"
        }
        Api.setAuthProvider(auth)

        logger.i("requireUsername(): Validating token with ListenBrainz API")
        val username = when (val res = LbCoreApi.validateToken()) {
            is Either.Left -> {
                val error = res.value
                logger.e("requireUsername(): Token validation failed with error: $error")
                throw error
            }

            is Either.Right -> {
                val user = res.value.data.userName
                logger.i("requireUsername(): Token validation successful, username: $user")
                user
            }
        }
        cachedUsername = username
        logger.d("requireUsername(): Caching username: $username")
        return username!!
    }

}