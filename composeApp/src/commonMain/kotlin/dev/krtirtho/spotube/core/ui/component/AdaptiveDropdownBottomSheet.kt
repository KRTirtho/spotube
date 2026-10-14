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

package dev.krtirtho.spotube.core.ui.component


import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.ui.draw.clip
import androidx.compose.foundation.text.input.rememberTextFieldState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import com.composeunstyled.currentWindowWidthBreakpoint
import org.spotube.millennium.adaptive.WindowBreakpoints
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.composeunstyled.SheetDetent
import com.composeunstyled.rememberModalBottomSheetState
import compose.icons.FeatherIcons
import compose.icons.feathericons.Check
import dev.krtirtho.spotube.core.ui.theming.AppTheme
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.Iconsax3DotsMore
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart
import dev.krtirtho.spotube.resources.iconsax.IconsaxShare
import dev.krtirtho.spotube.resources.iconsax.IconsaxTrash
import org.jetbrains.compose.resources.stringResource
import org.spotube.millennium.composables.MillenniumDropdownMenu
import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import org.spotube.millennium.composables.MillenniumListTile
import org.spotube.millennium.composables.MillenniumModalBottomSheet
import org.spotube.millennium.composables.MillenniumSeparator
import org.spotube.millennium.composables.MillenniumText
import org.spotube.millennium.composables.MillenniumTextField
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.accessibility_selected
import spotube.composeapp.generated.resources.search_filter_placeholder

data class AdaptiveMenuItem(
    val icon: ImageVector? = null,
    val label: String,
    val onClick: () -> Unit,
    val enabled: Boolean = true,
    val selected: Boolean = false,
    val dividerBefore: Boolean = false,
    val subtitle: String? = null,
    val leadingContent: (@Composable () -> Unit)? = null)

enum class HeaderDisplayMode {
    Always,
    OnlyInDropdown,
    OnlyInBottomSheet,
}

@Composable
fun AdaptiveDropdownBottomSheet(
    items: List<AdaptiveMenuItem>,
    trigger: @Composable (onClick: () -> Unit) -> Unit,
    modifier: Modifier = Modifier,
    menuMinWidth: Dp = 200.dp,
    header: @Composable (() -> Unit)? = null,
    headerDisplayMode: HeaderDisplayMode = HeaderDisplayMode.Always,
    filter: ((AdaptiveMenuItem, String) -> Boolean)? = null) {
    var expanded by remember { mutableStateOf(false) }
    val isLargeScreen = currentWindowWidthBreakpoint() isAtLeast WindowBreakpoints.Medium

    Box(modifier = modifier) {
        if (isLargeScreen) {
            MillenniumDropdownMenu(
                expanded = expanded,
                onExpandedChange = { expanded = it },
                items = items.map { it.label },
                onItemClick = { label ->
                    items.firstOrNull { it.label == label && it.enabled }?.onClick?.invoke()
                    expanded = false
                },
                minimumWidth = menuMinWidth,
                anchor = { trigger { expanded = true } }
            )
        } else {
            trigger { expanded = true }
            if (expanded) {
                AdaptiveBottomSheetContent(
                    onDismiss = { expanded = false },
                    items = items,
                    header = if (header != null && (headerDisplayMode == HeaderDisplayMode.Always || headerDisplayMode == HeaderDisplayMode.OnlyInBottomSheet)) {
                        header
                    } else {
                        null
                    },
                    filter = filter)
            }
        }
    }
}

@Composable
private fun AdaptiveBottomSheetContent(
    onDismiss: () -> Unit,
    items: List<AdaptiveMenuItem>,
    header: @Composable (() -> Unit)?,
    filter: ((AdaptiveMenuItem, String) -> Boolean)? = null) {
    val hasSelection = items.any { it.selected }
    val queryState = rememberTextFieldState()
    val query = queryState.text.toString()
    val filteredItems = if (filter != null && query.isNotBlank()) {
        items.filter { filter(it, query) }
    } else {
        items
    }
    val sheetState = rememberModalBottomSheetState(initialDetent = SheetDetent.FullyExpanded)
    LaunchedEffect(sheetState.currentDetent) {
        if (sheetState.currentDetent == SheetDetent.Hidden) {
            onDismiss()
        }
    }
    MillenniumModalBottomSheet(state = sheetState) {
        Column(
            modifier = Modifier.fillMaxWidth()) {
            header?.invoke()

            if (filter != null) {
                Spacer(modifier = Modifier.height(8.dp))
                MillenniumTextField(
                    state = queryState,
                    label = "",
                    placeholder = stringResource(Res.string.search_filter_placeholder),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 12.dp, vertical = 8.dp))
            }

            LazyColumn(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 8.dp, vertical = 8.dp),
                verticalArrangement = Arrangement.spacedBy(2.dp)) {
                items(
                    count = filteredItems.size) { index ->
                    val item = filteredItems[index]

                    if (item.dividerBefore) {
                        MillenniumSeparator(modifier = Modifier.padding(vertical = 4.dp))
                    }
                    MillenniumListTile(
                        title = {
                            MillenniumText(
                                item.label,
                                style = AppTheme.typography.bodyLarge,
                                color = if (item.enabled) {
                                    AppTheme.colors.onSurface
                                } else {
                                    AppTheme.colors.onSurface.copy(alpha = 0.38f)
                                }
                            )
                        },
                        subtitle = item.subtitle?.let { subtitle ->
                            {
                                MillenniumText(
                                    subtitle,
                                    style = AppTheme.typography.bodySmall,
                                    color = AppTheme.colors.onSurfaceVariant
                                )
                            }
                        },
                        leading = when {
                            item.leadingContent != null -> item.leadingContent
                            item.icon != null -> {
                                {
                                    MillenniumIcon(
                                        imageVector = item.icon,
                                        contentDescription = null,
                                        modifier = Modifier.size(22.dp)
                                    )
                                }
                            }
                            item.selected -> {
                                {
                                    MillenniumIcon(
                                        imageVector = FeatherIcons.Check,
                                        contentDescription = stringResource(Res.string.accessibility_selected),
                                        modifier = Modifier.size(22.dp)
                                    )
                                }
                            }
                            hasSelection -> {{ Spacer(modifier = Modifier.size(22.dp)) }}
                            else -> null
                        },
                        trailing = if (item.selected && (item.icon != null || item.leadingContent != null)) {
                            {
                                MillenniumIcon(
                                    imageVector = FeatherIcons.Check,
                                    contentDescription = stringResource(Res.string.accessibility_selected),
                                    modifier = Modifier.size(22.dp)
                                )
                            }
                        } else {
                            null
                        },
                        selected = item.selected,
                        enabled = item.enabled,
                        onClick = {
                            item.onClick()
                            onDismiss()
                        },
                        minimumHeight = 56.dp
                    )
                }
            }
        }
    }
}

@Preview
@Composable
private fun AdaptiveDropdownBottomSheetPreview() {
    Box(modifier = Modifier.background(AppTheme.colors.background)) {
        AdaptiveDropdownBottomSheet(
            items = listOf(
                AdaptiveMenuItem(
                    icon = Iconsax.IconsaxHeart,
                    label = "Favorite",
                    onClick = {}),
                AdaptiveMenuItem(
                    icon = Iconsax.IconsaxShare,
                    label = "Share",
                    onClick = {}),
                AdaptiveMenuItem(
                    icon = Iconsax.IconsaxTrash,
                    label = "Delete",
                    onClick = {},
                    enabled = false)),
            trigger = { onClick ->
                MillenniumIconButton(
                    onClick = onClick,
                    modifier = Modifier
                        .size(32.dp)
                        .background(
                            color = AppTheme.colors.primary.copy(alpha = 0.1f),
                            shape = CircleShape)
                        .clip(CircleShape),
                    style = MillenniumIconButtonStyle.Quiet) {
                    MillenniumIcon(
                        imageVector = Iconsax.Iconsax3DotsMore,
                        contentDescription = null,
                        tint = AppTheme.colors.primary)
                }
            })
    }
}
