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

package dev.krtirtho.spotube.modules.library

import androidx.compose.ui.graphics.vector.ImageVector
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxCd
import dev.krtirtho.spotube.resources.iconsax.IconsaxDirectboxReceive
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusicDashboard
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusicLibrary
import dev.krtirtho.spotube.resources.iconsax.User

enum class LibraryTab(val title: String, val icon: ImageVector) {
    Playlists("Playlists", Iconsax.IconsaxMusicDashboard),
    Albums("Albums", Iconsax.IconsaxCd),
    Artists("Artists", Iconsax.User),
    LocalTracks("Local Tracks", Iconsax.IconsaxMusicLibrary),
    Downloads("Downloads", Iconsax.IconsaxDirectboxReceive),
}
