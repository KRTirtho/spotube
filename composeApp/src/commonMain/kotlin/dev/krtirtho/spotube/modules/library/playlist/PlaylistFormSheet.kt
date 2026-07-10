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

package dev.krtirtho.spotube.modules.library.playlist

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.adaptive.currentWindowAdaptiveInfo
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import dev.krtirtho.spotube.core.ui.base.TextField
import io.github.vinceglb.filekit.dialogs.FileKitType
import io.github.vinceglb.filekit.dialogs.compose.rememberFilePickerLauncher
import io.github.vinceglb.filekit.readBytes
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okio.ByteString.Companion.toByteString

data class PlaylistFormData(
    val name: String = "",
    val description: String = "",
    val isPublic: Boolean = true,
    val isCollaborating: Boolean = false,
    val imageBase64: String = "",
    val imagePreviewUrl: String? = null,
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PlaylistFormSheet(
    visible: Boolean,
    onDismiss: () -> Unit,
    onSubmit: (PlaylistFormData) -> Unit,
    modifier: Modifier = Modifier,
    initialData: PlaylistFormData? = null,
    isEditing: Boolean = false,
    breakpointDp: Float = 600f,
) {
    if (!visible) return

    val adaptiveInfo = currentWindowAdaptiveInfo()
    val isLargeScreen = adaptiveInfo.windowSizeClass.minWidthDp >= breakpointDp

    var name by remember(initialData) { mutableStateOf(initialData?.name ?: "") }
    var description by remember(initialData) { mutableStateOf(initialData?.description ?: "") }
    var isPublic by remember(initialData) { mutableStateOf(initialData?.isPublic ?: true) }
    var isCollaborating by remember(initialData) { mutableStateOf(initialData?.isCollaborating ?: false) }
    var imageBase64 by remember(initialData) { mutableStateOf(initialData?.imageBase64 ?: "") }
    var imagePreviewUrl by remember(initialData) { mutableStateOf(initialData?.imagePreviewUrl) }

    val scope = rememberCoroutineScope()
    val imagePicker = rememberFilePickerLauncher(
        type = FileKitType.Image
    ) { file ->
        if (file != null) {
            scope.launch {
                val bytes = file.readBytes()
                val base64 = withContext(Dispatchers.Default) {
                    bytes.toByteString().base64()
                }
                imageBase64 = base64
                imagePreviewUrl = null
            }
        }
    }

    val currentData = PlaylistFormData(
        name = name,
        description = description,
        isPublic = isPublic,
        isCollaborating = isCollaborating,
        imageBase64 = imageBase64,
        imagePreviewUrl = imagePreviewUrl,
    )

    val handleImagePick = { imagePicker.launch() }

    if (isLargeScreen) {
        AlertDialog(
            onDismissRequest = onDismiss,
            modifier = modifier,
            title = {
                Text(if (isEditing) "Edit Playlist" else "Create Playlist")
            },
            text = {
                PlaylistFormFields(
                    name = name,
                    onNameChange = { name = it },
                    description = description,
                    onDescriptionChange = { description = it },
                    isPublic = isPublic,
                    onIsPublicChange = { isPublic = it },
                    isCollaborating = isCollaborating,
                    onIsCollaboratingChange = { isCollaborating = it },
                    imageBase64 = imageBase64,
                    imagePreviewUrl = imagePreviewUrl,
                    onPickImage = handleImagePick,
                )
            },
            confirmButton = {
                TextButton(
                    onClick = {
                        onSubmit(currentData)
                        onDismiss()
                    },
                    enabled = name.isNotBlank(),
                ) {
                    Text(if (isEditing) "Save" else "Create")
                }
            },
            dismissButton = {
                TextButton(onClick = onDismiss) {
                    Text("Cancel")
                }
            },
        )
    } else {
        ModalBottomSheet(
            onDismissRequest = onDismiss,
            dragHandle = null,
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp),
            ) {
                Text(
                    text = if (isEditing) "Edit Playlist" else "Create Playlist",
                    style = MaterialTheme.typography.headlineSmall,
                    modifier = Modifier.padding(bottom = 16.dp),
                )
                PlaylistFormFields(
                    name = name,
                    onNameChange = { name = it },
                    description = description,
                    onDescriptionChange = { description = it },
                    isPublic = isPublic,
                    onIsPublicChange = { isPublic = it },
                    isCollaborating = isCollaborating,
                    onIsCollaboratingChange = { isCollaborating = it },
                    imageBase64 = imageBase64,
                    imagePreviewUrl = imagePreviewUrl,
                    onPickImage = handleImagePick,
                )
                Spacer(modifier = Modifier.height(12.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp, Alignment.End),
                ) {
                    TextButton(onClick = onDismiss) {
                        Text("Cancel")
                    }
                    TextButton(
                        onClick = {
                            onSubmit(currentData)
                            onDismiss()
                        },
                        enabled = name.isNotBlank(),
                    ) {
                        Text(if (isEditing) "Save" else "Create")
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
            }
        }
    }
}

@Composable
private fun PlaylistFormFields(
    name: String,
    onNameChange: (String) -> Unit,
    description: String,
    onDescriptionChange: (String) -> Unit,
    isPublic: Boolean,
    onIsPublicChange: (Boolean) -> Unit,
    isCollaborating: Boolean,
    onIsCollaboratingChange: (Boolean) -> Unit,
    imageBase64: String,
    imagePreviewUrl: String?,
    onPickImage: () -> Unit,
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        TextField(
            value = name,
            onValueChange = onNameChange,
            modifier = Modifier.fillMaxWidth(),
            placeholder = { Text("Playlist name") },
            singleLine = true,
            label = { Text("Name") },
        )

        TextField(
            value = description,
            onValueChange = onDescriptionChange,
            modifier = Modifier.fillMaxWidth(),
            placeholder = { Text("Description (optional)") },
            maxLines = 3,
            label = { Text("Description") },
        )

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(12.dp))
                .clickable { onIsPublicChange(!isPublic) }
                .padding(horizontal = 4.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text("Public", style = MaterialTheme.typography.bodyLarge)
                Text(
                    "Anyone can see this playlist",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            Switch(checked = isPublic, onCheckedChange = onIsPublicChange)
        }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(12.dp))
                .clickable { onIsCollaboratingChange(!isCollaborating) }
                .padding(horizontal = 4.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text("Collaborative", style = MaterialTheme.typography.bodyLarge)
                Text(
                    "Others can add tracks to this playlist",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            Switch(checked = isCollaborating, onCheckedChange = onIsCollaboratingChange)
        }

        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Text("Cover Image", style = MaterialTheme.typography.bodyLarge)
            Row(
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Box(
                    modifier = Modifier
                        .size(64.dp)
                        .clip(RoundedCornerShape(8.dp)),
                    contentAlignment = Alignment.Center,
                ) {
                    when {
                        imagePreviewUrl != null -> AsyncImage(
                            model = imagePreviewUrl,
                            contentDescription = "Playlist cover",
                            modifier = Modifier.size(64.dp),
                            contentScale = ContentScale.Crop,
                        )
                        imageBase64.isNotBlank() -> {
                            Text(
                                "✓",
                                style = MaterialTheme.typography.titleMedium,
                                color = MaterialTheme.colorScheme.primary,
                            )
                        }
                        else -> {
                            Text(
                                "No image",
                                style = MaterialTheme.typography.labelSmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    }
                }
                TextButton(onClick = onPickImage) {
                    Text(if (imageBase64.isNotBlank() || imagePreviewUrl != null) "Change Image" else "Pick Image")
                }
            }
        }
    }
}
