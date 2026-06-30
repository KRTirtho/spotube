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

package dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.wikidata

import io.ktor.client.HttpClient
import io.ktor.client.request.get
import io.ktor.client.request.parameter
import io.ktor.client.request.url
import io.ktor.client.statement.bodyAsText
import kotlinx.serialization.json.Json

class WikidataRepository(private val httpClient: HttpClient) {
    private val json = Json {
        ignoreUnknownKeys = true
        isLenient = true
    }

    suspend fun getArtistImages(wikidataIds: List<String>): Map<String, String?> {
        if (wikidataIds.isEmpty()) return emptyMap()

        try {
            // 1. Get image filenames from Wikidata
            val wikidataResponseText = httpClient.get {
                url("https://www.wikidata.org/w/api.php")
                parameter("format", "json")
                parameter("props", "claims")
                parameter("ids", wikidataIds.joinToString("|"))
                parameter("action", "wbgetentities")
            }.bodyAsText()

            val wikidataResponse = json.decodeFromString<WikidataEntitiesResponse>(wikidataResponseText)
            
            val idsWithImageNames = wikidataIds.map { id ->
                val imageName = wikidataResponse.entities[id]?.claims?.get("P18")?.firstOrNull()?.mainsnak?.datavalue?.value
                id to imageName
            }

            val imageNames = idsWithImageNames.mapNotNull { it.second }
            if (imageNames.isEmpty()) return wikidataIds.associateWith { null }

            val titles = imageNames.map { "File:$it" }.joinToString("|")

            // 2. Get image URLs from Wikimedia Commons
            val commonsResponseText = httpClient.get {
                url("https://commons.wikimedia.org/w/api.php")
                parameter("prop", "imageinfo")
                parameter("action", "query")
                parameter("iiprop", "url|size")
                parameter("iiurlheight", 300)
                parameter("iiurlwidth", 300)
                parameter("format", "json")
                parameter("titles", titles)
            }.bodyAsText()

            val commonsResponse = json.decodeFromString<WikimediaResponse>(commonsResponseText)
            val pages = commonsResponse.query?.pages?.values ?: emptyList()

            val imagesMap = mutableMapOf<String, String?>()

            // Initialize all with null
            wikidataIds.forEach { imagesMap[it] = null }

            for (page in pages) {
                val imageName = page.title.removePrefix("File:")
                val imageUrl = page.imageinfo?.firstOrNull()?.thumburl ?: page.imageinfo?.firstOrNull()?.url
                
                // Find original Wikidata ID for this image name
                val wikidataId = idsWithImageNames.firstOrNull { it.second == imageName }?.first
                if (wikidataId != null) {
                    imagesMap[wikidataId] = imageUrl
                }
            }

            return imagesMap
        } catch (e: Exception) {
            e.printStackTrace()
            return wikidataIds.associateWith { null }
        }
    }
}

