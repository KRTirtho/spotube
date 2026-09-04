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
import dev.krtirtho.spotube.PlatformType
import dev.krtirtho.spotube.core.deeplink.JamDeepLinkService
import dev.krtirtho.spotube.core.jam.JamInviteCodec
import dev.krtirtho.spotube.core.jam.JamInviteLink
import dev.krtirtho.spotube.core.jam.JamParticipant
import dev.krtirtho.spotube.core.jam.JamRole
import dev.krtirtho.spotube.core.jam.JamSessionService
import dev.krtirtho.spotube.core.share.ShareService
import dev.krtirtho.spotube.getPlatform
import dev.krtirtho.spotube.modules.settings.SettingsProvider
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

data class JamUiState(
    val isActive: Boolean = false,
    val isConnected: Boolean = false,
    val role: JamRole? = null,
    val participants: List<JamParticipant> = emptyList(),
    /** Host: deep link containing this session's SDP offer, ready to share. */
    val inviteLink: String? = null,
    /** Guest: deep link containing our SDP answer, to send back to the host. */
    val answerLink: String? = null,
    /** Guest: offer received via deep link (or paste), waiting for confirmation. */
    val incomingHostName: String? = null,
    val incomingOfferSdp: String? = null,
    val error: String? = null,
)

class JamViewModel(
    private val jamSession: JamSessionService,
    private val deepLinks: JamDeepLinkService,
    private val shareService: ShareService,
    private val settingsProvider: SettingsProvider,
) : ViewModel() {

    private val _uiState = MutableStateFlow(JamUiState())
    val uiState: StateFlow<JamUiState> = _uiState.asStateFlow()

    val supportsNativeShare: Boolean =
        getPlatform().type == PlatformType.Android || getPlatform().type == PlatformType.IOS

    init {
        viewModelScope.launch {
            // Mirror live session state into the UI state.
            jamSession.isActive.collect { active ->
                _uiState.update {
                    it.copy(
                        isActive = active,
                        isConnected = jamSession.isConnected.value,
                        role = jamSession.role.value,
                        participants = jamSession.participants.value,
                        inviteLink = if (!active) null else it.inviteLink,
                        answerLink = if (!active) null else it.answerLink,
                        incomingOfferSdp = if (!active) it.incomingOfferSdp else null,
                        incomingHostName = if (!active) it.incomingHostName else null,
                    )
                }
            }
        }
        viewModelScope.launch {
            jamSession.participants.collect { participants ->
                _uiState.update { it.copy(participants = participants) }
            }
        }
        viewModelScope.launch {
            jamSession.isConnected.collect { connected ->
                _uiState.update { it.copy(isConnected = connected) }
            }
        }
        viewModelScope.launch {
            deepLinks.pendingLink.collect { link ->
                handleDeepLink(link)
            }
        }
    }

    fun createSession() {
        viewModelScope.launch {
            runCatching {
                val offer = jamSession.createSession()
                JamInviteCodec.buildHostInvite(localName(), offer)
            }.onSuccess { link ->
                _uiState.update { it.copy(inviteLink = link, error = null) }
            }.onFailure { e ->
                _uiState.update { it.copy(error = "Failed to create session: ${e.message}") }
            }
        }
    }

    fun generateNewInvite() {
        viewModelScope.launch {
            runCatching {
                val invite = jamSession.generateInvite()
                JamInviteCodec.buildHostInvite(localName(), invite.sdp)
            }.onSuccess { link ->
                _uiState.update { it.copy(inviteLink = link, error = null) }
            }.onFailure { e ->
                _uiState.update { it.copy(error = "Failed to generate invite: ${e.message}") }
            }
        }
    }

    fun joinWithIncomingInvite() {
        val sdp = _uiState.value.incomingOfferSdp ?: return
        join(sdp, _uiState.value.incomingHostName)
    }

    fun joinWithPasted(input: String) {
        val parsed = JamInviteCodec.parse(input)
        val sdp = parsed?.sdp ?: JamInviteCodec.extractSdp(input)
        if (sdp == null) {
            _uiState.update { it.copy(error = "That doesn't look like a valid jam invite.") }
            return
        }
        join(sdp, (parsed as? JamInviteLink.HostInvite)?.peerName)
    }

    /**
     * Host side: accepts an answer pasted as raw SDP or as a full `spotube://jam/answer` link.
     */
    fun submitAnswerPasted(input: String) {
        when (val parsed = JamInviteCodec.parse(input.trim())) {
            is JamInviteLink.GuestAnswer -> acceptAnswerInternal(parsed.sdp, parsed.peerName)
            else -> {
                val sdp = JamInviteCodec.extractSdp(input)
                if (sdp == null) {
                    _uiState.update { it.copy(error = "That doesn't look like a valid SDP answer.") }
                } else {
                    acceptAnswerInternal(sdp, "")
                }
            }
        }
    }

    fun share(text: String) {
        shareService.share(text, "Spotube Group Jam")
    }

    fun leave() {
        viewModelScope.launch {
            jamSession.leave()
            deepLinks.clear()
            _uiState.update {
                JamUiState(incomingOfferSdp = it.incomingOfferSdp, incomingHostName = it.incomingHostName)
            }
        }
    }

    fun clearError() {
        _uiState.update { it.copy(error = null) }
    }

    fun dismissIncomingInvite() {
        deepLinks.clear()
        _uiState.update { it.copy(incomingOfferSdp = null, incomingHostName = null) }
    }

    private fun join(offerSdp: String, hostName: String? = null) {
        viewModelScope.launch {
            runCatching {
                val answer = jamSession.joinSession(offerSdp, hostName)
                JamInviteCodec.buildGuestAnswer(localName(), answer)
            }.onSuccess { link ->
                _uiState.update {
                    it.copy(answerLink = link, incomingOfferSdp = null, incomingHostName = null, error = null)
                }
            }.onFailure { e ->
                _uiState.update { it.copy(error = "Failed to join session: ${e.message}") }
            }
        }
    }

    private fun acceptAnswerInternal(answerSdp: String, peerName: String) {
        viewModelScope.launch {
            val accepted = runCatching { jamSession.acceptAnswer(null, answerSdp, peerName) }
                .getOrDefault(false)
            if (!accepted) {
                _uiState.update { it.copy(error = "Couldn't accept that answer — no pending invite matched.") }
            } else {
                _uiState.update { it.copy(error = null) }
            }
        }
    }

    private suspend fun handleDeepLink(link: JamInviteLink?) {
        when (link) {
            is JamInviteLink.HostInvite -> {
                if (!jamSession.isActive.value) {
                    _uiState.update {
                        it.copy(incomingHostName = link.peerName.ifBlank { "Someone" }, incomingOfferSdp = link.sdp)
                    }
                }
            }

            is JamInviteLink.GuestAnswer -> {
                if (jamSession.role.value == JamRole.Host) {
                    acceptAnswerInternal(link.sdp, link.peerName)
                }
            }

            null -> Unit
        }
    }

    private fun localName(): String =
        settingsProvider.settingsState.value?.jamParticipantName.orEmpty()
}