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

import co.touchlab.kermit.Logger
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerInterface
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.modules.settings.SettingsProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import org.koin.core.component.KoinComponent
import uniffi.compose_app.IceServerConfig
import uniffi.compose_app.WebrtcEventHandler
import uniffi.compose_app.WebrtcPeerConnection
import uniffi.compose_app.createWebrtcPeerConnection

class JamSessionService(
    private val audioPlayer: AudioPlayerInterface,
    private val settingsProvider: SettingsProvider,
) : KoinComponent {
    val logger by injectLogger<JamSessionService>()
    private val log = Logger.withTag("JamSessionService")

    private val json = Json {
        ignoreUnknownKeys = true
        classDiscriminator = "type"
        encodeDefaults = true
    }

    private val _role = MutableStateFlow<JamRole?>(null)
    val role: StateFlow<JamRole?> = _role.asStateFlow()

    private val _participants = MutableStateFlow<List<JamParticipant>>(emptyList())
    val participants: StateFlow<List<JamParticipant>> = _participants.asStateFlow()

    private val _isActive = MutableStateFlow(false)
    val isActive: StateFlow<Boolean> = _isActive.asStateFlow()

    private val _localParticipantId = MutableStateFlow<String?>(null)
    val localParticipantId: StateFlow<String?> = _localParticipantId.asStateFlow()

    private val _incomingMessages = MutableSharedFlow<JamMessage>(extraBufferCapacity = 64)
    val incomingMessages = _incomingMessages.asSharedFlow()

    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    private val _incomingSuggestions = MutableSharedFlow<JamMessage>(extraBufferCapacity = 32)
    val incomingSuggestions = _incomingSuggestions.asSharedFlow()

    private var hostConnection: WebrtcPeerConnection? = null
    private val guestConnections = mutableMapOf<String, WebrtcPeerConnection>()
    private val guestLabels = mutableMapOf<String, String>()

    private val eventHandler = object : WebrtcEventHandler {
        override fun onIceCandidate(candidate: String) {
            // No-op in non-trickle mode: candidates are bundled into SDP
        }

        override fun onIceGatheringStateChange(state: String) {
            log.d { "ICE gathering state: $state" }
        }

        override fun onConnectionStateChange(state: String) {
            log.i { "Connection state: $state" }
        }

        override fun onDataChannelOpen(label: String) {
            log.i { "Data channel '$label' open" }
        }

        override fun onDataChannelMessage(label: String, data: String) {
            handleIncomingMessage(label, data)
        }

        override fun onDataChannelClose(label: String) {
            log.i { "Data channel '$label' closed" }
        }
    }

    suspend fun createSession(): String {
        log.i { "Creating jam session" }
        val settings = settingsProvider.settingsState.first()
        val participantName = settings?.jamParticipantName?.ifBlank {
            "Host-${randomShortId()}"
        } ?: "Host"

        val pc = createWebrtcPeerConnection(
            iceServers = listOf(
                IceServerConfig(
                    urls = listOf("stun:stun.l.google.com:19302"),
                    username = "",
                    credential = "",
                )
            ),
            handler = eventHandler,
        )

        hostConnection = pc
        _role.value = JamRole.Host
        _localParticipantId.value = "host"
        _participants.value = listOf(
            JamParticipant(
                id = "host",
                displayName = participantName,
                isHost = true,
            )
        )
        _isActive.value = true

        pc.createDataChannel("jam")
        val offer = pc.createOffer()
        log.i { "Generated SDP offer (length=${offer.length})" }
        return offer
    }

    suspend fun acceptGuestAnswer(guestId: String, answer: String) {
        val pc = guestConnections[guestId] ?: run {
            log.w { "acceptGuestAnswer: no connection for $guestId" }
            return
        }
        pc.setRemoteAnswer(answer)
    }

    suspend fun joinSession(offer: String): String {
        log.i { "Joining jam session" }
        val settings = settingsProvider.settingsState.first()
        val participantName = settings?.jamParticipantName?.ifBlank {
            "Guest-${randomShortId()}"
        } ?: "Guest"

        val pc = createWebrtcPeerConnection(
            iceServers = listOf(
                IceServerConfig(
                    urls = listOf("stun:stun.l.google.com:19302"),
                    username = "",
                    credential = "",
                )
            ),
            handler = eventHandler,
        )

        hostConnection = pc
        _role.value = JamRole.Guest
        _localParticipantId.value = "guest"
        _isActive.value = true

        pc.setRemoteOffer(offer)
        pc.createDataChannel("jam")
        val answer = pc.createAnswer()
        log.i { "Generated SDP answer (length=${answer.length})" }
        return answer
    }

    suspend fun hostAdmitGuest(guestOffer: String): String {
        if (_role.value != JamRole.Host) {
            error("hostAdmitGuest can only be called by the host")
        }
        val guestId = "guest-${guestConnections.size + 1}"
        log.i { "Admitting guest $guestId" }

        val handler = object : WebrtcEventHandler {
            override fun onIceCandidate(candidate: String) {}
            override fun onIceGatheringStateChange(state: String) {}
            override fun onConnectionStateChange(state: String) {}
            override fun onDataChannelOpen(label: String) {}
            override fun onDataChannelMessage(label: String, data: String) {
                handleIncomingMessage(label, data, guestId)
            }
            override fun onDataChannelClose(label: String) {}
        }

        val pc = createWebrtcPeerConnection(
            iceServers = listOf(
                IceServerConfig(
                    urls = listOf("stun:stun.l.google.com:19302"),
                    username = "",
                    credential = "",
                )
            ),
            handler = handler,
        )
        guestConnections[guestId] = pc
        guestLabels[guestId] = "jam-$guestId"

        pc.setRemoteOffer(guestOffer)
        pc.createDataChannel("jam-${guestId}")
        val answer = pc.createAnswer()
        return answer
    }

    suspend fun sendMessage(message: JamMessage, guestId: String? = null) {
        val json = json.encodeToString(JamMessage.serializer(), message)
        when (_role.value) {
            JamRole.Host -> {
                if (guestId != null) {
                    guestConnections[guestId]?.sendData("jam-$guestId", json)
                } else {
                    guestConnections.forEach { (id, pc) ->
                        pc.sendData("jam-$id", json)
                    }
                }
            }

            JamRole.Guest -> {
                hostConnection?.sendData("jam", json)
            }

            null -> log.w { "sendMessage called while no session is active" }
        }
    }

    suspend fun leave() {
        log.i { "Leaving jam session" }
        runCatching { sendMessage(JamMessage.Leave()) }
        hostConnection?.shutdown()
        guestConnections.values.forEach { runCatching { it.shutdown() } }
        hostConnection = null
        guestConnections.clear()
        guestLabels.clear()
        _role.value = null
        _participants.value = emptyList()
        _isActive.value = false
        _localParticipantId.value = null
    }

    private fun handleIncomingMessage(label: String, data: String, fromGuestId: String? = null) {
        try {
            val message = json.decodeFromString(JamMessage.serializer(), data)
            _incomingMessages.tryEmit(message)
            when (message) {
                is JamMessage.SuggestTrack, is JamMessage.SuggestPlaylist -> {
                    _incomingSuggestions.tryEmit(message)
                }

                is JamMessage.Leave -> {
                    if (_role.value == JamRole.Host && fromGuestId != null) {
                        val leavingPc = guestConnections.remove(fromGuestId)
                        guestLabels.remove(fromGuestId)
                        scope.launch {
                            runCatching { leavingPc?.shutdown() }
                        }
                        _participants.update { current ->
                            current.filterNot { it.id == fromGuestId }
                        }
                    }
                }

                else -> Unit
            }
        } catch (e: Exception) {
            log.w(e) { "Failed to parse jam message on $label" }
        }
    }

    suspend fun broadcastPlaybackCommand(command: PlaybackCmd) {
        if (_role.value != JamRole.Host) return
        sendMessage(JamMessage.PlaybackCommand(command))
    }

    suspend fun broadcastQueueState(
        items: List<JamMediaItem>,
        currentIndex: Int,
        isPlaying: Boolean,
        positionMs: Long,
    ) {
        if (_role.value != JamRole.Host) return
        sendMessage(JamMessage.QueueState(items, currentIndex, isPlaying, positionMs))
    }

    suspend fun suggestTrack(mediaItem: JamMediaItem) {
        if (_role.value != JamRole.Guest) return
        sendMessage(JamMessage.SuggestTrack(mediaItem))
    }

    suspend fun suggestPlaylist(tracks: List<JamMediaItem>) {
        if (_role.value != JamRole.Guest) return
        sendMessage(JamMessage.SuggestPlaylist(tracks))
    }
}

private fun <T> MutableStateFlow<T>.update(transform: (T) -> T) {
    value = transform(value)
}

private fun randomShortId(): String {
    val chars = "0123456789abcdef"
    return buildString(8) {
        repeat(8) {
            append(chars[kotlin.random.Random.nextInt(chars.length)])
        }
    }
}