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

package dev.krtirtho.spotube.modules.jam

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerInterface
import dev.krtirtho.spotube.core.jam.JamMessage
import dev.krtirtho.spotube.core.jam.JamParticipant
import dev.krtirtho.spotube.core.jam.JamRole
import dev.krtirtho.spotube.core.jam.JamSessionService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class JamViewModel : ViewModel(), KoinComponent {
    private val jamSession: JamSessionService by inject()
    private val audioPlayer: AudioPlayerInterface by inject()

    val role: StateFlow<JamRole?> = jamSession.role
    val participants: StateFlow<List<JamParticipant>> = jamSession.participants
    val isActive: StateFlow<Boolean> = jamSession.isActive

    private val _pendingHostOffer = MutableStateFlow<String?>(null)
    val pendingHostOffer: StateFlow<String?> = _pendingHostOffer.asStateFlow()

    private val _pendingGuestAnswer = MutableStateFlow<String?>(null)
    val pendingGuestAnswer: StateFlow<String?> = _pendingGuestAnswer.asStateFlow()

    private val _error = MutableStateFlow<String?>(null)
    val error: StateFlow<String?> = _error.asStateFlow()

    fun createSession() {
        viewModelScope.launch {
            try {
                val offer = jamSession.createSession()
                _pendingHostOffer.value = offer
            } catch (e: Exception) {
                _error.value = "Failed to create session: ${e.message}"
            }
        }
    }

    fun joinSession(offer: String) {
        viewModelScope.launch {
            try {
                val answer = jamSession.joinSession(offer)
                _pendingGuestAnswer.value = answer
            } catch (e: Exception) {
                _error.value = "Failed to join session: ${e.message}"
            }
        }
    }

    fun leave() {
        viewModelScope.launch {
            jamSession.leave()
            _pendingHostOffer.value = null
            _pendingGuestAnswer.value = null
        }
    }

    fun clearError() {
        _error.value = null
    }
}