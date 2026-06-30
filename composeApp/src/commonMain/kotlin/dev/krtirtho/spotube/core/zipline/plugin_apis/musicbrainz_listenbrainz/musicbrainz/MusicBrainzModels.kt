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

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class MusicbrainzTag(
	val name: String,
	val count: Int? = null,
)

@Serializable
data class MusicbrainzLifeSpan(
	val begin: String? = null,
	val end: String? = null,
	val ended: Boolean? = null,
)

@Serializable
data class MusicbrainzTextRepresentation(
	val language: String? = null,
	val script: String? = null,
)

@Serializable
data class MusicbrainzArtist(
	val id: String,
	val name: String,
	val score: String? = null,
	@SerialName("sort-name")
	val sortName: String? = null,
	val country: String? = null,
	val type: String? = null,
	val gender: String? = null,
	val disambiguation: String? = null,
	@SerialName("life-span")
	val lifeSpan: MusicbrainzLifeSpan? = null,
	val tags: List<MusicbrainzTag> = emptyList(),
)

@Serializable
data class MusicbrainzArtistCredit(
	val name: String? = null,
	@SerialName("joinphrase")
	val joinPhrase: String? = null,
	val artist: MusicbrainzArtist? = null,
)

@Serializable
data class MusicbrainzReleaseGroup(
	val id: String,
	val title: String,
	@SerialName("primary-type")
	val primaryType: String? = null,
	@SerialName("secondary-types")
	val secondaryTypes: List<String> = emptyList(),
	@SerialName("first-release-date")
	val firstReleaseDate: String? = null,
)

@Serializable
data class MusicbrainzRelease(
	val id: String,
	val title: String,
	val score: String? = null,
	val status: String? = null,
	val quality: String? = null,
	val date: String? = null,
	val country: String? = null,
	@SerialName("barcode")
	val barCode: String? = null,
	@SerialName("track-count")
	val trackCount: Int? = null,
	@SerialName("text-representation")
	val textRepresentation: MusicbrainzTextRepresentation? = null,
	@SerialName("artist-credit")
	val artistCredit: List<MusicbrainzArtistCredit> = emptyList(),
	@SerialName("release-group")
	val releaseGroup: MusicbrainzReleaseGroup? = null,
)

@Serializable
data class MusicbrainzRecording(
	val id: String,
	val title: String,
	val length: Int? = null,
	val disambiguation: String? = null,
	val video: Boolean? = null,
	val score: String? = null,
	@SerialName("first-release-date")
	val firstReleaseDate: String? = null,
	@SerialName("artist-credit")
	val artistCredit: List<MusicbrainzArtistCredit> = emptyList(),
	val releases: List<MusicbrainzRelease> = emptyList(),
	val tags: List<MusicbrainzTag> = emptyList(),
	val isrcs: List<String> = emptyList(),
)

@Serializable
data class MusicbrainzRecordingSearchResponse(
	val created: String? = null,
	val count: Int = 0,
	val offset: Int = 0,
	val recordings: List<MusicbrainzRecording> = emptyList(),
)

@Serializable
data class MusicbrainzArtistSearchResponse(
	val created: String? = null,
	val count: Int = 0,
	val offset: Int = 0,
	val artists: List<MusicbrainzArtist> = emptyList(),
)

@Serializable
data class MusicbrainzReleaseSearchResponse(
	val created: String? = null,
	val count: Int = 0,
	val offset: Int = 0,
	val releases: List<MusicbrainzRelease> = emptyList(),
)

@Serializable
data class MusicbrainzReleaseGroupSearchResponse(
	val created: String? = null,
	val count: Int = 0,
	val offset: Int = 0,
	@SerialName("release-groups")
	val releaseGroups: List<MusicbrainzReleaseGroup> = emptyList(),
)

@Serializable
data class MusicbrainzUrlRelation(
	val artist: MusicbrainzArtist? = null,
)

@Serializable
data class MusicbrainzUrlRelationList(
	val relations: List<MusicbrainzUrlRelation> = emptyList(),
)

@Serializable
data class MusicbrainzUrl(
	val resource: String,
	@SerialName("relation-list")
	val relationList: List<MusicbrainzUrlRelationList> = emptyList(),
)

@Serializable
data class MusicbrainzUrlResponse(
	val urls: List<MusicbrainzUrl> = emptyList(),
)

@Serializable
data class MusicbrainzIsrcLookupResponse(
	val isrc: String,
	val recordings: List<MusicbrainzRecording> = emptyList(),
)
