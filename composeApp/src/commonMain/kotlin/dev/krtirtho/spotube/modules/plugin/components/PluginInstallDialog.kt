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

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MenuAnchorType
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
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
import dev.krtirtho.spotube.core.ui.base.PrimaryButton
import dev.krtirtho.spotube.core.ui.base.ThemedDialog
import dev.krtirtho.spotube.modules.plugin.GitHubRepo
import dev.krtirtho.spotube.modules.plugin.GitHubRelease
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxBox
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PluginInstallDialog(
    repo: GitHubRepo,
    releases: List<GitHubRelease>,
    isLoadingReleases: Boolean,
    onDismiss: () -> Unit,
    onInstall: (GitHubRelease) -> Unit,
) {
    var selectedRelease by remember { mutableStateOf<GitHubRelease?>(null) }
    var expanded by remember { mutableStateOf(false) }

    LaunchedEffect(releases) {
        if (selectedRelease == null && releases.isNotEmpty()) {
            selectedRelease = releases.first()
        }
    }

    ThemedDialog(
        onDismissRequest = onDismiss,
        title = {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Surface(
                    modifier = Modifier
                        .size(48.dp)
                        .clip(RoundedCornerShape(12.dp)),
                    color = MaterialTheme.colorScheme.primary.copy(alpha = 0.12f)
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
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.SemiBold,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                    if (!repo.description.isNullOrBlank()) {
                        Text(
                            repo.description,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            maxLines = 2,
                            overflow = TextOverflow.Ellipsis
                        )
                    }
                }
            }
        },
        actions = {
            PrimaryButton(
                onClick = { selectedRelease?.let { onInstall(it) } },
                enabled = selectedRelease != null && !isLoadingReleases
            ) {
                Text("Install")
            }
        }
    ) {
        Column(
            verticalArrangement = Arrangement.spacedBy(12.dp),
            modifier = Modifier.fillMaxWidth()
        ) {
            if (isLoadingReleases) {
                Box(
                    modifier = Modifier.fillMaxWidth().height(120.dp),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator(modifier = Modifier.size(32.dp))
                }
            } else if (releases.isEmpty()) {
                Text(
                    "No releases found",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            } else {
                Text(
                    "Select Release",
                    style = MaterialTheme.typography.labelMedium,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.onSurface
                )

                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = it }
                ) {
                    Surface(
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor(MenuAnchorType.PrimaryNotEditable),
                        shape = RoundedCornerShape(8.dp),
                        color = MaterialTheme.colorScheme.surfaceVariant
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                selectedRelease?.tagName ?: "Select a release",
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurface
                            )
                            ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded)
                        }
                    }

                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        releases.forEach { release ->
                            DropdownMenuItem(
                                text = {
                                    Column {
                                        Text(
                                            release.tagName,
                                            style = MaterialTheme.typography.bodyMedium,
                                            fontWeight = if (release == selectedRelease) FontWeight.SemiBold else FontWeight.Normal
                                        )
                                        if (release.prerelease) {
                                            Text(
                                                "Pre-release",
                                                style = MaterialTheme.typography.labelSmall,
                                                color = MaterialTheme.colorScheme.error
                                            )
                                        }
                                    }
                                },
                                onClick = {
                                    selectedRelease = release
                                    expanded = false
                                }
                            )
                        }
                    }
                }

                selectedRelease?.let { release ->
                    if (!release.body.isNullOrBlank()) {
                        Text(
                            "Release Notes",
                            style = MaterialTheme.typography.labelMedium,
                            fontWeight = FontWeight.SemiBold,
                            color = MaterialTheme.colorScheme.onSurface
                        )
                        Surface(
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(8.dp),
                            color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
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
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}
