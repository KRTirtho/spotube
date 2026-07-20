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

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.adaptive.currentWindowAdaptiveInfo
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import dev.krtirtho.spotube.core.ui.base.IconButton
import dev.krtirtho.spotube.core.ui.base.ThemedDialog
import dev.krtirtho.spotube.resources.iconsax.FluentDismiss
import dev.krtirtho.spotube.resources.iconsax.Iconsax

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdaptiveDialogBottomSheet(
    onDismiss: () -> Unit,
    title: @Composable (() -> Unit)? = null,
    modifier: Modifier = Modifier,
    breakpointDp: Float = 600f,
    actions: @Composable (() -> Unit)? = null,
    content: @Composable () -> Unit,
) {
    val adaptiveInfo = currentWindowAdaptiveInfo()
    val isLargeScreen = adaptiveInfo.windowSizeClass.minWidthDp >= breakpointDp

    if (isLargeScreen) {
        ThemedDialog(
            onDismissRequest = onDismiss,
            title = if (title != null) {
                {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(Modifier.weight(1f)) { title() }
                        IconButton(onClick = onDismiss) {
                            Icon(
                                Iconsax.FluentDismiss,
                                contentDescription = "Close dialog",
                            )
                        }
                    }
                }
            } else {
                null
            },
            actions = actions,
            modifier = modifier,
        ) {
            content()
        }
    } else {
        ModalBottomSheet(
            onDismissRequest = onDismiss,
            dragHandle = null,
            modifier = modifier,
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .padding(top = 16.dp),
                horizontalAlignment = Alignment.Start,
            ) {
                title?.let {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(Modifier.weight(1f)) { it() }
                        IconButton(onClick = onDismiss) {
                            Icon(
                                Iconsax.FluentDismiss,
                                contentDescription = "Close dialog",
                            )
                        }
                    }
                    Spacer(Modifier.height(12.dp))
                }
                content()
                actions?.let {
                    Spacer(Modifier.height(8.dp))
                    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f))
                    Spacer(Modifier.height(8.dp))
                    it()
                }
            }
            Spacer(Modifier.height(24.dp))
        }
    }
}
