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

package dev.krtirtho.spotube.modules.shell.player_queue

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

data class QueueContentUiState(
    val filterQuery: String = "",
    val queue: List<QueueEntry> = emptyList(),
    val currentQueueEntry: QueueEntry? = null,
)

class PlayerQueueContentViewModel(
    private val audioPlayerQueue: AudioPlayerQueue,
) : ViewModel() {
    private val queueVisibilityFlow = MutableStateFlow(false)
    private val queueFilterFlow = MutableStateFlow("")

    val isQueueVisible: StateFlow<Boolean> = queueVisibilityFlow.asStateFlow()

    val queueContentUiState: StateFlow<QueueContentUiState> = combine(
        audioPlayerQueue.queueFlow,
        audioPlayerQueue.currentQueueEntryFlow,
        queueFilterFlow,
    ) { queue, currentQueueEntry, filterQuery ->
        QueueContentUiState(
            filterQuery = filterQuery,
            queue = queue,
            currentQueueEntry = currentQueueEntry,
        )
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5_000),
        initialValue = QueueContentUiState(),
    )

    fun toggleQueueVisibility() {
        queueVisibilityFlow.update { !it }
    }

    fun setQueueVisibility(isVisible: Boolean) {
        queueVisibilityFlow.value = isVisible
    }

    fun setQueueFilter(query: String) {
        queueFilterFlow.value = query
    }

    fun moveQueueItem(fromIndex: Int, toIndex: Int) {
        if (fromIndex == toIndex || fromIndex < 0 || toIndex < 0) return
        viewModelScope.launch {
            audioPlayerQueue.move(fromIndex, toIndex)
        }
    }

    fun playQueueItem(index: Int) {
        if (index < 0) return
        viewModelScope.launch {
            audioPlayerQueue.jumpTo(index)
        }
    }

    fun removeQueueItem(index: Int) {
        if (index < 0) return
        viewModelScope.launch {
            val currentQueue = audioPlayerQueue.queueFlow.value
            if (index < currentQueue.size) {
                audioPlayerQueue.removeFromQueue(currentQueue[index])
            }
        }
    }

    fun clearQueue() {
        viewModelScope.launch {
            audioPlayerQueue.clear()
        }
    }
}