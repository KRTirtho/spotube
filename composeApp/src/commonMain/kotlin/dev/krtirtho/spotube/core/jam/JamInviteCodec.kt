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

package dev.krtirtho.spotube.core.jam

import io.ktor.http.decodeURLQueryComponent
import io.ktor.http.encodeURLParameter

/**
 * SDP payloads exchanged between jam peers are wrapped into `spotube://` deep links
 * so they can be shared through any messaging medium. The SDP blob is percent-encoded
 * as a query parameter.
 *
 * Host invite  : `spotube://jam/invite?name=<host name>&sdp=<offer sdp>`
 * Guest answer : `spotube://jam/answer?name=<guest name>&sdp=<answer sdp>`
 */
sealed interface JamInviteLink {
    val peerName: String
    val sdp: String

    data class HostInvite(
        override val peerName: String,
        override val sdp: String,
    ) : JamInviteLink

    data class GuestAnswer(
        override val peerName: String,
        override val sdp: String,
    ) : JamInviteLink
}

object JamInviteCodec {
    const val SCHEME = "spotube"
    const val INVITE_PATH = "jam/invite"
    const val ANSWER_PATH = "jam/answer"

    fun buildHostInvite(hostName: String, offerSdp: String): String =
        buildLink(INVITE_PATH, hostName, offerSdp)

    fun buildGuestAnswer(guestName: String, answerSdp: String): String =
        buildLink(ANSWER_PATH, guestName, answerSdp)

    private fun buildLink(path: String, peerName: String, sdp: String): String =
        "$SCHEME://$path?name=${peerName.encodeURLParameter()}" +
            "&sdp=${sdp.encodeURLParameter()}"

    /**
     * Parses a `spotude://jam/...` link. Returns null for foreign or malformed URIs.
     * Parsing is done manually — generic URI parsers normalize unknown schemes in
     * ways that mangle percent-encoded multi-line payloads.
     */
    fun parse(rawUri: String): JamInviteLink? {
        val uri = rawUri.trim()
        if (!uri.startsWith("$SCHEME://", ignoreCase = true)) return null

        val withoutScheme = uri.substring(SCHEME.length + 3)
        val queryStart = withoutScheme.indexOf('?')
        if (queryStart < 0) return null

        val path = withoutScheme.take(queryStart).trim('/').lowercase()
        val params = withoutScheme.substring(queryStart + 1)
            .split('&')
            .mapNotNull { pair ->
                val separator = pair.indexOf('=')
                if (separator <= 0) return@mapNotNull null
                pair.take(separator) to pair.substring(separator + 1)
            }
            .toMap()

        val sdp = params["sdp"]?.decodeURLQueryComponent()?.takeIf { it.isNotBlank() }
            ?: return null
        val peerName = params["name"]?.decodeURLQueryComponent().orEmpty()

        return when (path) {
            INVITE_PATH -> JamInviteLink.HostInvite(peerName, sdp)
            ANSWER_PATH -> JamInviteLink.GuestAnswer(peerName, sdp)
            else -> null
        }
    }

    /**
     * Extracts an SDP payload from user input which may either be a full
     * `spotube://` deep link or a raw SDP body pasted by hand.
     */
    fun extractSdp(rawInput: String): String? {
        val input = rawInput.trim()
        parse(input)?.let { return it.sdp }
        // Heuristic for raw SDP: first line is the session description header
        return if (input.startsWith("v=", ignoreCase = false)) input else null
    }
}