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

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Stable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import dev.krtirtho.spotube.core.ui.base.BaseUITheme.AutoCompleteMenuTheme
import dev.krtirtho.spotube.core.ui.base.BaseUITheme.CheckBoxTheme
import dev.krtirtho.spotube.core.ui.base.BaseUITheme.ChipTabTheme
import dev.krtirtho.spotube.core.ui.base.BaseUITheme.SliderTheme
import dev.krtirtho.spotube.core.ui.base.BaseUITheme.TextFieldTheme

@Stable
data class BaseUITheme(
    val buttons: ButtonVariants,
    val iconButtons: ButtonVariants,
    val textField: TextFieldTheme,
    val autoCompleteMenuTheme: AutoCompleteMenuTheme,
    val slider: SliderTheme,
    val checkBox: CheckBoxTheme,
    val chipTab: ChipTabTheme,
    val card: CardTheme,
    val listRowTile: ListRowTheme,
) {

    @Stable
    data class InteractionState<T>(
        val hovered: T,
        val pressed: T,
        val focused: T,
    ) {
        companion object {
            fun <T> fromSingleValue(value: T): InteractionState<T> {
                return InteractionState(value, value, value)
            }
        }
    }

    @Stable
    data class AdvancedInteractionState<T>(
        val hovered: T,
        val pressed: T,
        val focused: T,
        val selected: T,
        val disabled: T,
    ) {
        companion object {
            fun <T> fromSingleValue(value: T): AdvancedInteractionState<T> {
                return AdvancedInteractionState(value, value, value, value, value)
            }
        }
    }

    @Stable
    data class Border(
        val color: Color,
        val width: Dp,
    )

    @Stable
    data class Shadow(
        val elevation: Dp,
        val clip: Boolean = elevation > 0.dp,
        val ambientColor: Color,
        val spotColor: Color,
    )

    @Stable
    data class ButtonVariants(
        val primary: ButtonStyle,
        val secondary: ButtonStyle,
        val outline: ButtonStyle,
        val ghost: ButtonStyle,
    )

    @Stable
    data class ButtonStyle(
        val colors: InteractionState<ButtonColors>,
        val shape: InteractionState<Shape>,
        val shadow: InteractionState<Shadow>,
        val border: InteractionState<Border>,
        val padding: InteractionState<PaddingValues>,
    )

    @Stable
    data class ButtonColors(
        val background: Brush,
        val foreground: Color,
        val highlight: Color,
    )

    data class CardTheme(
        val background: Brush,
        val shape: Shape,
        val border: Border,
        val padding: PaddingValues,
        val shadow: Shadow,
    )

    data class ListRowTheme(
        val background: AdvancedInteractionState<Brush>,
        val shape: AdvancedInteractionState<Shape>,
        val border: AdvancedInteractionState<Border>,
        val shadow: AdvancedInteractionState<Shadow>,
        val padding: PaddingValues,
        val textStyle: AdvancedInteractionState<TextStyle>,
        val foreground: AdvancedInteractionState<Color>,
    )

    data class TextFieldTheme(
        val background: InteractionState<Brush>,
        val highlight: InteractionState<Color>,
        val shape: InteractionState<Shape>,
        val border: InteractionState<Border>,
        val shadow: InteractionState<Shadow>,
        val padding: PaddingValues,
        val textStyle: TextStyle,
        val cursor: Brush,
        val foreground: InteractionState<Color>,
    )

    data class AutoCompleteMenuTheme(
        val background: Brush,
        val shape: Shape,
        val border: Border,
        val padding: PaddingValues,
        val shadowElevation: Dp,
    )

    data class SliderTheme(
        val trackActiveColor: InteractionState<Color>,
        val trackInactiveColor: InteractionState<Color>,
        val thumbColor: InteractionState<Color>,
        val thumbShadow: InteractionState<Shadow>,
        val stepActiveColor: Color,
        val stepInactiveColor: Color,
    )

    data class CheckBoxTheme(
        val selected: ButtonStyle,
        val unselected: ButtonStyle,
        val checkmarkColor: Color,
    )

    data class ChipTabTheme(
        val selected: ButtonStyle,
        val unselected: ButtonStyle,
    )

    companion object {
        private val defaultShape = RoundedCornerShape(14.dp)
        private val defaultShapeState =
            InteractionState<Shape>(defaultShape, defaultShape, defaultShape)
        private val noBorder = Border(Color.Transparent, 0.dp)
        private val noBorderState = InteractionState(noBorder, noBorder, noBorder)
        private val noShadow = Shadow(0.dp, false, Color.Transparent, Color.Transparent)
        private val noShadowState = InteractionState(noShadow, noShadow, noShadow)
        private val defaultButtonPadding = InteractionState(
            PaddingValues(horizontal = 20.dp, vertical = 10.dp),
            PaddingValues(horizontal = 20.dp, vertical = 10.dp),
            PaddingValues(horizontal = 20.dp, vertical = 10.dp),
        )
        private val iconButtonPadding = InteractionState(
            PaddingValues(8.dp),
            PaddingValues(8.dp),
            PaddingValues(8.dp),
        )

        val Default: BaseUITheme = BaseUITheme(
            buttons = ButtonVariants(
                primary = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1ED760).copy(alpha = 0.85f),
                                    Color(0xFF1DB954)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.15f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.45f),
                            Color(0xFF1DB954).copy(alpha = 0.5f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.2f),
                            Color(0xFF1DB954).copy(alpha = 0.25f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.35f),
                            Color(0xFF1DB954).copy(alpha = 0.4f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFF1DB954), 0.5.dp),
                        pressed = Border(Color(0xFF1DB954), 0.5.dp),
                        focused = Border(Color(0xFF1DB954), 0.5.dp),
                    ),
                    padding = defaultButtonPadding,
                ),
                secondary = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E0),
                                    Color(0xFFD0D0D0)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.5f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFD0D0D0),
                                    Color(0xFFC0C0C0)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.3f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E0),
                                    Color(0xFFD0D0D0)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.5f),
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color.Black.copy(alpha = 0.22f),
                            Color.Black.copy(alpha = 0.26f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color.Black.copy(alpha = 0.08f),
                            Color.Black.copy(alpha = 0.1f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color.Black.copy(alpha = 0.15f),
                            Color.Black.copy(alpha = 0.18f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFFE0E0E0).copy(alpha = 0.5f), 0.5.dp),
                        pressed = Border(Color(0xFFD0D0D0).copy(alpha = 0.5f), 0.5.dp),
                        focused = Border(Color(0xFFE0E0E0).copy(alpha = 0.5f), 0.5.dp),
                    ),
                    padding = defaultButtonPadding,
                ),
                outline = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3),
                                    Color(0xFFE0E0E3)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color.Black.copy(alpha = 0.22f),
                            Color.Black.copy(alpha = 0.26f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color.Black.copy(alpha = 0.08f),
                            Color.Black.copy(alpha = 0.1f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color.Black.copy(alpha = 0.15f),
                            Color.Black.copy(alpha = 0.18f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFFCCCCCC), 0.5.dp),
                        pressed = Border(Color(0xFFCCCCCC).copy(alpha = 0.7f), 0.5.dp),
                        focused = Border(Color(0xFFCCCCCC), 0.5.dp),
                    ),
                    padding = defaultButtonPadding,
                ),
                ghost = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3).copy(alpha = 0.5f),
                                    Color(0xFFE0E0E3).copy(alpha = 0.5f)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.Transparent,
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3),
                                    Color(0xFFE0E0E3)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.Transparent,
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.Transparent,
                                    Color.Transparent
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.Transparent,
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = noShadowState,
                    border = noBorderState,
                    padding = defaultButtonPadding,
                ),
            ),
            iconButtons = ButtonVariants(
                primary = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1ED760).copy(alpha = 0.85f),
                                    Color(0xFF1DB954)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.15f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.45f),
                            Color(0xFF1DB954).copy(alpha = 0.5f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.2f),
                            Color(0xFF1DB954).copy(alpha = 0.25f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.35f),
                            Color(0xFF1DB954).copy(alpha = 0.4f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFF1DB954), 0.5.dp),
                        pressed = Border(Color(0xFF1DB954), 0.5.dp),
                        focused = Border(Color(0xFF1DB954), 0.5.dp),
                    ),
                    padding = iconButtonPadding,
                ),
                secondary = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E0),
                                    Color(0xFFD0D0D0)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.5f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFD0D0D0),
                                    Color(0xFFC0C0C0)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.3f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E0),
                                    Color(0xFFD0D0D0)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.5f),
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color.Black.copy(alpha = 0.22f),
                            Color.Black.copy(alpha = 0.26f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color.Black.copy(alpha = 0.08f),
                            Color.Black.copy(alpha = 0.1f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color.Black.copy(alpha = 0.15f),
                            Color.Black.copy(alpha = 0.18f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFFE0E0E0).copy(alpha = 0.5f), 0.5.dp),
                        pressed = Border(Color(0xFFD0D0D0).copy(alpha = 0.5f), 0.5.dp),
                        focused = Border(Color(0xFFE0E0E0).copy(alpha = 0.5f), 0.5.dp),
                    ),
                    padding = iconButtonPadding,
                ),
                outline = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3),
                                    Color(0xFFE0E0E3)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color.Black.copy(alpha = 0.22f),
                            Color.Black.copy(alpha = 0.26f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color.Black.copy(alpha = 0.08f),
                            Color.Black.copy(alpha = 0.1f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color.Black.copy(alpha = 0.15f),
                            Color.Black.copy(alpha = 0.18f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFFCCCCCC), 0.5.dp),
                        pressed = Border(Color(0xFFCCCCCC).copy(alpha = 0.7f), 0.5.dp),
                        focused = Border(Color(0xFFCCCCCC), 0.5.dp),
                    ),
                    padding = iconButtonPadding,
                ),
                ghost = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3).copy(alpha = 0.5f),
                                    Color(0xFFE0E0E3).copy(alpha = 0.5f)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.Transparent,
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3),
                                    Color(0xFFE0E0E3)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.Transparent,
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.Transparent,
                                    Color.Transparent
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.Transparent,
                        ),
                    ),
                    shape = defaultShapeState,
                    shadow = noShadowState,
                    border = noBorderState,
                    padding = iconButtonPadding,
                ),
            ),
            textField = TextFieldTheme(
                background = InteractionState(
                    hovered = Brush.verticalGradient(listOf(Color(0xFFF5F5F5), Color(0xFFE8E8E8))),
                    pressed = Brush.verticalGradient(listOf(Color.White, Color(0xFFF2F2F4))),
                    focused = Brush.verticalGradient(listOf(Color.White, Color(0xFFF2F2F4))),
                ),
                highlight = InteractionState(
                    hovered = Color.White.copy(alpha = 0.9f),
                    pressed = Color.White.copy(alpha = 0.9f),
                    focused = Color.White.copy(alpha = 0.9f),
                ),
                shape = InteractionState(
                    hovered = defaultShape,
                    pressed = defaultShape,
                    focused = defaultShape,
                ),
                border = InteractionState(
                    hovered = Border(Color(0xFFCCCCCC).copy(alpha = 0.85f), 0.5.dp),
                    pressed = Border(Color(0xFFCCCCCC), 0.5.dp),
                    focused = Border(Color(0xFF1DB954), 0.5.dp),
                ),
                shadow = InteractionState(
                    hovered = Shadow(
                        9.dp,
                        true,
                        Color.Black.copy(alpha = 0.22f),
                        Color.Black.copy(alpha = 0.26f)
                    ),
                    pressed = Shadow(
                        6.dp,
                        true,
                        Color.Black.copy(alpha = 0.15f),
                        Color.Black.copy(alpha = 0.18f)
                    ),
                    focused = Shadow(
                        9.dp,
                        true,
                        Color(0xFF1DB954).copy(alpha = 0.2f),
                        Color(0xFF1DB954).copy(alpha = 0.25f)
                    ),
                ),
                padding = PaddingValues(horizontal = 14.dp, vertical = 10.dp),
                textStyle = TextStyle.Default,
                cursor = SolidColor(Color(0xFF1DB954)),
                foreground = InteractionState(
                    hovered = Color.Black,
                    pressed = Color.Black,
                    focused = Color.Black,
                ),
            ),
            autoCompleteMenuTheme = AutoCompleteMenuTheme(
                background = Brush.verticalGradient(listOf(Color(0xFFF5F5F5), Color(0xFFE8E8E8))),
                shape = RoundedCornerShape(12.dp),
                border = Border(Color(0xFFCCCCCC), 0.5.dp),
                padding = PaddingValues(0.dp),
                shadowElevation = 8.dp,
            ),
            slider = SliderTheme(
                trackActiveColor = InteractionState(
                    hovered = Color(0xFF1DB954),
                    pressed = Color(0xFF1DB954),
                    focused = Color(0xFF1DB954),
                ),
                trackInactiveColor = InteractionState(
                    hovered = Color(0xFFCCCCCC).copy(alpha = 0.6f),
                    pressed = Color(0xFFCCCCCC).copy(alpha = 0.6f),
                    focused = Color(0xFFCCCCCC).copy(alpha = 0.6f),
                ),
                thumbColor = InteractionState(
                    hovered = Color(0xFF1DB954),
                    pressed = Color(0xFF1DB954),
                    focused = Color(0xFF1DB954),
                ),
                thumbShadow = InteractionState(
                    hovered = Shadow(
                        8.dp,
                        true,
                        Color(0xFF1DB954).copy(alpha = 0.4f),
                        Color(0xFF1DB954).copy(alpha = 0.5f)
                    ),
                    pressed = Shadow(
                        2.dp,
                        true,
                        Color(0xFF1DB954).copy(alpha = 0.2f),
                        Color(0xFF1DB954).copy(alpha = 0.25f)
                    ),
                    focused = Shadow(
                        5.dp,
                        true,
                        Color(0xFF1DB954).copy(alpha = 0.35f),
                        Color(0xFF1DB954).copy(alpha = 0.4f)
                    ),
                ),
                stepActiveColor = Color.White.copy(alpha = 0.5f),
                stepInactiveColor = Color.Black.copy(alpha = 0.25f),
            ),
            checkBox = CheckBoxTheme(
                selected = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1ED760).copy(alpha = 0.85f),
                                    Color(0xFF1DB954)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.15f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                    ),
                    shape = InteractionState(
                        RoundedCornerShape(6.dp),
                        RoundedCornerShape(6.dp),
                        RoundedCornerShape(6.dp)
                    ),
                    shadow = InteractionState(
                        hovered = Shadow(
                            8.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.4f),
                            Color(0xFF1DB954).copy(alpha = 0.45f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.2f),
                            Color(0xFF1DB954).copy(alpha = 0.25f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.3f),
                            Color(0xFF1DB954).copy(alpha = 0.35f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFF1DB954), 0.5.dp),
                        pressed = Border(Color(0xFF1DB954), 0.5.dp),
                        focused = Border(Color(0xFF1DB954), 0.5.dp),
                    ),
                    padding = InteractionState(
                        PaddingValues(0.dp),
                        PaddingValues(0.dp),
                        PaddingValues(0.dp)
                    ),
                ),
                unselected = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3),
                                    Color(0xFFE0E0E3)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                    ),
                    shape = InteractionState(
                        RoundedCornerShape(6.dp),
                        RoundedCornerShape(6.dp),
                        RoundedCornerShape(6.dp)
                    ),
                    shadow = InteractionState(
                        hovered = Shadow(
                            5.dp,
                            true,
                            Color.Black.copy(alpha = 0.2f),
                            Color.Black.copy(alpha = 0.24f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color.Black.copy(alpha = 0.08f),
                            Color.Black.copy(alpha = 0.1f)
                        ),
                        focused = Shadow(
                            3.dp,
                            true,
                            Color.Black.copy(alpha = 0.15f),
                            Color.Black.copy(alpha = 0.18f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFFCCCCCC), 0.5.dp),
                        pressed = Border(Color(0xFFCCCCCC), 0.5.dp),
                        focused = Border(Color(0xFFCCCCCC), 0.5.dp),
                    ),
                    padding = InteractionState(
                        PaddingValues(0.dp),
                        PaddingValues(0.dp),
                        PaddingValues(0.dp)
                    ),
                ),
                checkmarkColor = Color.White,
            ),
            chipTab = ChipTabTheme(
                selected = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1ED760).copy(alpha = 0.85f),
                                    Color(0xFF1DB954)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.15f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760)
                                )
                            ),
                            foreground = Color.White,
                            highlight = Color.White.copy(alpha = 0.25f),
                        ),
                    ),
                    shape = InteractionState(
                        RoundedCornerShape(10.dp),
                        RoundedCornerShape(10.dp),
                        RoundedCornerShape(10.dp)
                    ),
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.45f),
                            Color(0xFF1DB954).copy(alpha = 0.5f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.2f),
                            Color(0xFF1DB954).copy(alpha = 0.25f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color(0xFF1DB954).copy(alpha = 0.35f),
                            Color(0xFF1DB954).copy(alpha = 0.4f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFF1DB954), 0.5.dp),
                        pressed = Border(Color(0xFF1DB954), 0.5.dp),
                        focused = Border(Color(0xFF1DB954), 0.5.dp),
                    ),
                    padding = InteractionState(
                        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
                        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
                        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
                    ),
                ),
                unselected = ButtonStyle(
                    colors = InteractionState(
                        hovered = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        pressed = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color(0xFFE0E0E3),
                                    Color(0xFFE0E0E3)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                        focused = ButtonColors(
                            background = Brush.verticalGradient(
                                listOf(
                                    Color.White,
                                    Color(0xFFF2F2F4)
                                )
                            ),
                            foreground = Color.Black,
                            highlight = Color.White.copy(alpha = 0.9f),
                        ),
                    ),
                    shape = InteractionState(
                        RoundedCornerShape(10.dp),
                        RoundedCornerShape(10.dp),
                        RoundedCornerShape(10.dp)
                    ),
                    shadow = InteractionState(
                        hovered = Shadow(
                            9.dp,
                            true,
                            Color.Black.copy(alpha = 0.22f),
                            Color.Black.copy(alpha = 0.26f)
                        ),
                        pressed = Shadow(
                            1.dp,
                            true,
                            Color.Black.copy(alpha = 0.08f),
                            Color.Black.copy(alpha = 0.1f)
                        ),
                        focused = Shadow(
                            6.dp,
                            true,
                            Color.Black.copy(alpha = 0.15f),
                            Color.Black.copy(alpha = 0.18f)
                        ),
                    ),
                    border = InteractionState(
                        hovered = Border(Color(0xFFCCCCCC), 0.5.dp),
                        pressed = Border(Color(0xFFCCCCCC).copy(alpha = 0.7f), 0.5.dp),
                        focused = Border(Color(0xFFCCCCCC), 0.5.dp),
                    ),
                    padding = InteractionState(
                        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
                        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
                        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
                    ),
                ),
            ),
            card = CardTheme(
                background = Brush.verticalGradient(listOf(Color.White, Color(0xFFF2F2F4))),
                shape = RoundedCornerShape(16.dp),
                border = Border(Color(0xFFCCCCCC), 0.5.dp),
                padding = PaddingValues(12.dp),
                shadow = Shadow(6.dp, true, Color.Black.copy(alpha = 0.15f), Color.Black.copy(alpha = 0.18f)),
            ),
            listRowTile = ListRowTheme(
                background = AdvancedInteractionState(
                    hovered = Brush.verticalGradient(listOf(Color.White, Color(0xFFF2F2F4))),
                    pressed = Brush.verticalGradient(listOf(Color(0xFFE0E0E3), Color(0xFFE0E0E3))),
                    focused = Brush.verticalGradient(listOf(Color.White, Color(0xFFF2F2F4))),
                    selected = Brush.verticalGradient(listOf(Color(0xFF1DB954).copy(alpha = 0.14f), Color(0xFF1DB954).copy(alpha = 0.14f))),
                    disabled = Brush.verticalGradient(listOf(Color(0xFFF5F5F5), Color(0xFFF5F5F5))),
                ),
                shape = AdvancedInteractionState(
                    hovered = RoundedCornerShape(8.dp),
                    pressed = RoundedCornerShape(8.dp),
                    focused = RoundedCornerShape(8.dp),
                    selected = RoundedCornerShape(8.dp),
                    disabled = RoundedCornerShape(8.dp),
                ),
                border = AdvancedInteractionState(
                    hovered = Border(Color.Transparent, 0.dp),
                    pressed = Border(Color.Transparent, 0.dp),
                    focused = Border(Color.Transparent, 0.dp),
                    selected = Border(Color.Transparent, 0.dp),
                    disabled = Border(Color.Transparent, 0.dp),
                ),
                shadow = AdvancedInteractionState(
                    hovered = Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                    pressed = Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                    focused = Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                    selected = Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                    disabled = Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                ),
                padding = PaddingValues(horizontal = 8.dp, vertical = 6.dp),
                textStyle = AdvancedInteractionState(
                    hovered = TextStyle.Default,
                    pressed = TextStyle.Default,
                    focused = TextStyle.Default,
                    selected = TextStyle.Default,
                    disabled = TextStyle.Default,
                ),
                foreground = AdvancedInteractionState(
                    hovered = Color.Black,
                    pressed = Color.Black,
                    focused = Color.Black,
                    selected = Color.Black,
                    disabled = Color.Black.copy(alpha = 0.38f),
                ),
            ),
        )
    }
}

val LocalBaseUITheme = staticCompositionLocalOf { BaseUITheme.Default }

@Composable
fun rememberBaseUITheme(): BaseUITheme {
    val scheme = MaterialTheme.colorScheme
    val isLight = scheme.surface.luminance() > 0.5f

    val containerLighter = if (isLight) Color.White else scheme.surfaceContainerHigh
    val containerDarker = if (isLight) Color(0xFFF2F2F4) else scheme.surfaceContainer
    val containerPressed = if (isLight) Color(0xFFE0E0E3) else scheme.surfaceContainerHighest
    val highlight = if (isLight) Color.White.copy(alpha = 0.9f) else Color.White.copy(alpha = 0.06f)
    val shadowColor = scheme.onSurface.copy(alpha = 0.12f)
    val border = scheme.outlineVariant

    val secondaryContainer = scheme.secondaryContainer
    val secondaryContainerPressed = secondaryContainer.copy(alpha = if (isLight) 0.85f else 0.92f)
    val secondaryHighlight =
        if (isLight) Color.White.copy(alpha = 0.5f) else Color.White.copy(alpha = 0.08f)

    val defaultShape = RoundedCornerShape(14.dp)
    val defaultShapeState =
        BaseUITheme.InteractionState<Shape>(defaultShape, defaultShape, defaultShape)
    val noBorder = BaseUITheme.Border(Color.Transparent, 0.dp)
    val noBorderState = BaseUITheme.InteractionState(noBorder, noBorder, noBorder)
    val noShadow = BaseUITheme.Shadow(0.dp, false, Color.Transparent, Color.Transparent)
    val noShadowState = BaseUITheme.InteractionState(noShadow, noShadow, noShadow)
    val defaultButtonPadding = BaseUITheme.InteractionState(
        PaddingValues(horizontal = 20.dp, vertical = 10.dp),
        PaddingValues(horizontal = 20.dp, vertical = 10.dp),
        PaddingValues(horizontal = 20.dp, vertical = 10.dp),
    )
    val iconButtonPadding = BaseUITheme.InteractionState(
        PaddingValues(8.dp),
        PaddingValues(8.dp),
        PaddingValues(8.dp),
    )

    val outlineColors = BaseUITheme.InteractionState(
        hovered = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
            foreground = scheme.onSurface,
            highlight = highlight,
        ),
        pressed = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(listOf(containerPressed, containerPressed)),
            foreground = scheme.onSurface,
            highlight = highlight,
        ),
        focused = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
            foreground = scheme.onSurface,
            highlight = highlight,
        ),
    )
    val outlineShadow = BaseUITheme.InteractionState(
        hovered = BaseUITheme.Shadow(
            9.dp,
            true,
            shadowColor.copy(alpha = 0.22f / 0.12f),
            shadowColor.copy(alpha = 0.26f / 0.12f)
        ),
        pressed = BaseUITheme.Shadow(
            1.dp,
            true,
            shadowColor.copy(alpha = 0.08f / 0.12f),
            shadowColor.copy(alpha = 0.1f / 0.12f)
        ),
        focused = BaseUITheme.Shadow(
            6.dp,
            true,
            shadowColor.copy(alpha = 0.15f / 0.12f),
            shadowColor.copy(alpha = 0.18f / 0.12f)
        ),
    )
    val outlineBorder = BaseUITheme.InteractionState(
        hovered = BaseUITheme.Border(border, 0.5.dp),
        pressed = BaseUITheme.Border(border.copy(alpha = 0.7f), 0.5.dp),
        focused = BaseUITheme.Border(border, 0.5.dp),
    )

    val primaryColors = BaseUITheme.InteractionState(
        hovered = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(listOf(scheme.primary, scheme.primary)),
            foreground = scheme.onPrimary,
            highlight = Color.White.copy(alpha = 0.25f),
        ),
        pressed = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(
                listOf(
                    scheme.primary.copy(alpha = 0.85f),
                    scheme.primary
                )
            ),
            foreground = scheme.onPrimary,
            highlight = Color.White.copy(alpha = 0.25f),
        ),
        focused = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(listOf(scheme.primary, scheme.primary)),
            foreground = scheme.onPrimary,
            highlight = Color.White.copy(alpha = 0.25f),
        ),
    )
    val primaryShadow = BaseUITheme.InteractionState(
        hovered = BaseUITheme.Shadow(
            9.dp,
            true,
            scheme.primary.copy(alpha = 0.45f),
            scheme.primary.copy(alpha = 0.5f)
        ),
        pressed = BaseUITheme.Shadow(
            1.dp,
            true,
            scheme.primary.copy(alpha = 0.2f),
            scheme.primary.copy(alpha = 0.25f)
        ),
        focused = BaseUITheme.Shadow(
            6.dp,
            true,
            scheme.primary.copy(alpha = 0.35f),
            scheme.primary.copy(alpha = 0.4f)
        ),
    )
    val primaryBorder = BaseUITheme.InteractionState(
        hovered = BaseUITheme.Border(scheme.primary, 0.5.dp),
        pressed = BaseUITheme.Border(scheme.primary, 0.5.dp),
        focused = BaseUITheme.Border(scheme.primary, 0.5.dp),
    )

    val secondaryColors = BaseUITheme.InteractionState(
        hovered = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(
                listOf(
                    secondaryContainer,
                    secondaryContainer.copy(alpha = if (secondaryContainer.luminance() > 0.5f) 0.92f else 1f)
                )
            ),
            foreground = scheme.onSecondaryContainer,
            highlight = secondaryHighlight,
        ),
        pressed = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(
                listOf(
                    secondaryContainerPressed,
                    secondaryContainerPressed
                )
            ),
            foreground = scheme.onSecondaryContainer,
            highlight = secondaryHighlight,
        ),
        focused = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(
                listOf(
                    secondaryContainer,
                    secondaryContainer.copy(alpha = if (secondaryContainer.luminance() > 0.5f) 0.92f else 1f)
                )
            ),
            foreground = scheme.onSecondaryContainer,
            highlight = secondaryHighlight,
        ),
    )
    val secondaryShadow = BaseUITheme.InteractionState(
        hovered = BaseUITheme.Shadow(
            9.dp,
            true,
            shadowColor.copy(alpha = 0.22f / 0.12f),
            shadowColor.copy(alpha = 0.26f / 0.12f)
        ),
        pressed = BaseUITheme.Shadow(
            1.dp,
            true,
            shadowColor.copy(alpha = 0.08f / 0.12f),
            shadowColor.copy(alpha = 0.1f / 0.12f)
        ),
        focused = BaseUITheme.Shadow(
            6.dp,
            true,
            shadowColor.copy(alpha = 0.15f / 0.12f),
            shadowColor.copy(alpha = 0.18f / 0.12f)
        ),
    )
    val secondaryBorder = BaseUITheme.InteractionState(
        hovered = BaseUITheme.Border(secondaryContainer.copy(alpha = 0.5f), 0.5.dp),
        pressed = BaseUITheme.Border(secondaryContainer.copy(alpha = 0.5f), 0.5.dp),
        focused = BaseUITheme.Border(secondaryContainer.copy(alpha = 0.5f), 0.5.dp),
    )

    val ghostColors = BaseUITheme.InteractionState(
        hovered = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(
                listOf(
                    containerPressed.copy(alpha = 0.5f),
                    containerPressed.copy(alpha = 0.5f)
                )
            ),
            foreground = scheme.onSurface,
            highlight = Color.Transparent,
        ),
        pressed = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(listOf(containerPressed, containerPressed)),
            foreground = scheme.onSurface,
            highlight = Color.Transparent,
        ),
        focused = BaseUITheme.ButtonColors(
            background = Brush.verticalGradient(listOf(Color.Transparent, Color.Transparent)),
            foreground = scheme.onSurface,
            highlight = Color.Transparent,
        ),
    )

    val outlineStyle = BaseUITheme.ButtonStyle(
        outlineColors,
        defaultShapeState,
        outlineShadow,
        outlineBorder,
        defaultButtonPadding
    )
    val primaryStyle = BaseUITheme.ButtonStyle(
        primaryColors,
        defaultShapeState,
        primaryShadow,
        primaryBorder,
        defaultButtonPadding
    )
    val secondaryStyle = BaseUITheme.ButtonStyle(
        secondaryColors,
        defaultShapeState,
        secondaryShadow,
        secondaryBorder,
        defaultButtonPadding
    )
    val ghostStyle = BaseUITheme.ButtonStyle(
        ghostColors,
        defaultShapeState,
        noShadowState,
        noBorderState,
        defaultButtonPadding
    )

    val outlineIconStyle = BaseUITheme.ButtonStyle(
        outlineColors,
        defaultShapeState,
        outlineShadow,
        outlineBorder,
        iconButtonPadding
    )
    val primaryIconStyle = BaseUITheme.ButtonStyle(
        primaryColors,
        defaultShapeState,
        primaryShadow,
        primaryBorder,
        iconButtonPadding
    )
    val secondaryIconStyle = BaseUITheme.ButtonStyle(
        secondaryColors,
        defaultShapeState,
        secondaryShadow,
        secondaryBorder,
        iconButtonPadding
    )
    val ghostIconStyle = BaseUITheme.ButtonStyle(
        ghostColors,
        defaultShapeState,
        noShadowState,
        noBorderState,
        iconButtonPadding
    )

    val textFieldForeground = BaseUITheme.InteractionState(
        hovered = scheme.onSurface,
        pressed = scheme.onSurface,
        focused = scheme.onSurface,
    )

    val checkBoxShape = RoundedCornerShape(6.dp)
    val checkBoxShapeState =
        BaseUITheme.InteractionState<Shape>(checkBoxShape, checkBoxShape, checkBoxShape)
    val noPadding =
        BaseUITheme.InteractionState(PaddingValues(0.dp), PaddingValues(0.dp), PaddingValues(0.dp))

    val chipTabShape = RoundedCornerShape(10.dp)
    val chipTabShapeState =
        BaseUITheme.InteractionState<Shape>(chipTabShape, chipTabShape, chipTabShape)
    val chipTabPadding = BaseUITheme.InteractionState(
        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
        PaddingValues(horizontal = 14.dp, vertical = 4.dp),
    )

    return BaseUITheme(
        buttons = BaseUITheme.ButtonVariants(
            primary = primaryStyle,
            secondary = secondaryStyle,
            outline = outlineStyle,
            ghost = ghostStyle,
        ),
        iconButtons = BaseUITheme.ButtonVariants(
            primary = primaryIconStyle,
            secondary = secondaryIconStyle,
            outline = outlineIconStyle,
            ghost = ghostIconStyle,
        ),
        textField = TextFieldTheme(
            background = BaseUITheme.InteractionState(
                hovered = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
                pressed = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
                focused = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
            ),
            highlight = BaseUITheme.InteractionState(
                hovered = highlight,
                pressed = highlight,
                focused = highlight,
            ),
            shape = BaseUITheme.InteractionState(
                hovered = defaultShape,
                pressed = defaultShape,
                focused = defaultShape,
            ),
            border = BaseUITheme.InteractionState(
                hovered = BaseUITheme.Border(border.copy(alpha = 0.85f), 0.5.dp),
                pressed = BaseUITheme.Border(border, 0.5.dp),
                focused = BaseUITheme.Border(scheme.primary, 0.5.dp),
            ),
            shadow = BaseUITheme.InteractionState(
                hovered = BaseUITheme.Shadow(
                    9.dp,
                    true,
                    shadowColor.copy(alpha = 0.22f / 0.12f),
                    shadowColor.copy(alpha = 0.26f / 0.12f)
                ),
                pressed = BaseUITheme.Shadow(
                    6.dp,
                    true,
                    shadowColor.copy(alpha = 0.15f / 0.12f),
                    shadowColor.copy(alpha = 0.18f / 0.12f)
                ),
                focused = BaseUITheme.Shadow(
                    9.dp,
                    true,
                    scheme.primary.copy(alpha = 0.2f),
                    scheme.primary.copy(alpha = 0.25f)
                ),
            ),
            padding = PaddingValues(horizontal = 14.dp, vertical = 10.dp),
            textStyle = TextStyle.Default,
            cursor = SolidColor(scheme.primary),
            foreground = textFieldForeground,
        ),
        autoCompleteMenuTheme = AutoCompleteMenuTheme(
            background = Brush.verticalGradient(
                listOf(
                    scheme.surfaceContainerHigh,
                    scheme.surfaceContainer
                )
            ),
            shape = RoundedCornerShape(12.dp),
            border = BaseUITheme.Border(border, 0.5.dp),
            padding = PaddingValues(0.dp),
            shadowElevation = 8.dp,
        ),
        slider = SliderTheme(
            trackActiveColor = BaseUITheme.InteractionState(
                hovered = scheme.primary,
                pressed = scheme.primary,
                focused = scheme.primary,
            ),
            trackInactiveColor = BaseUITheme.InteractionState(
                hovered = border.copy(alpha = 0.6f),
                pressed = border.copy(alpha = 0.6f),
                focused = border.copy(alpha = 0.6f),
            ),
            thumbColor = BaseUITheme.InteractionState(
                hovered = scheme.primary,
                pressed = scheme.primary,
                focused = scheme.primary,
            ),
            thumbShadow = BaseUITheme.InteractionState(
                hovered = BaseUITheme.Shadow(
                    8.dp,
                    true,
                    scheme.primary.copy(alpha = 0.4f),
                    scheme.primary.copy(alpha = 0.5f)
                ),
                pressed = BaseUITheme.Shadow(
                    2.dp,
                    true,
                    scheme.primary.copy(alpha = 0.2f),
                    scheme.primary.copy(alpha = 0.25f)
                ),
                focused = BaseUITheme.Shadow(
                    5.dp,
                    true,
                    scheme.primary.copy(alpha = 0.35f),
                    scheme.primary.copy(alpha = 0.4f)
                ),
            ),
            stepActiveColor = scheme.onPrimary.copy(alpha = 0.5f),
            stepInactiveColor = scheme.onSurface.copy(alpha = 0.25f),
        ),
        checkBox = CheckBoxTheme(
            selected = BaseUITheme.ButtonStyle(
                colors = primaryColors,
                shape = checkBoxShapeState,
                shadow = BaseUITheme.InteractionState(
                    hovered = BaseUITheme.Shadow(
                        8.dp,
                        true,
                        scheme.primary.copy(alpha = 0.4f),
                        scheme.primary.copy(alpha = 0.45f)
                    ),
                    pressed = BaseUITheme.Shadow(
                        1.dp,
                        true,
                        scheme.primary.copy(alpha = 0.2f),
                        scheme.primary.copy(alpha = 0.25f)
                    ),
                    focused = BaseUITheme.Shadow(
                        6.dp,
                        true,
                        scheme.primary.copy(alpha = 0.3f),
                        scheme.primary.copy(alpha = 0.35f)
                    ),
                ),
                border = primaryBorder,
                padding = noPadding,
            ),
            unselected = BaseUITheme.ButtonStyle(
                colors = outlineColors,
                shape = checkBoxShapeState,
                shadow = BaseUITheme.InteractionState(
                    hovered = BaseUITheme.Shadow(
                        5.dp,
                        true,
                        shadowColor.copy(alpha = 0.2f),
                        shadowColor.copy(alpha = 0.24f)
                    ),
                    pressed = BaseUITheme.Shadow(
                        1.dp,
                        true,
                        shadowColor.copy(alpha = 0.08f),
                        shadowColor.copy(alpha = 0.1f)
                    ),
                    focused = BaseUITheme.Shadow(
                        3.dp,
                        true,
                        shadowColor.copy(alpha = 0.15f),
                        shadowColor.copy(alpha = 0.18f)
                    ),
                ),
                border = outlineBorder,
                padding = noPadding,
            ),
            checkmarkColor = scheme.onPrimary,
        ),
        chipTab = ChipTabTheme(
            selected = BaseUITheme.ButtonStyle(
                colors = primaryColors,
                shape = chipTabShapeState,
                shadow = primaryShadow,
                border = primaryBorder,
                padding = chipTabPadding,
            ),
            unselected = BaseUITheme.ButtonStyle(
                colors = outlineColors,
                shape = chipTabShapeState,
                shadow = outlineShadow,
                border = outlineBorder,
                padding = chipTabPadding,
            ),
        ),
        card = BaseUITheme.CardTheme(
            background = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
            shape = RoundedCornerShape(16.dp),
            border = BaseUITheme.Border(border, 0.5.dp),
            padding = PaddingValues(12.dp),
            shadow = BaseUITheme.Shadow(6.dp, true, shadowColor.copy(alpha = 0.15f / 0.12f), shadowColor.copy(alpha = 0.18f / 0.12f)),
        ),
        listRowTile = BaseUITheme.ListRowTheme(
            background = BaseUITheme.AdvancedInteractionState(
                hovered = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
                pressed = Brush.verticalGradient(listOf(containerPressed, containerPressed)),
                focused = Brush.verticalGradient(listOf(containerLighter, containerDarker)),
                selected = Brush.verticalGradient(listOf(scheme.primaryContainer.copy(alpha = 0.3f), scheme.primaryContainer.copy(alpha = 0.3f))),
                disabled = Brush.verticalGradient(listOf(containerLighter.copy(alpha = 0.5f), containerDarker.copy(alpha = 0.5f))),
            ),
            shape = BaseUITheme.AdvancedInteractionState(
                hovered = RoundedCornerShape(8.dp),
                pressed = RoundedCornerShape(8.dp),
                focused = RoundedCornerShape(8.dp),
                selected = RoundedCornerShape(8.dp),
                disabled = RoundedCornerShape(8.dp),
            ),
            border = BaseUITheme.AdvancedInteractionState(
                hovered = BaseUITheme.Border(Color.Transparent, 0.dp),
                pressed = BaseUITheme.Border(Color.Transparent, 0.dp),
                focused = BaseUITheme.Border(Color.Transparent, 0.dp),
                selected = BaseUITheme.Border(Color.Transparent, 0.dp),
                disabled = BaseUITheme.Border(Color.Transparent, 0.dp),
            ),
            shadow = BaseUITheme.AdvancedInteractionState(
                hovered = BaseUITheme.Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                pressed = BaseUITheme.Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                focused = BaseUITheme.Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                selected = BaseUITheme.Shadow(0.dp, false, Color.Transparent, Color.Transparent),
                disabled = BaseUITheme.Shadow(0.dp, false, Color.Transparent, Color.Transparent),
            ),
            padding = PaddingValues(horizontal = 8.dp, vertical = 6.dp),
            textStyle = BaseUITheme.AdvancedInteractionState(
                hovered = TextStyle.Default,
                pressed = TextStyle.Default,
                focused = TextStyle.Default,
                selected = TextStyle.Default,
                disabled = TextStyle.Default,
            ),
            foreground = BaseUITheme.AdvancedInteractionState(
                hovered = scheme.onSurface,
                pressed = scheme.onSurface,
                focused = scheme.onSurface,
                selected = scheme.onSurface,
                disabled = scheme.onSurface.copy(alpha = 0.38f),
            ),
        ),
    )
}

// Helper functions for easier theme overrides

fun BaseUITheme.ButtonStyle.copyShape(shape: Shape): BaseUITheme.ButtonStyle =
    copy(shape = BaseUITheme.InteractionState.fromSingleValue(shape))

fun BaseUITheme.ButtonStyle.copyShadow(shadow: BaseUITheme.Shadow): BaseUITheme.ButtonStyle =
    copy(shadow = BaseUITheme.InteractionState.fromSingleValue(shadow))

fun BaseUITheme.ButtonStyle.copyBorder(border: BaseUITheme.Border): BaseUITheme.ButtonStyle =
    copy(border = BaseUITheme.InteractionState.fromSingleValue(border))

fun BaseUITheme.ButtonStyle.copyPadding(padding: PaddingValues): BaseUITheme.ButtonStyle =
    copy(padding = BaseUITheme.InteractionState.fromSingleValue(padding))

fun BaseUITheme.ButtonStyle.copyColors(colors: BaseUITheme.ButtonColors): BaseUITheme.ButtonStyle =
    copy(colors = BaseUITheme.InteractionState.fromSingleValue(colors))

@Composable
fun invertedButtonStyle(): BaseUITheme.ButtonStyle {
    val scheme = MaterialTheme.colorScheme
    val isLight = scheme.surface.luminance() > 0.5f
    val shadowColor = scheme.onSurface.copy(alpha = 0.12f)

    val invertedColors = BaseUITheme.ButtonColors(
        background = Brush.verticalGradient(listOf(scheme.onSurface, scheme.onSurface)),
        foreground = scheme.surface,
        highlight = if (isLight) Color.White.copy(alpha = 0.15f) else Color.White.copy(alpha = 0.08f),
    )
    val pressedColors = BaseUITheme.ButtonColors(
        background = Brush.verticalGradient(listOf(scheme.onSurfaceVariant, scheme.onSurfaceVariant)),
        foreground = scheme.surface,
        highlight = if (isLight) Color.White.copy(alpha = 0.1f) else Color.White.copy(alpha = 0.05f),
    )
    val border = BaseUITheme.Border(scheme.onSurfaceVariant, 0.5.dp)
    val shadow = BaseUITheme.Shadow(
        elevation = 6.dp,
        clip = true,
        ambientColor = shadowColor.copy(alpha = 0.2f),
        spotColor = shadowColor.copy(alpha = 0.25f),
    )

    return BaseUITheme.ButtonStyle(
        colors = BaseUITheme.InteractionState(
            hovered = invertedColors,
            pressed = pressedColors,
            focused = invertedColors,
        ),
        shape = BaseUITheme.InteractionState.fromSingleValue(RoundedCornerShape(14.dp)),
        shadow = BaseUITheme.InteractionState.fromSingleValue(shadow),
        border = BaseUITheme.InteractionState.fromSingleValue(border),
        padding = BaseUITheme.InteractionState.fromSingleValue(PaddingValues(8.dp)),
    )
}
