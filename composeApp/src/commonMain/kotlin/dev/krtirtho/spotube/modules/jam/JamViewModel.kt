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
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerInterface
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.LoopState
import dev.krtirtho.spotube.core.audioplayer.MediaItem
import dev.krtirtho.spotube.core.audioplayer.PlayerState
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.deeplink.JamDeepLinkService
import dev.krtirtho.spotube.core.jam.JamInviteCodec
import dev.krtirtho.spotube.core.jam.JamInviteLink
import dev.krtirtho.spotube.core.jam.JamLoopMapping
import dev.krtirtho.spotube.core.jam.JamMediaItem
import dev.krtirtho.spotube.core.jam.JamMessage
import dev.krtirtho.spotube.core.jam.JamParticipant
import dev.krtirtho.spotube.core.jam.JamRole
import dev.krtirtho.spotube.core.jam.JamSessionService
import dev.krtirtho.spotube.core.jam.PlaybackCmd
import dev.krtirtho.spotube.core.share.ShareService
import dev.krtirtho.spotube.getPlatform
import dev.krtirtho.spotube.modules.settings.SettingsProvider
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
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

data class JamQueueUiItem(
    val id: String,
    val title: String,
    val artist: String,
    val album: String,
    val durationMs: Long,
    val coverUrl: String,
    val isCurrent: Boolean,
)

data class JamPlayerUiState(
    val queue: List<JamQueueUiItem> = emptyList(),
    val currentIndex: Int = -1,
    val currentTitle: String? = null,
    val currentArtist: String? = null,
    val currentCoverUrl: String? = null,
    val isPlaying: Boolean = false,
    val positionMs: Long = 0,
    val durationMs: Long = 0,
    val shuffleEnabled: Boolean = false,
    val loopMode: String = "none",
)

class JamViewModel(
    private val jamSession: JamSessionService,
    private val deepLinks: JamDeepLinkService,
    private val shareService: ShareService,
    private val settingsProvider: SettingsProvider,
    private val audioPlayer: AudioPlayerInterface,
    private val audioPlayerQueue: AudioPlayerQueue,
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

    /**
     * The jam player state: the shared queue + current playback, built from the
     * local player (the host's queue IS the jam queue; on guests the synced
     * mirror lives in the local player).
     */
    val jamPlayerState: StateFlow<JamPlayerUiState> = combine(
        audioPlayerQueue.queueFlow,
        audioPlayerQueue.currentQueueEntryFlow,
        audioPlayer.playlistFlow,
        audioPlayer.currentMediaItemFlow,
        audioPlayer.playerStateFlow,
        audioPlayer.positionFlow,
        audioPlayer.durationFlow,
        audioPlayer.loopStateFlow,
        audioPlayer.shuffleModeFlow,
    ) { values ->
        val queue: List<QueueEntry> = values[0] as List<QueueEntry>
        val currentEntry: QueueEntry? = values[1] as QueueEntry?
        val playlist: List<MediaItem> = values[2] as List<MediaItem>
        val currentItem: MediaItem? = values[3] as MediaItem?
        val playerState: PlayerState = values[4] as PlayerState
        val position: kotlin.time.Duration = values[5] as kotlin.time.Duration
        val duration: kotlin.time.Duration = values[6] as kotlin.time.Duration
        val loop: LoopState = values[7] as LoopState
        val shuffle: Boolean = values[8] as Boolean

        val isHost = jamSession.role.value == JamRole.Host

        val items: List<JamQueueUiItem>
        val currentIndex: Int
        val currentTitle: String?
        val currentArtist: String?
        val currentCoverUrl: String?

        if (isHost) {
            val queueItems = queue.map { JamMediaItem.fromQueueEntry(it) }
            val index = if (currentEntry != null) {
                queue.indexOfFirst { entry -> entry.matchesQueueEntry(currentEntry) }
            } else {
                -1
            }
            items = queueItems.mapIndexed { i, item ->
                item.toUiItem(i == index)
            }
            currentIndex = index
            currentTitle = queueItems.getOrNull(index)?.title
            currentArtist = queueItems.getOrNull(index)?.artist
            currentCoverUrl = queueItems.getOrNull(index)?.coverUrl
        } else {
            val index = playlist.indexOf(currentItem)
            items = playlist.mapIndexed { i, item ->
                JamMediaItem.fromMediaItem(item).toUiItem(i == index)
            }
            currentIndex = index
            currentTitle = currentItem?.title
            currentArtist = currentItem?.artist
            currentCoverUrl = currentItem?.coverURL
        }

        JamPlayerUiState(
            queue = items,
            currentIndex = currentIndex,
            currentTitle = currentTitle,
            currentArtist = currentArtist,
            currentCoverUrl = currentCoverUrl,
            isPlaying = playerState == PlayerState.PLAYING,
            positionMs = position.inWholeMilliseconds,
            durationMs = duration.inWholeMilliseconds,
            shuffleEnabled = shuffle,
            loopMode = loop.name.lowercase(),
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), JamPlayerUiState())

    // ---------- Playback controls ----------

    fun togglePlayPause() = sendOrApply(PlaybackCmd.Toggle)

    fun skipNext() = sendOrApply(PlaybackCmd.SkipNext)

    fun skipPrevious() = sendOrApply(PlaybackCmd.SkipPrevious)

    fun seek(positionMs: Long) = sendOrApply(PlaybackCmd.Seek(positionMs))

    fun jumpTo(index: Int) = sendOrApply(PlaybackCmd.JumpTo(index))

    fun toggleShuffle() = sendOrApply(PlaybackCmd.SetShuffle(!jamPlayerState.value.shuffleEnabled))

    fun cycleLoopMode() {
        val next = when (jamPlayerState.value.loopMode) {
            "none" -> "one"
            "one" -> "all"
            else -> "none"
        }
        sendOrApply(PlaybackCmd.SetLoop(next))
    }

    private fun sendOrApply(command: PlaybackCmd) {
        viewModelScope.launch {
            if (jamSession.role.value == JamRole.Host) {
                applyCommandLocally(command)
            } else {
                jamSession.sendMessage(JamMessage.PlaybackCommand(command))
            }
        }
    }

    private suspend fun applyCommandLocally(command: PlaybackCmd) {
        when (command) {
            PlaybackCmd.Play -> audioPlayer.play()
            PlaybackCmd.Pause -> audioPlayer.pause()
            PlaybackCmd.Toggle -> {
                if (audioPlayer.playerStateFlow.value == PlayerState.PLAYING) {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play()
                }
            }

            is PlaybackCmd.Seek -> audioPlayer.seekTo(kotlin.time.Duration.parse("${command.positionMs}ms"))
            PlaybackCmd.SkipNext -> audioPlayer.skipToNext()
            PlaybackCmd.SkipPrevious -> audioPlayer.skipToPrevious()
            is PlaybackCmd.SetVolume -> audioPlayer.setVolume(command.volume)
            is PlaybackCmd.SetLoop -> audioPlayer.loop(JamLoopMapping.fromString(command.loop))
            is PlaybackCmd.SetShuffle -> audioPlayer.shuffle(command.enabled)
            is PlaybackCmd.JumpTo -> audioPlayer.jumpTo(command.index)
        }
    }

    // ---------- Host moderation ----------

    fun kickParticipant(participantId: String) {
        viewModelScope.launch { jamSession.kickParticipant(participantId) }
    }

    fun banParticipant(participantId: String) {
        viewModelScope.launch { jamSession.banParticipant(participantId) }
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

private fun JamMediaItem.toUiItem(isCurrent: Boolean): JamQueueUiItem = JamQueueUiItem(
    id = if (trackId.isNotBlank()) trackId else url,
    title = title,
    artist = artist,
    album = album,
    durationMs = durationMs,
    coverUrl = coverUrl,
    isCurrent = isCurrent,
)

private fun QueueEntry.matchesQueueEntry(other: QueueEntry): Boolean {
    return when {
        this is QueueEntry.StreamingTrack && other is QueueEntry.StreamingTrack ->
            this.track.id == other.track.id

        this is QueueEntry.LocalTrack && other is QueueEntry.LocalTrack ->
            this.url == other.url && this.name == other.name

        else -> false
    }
}