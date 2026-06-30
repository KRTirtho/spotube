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

package dev.krtirtho.spotube.core.audioplayer

import dev.krtirtho.plugin_interfaces.plugin_apis.audio.StreamProtocol
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.StateFlow
import kotlin.time.Duration

data class MediaItem(
    val title: String,
    val artist: String,
    val album: String,
    val duration: Duration,
    val coverURL: String,
    val url: String,
    val protocol: StreamProtocol = StreamProtocol.PROGRESSIVE,
) {
    fun toDebugString(): String {
        return "MediaItem(title='$title', artist='$artist', album='$album', duration=$duration, coverURL='$coverURL', url='$url', protocol=$protocol)"
    }
}

enum class LoopState {
    NONE, ONE, ALL;

    fun next(): LoopState {
        return when (this) {
            NONE -> ONE
            ONE -> ALL
            ALL -> NONE
        }
    }
}

enum class PlayerState {
    IDLE, BUFFERING, READY, PLAYING, PAUSED, COMPLETED
}

@Suppress("EXPECT_ACTUAL_CLASSIFIERS_ARE_IN_BETA_WARNING")
expect class AudioPlayer(context: Any) {
    val context: Any // Optional context for platform-specific implementations (e.g., Android Context)

    // Playback
    suspend fun play()
    suspend fun pause()
    suspend fun stop()
    suspend fun seekTo(position: Duration)
    suspend fun loop(state: LoopState)
    suspend fun shuffle(enabled: Boolean)

    // Playlist management
    suspend fun load(playlist: List<MediaItem>, autoPlay: Boolean = true, startPosition: Int = 0)
    suspend fun addMediaItem(mediaItem: MediaItem)
    suspend fun insertMediaItemAtNextIndex(mediaItem: MediaItem)
    suspend fun removeMediaItem(mediaItem: MediaItem)
    suspend fun moveMediaItem(fromIndex: Int, toIndex: Int)
    suspend fun skipToNext()
    suspend fun skipToPrevious()
    suspend fun jumpTo(index: Int)

    // State as flows StateFlow

    val playerStateFlow : StateFlow<PlayerState>
    val currentMediaItemFlow : StateFlow<MediaItem?>
    val playlistFlow : StateFlow<List<MediaItem>>
    val durationFlow : StateFlow<Duration>
    val positionFlow : StateFlow<Duration>
    val bufferingPositionFlow : StateFlow<Duration>
    val loopStateFlow : StateFlow<LoopState>
    val shuffleModeFlow : StateFlow<Boolean>
    val playbackSpeedFlow : StateFlow<Float>
    val volumeFlow : StateFlow<Float>
    val completionFlow : Flow<Unit>
    val errorFlow : Flow<Throwable>

    suspend fun setVolume(volume: Float)
    suspend fun setPlaybackSpeed(speed: Float)

    fun isDisposed(): Boolean
    fun dispose() // Clean up resources when done. The player should not be used after this is called.
}
