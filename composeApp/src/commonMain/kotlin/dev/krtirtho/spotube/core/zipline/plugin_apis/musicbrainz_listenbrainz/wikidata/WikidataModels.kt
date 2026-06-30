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

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

@Serializable
data class WikidataEntityValue(
    val value: String? = null
)

@Serializable
data class WikidataEntityDataValue(
    val value: String? = null // It can be object but for P18 (image) it is string (filename)
)

@Serializable
data class WikidataEntitySnak(
    val datavalue: WikidataEntityDataValue? = null
)

@Serializable
data class WikidataEntityClaim(
    val mainsnak: WikidataEntitySnak? = null
)

@Serializable
data class WikidataEntity(
    val id: String,
    val claims: Map<String, List<WikidataEntityClaim>>? = null
)

@Serializable
data class WikidataEntitiesResponse(
    val entities: Map<String, WikidataEntity> = emptyMap()
)

@Serializable
data class WikimediaImageInfo(
    val thumburl: String? = null,
    val thumbwidth: Int? = null,
    val thumbheight: Int? = null,
    val url: String? = null,
    val width: Int? = null,
    val height: Int? = null
)

@Serializable
data class WikimediaPage(
    val pageid: Long,
    val title: String,
    val imageinfo: List<WikimediaImageInfo>? = null
)

@Serializable
data class WikimediaQuery(
    val pages: Map<String, WikimediaPage> = emptyMap()
)

@Serializable
data class WikimediaResponse(
    val query: WikimediaQuery? = null
)

