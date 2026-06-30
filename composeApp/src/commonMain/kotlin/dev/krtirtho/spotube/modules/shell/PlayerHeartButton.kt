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

package dev.krtirtho.spotube.modules.shell

import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.modules.saved_tracks.SavedState
import dev.krtirtho.spotube.modules.saved_tracks.SavedTracksViewModel
import dev.krtirtho.spotube.modules.saved_tracks.rememberIsSavedTracks
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart2
import kotlinx.coroutines.launch

@Composable
fun PlayerHeartButton(
    audioPlayerQueue: AudioPlayerQueue,
    savedTracksViewModel: SavedTracksViewModel,
) {
    val scope = rememberCoroutineScope()
    val currentQueueEntry by audioPlayerQueue.currentQueueEntryFlow.collectAsStateWithLifecycle()
    val currentTrackId = (currentQueueEntry as? QueueEntry.StreamingTrack)?.track?.id
    val isSavedTrackState =
        rememberIsSavedTracks(trackIds = currentTrackId?.let { listOf(it) } ?: emptyList())
    val savedTrackIds by savedTracksViewModel.savedTrackIdsFlow.collectAsStateWithLifecycle()

    val isInSavedIds = if (currentTrackId != null) currentTrackId in savedTrackIds else false
    val isLiked = if (isSavedTrackState is SavedState.Success) {
        isSavedTrackState.data.firstOrNull() == true || isInSavedIds
    } else {
        isInSavedIds
    }

    fun onLike() {
        val entry = currentQueueEntry as? QueueEntry.StreamingTrack ?: return
        if (isLiked) {
            scope.launch {
                savedTracksViewModel.removeSavedTracks(listOf(entry.track.id))
            }
        } else {
            scope.launch {
                savedTracksViewModel.saveTracks(listOf(entry.track.id))
            }
        }
    }
    IconButton(
        onClick = ::onLike,
        enabled = isSavedTrackState is SavedState.Success
    ) {
        Icon(
            imageVector = if (isLiked) Iconsax.IconsaxHeart2 else Iconsax.IconsaxHeart,
            contentDescription = if (isLiked) "Unlike" else "Like",
            tint = if (isLiked) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}