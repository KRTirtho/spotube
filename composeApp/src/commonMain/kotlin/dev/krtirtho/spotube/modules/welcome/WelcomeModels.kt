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

import androidx.compose.ui.graphics.vector.ImageVector
import org.jetbrains.compose.resources.StringResource

/** A single donation destination shown on the support page. */
data class DonationOption(
    val id: String,
    val title: StringResource,
    val subtitle: StringResource,
    val url: String,
    val icon: ImageVector)

data class WelcomeUiState(
    val currentPageIndex: Int,
    val pageCount: Int,
    val isLastPage: Boolean,
    val primaryLabel: StringResource,
    val donations: List<DonationOption>)
