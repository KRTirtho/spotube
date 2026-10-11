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

package dev.krtirtho.spotube.modules.shell


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumDialog
import org.spotube.millennium.composables.MillenniumIndeterminateProgress
import org.spotube.millennium.composables.MillenniumTextField
import org.spotube.millennium.theme.millenniumSurface
import androidx.compose.foundation.text.input.rememberTextFieldState
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions

import dev.krtirtho.spotube.core.ui.theming.AppTheme

import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioStream
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxCheckCircle
import dev.krtirtho.spotube.resources.iconsax.IconsaxDirectboxReceive
import dev.krtirtho.spotube.core.server.CacheEntry

@Composable
fun PlayerOptionDialogs(viewModel: PlayerOptionsViewModel) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    if (uiState.isSleepTimerDialogOpen) {
        SleepTimerDialog(
            minutes = uiState.sleepTimerMinutes,
            remainingMs = uiState.sleepTimerRemainingMs,
            onMinutesChange = viewModel::updateSleepTimerMinutes,
            onStart = viewModel::startSleepTimer,
            onCancelTimer = viewModel::cancelSleepTimer,
            onDismiss = viewModel::dismissSleepTimerDialog)
    }

    uiState.trackDetails?.let { details ->
        TrackDetailsDialog(
            details = details,
            onDismiss = viewModel::dismissTrackDetails)
    }
}

@Composable
private fun SleepTimerDialog(
    minutes: String,
    remainingMs: Long?,
    onMinutesChange: (String) -> Unit,
    onStart: () -> Unit,
    onCancelTimer: () -> Unit,
    onDismiss: () -> Unit) {
    MillenniumDialog(
        visible = true,
        onDismissRequest = onDismiss,
        title = "Sleep timer") {
        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            if (remainingMs != null) {
                Text(
                    text = "Playback will pause in ${formatRemainingTime(remainingMs)}.",
                    style = AppTheme.typography.bodyMedium,
                    color = AppTheme.colors.primary)
            } else {
                Text(
                    text = "Pause playback after the selected number of minutes.",
                    style = AppTheme.typography.bodyMedium)
            }
            val minutesState = rememberTextFieldState(minutes)
            LaunchedEffect(minutesState.text) {
                onMinutesChange(minutesState.text.toString())
            }
            MillenniumTextField(
                state = minutesState,
                label = "Minutes",
                placeholder = "Choose between 1 and 600 minutes",
                modifier = Modifier.fillMaxWidth())

            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                if (remainingMs != null) {
                    MillenniumButton(
                        onClick = onCancelTimer,
                        style = MillenniumButtonStyle.Secondary) { Text("Cancel timer") }
                }
                MillenniumButton(
                    onClick = onDismiss,
                    style = MillenniumButtonStyle.Secondary) { Text("Close") }
                MillenniumButton(
                    onClick = onStart,
                    enabled = minutes.toLongOrNull()?.let { it in 1L..600L } == true) {
                    Text("Start")
                }
            }
        }
    }
}

@Composable
private fun TrackDetailsDialog(
    details: PlayerTrackDetails,
    onDismiss: () -> Unit) {
    MillenniumDialog(
        visible = true,
        onDismissRequest = onDismiss,
        title = "Track details") {
        Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
            Text(
                details.track.title,
                style = AppTheme.typography.bodyMedium,
                color = AppTheme.colors.onSurfaceVariant)
            if (details.isLoading) {
                Row(
                    modifier = Modifier.fillMaxWidth().padding(vertical = 20.dp),
                    horizontalArrangement = Arrangement.Center) {
                    MillenniumIndeterminateProgress(
                        modifier = Modifier.fillMaxWidth())
                }
            }

            if (details.localCacheEntry != null) {
                LocalCacheBanner(details.localCacheEntry)
            }
            if (details.localCacheEntry == null && details.activeStreamMatchesPreference == false) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .millenniumSurface(
                            background = SolidColor(AppTheme.colors.tertiaryContainer),
                            shape = RoundedCornerShape(12.dp))) {
                    Text(
                        "The playback URL was resolved with different streaming settings. The highlighted stream matches your current preference; the active URL refreshes on the next stream request.",
                        modifier = Modifier.padding(12.dp),
                        style = AppTheme.typography.bodySmall,
                        color = AppTheme.colors.onTertiaryContainer)
                }
            }

            TrackMetadataSection(details.track)

            Text(
                "Matched audio source",
                style = AppTheme.typography.titleSmall,
                fontWeight = FontWeight.SemiBold)
            val source = details.matchedSource
            if (details.isLoading) {
                Text("Loading matched source…", style = AppTheme.typography.bodySmall)
            } else if (source == null) {
                Text(
                    details.error ?: if (details.localCacheEntry != null) {
                        "A matched remote source is not needed while playing the local cached file."
                    } else {
                        "No matched source is available."
                    },
                    style = AppTheme.typography.bodySmall,
                    color = AppTheme.colors.onSurfaceVariant)
            } else {
                DetailRow("Title", source.title)
                DetailRow("ID", source.id)
                DetailRow("Artist", source.artist)
                DetailRow("Album", source.album)
                DetailRow("Confidence", "${(source.confidence * 100).toInt()}%")
                DetailRow("External URI", source.externalUri)
            }

            Text(
                "Available streams",
                style = AppTheme.typography.titleSmall,
                fontWeight = FontWeight.SemiBold)
            when {
                details.localCacheEntry != null && details.streams.isEmpty() -> Text(
                    "This track is being served from the local cache. Stream variants are not used for this playback.",
                    style = AppTheme.typography.bodySmall,
                    color = AppTheme.colors.onSurfaceVariant)

                details.isLoading -> Text("Loading streams…", style = AppTheme.typography.bodySmall)
                details.streams.isEmpty() -> Text(
                    details.error ?: "No streams are available for this source.",
                    style = AppTheme.typography.bodySmall,
                    color = AppTheme.colors.onSurfaceVariant)

                else -> details.streams.forEach { stream ->
                    val isSelected = stream == details.preferredStream
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .millenniumSurface(
                                background = SolidColor(
                                    if (isSelected) {
                                        AppTheme.colors.primaryContainer
                                    } else {
                                        AppTheme.colors.surfaceContainerHigh
                                    }),
                                shape = RoundedCornerShape(12.dp))) {
                        Column(
                            modifier = Modifier.padding(12.dp),
                            verticalArrangement = Arrangement.spacedBy(4.dp)) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.SpaceBetween) {
                                Text(
                                    text = streamFormatAndQuality(stream),
                                    style = AppTheme.typography.bodyMedium,
                                    fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal,
                                    color = if (isSelected) {
                                        AppTheme.colors.onPrimaryContainer
                                    } else {
                                        AppTheme.colors.onSurface
                                    },
                                    modifier = Modifier.weight(1f))
                                if (isSelected) {
                                    MillenniumIcon(
                                        imageVector = Iconsax.IconsaxCheckCircle,
                                        contentDescription = "Currently selected stream",
                                        tint = AppTheme.colors.primary)
                                }
                            }
                            Text(
                                "${stream.protocol} • ${stream.codec} • ${stream.container}",
                                style = AppTheme.typography.labelSmall,
                                color = AppTheme.colors.onSurfaceVariant)
                            Text(
                                stream.url,
                                style = AppTheme.typography.labelSmall,
                                color = AppTheme.colors.onSurfaceVariant)
                            if (isSelected) {
                                Text(
                                    "Matches your streaming format & quality preference",
                                    style = AppTheme.typography.labelSmall,
                                    color = AppTheme.colors.primary)
                            }
                        }
                    }
                }
            }

            details.activeStreamUrl?.let { activeUrl ->
                DetailRow("Active playback URL", activeUrl)
            }

            MillenniumButton(
                onClick = onDismiss,
                style = MillenniumButtonStyle.Secondary) { Text("Close") }
        }
    }
}

@Composable
private fun LocalCacheBanner(entry: CacheEntry) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .millenniumSurface(
                background = SolidColor(AppTheme.colors.secondaryContainer),
                shape = RoundedCornerShape(12.dp))) {
        Row(
            modifier = Modifier.padding(12.dp),
            horizontalArrangement = Arrangement.spacedBy(10.dp),
            verticalAlignment = Alignment.CenterVertically) {
            MillenniumIcon(
                imageVector = Iconsax.IconsaxDirectboxReceive,
                contentDescription = null,
                tint = AppTheme.colors.onSecondaryContainer)
            Column(verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(
                    "Served from local cache",
                    style = AppTheme.typography.labelLarge,
                    fontWeight = FontWeight.SemiBold,
                    color = AppTheme.colors.onSecondaryContainer)
                Text(
                    "${entry.filename} • ${formatFileSize(entry.sizeBytes)}",
                    style = AppTheme.typography.labelSmall,
                    color = AppTheme.colors.onSecondaryContainer)
            }
        }
    }
}

@Composable
private fun TrackMetadataSection(track: MetadataTrack) {
    Text(
        "Metadata track",
        style = AppTheme.typography.titleSmall,
        fontWeight = FontWeight.SemiBold)
    DetailRow("ID", track.id)
    DetailRow("Title", track.title)
    DetailRow("Artists", track.artists.joinToString { it.name })
    DetailRow("Album", track.album?.title)
    DetailRow("Album ID", track.album?.id)
    DetailRow("Album type", track.album?.albumType?.name)
    DetailRow("Album release date", track.album?.releaseDate)
    DetailRow("Album track count", track.album?.trackCount?.toString())
    DetailRow("Album genres", track.album?.genres?.joinToString())
    DetailRow("Duration", formatRemainingTime(track.durationMs))
    DetailRow("Track number", track.trackNumber?.toString())
    DetailRow("Disc number", track.discNumber?.toString())
    DetailRow("Explicit", track.explicit?.toString())
    DetailRow("Popularity", track.popularity?.toString())
    DetailRow("ISRC", track.isrcCode)
    DetailRow("External URI", track.externalUri)
    DetailRow("Thumbnail URLs", track.thumbnails?.joinToString { it.url })
}

@Composable
private fun DetailRow(label: String, value: String?) {
    if (value.isNullOrBlank()) return
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            label,
            modifier = Modifier.weight(0.38f),
            style = AppTheme.typography.labelMedium,
            color = AppTheme.colors.onSurfaceVariant)
        Text(
            value,
            modifier = Modifier.weight(0.62f),
            style = AppTheme.typography.bodySmall)
    }
}

private fun streamFormatAndQuality(stream: AudioStream): String = when (stream) {
    is AudioStream.Lossy -> "${stream.bitrate / 1_000} kbps"
    is AudioStream.Lossless -> {
        val rate = if (stream.sampleRate % 1_000 == 0) {
            "${stream.sampleRate / 1_000}"
        } else {
            "${stream.sampleRate / 1_000.0}"
        }
        "$rate kHz • ${stream.channels} ch"
    }
}

private fun formatRemainingTime(milliseconds: Long): String {
    val totalSeconds = (milliseconds / 1_000).coerceAtLeast(0)
    val hours = totalSeconds / 3_600
    val minutes = (totalSeconds % 3_600) / 60
    val seconds = totalSeconds % 60
    return if (hours > 0) {
        "$hours:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}"
    } else {
        "$minutes:${seconds.toString().padStart(2, '0')}"
    }
}

private fun formatFileSize(sizeBytes: Long): String = when {
    sizeBytes >= 1024L * 1024L -> "${sizeBytes / (1024L * 1024L)} MB"
    sizeBytes >= 1024L -> "${sizeBytes / 1024L} KB"
    else -> "$sizeBytes B"
}
