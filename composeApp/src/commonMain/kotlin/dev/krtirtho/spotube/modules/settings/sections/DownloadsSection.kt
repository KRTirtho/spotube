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

package dev.krtirtho.spotube.modules.settings.sections

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import compose.icons.FeatherIcons
import compose.icons.feathericons.Disc
import compose.icons.feathericons.Folder
import compose.icons.feathericons.PlusSquare
import compose.icons.feathericons.Sliders
import compose.icons.feathericons.Trash2
import spotube.composeapp.generated.resources.*
import dev.krtirtho.spotube.modules.settings.SettingsViewModel
import dev.krtirtho.spotube.modules.settings.UserSettings
import dev.krtirtho.spotube.modules.settings.components.SettingCardItem
import dev.krtirtho.spotube.modules.settings.components.SelectionSettingCard
import io.github.vinceglb.filekit.path
import io.github.vinceglb.filekit.dialogs.compose.rememberDirectoryPickerLauncher
import org.jetbrains.compose.resources.stringResource

internal fun LazyListScope.downloadsSection(
    settings: UserSettings,
    settingsViewModel: SettingsViewModel,
) {
    val downloadFormats = availableAudioFormats(settings.downloadMusicFormat, downloadFormatPresets)
    val downloadQualities = availableAudioQualities(
        format = settings.downloadMusicFormat,
        current = settings.downloadMusicQuality,
    )

    settingsSectionHeader(Res.string.settings_section_downloads)

    item {
        DownloadFolderSettingCard(
            folder = settings.overloadedDownloadFolder,
            onFolderSelected = { folder ->
                settingsViewModel.updateSettings {
                    copy(overloadedDownloadFolder = folder)
                }
            }
        )
    }

    item {
        LocalMediaFoldersSettingCard(
            folders = settings.localMediaFolders,
            onFoldersSaved = { folders ->
                settingsViewModel.updateSettings {
                    copy(localMediaFolders = folders)
                }
            }
        )
    }

    item {
        SelectionSettingCard(
            title = stringResource(Res.string.settings_download_format_title),
            subtitle = stringResource(
                Res.string.settings_download_format_subtitle_current,
                settings.downloadMusicFormat.displayLabel()
            ),
            icon = {
                SettingsItemIcon(FeatherIcons.Disc, stringResource(Res.string.settings_download_format_title))
            },
            selectedOption = settings.downloadMusicFormat,
            options = downloadFormats,
            optionLabel = { it.displayLabel() },
            onOptionSelected = { format ->
                settingsViewModel.updateSettings {
                    copy(
                        downloadMusicFormat = format,
                        downloadMusicQuality = format.resolveQuality(downloadMusicQuality),
                    )
                }
            }
        )
    }

    item {
        SelectionSettingCard(
            title = stringResource(Res.string.settings_download_quality_title),
            subtitle = stringResource(
                Res.string.settings_subtitle_current,
                settings.downloadMusicQuality.displayLabel()
            ),
            icon = {
                SettingsItemIcon(FeatherIcons.Sliders, stringResource(Res.string.settings_download_quality_title))
            },
            selectedOption = settings.downloadMusicQuality,
            options = downloadQualities,
            optionLabel = { it.displayLabel() },
            onOptionSelected = { quality ->
                settingsViewModel.updateSettings {
                    copy(downloadMusicQuality = quality)
                }
            }
        )
    }
}

@Composable
private fun DownloadFolderSettingCard(
    folder: String?,
    onFolderSelected: (String?) -> Unit,
) {
    val pickerLauncher = rememberDirectoryPickerLauncher { directory ->
        if (directory != null) {
            val normalized = normalizePath(directory.path)
            if (normalized.isNotEmpty()) {
                onFolderSelected(normalized)
            }
        }
    }

    SettingCardItem(
        title = stringResource(Res.string.settings_download_folder_title),
        subtitle = folder?.let {
            stringResource(Res.string.settings_download_folder_current, it)
        } ?: stringResource(Res.string.settings_download_folder_default),
        icon = {
            SettingsItemIcon(FeatherIcons.Folder, stringResource(Res.string.settings_download_folder_title))
        },
        trailingContent = {
            IconButton(onClick = { pickerLauncher.launch() }) {
                Icon(
                    FeatherIcons.Folder,
                    contentDescription = stringResource(Res.string.settings_download_folder_title)
                )
            }
        },
        onClick = {
            pickerLauncher.launch()
        }
    )
}

@Composable
private fun LocalMediaFoldersSettingCard(
    folders: List<String>,
    onFoldersSaved: (List<String>) -> Unit,
) {
    var isDialogOpen by remember { mutableStateOf(false) }

    val subtitlePreview = when {
        folders.isEmpty() -> stringResource(Res.string.settings_local_media_folders_subtitle_empty)
        folders.size == 1 -> folders.first()
        else -> stringResource(
            Res.string.settings_local_media_folders_subtitle_current,
            folders.size,
        )
    }

    SettingCardItem(
        title = stringResource(Res.string.settings_local_media_folders_title),
        subtitle = subtitlePreview,
        icon = {
            SettingsItemIcon(
                FeatherIcons.Folder,
                stringResource(Res.string.settings_local_media_folders_title),
            )
        },
        trailingContent = {
            TextButton(onClick = { isDialogOpen = true }) {
                Text(stringResource(Res.string.settings_local_media_folders_manage))
            }
        },
        onClick = {
            isDialogOpen = true
        }
    )

    if (isDialogOpen) {
        LocalMediaFoldersDialog(
            folders = folders,
            onDismiss = { isDialogOpen = false },
            onFoldersSaved = onFoldersSaved,
        )
    }
}

@Composable
private fun LocalMediaFoldersDialog(
    folders: List<String>,
    onDismiss: () -> Unit,
    onFoldersSaved: (List<String>) -> Unit,
) {
    val draftFolders = remember(folders) {
        mutableStateListOf<String>().apply { addAll(folders) }
    }
    val pickerLauncher = rememberDirectoryPickerLauncher { directory ->
        if (directory != null) {
            val normalized = normalizePath(directory.path)
            if (normalized.isNotEmpty() && draftFolders.none { normalizePath(it) == normalized }) {
                draftFolders.add(normalized)
            }
        }
    }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(stringResource(Res.string.settings_local_media_folders_title))
        },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.verticalScroll(rememberScrollState()),
            ) {
                Text(
                    text = stringResource(Res.string.settings_local_media_folders_description),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )

                TextButton(onClick = { pickerLauncher.launch() }) {
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(8.dp),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Icon(FeatherIcons.PlusSquare, contentDescription = null)
                        Text(stringResource(Res.string.settings_local_media_folders_add_action))
                    }
                }

                if (draftFolders.isEmpty()) {
                    Box(modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp)) {
                        Text(
                            text = stringResource(Res.string.settings_local_media_folders_none_added),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                } else {
                    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                        draftFolders.forEachIndexed { index, folder ->
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                verticalAlignment = Alignment.CenterVertically,
                            ) {
                                Text(
                                    text = folder,
                                    modifier = Modifier.weight(1f),
                                    maxLines = 2,
                                    overflow = TextOverflow.Ellipsis,
                                    style = MaterialTheme.typography.bodySmall,
                                )
                                IconButton(
                                    onClick = {
                                        if (index in draftFolders.indices) {
                                            draftFolders.removeAt(index)
                                        }
                                    }
                                ) {
                                    Icon(
                                        imageVector = FeatherIcons.Trash2,
                                        contentDescription = stringResource(
                                            Res.string.settings_local_media_folders_remove_action,
                                        ),
                                    )
                                }
                            }
                        }
                    }
                }
            }
        },
        confirmButton = {
            TextButton(
                onClick = {
                    onFoldersSaved(draftFolders.map(::normalizePath).filter { it.isNotBlank() }.distinct())
                    onDismiss()
                }
            ) {
                Text(stringResource(Res.string.settings_action_save))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text(stringResource(Res.string.settings_action_cancel))
            }
        }
    )
}

