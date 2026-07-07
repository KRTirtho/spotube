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

package dev.krtirtho.spotube.modules.downloads

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn

class DownloadsViewModel(
    private val downloadManager: DownloadManager,
) : ViewModel() {
    val downloads: StateFlow<List<DownloadItem>> = downloadManager.downloadsFlow.stateIn(
        viewModelScope,
        SharingStarted.WhileSubscribed(5000),
        emptyList(),
    )

    fun downloadTrack(track: MetadataTrack) {
        downloadManager.enqueue(track)
    }

    fun downloadTracks(tracks: List<MetadataTrack>) {
        tracks.forEach { track ->
            downloadManager.enqueue(track)
        }
    }

    fun cancel(id: String) {
        downloadManager.cancel(id)
    }

    fun retry(id: String) {
        downloadManager.retry(id)
    }

    fun remove(id: String) {
        downloadManager.remove(id)
    }

    fun clearCompleted() {
        downloadManager.clearCompleted()
    }
}
