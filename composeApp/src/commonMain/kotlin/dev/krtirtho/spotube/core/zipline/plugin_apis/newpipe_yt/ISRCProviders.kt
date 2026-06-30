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

package dev.krtirtho.spotube.core.zipline.plugin_apis.newpipe_yt

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.tools.user_agents.UserAgents
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.request.get
import io.ktor.client.request.parameter
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.http.contentType
import io.ktor.http.headers
import io.ktor.serialization.kotlinx.json.json
import io.ktor.util.appendAll
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json

class ISRCProviders {
    companion object {
        val greedyGreenCorp =
            listOf(-0x03, -0x01, 0x05, -0x0B, -0x03, 0x13)
                .scan(0x64 + 0x0F) { acc, step -> acc + step }
                .map { it.toChar() }
                .joinToString("")
                .lowercase()
    }

    val client = HttpClient() {
        install(ContentNegotiation) {
            json(Json {
                prettyPrint = true
                isLenient = true
                ignoreUnknownKeys = true
            })
        }
    }


    private var ifpiSessionToken: String? = null
    private val ifpiDefaultHeaders = mapOf(
        "Content-Type" to "application/json",
        "Accept" to "application/json",
        "Origin" to "https://isrcsearch.ifpi.org/",
        "Referer" to "https://isrcsearch.ifpi.org/",
        "User-Agent" to UserAgents.random()
    )
    private val soundplateDefaultHeaders = mapOf(
        "Content-Type" to "application/json",
        "Accept" to "application/json",
        "Origin" to "https://soundplate.com/",
        "Referer" to "https://phpstack-822472-6184058.cloudwaysapps.com/?",
        "sec-fetch-mode" to "cors",
        "sec-fetch-site" to "same-origin",
        "User-Agent" to UserAgents.random()
    )


    private suspend fun ifpiSessionToken(): String? = withContext(Dispatchers.IO) {
        if (ifpiSessionToken != null) return@withContext ifpiSessionToken

        val res = client.get("https://isrc-api.soundexchange.com/api/ext/login") {
            headers.appendAll(ifpiDefaultHeaders)
        }

        if (res.status.value != 200) {
            return@withContext null
        }

        val body = res.body<IFPISessionResponse>()
        ifpiSessionToken = body.token
        body.token
    }

    suspend fun ifpi(track: MetadataTrack): String? = withContext(Dispatchers.IO) {
        val sessonToken = ifpiSessionToken() ?: return@withContext null
        val input = IFPIRecordingRequestInput(
            searchFields = IFPIRecordingRequestInput.SearchFields(
                recordingArtistName = track.artists.firstOrNull()?.name?.let {
                    IFPIRecordingRequestInput.SearchFields.FieldValue(
                        it
                    )
                },
                recordingTitle = track.title.let {
                    IFPIRecordingRequestInput.SearchFields.FieldValue(
                        it
                    )
                },
                releaseName = track.album?.title?.let {
                    IFPIRecordingRequestInput.SearchFields.FieldValue(
                        it
                    )
                }
            )
        )

        val res = client.post("https://isrc-api.soundexchange.com/api/ext/recordings") {
            contentType(ContentType.Application.Json)
            headers {
                appendAll(ifpiDefaultHeaders)
                append("Authorization", "Token $sessonToken")
            }
            setBody(input)
        }

        if (res.status.value != 200) {
            return@withContext null
        }

        val body = res.body<IFPIRecordingResponse>()
        if (body.recordings.isEmpty()) {
            return@withContext null
        }
        body.recordings.first().isrc
    }

    suspend fun musicGateway(track: MetadataTrack): String? = withContext(Dispatchers.IO) {
        val res = client.get("https://www.musicgateway.com/isrc-finder") {
            parameter("search", "${track.title} ${track.artists.joinToString(", ") { it.name }}")
            parameter("type", "name")
            parameter("page", "1")
        }

        if (res.status != HttpStatusCode.OK) {
            return@withContext null
        }

        val body = res.body<MusicGatewayResponse>()
        val results = body.result.tracks.items

        if (results.isEmpty()) {
            return@withContext null
        }

        var isrcCode: String? = null

        for (item in results) {
            val isExactTitle = item.name.equals(track.title, ignoreCase = true)
            val isArtistMatch = item.artists.any {
                it.name.equals(
                    track.artists.firstOrNull()?.name ?: "",
                    ignoreCase = true
                )
            }
            val isSameId = item.id == track.id
            if (isSameId || (isExactTitle && isArtistMatch)) {
                isrcCode = item.externalIds.isrc
                break
            }
        }

        isrcCode
    }

    suspend fun soundplate(track: MetadataTrack): String? = withContext(Dispatchers.IO) {
        val isGreedyGreenCorp = track.externalUri?.contains(greedyGreenCorp) ?: false
        val uri = "https://open.$greedyGreenCorp.com/track/${track.id}"
        val res =
            client.get("https://phpstack-822472-6184058.cloudwaysapps.com/api/$greedyGreenCorp.php") {
                if (isGreedyGreenCorp) {
                    parameter("q", uri)
                } else {
                    parameter("q", "${track.artists.firstOrNull()?.name ?: ""} - ${track.title}")
                }
                headers.appendAll(soundplateDefaultHeaders)
            }

        if (res.status.value != 200) {
            return@withContext null
        }

        val body = res.body<SoundplateResponse>()
        body.isrc
    }

    suspend fun auto(track: MetadataTrack): String? {
        return runCatching { soundplate(track) }.getOrNull()
            ?: runCatching { ifpi(track) }.getOrNull()
            ?: runCatching { musicGateway(track) }.getOrNull()
    }
}