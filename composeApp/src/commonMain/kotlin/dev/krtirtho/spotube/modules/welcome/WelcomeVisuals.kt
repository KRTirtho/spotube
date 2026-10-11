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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

package dev.krtirtho.spotube.modules.welcome

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.TextUnit
import com.composeunstyled.Text
import dev.krtirtho.spotube.core.ui.theming.AppTheme
import org.jetbrains.compose.resources.Font
import org.jetbrains.compose.resources.stringResource
import org.spotube.millennium.theme.MillenniumTheme
import spotube.composeapp.generated.resources.*

/** Installs the Millennium theme for the onboarding pages. */
@Composable
fun WelcomeTheme(content: @Composable () -> Unit) {
    val dark = AppTheme.colors.surface.luminance() < 0.5f
    MillenniumTheme(dark = dark) {
        content()
    }
}

@Composable
fun WelcomeBackground(modifier: Modifier = Modifier) {
    val scheme = AppTheme.colors
    Box(
        modifier.fillMaxSize().background(
            Brush.verticalGradient(listOf(scheme.surfaceContainer, scheme.surface)))
    )
}

@Composable
fun WelcomeWordmark(
    modifier: Modifier = Modifier,
    fontSize: TextUnit = AppTheme.typography.displaySmall.fontSize
) {
    Text(
        stringResource(Res.string.welcome_app_name),
        modifier = modifier,
        fontFamily = FontFamily(Font(Res.font.cookie_regular)),
        fontSize = fontSize,
        color = AppTheme.colors.onSurface)
}
