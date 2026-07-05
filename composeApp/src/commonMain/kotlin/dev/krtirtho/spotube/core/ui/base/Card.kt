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

package dev.krtirtho.spotube.core.ui.base

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.unit.dp

@Composable
fun Card(
    modifier: Modifier = Modifier,
    theme: BaseUITheme.CardTheme? = null,
    content: @Composable () -> Unit,
) {
    val cardTheme = theme ?: LocalBaseUITheme.current.card

    Box(
        modifier = modifier
            .then(
                if (cardTheme.shadow.elevation > 0.dp) {
                    Modifier.shadow(
                        elevation = cardTheme.shadow.elevation,
                        shape = cardTheme.shape,
                        ambientColor = cardTheme.shadow.ambientColor,
                        spotColor = cardTheme.shadow.spotColor,
                    )
                } else Modifier
            )
            .clip(cardTheme.shape)
            .background(cardTheme.background, cardTheme.shape)
            .border(BorderStroke(cardTheme.border.width, cardTheme.border.color), cardTheme.shape)
            .padding(cardTheme.padding),
    ) {
        content()
    }
}

@Composable
@androidx.compose.ui.tooling.preview.Preview
private fun CardPreview() {
    MaterialTheme {
        val theme = rememberBaseUITheme()
        CompositionLocalProvider(LocalBaseUITheme provides theme) {
            Surface(
                color = MaterialTheme.colorScheme.background,
                modifier = Modifier.padding(24.dp),
            ) {
                Card {
                    Box(modifier = Modifier.padding(16.dp))
                }
            }
        }
    }
}
