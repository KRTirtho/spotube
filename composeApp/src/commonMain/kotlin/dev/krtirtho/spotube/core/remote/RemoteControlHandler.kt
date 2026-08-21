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

package dev.krtirtho.spotube.core.remote

import dev.krtirtho.spotube.core.audioplayer.AudioPlayerInterface
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.LoopState
import dev.krtirtho.spotube.core.audioplayer.PlayerState as AudioPlayerState
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.modules.settings.SettingsRepository
import io.ktor.server.websocket.WebSocketServerSession
import io.ktor.websocket.CloseReason
import io.ktor.websocket.Frame
import io.ktor.websocket.close
import io.ktor.websocket.readText
import kotlin.coroutines.resume
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import org.koin.core.component.KoinComponent

class RemoteControlHandler(
    private val settingsRepository: SettingsRepository,
    private val audioPlayer: AudioPlayerInterface,
    private val audioPlayerQueue: AudioPlayerQueue,
) : KoinComponent {
    val logger by injectLogger<RemoteControlHandler>()

    val incomingConnectionRequests = MutableSharedFlow<ConnectionRequest>(
        extraBufferCapacity = 16,
    )

    private val json = Json {
        ignoreUnknownKeys = true
        classDiscriminator = "type"
        encodeDefaults = true
    }

    private val pendingRequestResolutions = mutableMapOf<String, (ConnectionRequestResponse) -> Unit>()

    suspend fun handleConnection(session: WebSocketServerSession) {
        val settings = settingsRepository.userSettings.first()
        if (!settings.allowRemoteControl) {
            logger.w { "Rejecting remote control connection: remote control is disabled" }
            session.close(CloseReason(CloseReason.Codes.VIOLATED_POLICY, "Remote control is disabled"))
            return
        }

        val deviceId = session.call.request.headers["X-Device-Id"]
        val deviceName = session.call.request.headers["X-Device-Name"] ?: "Unknown"

        val isAllowed = deviceId != null && deviceId in settings.allowedRemoteDevices

        if (!isAllowed) {
            val request = ConnectionRequest(
                deviceId = deviceId ?: "unknown",
                deviceName = deviceName,
                sessionId = session.call.request.headers["X-Request-Id"]
                    ?: "req-${kotlin.time.Clock.System.now().toEpochMilliseconds()}",
            )
            incomingConnectionRequests.emit(request)
            val response = waitForRequestResolution(request.sessionId)
            if (response != ConnectionRequestResponse.Allow && response != ConnectionRequestResponse.AllowAlways) {
                session.close(CloseReason(CloseReason.Codes.VIOLATED_POLICY, "Connection denied"))
                return
            }
            if (response == ConnectionRequestResponse.AllowAlways && deviceId != null) {
                settingsRepository.updateSettings(
                    settings.copy(
                        allowedRemoteDevices = (settings.allowedRemoteDevices + deviceId).distinct()
                    )
                )
                logger.i { "Device $deviceId added to always-allowed devices" }
            }
        }

        logger.i { "Remote control connection established from $deviceName ($deviceId)" }

        try {
            handleControlLoop(session)
        } catch (e: Exception) {
            logger.w(e) { "Error in remote control session" }
        } finally {
            session.close()
        }
    }

    fun resolveConnectionRequest(sessionId: String, response: ConnectionRequestResponse) {
        pendingRequestResolutions.remove(sessionId)?.invoke(response)
    }

    private suspend fun waitForRequestResolution(sessionId: String): ConnectionRequestResponse {
        return suspendCancellableCoroutine { continuation ->
            pendingRequestResolutions[sessionId] = { response ->
                if (continuation.isActive) {
                    continuation.resume(response)
                }
            }
            continuation.invokeOnCancellation {
                pendingRequestResolutions.remove(sessionId)
            }
        }
    }

    private suspend fun handleControlLoop(session: WebSocketServerSession) {
        for (frame in session.incoming) {
            if (frame is Frame.Text) {
                val text = frame.readText()
                try {
                    val envelope = json.decodeFromString(CommandEnvelope.serializer(), text)
                    handleCommand(session, envelope)
                } catch (e: Exception) {
                    logger.w(e) { "Failed to parse remote control command" }
                    sendError(session, "Invalid command: ${e.message}")
                }
            }
        }
    }

    private suspend fun handleCommand(session: WebSocketServerSession, envelope: CommandEnvelope) {
        when (val command = envelope.command) {
            is RemoteControlCommand.Play -> {
                logger.d { "Remote play request: ${command.source} (playback source not yet implemented)" }
            }
            is RemoteControlCommand.Pause -> {
                audioPlayer.pause()
            }
            is RemoteControlCommand.TogglePlayPause -> {
                if (audioPlayer.playerStateFlow.value == AudioPlayerState.PLAYING) {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play()
                }
            }
            is RemoteControlCommand.Seek -> {
                audioPlayer.seekTo(kotlin.time.Duration.parse("${command.positionMs}ms"))
            }
            is RemoteControlCommand.SetVolume -> {
                audioPlayer.setVolume(command.volume)
            }
            is RemoteControlCommand.SkipNext -> {
                audioPlayer.skipToNext()
            }
            is RemoteControlCommand.SkipPrevious -> {
                audioPlayer.skipToPrevious()
            }
            is RemoteControlCommand.SetShuffle -> {
                audioPlayer.shuffle(command.enabled)
            }
            is RemoteControlCommand.SetLoopMode -> {
                val loopState = when (command.mode) {
                    "none" -> LoopState.NONE
                    "one" -> LoopState.ONE
                    "all" -> LoopState.ALL
                    else -> {
                        sendError(session, "Invalid loop mode: ${command.mode}")
                        return
                    }
                }
                audioPlayer.loop(loopState)
            }
            is RemoteControlCommand.AddToQueue -> {
                logger.d { "Remote add to queue: ${command.source} (source parsing not yet implemented)" }
            }
            is RemoteControlCommand.RemoveFromQueue -> {
                audioPlayerQueue.removeFromQueueByMediaUrl(command.mediaUrl)
            }
        }
        sendAck(session, envelope.commandId)
        broadcastState(session)
    }

    private suspend fun sendAck(session: WebSocketServerSession, commandId: String) {
        val text = json.encodeToString(RemoteControlEvent.Ack.serializer(), RemoteControlEvent.Ack(commandId))
        session.send(Frame.Text(text))
    }

    private suspend fun sendError(session: WebSocketServerSession, message: String) {
        val text = json.encodeToString(RemoteControlEvent.Error.serializer(), RemoteControlEvent.Error(message))
        session.send(Frame.Text(text))
    }

    private suspend fun broadcastState(session: WebSocketServerSession) {
        val current = audioPlayerQueue.currentQueueEntryFlow.value
        val state = RemoteControlEvent.PlayerState(
            isPlaying = audioPlayer.playerStateFlow.value == AudioPlayerState.PLAYING,
            positionMs = audioPlayer.positionFlow.value.inWholeMilliseconds,
            durationMs = audioPlayer.durationFlow.value.inWholeMilliseconds,
            volume = audioPlayer.volumeFlow.value,
            shuffleEnabled = audioPlayer.shuffleModeFlow.value,
            loopMode = audioPlayer.loopStateFlow.value.name.lowercase(),
            currentTrackId = current?.mediaKey(),
            currentTrackTitle = current?.titleOrNull(),
            currentTrackArtists = current?.artistsOrNull(),
            currentTrackAlbum = current?.albumOrNull(),
            currentTrackCoverUrl = current?.coverUrlOrNull(),
        )
        val text = json.encodeToString(RemoteControlEvent.PlayerState.serializer(), state)
        session.send(Frame.Text(text))
    }

    private fun QueueEntry.mediaKey(): String = when (this) {
        is QueueEntry.StreamingTrack -> track.id
        is QueueEntry.LocalTrack -> url
    }

    private fun QueueEntry.titleOrNull(): String = when (this) {
        is QueueEntry.StreamingTrack -> track.title
        is QueueEntry.LocalTrack -> name
    }

    private fun QueueEntry.artistsOrNull(): String = when (this) {
        is QueueEntry.StreamingTrack -> track.artists.joinToString(", ") { artist -> artist.name }
        is QueueEntry.LocalTrack -> artists.joinToString(", ")
    }

    private fun QueueEntry.albumOrNull(): String? = when (this) {
        is QueueEntry.StreamingTrack -> track.album?.title
        is QueueEntry.LocalTrack -> album
    }

    private fun QueueEntry.coverUrlOrNull(): String? = when (this) {
        is QueueEntry.StreamingTrack -> track.thumbnails?.firstOrNull()?.url
        is QueueEntry.LocalTrack -> null
    }
}

@Serializable
data class CommandEnvelope(
    val commandId: String,
    val command: RemoteControlCommand,
)

data class ConnectionRequest(
    val deviceId: String,
    val deviceName: String,
    val sessionId: String,
)

enum class ConnectionRequestResponse {
    Allow,
    AllowAlways,
    Deny,
}