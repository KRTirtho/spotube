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
import dev.krtirtho.spotube.core.audioplayer.PlayerState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import kotlinx.coroutines.flow.first

/**
 * Manages queue synchronization between the host and the jam session.
 *
 * On the host: observes local playback state and broadcasts queue updates to guests.
 * On the guest: receives queue updates and applies them to local playback.
 *
 * Conflict resolution: the host has authority. When a guest receives a queue state,
 * it replaces the local queue. (and (The guest's local queue is essentially read-only
 * during a jam session.)
 */
class QueueSyncManager(
    private val audioPlayer: AudioPlayerInterface,
    private val jamSession: JamSessionService,
    private val scope: CoroutineScope,
) {
    private val log = Logger.withTag("QueueSyncManager")
    private val json = Json {
        ignoreUnknownKeys = true
        classDiscriminator = "type"
        encodeDefaults = true
    }

    private val _isSyncing = MutableStateFlow(false)
    val isSyncing: StateFlow<Boolean> = _isSyncing.asStateFlow()

    private var hostBroadcastJob: Job? = null
    private var guestApplyJob: Job? = null
    private var guestCommandJob: Job? = null

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
        guestApplyJob?.cancel()
        guestCommandJob?.cancel()
        hostBroadcastJob = null
        guestApplyJob = null
        guestCommandJob = null
    }

    private fun startHostSync() {
        hostBroadcastJob = scope.launch {
            jamSession.role.first { it != null }
            if (jamSession.role.value != JamRole.Host) return@launch

            jamSession.broadcastQueueState(
                items = audioPlayer.playlistFlow.value.map(JamMediaItem::fromMediaItem),
                currentIndex = audioPlayer.playlistFlow.value.indexOf(
                    audioPlayer.currentMediaItemFlow.value
                ).coerceAtLeast(0),
                isPlaying = audioPlayer.playerStateFlow.value == PlayerState.PLAYING,
                positionMs = audioPlayer.positionFlow.value.inWholeMilliseconds,
            )

            audioPlayer.playlistFlow.collect { playlist ->
                audioPlayer.playerStateFlow.value.let { state ->
                    audioPlayer.positionFlow.value.let { position ->
                        jamSession.broadcastQueueState(
                            items = playlist.map(JamMediaItem::fromMediaItem),
                            currentIndex = playlist.indexOf(audioPlayer.currentMediaItemFlow.value)
                                .coerceAtLeast(0),
                            isPlaying = state == PlayerState.PLAYING,
                            positionMs = position.inWholeMilliseconds,
                        )
                    }
                }
            }
        }
    }

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
        val mediaItems = state.items.map(JamMediaItem::toMediaItem)
        audioPlayer.load(
            playlist = mediaItems,
            autoPlay = state.isPlaying,
            startPosition = state.currentIndex.coerceAtLeast(0),
        )
    }

    private suspend fun applyPlaybackCommand(command: PlaybackCmd) {
        log.d { "Applying playback command: $command" }
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
}