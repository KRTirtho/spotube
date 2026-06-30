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

package dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz

import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.wikidata.WikidataRepository

class MusicbrainzArtistEnricher(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val wikidataRepository: WikidataRepository
) {
    suspend fun getArtistsWithImages(artistIds: List<String>): List<MusicbrainzArtist> {
        if (artistIds.isEmpty()) return emptyList()

        // 1. Find Wikidata URLs for these artists
        val idsQuery = artistIds.joinToString(" OR ") { "targetid:$it" }
        val query = "relationtype:wikidata AND targettype:artist AND ($idsQuery)"
        
        val urlResponse = musicbrainzRepository.searchUrls(
            query = query,
            limit = artistIds.size
        )

        val urls = urlResponse.urls
        val wikidataIds = urls.map { it.resource.substringAfterLast("/") }
        
        // Map MBID to Wikidata ID based on response
        // The response structure for /url search is a bit complex. 
        // It returns URLs, and each URL has relation-list -> relations -> artist -> id
        
        val mbidToWikidataId = mutableMapOf<String, String>()
        
        urls.forEach { url ->
            val wikidataId = url.resource.substringAfterLast("/")
            val artistId = url.relationList.firstOrNull()?.relations?.firstOrNull()?.artist?.id
            if (artistId != null) {
                mbidToWikidataId[artistId] = wikidataId
            }
        }

        // 2. Fetch images for Wikidata IDs
        val imagesMap = wikidataRepository.getArtistImages(wikidataIds)
        
        // 3. Construct result
        // We need to return MusicbrainzArtist objects. We might need to fetch details if we don't have them.
        // But here we are enriching. 
        // Logic in search.ht:
        // - Get wikidata IDs
        // - Fetch images
        // - Fetch artist details for artists WITHOUT wikidata link (using /artist search or lookup)
        // - Combine
        
        // Let's search/fetch artist details for all IDs using their MBIDs
        // Optimally we can batch fetch if possible, but MB API usually requires individual lookups or search.
        // search.ht uses search endpoint with "arid:ID OR arid:ID..."
        
        val artistsResponse = musicbrainzRepository.searchArtists(
            query = artistIds.joinToString(" OR ") { "arid:$it" },
            limit = artistIds.size
        )
        
        val artists = artistsResponse.artists.map { artist ->
            // Check if we have an image for this artist
            // We need to know which wikidata ID corresponds to this artist
            val wikidataId = mbidToWikidataId[artist.id]
            val imageUrl = wikidataId?.let { imagesMap[it] }
            
            // We don't have a field for 'images' in MusicbrainzArtist model yet.
            // We should probably return a Pair or a new model, or just rely on the fact that we can't modify MusicbrainzArtist easily if it's data class.
            // But wait, search.ht returns list of items which are maps.
            
            // I'll return MusicbrainzArtist, but I need to attach the image somehow.
            // I'll assume passing the image URL up is handled by the caller or I'll wrap it.
            // But MusicbrainzArtist is a data class.
            
            // Wait, Kotlin data classes are immutable.
            // references used in search.ht:
            // return { id: ..., name: ..., images: [url, ...] }
            
            // So this Enricher should probably return a data structure that holds Artist + Image list.
            EnrichedArtist(artist, imageUrl?.let { listOf(it) } ?: emptyList())
        }
        
        return artists.map { it.artist } // Wait, how to attach image?
    }
    
    data class EnrichedArtist(
        val artist: MusicbrainzArtist,
        val images: List<String>
    )
    
    suspend fun getEnrichedArtists(artistIds: List<String>): List<EnrichedArtist> {
         if (artistIds.isEmpty()) return emptyList()

        // 1. Find Wikidata URLs for these artists
        val idsQuery = artistIds.joinToString(" OR ") { "targetid:$it" }
        val query = "relationtype:wikidata AND targettype:artist AND ($idsQuery)"
        
        val urlResponse = musicbrainzRepository.searchUrls(
            query = query,
            limit = artistIds.size
        )

        val urls = urlResponse.urls
        
        val mbidToWikidataId = mutableMapOf<String, String>()
        urls.forEach { url ->
            val wikidataId = url.resource.substringAfterLast("/")
            val artistId = url.relationList.firstOrNull()?.relations?.firstOrNull()?.artist?.id
            if (artistId != null) {
                mbidToWikidataId[artistId] = wikidataId
            }
        }
        
        val wikidataIds = mbidToWikidataId.values.toList()

        // 2. Fetch images for Wikidata IDs
        val imagesMap = if (wikidataIds.isNotEmpty()) {
            wikidataRepository.getArtistImages(wikidataIds)
        } else {
            emptyMap()
        }
        
        // 3. Fetch artist details
        // search.ht fetches "missingArtistIds" (artists without wikidata link) separately.
        // But here we can just fetch ALL artists using one query (arid:...) because we need details for all of them anyway.
        // search.ht fetches "artistWithImages" from wikidata info (it gets artist object from /url response relation),
        // and "artistWithoutImages" from /artist search.
        // The /url response relation includes the artist object!
        
        // Let's follow search.ht optimization:
        // Use artists from /url response for those that have wikidata.
        // Use /artist search for those that don't.
        
        val artistsFromUrl = urls.mapNotNull { url ->
            val artist = url.relationList.firstOrNull()?.relations?.firstOrNull()?.artist
            val wikidataId = url.resource.substringAfterLast("/")
            val imageUrl = imagesMap[wikidataId]
            
            if (artist != null) {
                EnrichedArtist(artist, imageUrl?.let { listOf(it) } ?: emptyList())
            } else null
        }
        
        val foundArtistIds = artistsFromUrl.map { it.artist.id }.toSet()
        val missingRequestIds = artistIds.filter { !foundArtistIds.contains(it) }
        
        val artistsFromSearch = if (missingRequestIds.isNotEmpty()) {
             val artistsResponse = musicbrainzRepository.searchArtists(
                query = missingRequestIds.joinToString(" OR ") { "arid:$it" },
                limit = missingRequestIds.size
            )
            artistsResponse.artists.map { EnrichedArtist(it, emptyList()) }
        } else {
            emptyList()
        }
        
        return artistsFromUrl + artistsFromSearch
    }
}

