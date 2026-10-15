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
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumDialog
import org.spotube.millennium.composables.MillenniumModalBottomSheet
import org.spotube.millennium.composables.MillenniumSwitch
import org.spotube.millennium.composables.MillenniumTextField
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

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.SheetDetent
import com.composeunstyled.Text
import com.composeunstyled.rememberModalBottomSheetState
import com.composeunstyled.currentWindowWidthBreakpoint
import org.spotube.millennium.adaptive.WindowBreakpoints
import androidx.compose.foundation.text.input.TextFieldState
import androidx.compose.foundation.text.input.rememberTextFieldState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import io.github.vinceglb.filekit.dialogs.FileKitType
import io.github.vinceglb.filekit.dialogs.compose.rememberFilePickerLauncher
import io.github.vinceglb.filekit.readBytes
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.drop
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okio.ByteString.Companion.toByteString

data class PlaylistFormData(
    val name: String = "",
    val description: String = "",
    val isPublic: Boolean = true,
    val isCollaborating: Boolean = false,
    val imageBase64: String = "",
    val imagePreviewUrl: String? = null
)

@Composable
fun PlaylistFormSheet(
    visible: Boolean,
    onDismiss: () -> Unit,
    onSubmit: (PlaylistFormData) -> Unit,
    modifier: Modifier = Modifier,
    initialData: PlaylistFormData? = null,
    isEditing: Boolean = false
) {
    if (!visible) return

    val isLargeScreen = currentWindowWidthBreakpoint() isAtLeast WindowBreakpoints.Medium

    var name by remember(initialData) { mutableStateOf(initialData?.name ?: "") }
    var description by remember(initialData) { mutableStateOf(initialData?.description ?: "") }
    var isPublic by remember(initialData) { mutableStateOf(initialData?.isPublic ?: true) }
    var isCollaborating by remember(initialData) {
        mutableStateOf(
            initialData?.isCollaborating ?: false
        )
    }
    var imageBase64 by remember(initialData) { mutableStateOf(initialData?.imageBase64 ?: "") }
    var imagePreviewUrl by remember(initialData) { mutableStateOf(initialData?.imagePreviewUrl) }

    val nameState = rememberTextFieldState(initialData?.name ?: "")
    val descriptionState = rememberTextFieldState(initialData?.description ?: "")

    LaunchedEffect(nameState) {
        snapshotFlow { nameState.text.toString() }
            .drop(1)
            .collect { name = it }
    }
    LaunchedEffect(descriptionState) {
        snapshotFlow { descriptionState.text.toString() }
            .drop(1)
            .collect { description = it }
    }

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
        imagePreviewUrl = imagePreviewUrl
    )

    val handleImagePick = { imagePicker.launch() }

    if (isLargeScreen) {
        MillenniumDialog(
            visible = true,
            onDismissRequest = onDismiss,
            title = if (isEditing) "Edit Playlist" else "Create Playlist",
            modifier = modifier
        ) {
            PlaylistFormFields(
                nameState = nameState,
                descriptionState = descriptionState,
                isPublic = isPublic,
                onIsPublicChange = { isPublic = it },
                isCollaborating = isCollaborating,
                onIsCollaboratingChange = { isCollaborating = it },
                imageBase64 = imageBase64,
                imagePreviewUrl = imagePreviewUrl,
                onPickImage = handleImagePick
            )
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                MillenniumButton(
                    onClick = {
                        onSubmit(currentData)
                        onDismiss()
                    },
                    enabled = name.isNotBlank()
                ) {
                    Text(if (isEditing) "Save" else "Create")
                }
                MillenniumButton(
                    onClick = onDismiss,
                    style = MillenniumButtonStyle.Secondary
                ) {
                    Text("Cancel")
                }
            }
        }
    } else {
        val sheetState = rememberModalBottomSheetState(initialDetent = SheetDetent.FullyExpanded)
        MillenniumModalBottomSheet(state = sheetState) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            ) {
                Text(
                    text = if (isEditing) "Edit Playlist" else "Create Playlist",
                    style = AppTheme.typography.headlineSmall,
                    modifier = Modifier.padding(bottom = 16.dp)
                )
                PlaylistFormFields(
                    nameState = nameState,
                    descriptionState = descriptionState,
                    isPublic = isPublic,
                    onIsPublicChange = { isPublic = it },
                    isCollaborating = isCollaborating,
                    onIsCollaboratingChange = { isCollaborating = it },
                    imageBase64 = imageBase64,
                    imagePreviewUrl = imagePreviewUrl,
                    onPickImage = handleImagePick
                )
                Spacer(modifier = Modifier.height(12.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp, Alignment.End)
                ) {
                    MillenniumButton(
                        onClick = onDismiss,
                        style = MillenniumButtonStyle.Secondary
                    ) {
                        Text("Cancel")
                    }
                    MillenniumButton(
                        onClick = {
                            onSubmit(currentData)
                            onDismiss()
                        },
                        enabled = name.isNotBlank()
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
    nameState: TextFieldState,
    descriptionState: TextFieldState,
    isPublic: Boolean,
    onIsPublicChange: (Boolean) -> Unit,
    isCollaborating: Boolean,
    onIsCollaboratingChange: (Boolean) -> Unit,
    imageBase64: String,
    imagePreviewUrl: String?,
    onPickImage: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        MillenniumTextField(
            state = nameState,
            label = "Name",
            modifier = Modifier.fillMaxWidth(),
            placeholder = "Playlist name"
        )

        MillenniumTextField(
            state = descriptionState,
            label = "Description",
            modifier = Modifier.fillMaxWidth(),
            placeholder = "Description (optional)"
        )

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(12.dp))
                .clickable { onIsPublicChange(!isPublic) }
                .padding(horizontal = 4.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically) {
            Column(modifier = Modifier.weight(1f)) {
                Text("Public", style = AppTheme.typography.bodyLarge)
                Text(
                    "Anyone can see this playlist",
                    style = AppTheme.typography.bodySmall,
                    color = AppTheme.colors.onSurfaceVariant
                )
            }
            MillenniumSwitch(checked = isPublic, onCheckedChange = onIsPublicChange)
        }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(12.dp))
                .clickable { onIsCollaboratingChange(!isCollaborating) }
                .padding(horizontal = 4.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically) {
            Column(modifier = Modifier.weight(1f)) {
                Text("Collaborative", style = AppTheme.typography.bodyLarge)
                Text(
                    "Others can add tracks to this playlist",
                    style = AppTheme.typography.bodySmall,
                    color = AppTheme.colors.onSurfaceVariant
                )
            }
            MillenniumSwitch(checked = isCollaborating, onCheckedChange = onIsCollaboratingChange)
        }

        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text("Cover Image", style = AppTheme.typography.bodyLarge)
            Row(
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(64.dp)
                        .clip(RoundedCornerShape(8.dp)),
                    contentAlignment = Alignment.Center
                ) {
                    when {
                        imagePreviewUrl != null -> AsyncImage(
                            model = imagePreviewUrl,
                            contentDescription = "Playlist cover",
                            modifier = Modifier.size(64.dp),
                            contentScale = ContentScale.Crop
                        )

                        imageBase64.isNotBlank() -> {
                            Text(
                                "✓",
                                style = AppTheme.typography.titleMedium,
                                color = AppTheme.colors.primary
                            )
                        }

                        else -> {
                            Text(
                                "No image",
                                style = AppTheme.typography.labelSmall,
                                color = AppTheme.colors.onSurfaceVariant
                            )
                        }
                    }
                }
                MillenniumButton(onClick = onPickImage) {
                    Text(if (imageBase64.isNotBlank() || imagePreviewUrl != null) "Change Image" else "Pick Image")
                }
            }
        }
    }
}
