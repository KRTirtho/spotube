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

package dev.krtirtho.spotube.modules.welcome

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class WelcomeViewModel(
    private val repository: WelcomeRepository) : ViewModel() {
    private val currentPageIndex = MutableStateFlow(0)
    private val demoPlaying = MutableStateFlow(true)

    val uiState: StateFlow<WelcomeUiState> =
        combine(currentPageIndex, demoPlaying) { index, playing ->
            val pageCount = welcomePrimaryLabels.size
            WelcomeUiState(
                currentPageIndex = index,
                pageCount = pageCount,
                isLastPage = index == pageCount - 1,
                primaryLabel = welcomePrimaryLabels[index.coerceIn(0, pageCount - 1)],
                donations = welcomeDonations,
                demoPlaying = playing)
        }
            .stateIn(
                scope = viewModelScope,
                started = SharingStarted.Eagerly,
                initialValue = WelcomeUiState(
                    currentPageIndex = 0,
                    pageCount = welcomePrimaryLabels.size,
                    isLastPage = welcomePrimaryLabels.size == 1,
                    primaryLabel = welcomePrimaryLabels.first(),
                    donations = welcomeDonations))

    fun nextPage() {
        currentPageIndex.update { (it + 1).coerceAtMost(welcomePrimaryLabels.lastIndex) }
    }

    fun toggleDemo() {
        demoPlaying.update { !it }
    }

    fun onPrimary() {
        if (currentPageIndex.value == welcomePrimaryLabels.lastIndex) completeOnboarding() else nextPage()
    }

    fun openDonation(url: String) {
        // Only destinations owned by our static funding list can be opened here.
        if (welcomeDonations.none { it.url == url }) return
        runCatching { dev.krtirtho.spotube.openUrlInBrowser(url) }
    }

    fun previousPage() {
        currentPageIndex.update { (it - 1).coerceAtLeast(0) }
    }

    fun completeOnboarding() {
        viewModelScope.launch {
            repository.completeOnboarding()
        }
    }
}
