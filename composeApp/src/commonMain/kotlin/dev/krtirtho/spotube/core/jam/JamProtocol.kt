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

import dev.krtirtho.spotube.core.audioplayer.LoopState
import dev.krtirtho.spotube.core.audioplayer.MediaItem
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed class JamMessage {
    @Serializable
    @SerialName("hello")
    data class Hello(
        val displayName: String,
        val deviceId: String,
    ) : JamMessage()

    @Serializable
    @SerialName("welcome")
    data class Welcome(
        val hostName: String,
        val participantId: String,
    ) : JamMessage()

    @Serializable
    @SerialName("queueState")
    data class QueueState(
        val items: List<JamMediaItem>,
        val currentIndex: Int,
        val isPlaying: Boolean,
        val positionMs: Long,
    ) : JamMessage()

    @Serializable
    @SerialName("playbackCommand")
    data class PlaybackCommand(
        val command: PlaybackCmd,
    ) : JamMessage()

    @Serializable
    @SerialName("suggestTrack")
    data class SuggestTrack(val mediaItem: JamMediaItem) : JamMessage()

    @Serializable
    @SerialName("suggestPlaylist")
    data class SuggestPlaylist(val tracks: List<JamMediaItem>) : JamMessage()

    @Serializable
    @SerialName("chat")
    data class Chat(
        val fromName: String,
        val text: String,
    ) : JamMessage()

    @Serializable
    @SerialName("participantList")
    data class ParticipantList(val participants: List<JamParticipant>) : JamMessage()

    @Serializable
    @SerialName("leave")
    data class Leave(val reason: String = "user_left") : JamMessage()
}

@Serializable
sealed class PlaybackCmd {
    @Serializable
    @SerialName("play")
    data object Play : PlaybackCmd()

    @Serializable
    @SerialName("pause")
    data object Pause : PlaybackCmd()

    @Serializable
    @SerialName("toggle")
    data object Toggle : PlaybackCmd()

    @Serializable
    @SerialName("seek")
    data class Seek(val positionMs: Long) : PlaybackCmd()

    @Serializable
    @SerialName("skipNext")
    data object SkipNext : PlaybackCmd()

    @Serializable
    @SerialName("skipPrevious")
    data object SkipPrevious : PlaybackCmd()

    @Serializable
    @SerialName("setVolume")
    data class SetVolume(val volume: Float) : PlaybackCmd()

    @Serializable
    @SerialName("setLoop")
    data class SetLoop(val loop: String) : PlaybackCmd()

    @Serializable
    @SerialName("setShuffle")
    data class SetShuffle(val enabled: Boolean) : PlaybackCmd()

    @Serializable
    @SerialName("jumpTo")
    data class JumpTo(val index: Int) : PlaybackCmd()
}

@Serializable
data class JamMediaItem(
    val url: String,
    val title: String,
    val artist: String,
    val album: String,
    val durationMs: Long,
    val coverUrl: String,
    val protocol: String,
) {
    companion object {
        fun fromMediaItem(item: MediaItem): JamMediaItem = JamMediaItem(
            url = item.url,
            title = item.title,
            artist = item.artist,
            album = item.album,
            durationMs = item.duration.inWholeMilliseconds,
            coverUrl = item.coverURL,
            protocol = item.protocol.name,
        )

        fun toMediaItem(item: JamMediaItem): MediaItem = MediaItem(
            title = item.title,
            artist = item.artist,
            album = item.album,
            duration = kotlin.time.Duration.parse("${item.durationMs}ms"),
            coverURL = item.coverUrl,
            url = item.url,
            protocol = dev.krtirtho.plugin_interfaces.plugin_apis.audio.StreamProtocol
                .valueOf(item.protocol),
        )
    }
}

@Serializable
data class JamParticipant(
    val id: String,
    val displayName: String,
    val isHost: Boolean,
)

@Serializable
enum class JamRole {
    Host,
    Guest,
}

object JamLoopMapping {
    fun toString(state: LoopState): String = state.name.lowercase()
    fun fromString(value: String): LoopState = when (value.lowercase()) {
        "none" -> LoopState.NONE
        "one" -> LoopState.ONE
        "all" -> LoopState.ALL
        else -> LoopState.NONE
    }
}