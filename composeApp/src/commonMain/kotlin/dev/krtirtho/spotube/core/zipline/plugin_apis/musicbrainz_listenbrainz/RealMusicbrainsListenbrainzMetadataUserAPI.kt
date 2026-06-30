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
import com.kroegerama.openapi.kmp.gen.companion.appendSerializedQueryParameter
import dev.krtirtho.plugin_interfaces.host_apis.PersistedStorageAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUser
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUserAPI
import dev.krtirtho.spotube.core.zipline.host_apis.RealPersistedStorageAPI
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRepository
import dev.krtirtho.spotube.listenbrainz.Auth
import dev.krtirtho.spotube.listenbrainz.api.LbCoreApi

class RealMusicbrainsListenbrainzMetadataUserAPI(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val persistedStorage: PersistedStorageAPI
) : MetadataUserAPI {
    override suspend fun getUser(id: String): MetadataUser? {
        val token = persistedStorage.getString("listenbrainz_auth_token") ?: return null
        if(token.isEmpty()) return null
        when (val res = LbCoreApi.validateToken {
            appendSerializedQueryParameter("token", token)
        }) {
            is Either.Left -> {
                println("Error validating token: ${res.value}")
                return null
            }

            is Either.Right -> {
                val user = res.value.data
                return MetadataUser(
                    id = user.userName as String,
                    username = user.userName,
                    displayName = user.userName,
                    thumbnails = emptyList(),
                    externalUri = "https://listenbrainz.org/user/${user.userName}",
                )
            }
        }
    }
}