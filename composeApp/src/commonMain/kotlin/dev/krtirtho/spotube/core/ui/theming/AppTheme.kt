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

package dev.krtirtho.spotube.core.ui.theming

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import com.materialkolor.rememberDynamicColorScheme
import dev.krtirtho.spotube.modules.settings.Theme
import dev.krtirtho.spotube.modules.settings.UserSettings

@Composable
fun SpotubeTheme(
    settings: UserSettings,
    content: @Composable () -> Unit,
) {
    val isDarkTheme = when (settings.theme) {
        Theme.LIGHT -> false
        Theme.DARK -> true
        Theme.SYSTEM -> isSystemInDarkTheme()
    }

    val accent = if (isDarkTheme) {
        settings.accentColor.toDarkColor()
    } else {
        settings.accentColor.toLightColor()
    }

    val colorScheme = rememberDynamicColorScheme(
        seedColor = accent,
        isDark = isDarkTheme,
    )

    MaterialTheme(
        colorScheme = colorScheme,
    ) {
        Surface(content = content)
    }
}

