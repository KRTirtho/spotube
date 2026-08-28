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

package dev.krtirtho.spotube.core.deeplink

import dev.krtirtho.spotube.core.jam.JamInviteCodec
import dev.krtirtho.spotube.core.jam.JamInviteLink
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.navigation.Routes
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * Parses incoming `spotude://jam/...` deep links, exposes them to the Jam UI,
 * and navigates to [Routes.Jam] so the user lands where the link is handled.
 */
class JamDeepLinkService(
    private val navigationCommands: NavigationCommands,
) {
    private val _pendingLink = MutableStateFlow<JamInviteLink?>(null)
    val pendingLink: StateFlow<JamInviteLink?> = _pendingLink.asStateFlow()

    fun handleUri(uri: String) {
        val link = JamInviteCodec.parse(uri) ?: return
        _pendingLink.value = link
        navigationCommands.navigateTo(Routes.Jam)
    }

    /** Consumes the currently pending link (if any). */
    fun consume(): JamInviteLink? = _pendingLink.value.also { _pendingLink.value = null }

    fun clear() {
        _pendingLink.value = null
    }
}