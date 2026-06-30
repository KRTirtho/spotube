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

import io.ktor.client.HttpClient
import io.ktor.client.request.get
import io.ktor.client.request.header
import io.ktor.client.request.parameter
import io.ktor.client.request.url
import io.ktor.client.statement.bodyAsText
import io.ktor.client.statement.request
import io.ktor.client.statement.HttpResponse
import io.ktor.http.HttpHeaders
import io.ktor.http.isSuccess
import kotlinx.serialization.json.Json

interface MusicbrainzRepository {
	suspend fun searchRecordings(
		query: String,
		limit: Int = 25,
		offset: Int = 0,
	): MusicbrainzRecordingSearchResponse

	suspend fun searchArtists(
		query: String,
		limit: Int = 25,
		offset: Int = 0,
	): MusicbrainzArtistSearchResponse

	suspend fun searchReleases(
		query: String,
		limit: Int = 25,
		offset: Int = 0,
	): MusicbrainzReleaseSearchResponse

	suspend fun searchReleaseGroups(
		query: String,
		limit: Int = 25,
		offset: Int = 0,
	): MusicbrainzReleaseGroupSearchResponse

	suspend fun searchUrls(
		query: String,
		limit: Int = 25,
	): MusicbrainzUrlResponse

	suspend fun getRecordingByMbid(
		mbid: String,
		includes: List<String> = emptyList(),
	): MusicbrainzRecording

	suspend fun getArtistByMbid(
		mbid: String,
		includes: List<String> = emptyList(),
	): MusicbrainzArtist

	suspend fun getReleaseByMbid(
		mbid: String,
		includes: List<String> = emptyList(),
	): MusicbrainzRelease

	suspend fun lookupIsrc(
		isrc: String,
		includes: List<String> = emptyList(),
	): MusicbrainzIsrcLookupResponse
}

class KtorMusicbrainzRepository(
	private val httpClient: HttpClient,
	private val baseUrl: String = "https://musicbrainz.org",
	private val userAgent: String = "Spotube/0.1 (https://github.com/KRTirtho/spotube)",
) : MusicbrainzRepository {
	private val json = Json {
		ignoreUnknownKeys = true
		isLenient = true
	}

	override suspend fun searchRecordings(
		query: String,
		limit: Int,
		offset: Int,
	): MusicbrainzRecordingSearchResponse {
		val payload = fetch(
			endpoint = "recording",
			query = query,
			limit = limit,
			offset = offset,
		)
		return json.decodeFromString(payload)
	}

	override suspend fun searchArtists(
		query: String,
		limit: Int,
		offset: Int,
	): MusicbrainzArtistSearchResponse {
		val payload = fetch(
			endpoint = "artist",
			query = query,
			limit = limit,
			offset = offset,
		)
		return json.decodeFromString(payload)
	}

	override suspend fun searchReleases(
		query: String,
		limit: Int,
		offset: Int,
	): MusicbrainzReleaseSearchResponse {
		val payload = fetch(
			endpoint = "release",
			query = query,
			limit = limit,
			offset = offset,
		)
		return json.decodeFromString(payload)
	}

	override suspend fun searchReleaseGroups(
		query: String,
		limit: Int,
		offset: Int,
	): MusicbrainzReleaseGroupSearchResponse {
		val payload = fetch(
			endpoint = "release-group",
			query = query,
			limit = limit,
			offset = offset,
		)
		return json.decodeFromString(payload)
	}

	override suspend fun searchUrls(
		query: String,
		limit: Int,
	): MusicbrainzUrlResponse {
		val payload = fetch(
			endpoint = "url",
			query = query,
			limit = limit,
		)
		return json.decodeFromString(payload)
	}

	override suspend fun getRecordingByMbid(
		mbid: String,
		includes: List<String>,
	): MusicbrainzRecording {
		val payload = fetch(endpoint = "recording/${mbid.trim()}", inc = includes)
		return json.decodeFromString(payload)
	}

	override suspend fun getArtistByMbid(
		mbid: String,
		includes: List<String>,
	): MusicbrainzArtist {
		val payload = fetch(endpoint = "artist/${mbid.trim()}", inc = includes)
		return json.decodeFromString(payload)
	}

	override suspend fun getReleaseByMbid(
		mbid: String,
		includes: List<String>,
	): MusicbrainzRelease {
		val payload = fetch(endpoint = "release/${mbid.trim()}", inc = includes)
		return json.decodeFromString(payload)
	}

	override suspend fun lookupIsrc(
		isrc: String,
		includes: List<String>,
	): MusicbrainzIsrcLookupResponse {
		val payload = fetch(endpoint = "isrc/${isrc.trim()}", inc = includes)
		return json.decodeFromString(payload)
	}

	private suspend fun fetch(
		endpoint: String,
		query: String? = null,
		limit: Int? = null,
		offset: Int? = null,
		inc: List<String> = emptyList(),
	): String {
		val response = httpClient.get {
			url("${baseUrl.trimEnd('/')}/ws/2/$endpoint")
			header(HttpHeaders.Accept, "application/json")
			header(HttpHeaders.UserAgent, userAgent)
			parameter("fmt", "json")
			query?.takeIf { it.isNotBlank() }?.let { parameter("query", it) }
			limit?.let { parameter("limit", it) }
			offset?.let { parameter("offset", it) }
			inc.toMusicbrainzInc()?.let { parameter("inc", it) }
		}

		return response.requireBody()
	}
}

class MusicbrainzApiException(
	val statusCode: Int,
	message: String,
) : RuntimeException(message)

private suspend fun HttpResponse.requireBody(): String {
	val text = bodyAsText()
	if (status.isSuccess()) return text

	throw MusicbrainzApiException(
		statusCode = status.value,
		message = "MusicBrainz request failed (${status.value}) for ${request.url}. Response: ${text.take(512)}"
	)
}

private fun List<String>.toMusicbrainzInc(): String? {
	val cleaned = map { it.trim() }.filter { it.isNotBlank() }
	if (cleaned.isEmpty()) return null
	return cleaned.joinToString(separator = "+")
}
