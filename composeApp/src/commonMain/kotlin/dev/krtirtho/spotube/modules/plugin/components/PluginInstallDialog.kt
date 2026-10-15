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

package dev.krtirtho.spotube.modules.plugin.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll

import dev.krtirtho.spotube.core.ui.theming.AppTheme

import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import coil3.compose.LocalPlatformContext
import coil3.request.ImageRequest
import coil3.request.crossfade
import dev.krtirtho.spotube.modules.plugin.GitHubRepo
import dev.krtirtho.spotube.modules.plugin.GitHubRelease
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxArrowDown4
import dev.krtirtho.spotube.resources.iconsax.IconsaxBox
import org.jetbrains.compose.resources.stringResource
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumDialog
import org.spotube.millennium.composables.MillenniumDropdownMenu
import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIndeterminateProgress
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.plugin_action_install
import spotube.composeapp.generated.resources.plugin_install_no_releases
import spotube.composeapp.generated.resources.plugin_install_prerelease
import spotube.composeapp.generated.resources.plugin_install_release_notes
import spotube.composeapp.generated.resources.plugin_install_select_release_label
import spotube.composeapp.generated.resources.plugin_install_select_release_placeholder

@Composable
fun PluginInstallDialog(
    repo: GitHubRepo,
    releases: List<GitHubRelease>,
    isLoadingReleases: Boolean,
    onDismiss: () -> Unit,
    onInstall: (GitHubRelease) -> Unit) {
    var selectedRelease by remember { mutableStateOf<GitHubRelease?>(null) }
    var expanded by remember { mutableStateOf(false) }

    LaunchedEffect(releases) {
        if (selectedRelease == null && releases.isNotEmpty()) {
            selectedRelease = releases.first()
        }
    }

    MillenniumDialog(
        visible = true,
        onDismissRequest = onDismiss,
        title = repo.fullName) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(AppTheme.colors.primary.copy(alpha = 0.12f))
            ) {
                Box(contentAlignment = Alignment.Center) {
                    val platformContext = LocalPlatformContext.current
                    AsyncImage(
                        model = ImageRequest.Builder(platformContext)
                            .data(repo.owner.avatarUrl)
                            .crossfade(true)
                            .build(),
                        contentDescription = repo.owner.login,
                        modifier = Modifier.fillMaxSize()
                    )
                }
            }
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    repo.fullName,
                    style = AppTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                if (!repo.description.isNullOrBlank()) {
                    Text(
                        repo.description,
                        style = AppTheme.typography.bodySmall,
                        color = AppTheme.colors.onSurfaceVariant,
                        maxLines = 2,
                        overflow = TextOverflow.Ellipsis
                    )
                }
            }
        }

        if (isLoadingReleases) {
            Box(
                modifier = Modifier.fillMaxWidth().height(120.dp),
                contentAlignment = Alignment.Center
            ) {
                MillenniumIndeterminateProgress(modifier = Modifier.widthIn(max = 160.dp))
            }
        } else if (releases.isEmpty()) {
            Text(
                stringResource(Res.string.plugin_install_no_releases),
                style = AppTheme.typography.bodyMedium,
                color = AppTheme.colors.onSurfaceVariant
            )
        } else {
            Text(
                stringResource(Res.string.plugin_install_select_release_label),
                style = AppTheme.typography.labelMedium,
                fontWeight = FontWeight.SemiBold,
                color = AppTheme.colors.onSurface
            )

            MillenniumDropdownMenu(
                expanded = expanded,
                onExpandedChange = { expanded = it },
                items = releases.map { it.tagName },
                onItemClick = { tagName ->
                    selectedRelease = releases.firstOrNull { it.tagName == tagName }
                    expanded = false
                },
                modifier = Modifier.fillMaxWidth(),
                anchor = {
                    MillenniumButton(
                        onClick = { expanded = true },
                        modifier = Modifier.fillMaxWidth(),
                        style = MillenniumButtonStyle.Secondary
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                selectedRelease?.tagName
                                    ?: stringResource(Res.string.plugin_install_select_release_placeholder),
                                style = AppTheme.typography.bodyMedium
                            )
                            MillenniumIcon(
                                imageVector = Iconsax.IconsaxArrowDown4,
                                contentDescription = null,
                                modifier = Modifier.size(16.dp)
                            )
                        }
                    }
                }
            )

            selectedRelease?.let { release ->
                if (release.prerelease) {
                    Text(
                        stringResource(Res.string.plugin_install_prerelease),
                        style = AppTheme.typography.labelSmall,
                        color = AppTheme.colors.error
                    )
                }
                if (!release.body.isNullOrBlank()) {
                    Text(
                        stringResource(Res.string.plugin_install_release_notes),
                        style = AppTheme.typography.labelMedium,
                        fontWeight = FontWeight.SemiBold,
                        color = AppTheme.colors.onSurface
                    )
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(8.dp))
                            .background(AppTheme.colors.surfaceVariant.copy(alpha = 0.5f))
                    ) {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .heightIn(max = 200.dp)
                                .verticalScroll(rememberScrollState())
                                .padding(12.dp)
                        ) {
                            Text(
                                release.body,
                                style = AppTheme.typography.bodySmall,
                                color = AppTheme.colors.onSurfaceVariant
                            )
                        }
                    }
                }
            }
        }

        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            MillenniumButton(
                onClick = { selectedRelease?.let { onInstall(it) } },
                enabled = selectedRelease != null && !isLoadingReleases
            ) {
                Text(stringResource(Res.string.plugin_action_install))
            }
        }
    }
}
