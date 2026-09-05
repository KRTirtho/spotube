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
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.StreamProtocol
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerInterface
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.PlayerState
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json

/**
 * Keeps playback in sync across a jam session (star topology).
 *
 * On the **host**: applies incoming playback commands and guest suggestions to the
 * host's player, and broadcasts the current queue + playback state to all guests
 * (on queue changes and periodically, so play/pause/seek/position propagate).
 *
 * On the **guest**: mirrors the host's queue into the local player and applies
 * playback commands. The guest's queue is read-only — the host has authority.
 */
class QueueSyncManager(
    private val audioPlayer: AudioPlayerInterface,
    private val audioPlayerQueue: AudioPlayerQueue,
    private val jamSession: JamSessionService,
) {
    private val log = Logger.withTag("QueueSyncManager")
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    private val _isSyncing = MutableStateFlow(false)
    val isSyncing: StateFlow<Boolean> = _isSyncing.asStateFlow()

    private var hostBroadcastJob: Job? = null
    private var hostCommandJob: Job? = null
    private var guestApplyJob: Job? = null
    private var guestCommandJob: Job? = null

    /** Guest side: the last applied queue snapshot, used to detect real queue changes. */
    private var lastAppliedItems: List<JamMediaItem> = emptyList()

    /** Guest side: tracks the player was told to start playing from. */
    private var lastAppliedCurrentIndex = -1

    fun start() {
        if (_isSyncing.value) return
        _isSyncing.value = true

        when (jamSession.role.value) {
            JamRole.Host -> startHostSync()
            JamRole.Guest -> startGuestSync()
            null -> {
                _isSyncing.value = false
                return
            }
        }
    }

    fun stop() {
        _isSyncing.value = false
        hostBroadcastJob?.cancel()
        hostCommandJob?.cancel()
        guestApplyJob?.cancel()
        guestCommandJob?.cancel()
        hostBroadcastJob = null
        hostCommandJob = null
        guestApplyJob = null
        guestCommandJob = null
        lastAppliedItems = emptyList()
        lastAppliedCurrentIndex = -1
    }

    // ---------- Host side ----------

    private fun startHostSync() {
        // Apply commands/suggestions coming from guests.
        hostCommandJob = scope.launch {
            jamSession.role.first { it != null }
            if (jamSession.role.value != JamRole.Host) return@launch

            jamSession.incomingMessages.collect { message ->
                when (message) {
                    is JamMessage.PlaybackCommand -> applyPlaybackCommand(message.command)
                    is JamMessage.SuggestTrack -> acceptSuggestion(listOf(message.mediaItem))
                    is JamMessage.SuggestPlaylist -> acceptSuggestion(message.tracks)
                    else -> {}
                }
            }
        }

        // Broadcast state on queue changes and periodically.
        hostBroadcastJob = scope.launch {
            jamSession.role.first { it != null }
            if (jamSession.role.value != JamRole.Host) return@launch

            // Queue changes (separate coroutine — collect() never returns).
            launch {
                audioPlayerQueue.queueFlow.collect {
                    broadcastCurrentState()
                }
            }

            // Periodic tick so play/pause/seek/position propagate to guests.
            while (isActive) {
                delay(2_000)
                broadcastCurrentState()
            }
        }
    }

    /** Immediately pushes the current queue + playback state to all guests. */
    suspend fun broadcastNow() {
        if (jamSession.role.value == JamRole.Host) {
            broadcastCurrentState()
        }
    }

    private suspend fun broadcastCurrentState() {
        val queue = audioPlayerQueue.getQueue()
        val current = audioPlayerQueue.getCurrentQueueEntry()
        val currentIndex = if (current != null) {
            queue.indexOfFirst { it.matchesEntry(current) }
        } else {
            -1
        }
        jamSession.broadcastQueueState(
            items = queue.map(JamMediaItem::fromQueueEntry),
            currentIndex = currentIndex.coerceAtLeast(0),
            isPlaying = audioPlayer.playerStateFlow.value == PlayerState.PLAYING,
            positionMs = audioPlayer.positionFlow.value.inWholeMilliseconds,
        )
    }

    private suspend fun acceptSuggestion(items: List<JamMediaItem>) {
        if (items.isEmpty()) return
        val entries = items.map { it.toQueueEntry() }
        log.i { "Accepting ${entries.size} suggested item(s) into the jam queue" }
        audioPlayerQueue.addAllToQueue(entries)
    }

    // ---------- Guest side ----------

    private fun startGuestSync() {
        guestApplyJob = scope.launch {
            jamSession.incomingMessages.collect { message ->
                if (message !is JamMessage.QueueState) return@collect
                applyQueueState(message)
            }
        }

        guestCommandJob = scope.launch {
            jamSession.incomingMessages.collect { message ->
                if (message !is JamMessage.PlaybackCommand) return@collect
                applyPlaybackCommand(message.command)
            }
        }
    }

    private suspend fun applyQueueState(state: JamMessage.QueueState) {
        log.d { "Applying queue state: ${state.items.size} items, current=${state.currentIndex}" }

        // Items that carry neither a track id nor a usable URL can't be played
        // on this device — skip them instead of crashing the player.
        val playableItems = state.items.filter { it.trackId.isNotBlank() || it.url.isNotBlank() }

        val queueChanged = playableItems != lastAppliedItems
        if (queueChanged) {
            lastAppliedItems = playableItems
            lastAppliedCurrentIndex = state.currentIndex
            val entries = playableItems.map { it.toQueueEntry() }
            runCatching {
                // Load through the queue repository (like the host does) so the
                // stream proxy can resolve the tracks — it only knows tracks in
                // queueFlow.
                audioPlayerQueue.load(
                    entries = entries,
                    autoPlay = state.isPlaying,
                    startPosition = state.currentIndex.coerceIn(0, entries.lastIndex.coerceAtLeast(0)),
                )
            }.onFailure { e ->
                log.e(e) { "Failed to apply jam queue to local player" }
            }
            return
        }

        // Same queue: just sync playback state. Avoid seeking on every tick unless
        // the drift is meaningful.
        if (state.currentIndex != lastAppliedCurrentIndex) {
            lastAppliedCurrentIndex = state.currentIndex
            runCatching { audioPlayer.jumpTo(state.currentIndex.coerceAtLeast(0)) }
                .onFailure { e -> log.w(e) { "Failed to jump to index ${state.currentIndex}" } }
        }
        val currentState = audioPlayer.playerStateFlow.value
        if (state.isPlaying && currentState != PlayerState.PLAYING) {
            audioPlayer.play()
        } else if (!state.isPlaying && currentState == PlayerState.PLAYING) {
            audioPlayer.pause()
        }
        val driftMs = kotlin.math.abs(
            audioPlayer.positionFlow.value.inWholeMilliseconds - state.positionMs
        )
        if (driftMs > POSITION_SYNC_THRESHOLD_MS) {
            runCatching { audioPlayer.seekTo(kotlin.time.Duration.parse("${state.positionMs}ms")) }
                .onFailure { e -> log.w(e) { "Failed to sync position" } }
        }
    }

    private suspend fun applyPlaybackCommand(command: PlaybackCmd) {
        log.d { "Applying playback command: $command" }
        runCatching {
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
        }.onFailure { e ->
            log.w(e) { "Failed to apply playback command: $command" }
        }
    }

    /**
     * Build a queue entry from a jam media item. Streaming tracks carry their id
     * so the device's own queue/stream proxy can resolve a playable URL later.
     */
    private fun JamMediaItem.toQueueEntry(): QueueEntry = when {
        trackId.isNotBlank() -> QueueEntry.StreamingTrack(
            track = MetadataTrack(
                id = trackId,
                title = title,
                durationMs = durationMs,
                trackNumber = null,
                discNumber = null,
                artists = listOf(
                    MetadataArtist.Basic(id = "", name = artist, thumbnails = emptyList(), externalUri = null)
                ),
                album = null,
                thumbnails = null,
                explicit = null,
                popularity = null,
                isrcCode = null,
                externalUri = null,
            ),
            url = "",
            protocol = runCatching { StreamProtocol.valueOf(protocol.ifBlank { "PROGRESSIVE" }) }
                .getOrDefault(StreamProtocol.PROGRESSIVE),
        )

        else -> QueueEntry.LocalTrack(
            name = title,
            artists = artist.split(',').map { it.trim() }.filter { it.isNotEmpty() },
            duration = durationMs,
            album = album.ifBlank { null },
            coverBytes = null,
            url = url,
        )
    }

    private fun QueueEntry.matchesEntry(other: QueueEntry): Boolean {
        return when {
            this is QueueEntry.StreamingTrack && other is QueueEntry.StreamingTrack ->
                this.track.id == other.track.id

            this is QueueEntry.LocalTrack && other is QueueEntry.LocalTrack ->
                this.url == other.url && this.name == other.name

            else -> false
        }
    }

    companion object {
        /** Seek the guest only when its position drifts more than this from the host. */
        private const val POSITION_SYNC_THRESHOLD_MS = 3_000L
    }
}