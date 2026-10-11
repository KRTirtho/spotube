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


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import org.spotube.millennium.composables.MillenniumModalBottomSheet
import org.spotube.millennium.composables.MillenniumSeparator
import org.spotube.millennium.composables.MillenniumTextField
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.hoverable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsHoveredAsState
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.DropdownMenuPanel
import com.composeunstyled.SheetDetent
import com.composeunstyled.Text
import com.composeunstyled.UnstyledDropdownMenu
import com.composeunstyled.UnstyledDropdownMenuItem
import com.composeunstyled.rememberModalBottomSheetState
import org.spotube.millennium.adaptive.currentWindowAdaptiveInfo
import org.spotube.millennium.theme.MillenniumTheme
import org.spotube.millennium.theme.gelBrush
import org.spotube.millennium.theme.millenniumPanelBrush
import org.spotube.millennium.theme.millenniumSurface
import androidx.compose.foundation.text.input.rememberTextFieldState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.dp
import compose.icons.FeatherIcons
import compose.icons.feathericons.Check
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.Iconsax3DotsMore
import dev.krtirtho.spotube.resources.iconsax.IconsaxFilterSearch
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart
import dev.krtirtho.spotube.resources.iconsax.IconsaxShare
import dev.krtirtho.spotube.resources.iconsax.IconsaxTrash

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
    breakpointDp: Float = 600f,
    menuMinWidth: Dp = 200.dp,
    header: @Composable (() -> Unit)? = null,
    headerDisplayMode: HeaderDisplayMode = HeaderDisplayMode.Always,
    filter: ((AdaptiveMenuItem, String) -> Boolean)? = null) {
    var expanded by remember { mutableStateOf(false) }
    val adaptiveInfo = currentWindowAdaptiveInfo()
    val isLargeScreen = adaptiveInfo.windowSizeClass.minWidthDp >= breakpointDp

    Box(modifier = modifier) {
        if (isLargeScreen) {
            UnstyledDropdownMenu(
                expanded = expanded,
                onExpandedChange = { expanded = it },
                panel = {
                DropdownMenuPanel(
                    Modifier
                        .width(menuMinWidth)
                        .millenniumSurface(
                            background = millenniumPanelBrush(MillenniumTheme.colors),
                            shape = AppTheme.shapes.medium,
                            borderColor = AppTheme.colors.outlineVariant,
                            borderWidth = 1.dp)
                        .padding(4.dp)) {
                    if (header != null && (headerDisplayMode == HeaderDisplayMode.Always || headerDisplayMode == HeaderDisplayMode.OnlyInDropdown)) {
                        header()
                    }

                    val dropdownQueryState = rememberTextFieldState()
                    val query = dropdownQueryState.text.toString()
                    if (filter != null) {
                        MillenniumTextField(
                            state = dropdownQueryState,
                            label = "",
                            placeholder = "Search...",
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(horizontal = 12.dp, vertical = 8.dp))
                    }

                    items.forEach { item ->
                        if (query.isNotBlank() && filter != null && !filter(item, query)) {
                            return@forEach
                        }
                        if (item.dividerBefore) {
                            MillenniumSeparator(modifier = Modifier.padding(vertical = 4.dp))
                        }
                        val itemInteraction = remember { MutableInteractionSource() }
                        val itemHovered by itemInteraction.collectIsHoveredAsState()
                        val itemPressed by itemInteraction.collectIsPressedAsState()
                        val itemEnabled = item.enabled
                        val itemHighlighted = itemEnabled && (itemHovered || itemPressed || item.selected)
                        val itemForeground = when {
                            !itemEnabled -> AppTheme.colors.onSurface.copy(alpha = 0.38f)
                            itemHighlighted -> MillenniumTheme.colors.onAccent
                            else -> AppTheme.colors.onSurface
                        }
                        UnstyledDropdownMenuItem(
                            onClick = { item.onClick() },
                            enabled = itemEnabled,
                            indication = null,
                            interactionSource = itemInteraction) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .then(
                                        if (itemHighlighted) {
                                            Modifier.millenniumSurface(
                                                background = gelBrush(
                                                    MillenniumTheme.colors.accentTop,
                                                    MillenniumTheme.colors.accentBottom),
                                                shape = RoundedCornerShape(8.dp))
                                        } else {
                                            Modifier
                                        })
                                    .padding(horizontal = 12.dp, vertical = 8.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                                val itemIcon = item.icon
                                when {
                                    item.leadingContent != null -> item.leadingContent.invoke()
                                    itemIcon != null -> MillenniumIcon(
                                        imageVector = itemIcon,
                                        contentDescription = null,
                                        tint = itemForeground,
                                        modifier = Modifier.size(20.dp))

                                    item.selected -> MillenniumIcon(
                                        imageVector = FeatherIcons.Check,
                                        contentDescription = "Selected",
                                        tint = itemForeground,
                                        modifier = Modifier.size(20.dp))
                                }
                                Column(modifier = Modifier.weight(1f)) {
                                    Text(
                                        text = item.label,
                                        style = AppTheme.typography.bodyMedium,
                                        color = itemForeground)
                                    item.subtitle?.let { subtitle ->
                                        Text(
                                            text = subtitle,
                                            style = AppTheme.typography.bodySmall,
                                            color = if (itemHighlighted) {
                                                itemForeground.copy(alpha = 0.85f)
                                            } else {
                                                AppTheme.colors.onSurfaceVariant
                                            })
                                    }
                                }
                                if (item.selected && (item.icon != null || item.leadingContent != null)) {
                                    MillenniumIcon(
                                        imageVector = FeatherIcons.Check,
                                        contentDescription = "Selected",
                                        tint = itemForeground,
                                        modifier = Modifier.size(20.dp))
                                }
                            }
                        }
                    }
                }
            },
            anchor = { trigger { expanded = true } },
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
                    placeholder = "Search...",
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
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(AppTheme.shapes.medium)
                            .clickable(
                                enabled = item.enabled,
                                onClick = {
                                    item.onClick()
                                    onDismiss()
                                })
                            .background(
                                color = if (item.selected) {
                                    AppTheme.colors.secondary.copy(alpha = 0.12f)
                                } else {
                                    Color.Transparent
                                },
                                shape = AppTheme.shapes.medium)
                            .padding(horizontal = 12.dp, vertical = 14.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                        when {
                            item.leadingContent != null -> item.leadingContent.invoke()
                            item.icon != null -> MillenniumIcon(
                                imageVector = item.icon,
                                contentDescription = null,
                                modifier = Modifier.size(22.dp),
                                tint = if (item.enabled) {
                                    AppTheme.colors.onSurface
                                } else {
                                    AppTheme.colors.onSurface.copy(alpha = 0.38f)
                                })

                            item.selected -> MillenniumIcon(
                                imageVector = FeatherIcons.Check,
                                contentDescription = "Selected",
                                modifier = Modifier.size(22.dp),
                                tint = AppTheme.colors.onSurfaceVariant)

                            hasSelection -> Spacer(modifier = Modifier.size(22.dp))
                        }

                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = item.label,
                                style = AppTheme.typography.bodyLarge,
                                color = if (item.enabled) {
                                    AppTheme.colors.onSurface
                                } else {
                                    AppTheme.colors.onSurface.copy(alpha = 0.38f)
                                })
                            item.subtitle?.let { subtitle ->
                                Text(
                                    text = subtitle,
                                    style = AppTheme.typography.bodySmall,
                                    color = AppTheme.colors.onSurfaceVariant)
                            }
                        }

                        if (item.selected && (item.icon != null || item.leadingContent != null)) {
                            MillenniumIcon(
                                imageVector = FeatherIcons.Check,
                                contentDescription = "Selected",
                                modifier = Modifier.size(22.dp),
                                tint = AppTheme.colors.onSurfaceVariant)
                        }
                    }
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
