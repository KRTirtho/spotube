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

package dev.krtirtho.spotube.modules.plugin

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.PlatformType
import dev.krtirtho.spotube.core.ui.base.Card
import dev.krtirtho.spotube.core.ui.base.OutlineButton
import dev.krtirtho.spotube.core.ui.base.PrimaryButton
import dev.krtirtho.spotube.core.ui.base.SecondaryIconButton
import dev.krtirtho.spotube.core.ui.base.TextField
import dev.krtirtho.spotube.core.ui.component.AdaptiveDialogBottomSheet
import dev.krtirtho.spotube.core.ui.component.AdaptiveDropdownBottomSheet
import dev.krtirtho.spotube.core.ui.component.AdaptiveMenuItem
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.core.ui.component.HeaderDisplayMode
import dev.krtirtho.spotube.core.webview.WebViewController
import dev.krtirtho.spotube.getPlatform
import dev.krtirtho.spotube.openUrlInBrowser
import dev.krtirtho.spotube.modules.plugin.components.PluginCard
import dev.krtirtho.spotube.modules.plugin.components.PluginPermissionDialog
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxAdd
import dev.krtirtho.spotube.resources.iconsax.IconsaxArrowDown4
import dev.krtirtho.spotube.resources.iconsax.IconsaxBox
import dev.krtirtho.spotube.resources.iconsax.IconsaxCheckCircle
import dev.krtirtho.spotube.resources.iconsax.IconsaxDocumentDownload
import dev.krtirtho.spotube.resources.iconsax.IconsaxDocumentText
import dev.krtirtho.spotube.resources.iconsax.IconsaxGlobe
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart
import dev.krtirtho.spotube.resources.iconsax.IconsaxEdit
import dev.krtirtho.spotube.resources.iconsax.IconsaxExportArrowBulk
import dev.krtirtho.spotube.resources.iconsax.IconsaxImportArrow2Bulk
import dev.krtirtho.spotube.resources.iconsax.IconsaxLink
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusic
import dev.krtirtho.spotube.resources.iconsax.IconsaxSound
import dev.krtirtho.spotube.resources.iconsax.IconsaxTextalignLeft
import io.github.vinceglb.filekit.dialogs.FileKitType
import io.github.vinceglb.filekit.dialogs.compose.rememberFilePickerLauncher
import io.github.vinceglb.filekit.readBytes
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import okio.FileSystem
import okio.Path.Companion.toPath
import androidx.compose.foundation.clickable
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.derivedStateOf
import androidx.compose.ui.platform.LocalDensity
import coil3.compose.AsyncImage
import coil3.compose.LocalPlatformContext
import coil3.request.ImageRequest
import coil3.request.crossfade
import dev.krtirtho.spotube.core.extras.kebabToTitleCase
import dev.krtirtho.spotube.core.ui.base.SecondaryButton
import dev.krtirtho.spotube.resources.iconsax.CarbonGithubLogo
import okio.SYSTEM
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.koinInject
import org.koin.compose.viewmodel.koinViewModel
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.plugin_action_download
import spotube.composeapp.generated.resources.plugin_action_install_from_file
import spotube.composeapp.generated.resources.plugin_configure_title
import spotube.composeapp.generated.resources.plugin_empty_subtitle
import spotube.composeapp.generated.resources.plugin_empty_title
import spotube.composeapp.generated.resources.plugin_error_download_failed
import spotube.composeapp.generated.resources.plugin_error_enter_url
import spotube.composeapp.generated.resources.plugin_error_url_scheme
import spotube.composeapp.generated.resources.plugin_install_section_title
import spotube.composeapp.generated.resources.plugin_installed_count
import spotube.composeapp.generated.resources.plugin_installed_plural
import spotube.composeapp.generated.resources.plugin_installed_singular
import spotube.composeapp.generated.resources.plugin_screen_title
import spotube.composeapp.generated.resources.plugin_section_file_title
import spotube.composeapp.generated.resources.plugin_section_install
import spotube.composeapp.generated.resources.plugin_section_url_title
import spotube.composeapp.generated.resources.plugin_url_placeholder
import spotube.composeapp.generated.resources.settings_plugins_ability_audio
import spotube.composeapp.generated.resources.settings_plugins_ability_lyrics
import spotube.composeapp.generated.resources.settings_plugins_ability_metadata
import spotube.composeapp.generated.resources.settings_plugins_ability_scrobble
import spotube.composeapp.generated.resources.settings_plugins_action_change
import spotube.composeapp.generated.resources.settings_plugins_action_select
import spotube.composeapp.generated.resources.settings_plugins_default_ability_title
import spotube.composeapp.generated.resources.settings_plugins_no_plugins
import spotube.composeapp.generated.resources.settings_plugins_no_selection
import spotube.composeapp.generated.resources.settings_plugins_plugin_content_description

private val OFFICIAL_PLUGIN_OWNERS = setOf("KRTirtho", "team-spotube")

private val VERIFIED_PLUGIN_OWNERS = setOf<String>()

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PluginScreen(
    pluginManager: PluginManager,
    webviewController: WebViewController = koinInject()
) {
    val scope = rememberCoroutineScope()
    val platform = remember { getPlatform() }
    val pendingPlugin by pluginManager.pendingPlugin.collectAsStateWithLifecycle()
    val pluginsState by pluginManager.state.collectAsStateWithLifecycle()
    val activeServices by pluginManager.ziplineServices.collectAsStateWithLifecycle()
    val shellBottomInset = LocalAppShellBottomInset.current

    var urlInput by remember { mutableStateOf("") }
    var urlError by remember { mutableStateOf<String?>(null) }
    var isLoadingUrl by remember { mutableStateOf(false) }
    var showInstallSheet by remember { mutableStateOf(false) }

    val discoverViewModel: PluginDiscoverViewModel = koinViewModel()
    val discoverState by discoverViewModel.state.collectAsStateWithLifecycle()

    val pleaseEnterUrl = stringResource(Res.string.plugin_error_enter_url)
    val urlSchemeError = stringResource(Res.string.plugin_error_url_scheme)
    val downloadFailed = stringResource(Res.string.plugin_error_download_failed)

    val launcher = rememberFilePickerLauncher(
        type = FileKitType.File(
            extensions = if (platform.type == PlatformType.Android) listOf() else listOf("smplug")
        )
    ) { file ->
        if (file != null) {
            scope.launch { pluginManager.preparePlugin(file.readBytes()) }
        }
    }

    fun submitUrl() {
        val url = urlInput.trim()
        if (url.isBlank()) {
            urlError = pleaseEnterUrl
            return
        }
        if (!url.startsWith("http://") && !url.startsWith("https://")) {
            urlError = urlSchemeError
            return
        }
        urlError = null
        isLoadingUrl = true
        scope.launch {
            try {
                pluginManager.addPluginFromURL(url)
                urlInput = ""
            } catch (e: Exception) {
                urlError = e.message ?: downloadFailed
            } finally {
                isLoadingUrl = false
            }
        }
    }

    pendingPlugin?.let { pending ->
        val logoPath = remember(pending.existingEntry?.id) {
            val existingId = pending.existingEntry?.id ?: return@remember null
            val path = pluginManager.pluginsDirPath / existingId.toPath() / "logo.png".toPath()
            if (FileSystem.SYSTEM.exists(path)) path else null
        }
        PluginPermissionDialog(
            pluginInfo = pending.entry,
            title = pending.title,
            message = pending.message,
            confirmLabel = pending.confirmLabel,
            existingPlugin = pending.existingEntry,
            logoPath = logoPath,
            onConfirm = if (pending.kind != PluginManager.InstallPromptKind.INFO && pending.confirmLabel != null) {
                { pluginManager.confirmInstall() }
            } else {
                null
            },
            onDismiss = { pluginManager.dismissInstall() }
        )
    }

    if (showInstallSheet) {
        AdaptiveDialogBottomSheet(
            onDismiss = { showInstallSheet = false },
            title = {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        Iconsax.IconsaxImportArrow2Bulk,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                        tint = MaterialTheme.colorScheme.primary
                    )
                    Text(
                        stringResource(Res.string.plugin_install_section_title),
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            },
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    stringResource(Res.string.plugin_section_url_title),
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.Top,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    TextField(
                        value = urlInput,
                        onValueChange = { urlInput = it; urlError = null },
                        modifier = Modifier.weight(1f),
                        placeholder = {
                            Text(
                                stringResource(Res.string.plugin_url_placeholder),
                                style = MaterialTheme.typography.bodySmall
                            )
                        },
                        leadingIcon = {
                            Icon(
                                Iconsax.IconsaxLink,
                                contentDescription = null,
                                modifier = Modifier.size(16.dp)
                            )
                        },
                        isError = urlError != null,
                        singleLine = true,
                    )
                    SecondaryIconButton(
                        onClick = { submitUrl() },
                        enabled = !isLoadingUrl,
                    ) {
                        if (isLoadingUrl) {
                            CircularProgressIndicator(
                                modifier = Modifier.size(16.dp),
                                strokeWidth = 2.dp,
                                color = MaterialTheme.colorScheme.onPrimary
                            )
                        } else {
                            Icon(
                                Iconsax.IconsaxImportArrow2Bulk,
                                contentDescription = stringResource(Res.string.plugin_action_download),
                            )
                        }
                    }
                }

                HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f))

                Text(
                    stringResource(Res.string.plugin_section_file_title),
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                OutlineButton(
                    onClick = { launcher.launch() },
                    modifier = Modifier.fillMaxWidth(),
                ) {
                    Icon(
                        Iconsax.IconsaxExportArrowBulk,
                        contentDescription = stringResource(Res.string.plugin_action_install_from_file)
                    )
                    Spacer(Modifier.width(8.dp))
                    Text(stringResource(Res.string.plugin_action_install_from_file))
                }
            }
        }
    }

    Scaffold(
        topBar = {
            ApplicationMainBar(title = { Text(stringResource(Res.string.plugin_screen_title)) })
        }
    ) { innerPadding ->
        when (val state = pluginsState) {
            is PluginManagerStates.Loading -> {
                Box(
                    modifier = Modifier.fillMaxSize().padding(innerPadding),
                    contentAlignment = Alignment.Center
                ) { CircularProgressIndicator() }
            }

            is PluginManagerStates.Data -> {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(innerPadding)
                ) {
                    val discoverListState = rememberLazyListState()
                    LazyColumn(
                        state = discoverListState,
                        modifier = Modifier.widthIn(max = 1280.dp).align(Alignment.TopCenter),
                        contentPadding = PaddingValues(
                            start = 12.dp,
                            end = 12.dp,
                            top = 8.dp,
                            bottom = 24.dp + shellBottomInset
                        ),
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    )
                    {
                        // ── Configure header ──────────────────────────────
                        item {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(horizontal = 4.dp, vertical = 4.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    stringResource(Res.string.plugin_configure_title),
                                    style = MaterialTheme.typography.titleLarge,
                                    fontWeight = FontWeight.SemiBold
                                )
                                PrimaryButton(onClick = { showInstallSheet = true }) {
                                    Icon(
                                        Iconsax.IconsaxAdd,
                                        contentDescription = "Install a plugin",
                                    )
                                    Text(stringResource(Res.string.plugin_install_section_title))
                                }
                            }
                        }

                        // ── Default ability plugin selectors ─────────────────
                        item {
                            Card(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 4.dp),
                            ) {
                                Column(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(top = 4.dp, bottom = 4.dp)
                                ) {
                                    PluginAbility.entries.forEachIndexed { index, ability ->
                                        if (index > 0) {
                                            HorizontalDivider(
                                                color = MaterialTheme.colorScheme.outlineVariant.copy(
                                                    alpha = 0.5f
                                                ),
                                            )
                                        }
                                        val selectedPlugin = state.selectedPlugins[ability]
                                        DefaultAbilityPluginSelector(
                                            ability = ability,
                                            selectedPlugin = selectedPlugin,
                                            state = when (ability) {
                                                PluginAbility.METADATA -> pluginManager.metadataPlugins
                                                PluginAbility.AUDIO -> pluginManager.audioPlugins
                                                PluginAbility.LYRICS -> pluginManager.lyricsPlugins
                                                PluginAbility.SCROBBLE -> pluginManager.scrobblePlugins
                                            },
                                            onSelected = { plugin ->
                                                pluginManager.setSelectedPlugin(ability, plugin)
                                            },
                                        )
                                    }
                                }
                            }
                        }

                        if (state.plugins.isEmpty()) {
                            item {
                                Box(
                                    modifier = Modifier.fillMaxWidth().padding(vertical = 48.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Column(
                                        horizontalAlignment = Alignment.CenterHorizontally,
                                        verticalArrangement = Arrangement.spacedBy(12.dp)
                                    ) {
                                        Surface(
                                            modifier = Modifier.size(72.dp)
                                                .clip(RoundedCornerShape(18.dp)),
                                            color = MaterialTheme.colorScheme.primary.copy(alpha = 0.1f)
                                        ) {
                                            Box(contentAlignment = Alignment.Center) {
                                                Icon(
                                                    Iconsax.IconsaxBox,
                                                    contentDescription = null,
                                                    modifier = Modifier.size(32.dp),
                                                    tint = MaterialTheme.colorScheme.primary
                                                )
                                            }
                                        }
                                        Text(
                                            stringResource(Res.string.plugin_empty_title),
                                            style = MaterialTheme.typography.titleSmall,
                                            fontWeight = FontWeight.SemiBold
                                        )
                                        Text(
                                            stringResource(Res.string.plugin_empty_subtitle),
                                            style = MaterialTheme.typography.bodySmall,
                                            color = MaterialTheme.colorScheme.onSurfaceVariant
                                        )
                                    }
                                }
                            }
                        } else {
                            // ── Plugin list ───────────────────────────────────
                            item {
                                val noun = if (state.plugins.size == 1) {
                                    stringResource(Res.string.plugin_installed_singular)
                                } else {
                                    stringResource(Res.string.plugin_installed_plural)
                                }
                                Text(
                                    stringResource(
                                        Res.string.plugin_installed_count,
                                        state.plugins.size,
                                        noun
                                    ),
                                    style = MaterialTheme.typography.labelMedium,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                    modifier = Modifier.padding(horizontal = 4.dp, vertical = 4.dp)
                                )
                            }
                            item {
                                Card(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(vertical = 4.dp),
                                ) {
                                    Column(
                                        modifier = Modifier.fillMaxWidth()
                                    ) {
                                        state.plugins.forEachIndexed { index, plugin ->
                                            if (index > 0) {
                                                HorizontalDivider(
                                                    color = MaterialTheme.colorScheme.outlineVariant.copy(
                                                        alpha = 0.5f
                                                    ),
                                                )
                                            }
                                            val isSelected =
                                                state.selectedPlugins.containsValue(plugin)
                                            val selectedAbility = state.selectedPlugins
                                                .entries
                                                .firstOrNull { (_, selectedPlugin) -> selectedPlugin.id == plugin.id }
                                                ?.key
                                            val selectedService = selectedAbility?.let { ability ->
                                                activeServices?.get(ability)
                                            }

                                            var requiresAuth by remember(
                                                plugin.id,
                                                selectedService
                                            ) {
                                                mutableStateOf(false)
                                            }
                                            var isLoggedIn by remember(plugin.id, selectedService) {
                                                mutableStateOf(false)
                                            }

                                            LaunchedEffect(plugin.id, selectedService) {
                                                requiresAuth = false
                                                isLoggedIn = false
                                                val service =
                                                    selectedService ?: return@LaunchedEffect


                                                service.use {
                                                    val pluginRequiresAuth =
                                                        coreAPI.requiresAuthentication
                                                    requiresAuth = pluginRequiresAuth
                                                    if (!pluginRequiresAuth) return@use

                                                    coreAPI.loggedInFlow.collect { loggedIn ->
                                                        isLoggedIn = loggedIn
                                                    }
                                                }
                                            }

                                            val logoPath = remember(plugin.id) {
                                                val path =
                                                    pluginManager.pluginsDirPath / plugin.id.toPath() / "logo.png".toPath()
                                                if (FileSystem.SYSTEM.exists(path)) path else null
                                            }

                                            PluginCard(
                                                plugin = plugin,
                                                isSelected = isSelected,
                                                onRemove = {
                                                    scope.launch { pluginManager.removePlugin(plugin) }
                                                },
                                                isLoggedIn = isLoggedIn,
                                                logoPath = logoPath,
                                                onLogin = if (requiresAuth && selectedService != null) {
                                                    {
                                                        pluginManager.launchTask {
                                                            selectedService.use { coreAPI.login() }
                                                        }
                                                    }
                                                } else {
                                                    null
                                                },
                                                onLogout = if (requiresAuth && selectedService != null) {
                                                    {
                                                        pluginManager.launchTask {
                                                            selectedService.use { coreAPI.logout() }
                                                        }
                                                        // should clear webview data after logout
                                                        scope.launch { webviewController.clearData() }
                                                    }
                                                } else {
                                                    null
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        }

                        // ── Discover plugins ─────────────────────────
                        if (discoverState.isLoading || discoverState.repos.isNotEmpty()) {
                            item {
                                Row(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(horizontal = 4.dp, vertical = 12.dp),
                                    verticalAlignment = Alignment.CenterVertically,
                                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                                ) {
                                    Icon(
                                        Iconsax.IconsaxGlobe,
                                        contentDescription = null,
                                        modifier = Modifier.size(18.dp),
                                        tint = MaterialTheme.colorScheme.primary
                                    )
                                    Text(
                                        "Discover Plugins",
                                        style = MaterialTheme.typography.titleLarge,
                                        fontWeight = FontWeight.SemiBold
                                    )
                                }
                            }
                            items(
                                discoverState.repos,
                                key = { it.id }
                            ) { repo ->
                                val isOfficial = repo.owner.login in OFFICIAL_PLUGIN_OWNERS
                                val isVerified = repo.owner.login in VERIFIED_PLUGIN_OWNERS
                                val isInstalling = discoverState.installingRepoId == repo.id
                                Card(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(vertical = 4.dp)
                                ) {
                                    Row(
                                        modifier = Modifier
                                            .fillMaxWidth()
                                            .padding(12.dp),
                                        verticalAlignment = Alignment.CenterVertically,
                                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                                    ) {
                                        val platformContext = LocalPlatformContext.current
                                        AsyncImage(
                                            model = ImageRequest.Builder(platformContext)
                                                .data(repo.owner.avatarUrl)
                                                .crossfade(true)
                                                .build(),
                                            contentDescription = repo.owner.login,
                                            modifier = Modifier
                                                .size(36.dp)
                                                .clip(RoundedCornerShape(8.dp))
                                        )
                                        Column(
                                            modifier = Modifier.weight(1f),
                                            verticalArrangement = Arrangement.spacedBy(2.dp)
                                        ) {
                                            Row(
                                                verticalAlignment = Alignment.CenterVertically,
                                                horizontalArrangement = Arrangement.spacedBy(6.dp)
                                            ) {
                                                Text(
                                                    repo.fullName.split("/")
                                                        .last()
                                                        .replace("spotube-plugin-", "")
                                                        .kebabToTitleCase(),
                                                    style = MaterialTheme.typography.bodyMedium,
                                                    fontWeight = FontWeight.SemiBold,
                                                    maxLines = 1,
                                                    overflow = TextOverflow.Ellipsis,
                                                    modifier = Modifier.weight(1f, fill = false)
                                                )
                                                if (isOfficial) {
                                                    Surface(
                                                        shape = RoundedCornerShape(4.dp),
                                                        color = MaterialTheme.colorScheme.primary.copy(
                                                            alpha = 0.15f
                                                        )
                                                    ) {
                                                        Text(
                                                            "Official",
                                                            style = MaterialTheme.typography.labelSmall,
                                                            color = MaterialTheme.colorScheme.primary,
                                                            modifier = Modifier.padding(
                                                                horizontal = 5.dp,
                                                                vertical = 1.dp
                                                            )
                                                        )
                                                    }
                                                } else if (isVerified) {
                                                    Surface(
                                                        shape = RoundedCornerShape(4.dp),
                                                        color = Color(0xFF4CAF50).copy(alpha = 0.15f)
                                                    ) {
                                                        Row(
                                                            modifier = Modifier.padding(
                                                                horizontal = 5.dp,
                                                                vertical = 1.dp
                                                            ),
                                                            verticalAlignment = Alignment.CenterVertically,
                                                            horizontalArrangement = Arrangement.spacedBy(
                                                                2.dp
                                                            )
                                                        ) {
                                                            Icon(
                                                                Iconsax.IconsaxCheckCircle,
                                                                contentDescription = null,
                                                                modifier = Modifier.size(10.dp),
                                                                tint = Color(0xFF4CAF50)
                                                            )
                                                            Text(
                                                                "Verified",
                                                                style = MaterialTheme.typography.labelSmall,
                                                                color = Color(0xFF4CAF50)
                                                            )
                                                        }
                                                    }
                                                }
                                            }
                                            if (!repo.description.isNullOrBlank()) {
                                                Text(
                                                    repo.description,
                                                    style = MaterialTheme.typography.bodySmall,
                                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                                    maxLines = 2,
                                                    overflow = TextOverflow.Ellipsis
                                                )
                                            }
                                            Row(
                                                verticalAlignment = Alignment.CenterVertically,
                                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                                            ) {
                                                Text(
                                                    repo.owner.login,
                                                    style = MaterialTheme.typography.labelSmall,
                                                    color = MaterialTheme.colorScheme.onSurfaceVariant
                                                )
                                                Row(
                                                    verticalAlignment = Alignment.CenterVertically,
                                                    horizontalArrangement = Arrangement.spacedBy(3.dp)
                                                ) {
                                                    Icon(
                                                        Iconsax.IconsaxHeart,
                                                        contentDescription = "Github Stars",
                                                        modifier = Modifier.size(11.dp),
                                                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                                                    )
                                                    Text(
                                                        repo.stargazersCount.toString(),
                                                        style = MaterialTheme.typography.labelSmall,
                                                        color = MaterialTheme.colorScheme.onSurfaceVariant
                                                    )
                                                }
                                                Surface(
                                                    shape = RoundedCornerShape(4.dp),
                                                    color = MaterialTheme.colorScheme.surfaceVariant,
                                                    modifier = Modifier.clickable {
                                                        openUrlInBrowser(repo.htmlUrl)
                                                    }
                                                ) {
                                                    Row(
                                                        modifier = Modifier.padding(
                                                            horizontal = 5.dp,
                                                            vertical = 2.dp
                                                        ),
                                                        verticalAlignment = Alignment.CenterVertically,
                                                        horizontalArrangement = Arrangement.spacedBy(
                                                            3.dp
                                                        )
                                                    ) {
                                                        Icon(
                                                            Iconsax.CarbonGithubLogo,
                                                            contentDescription = "Github Repository URL",
                                                            modifier = Modifier.size(10.dp),
                                                            tint = MaterialTheme.colorScheme.onSurfaceVariant
                                                        )
                                                        Text(
                                                            "github.com",
                                                            style = MaterialTheme.typography.labelSmall,
                                                            color = MaterialTheme.colorScheme.onSurfaceVariant
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                        SecondaryButton(
                                            onClick = { discoverViewModel.installPlugin(repo) },
                                            enabled = !isInstalling
                                        ) {
                                            if (isInstalling) {
                                                CircularProgressIndicator(
                                                    modifier = Modifier.size(16.dp),
                                                    strokeWidth = 2.dp
                                                )
                                            } else {
                                                Icon(
                                                    Iconsax.IconsaxAdd,
                                                    contentDescription = null,
                                                )
                                            }
                                            Text(stringResource(Res.string.plugin_section_install))
                                        }
                                    }
                                }
                            }

                            if (discoverState.isLoadingMore) {
                                item {
                                    Box(
                                        modifier = Modifier
                                            .fillMaxWidth()
                                            .padding(vertical = 16.dp),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        CircularProgressIndicator(modifier = Modifier.size(24.dp))
                                    }
                                }
                            }

                            if (discoverState.error != null) {
                                item {
                                    Text(
                                        discoverState.error ?: "",
                                        style = MaterialTheme.typography.bodySmall,
                                        color = MaterialTheme.colorScheme.error,
                                        modifier = Modifier.padding(
                                            horizontal = 4.dp,
                                            vertical = 8.dp
                                        )
                                    )
                                }
                            }
                        }
                    }

                    val density = LocalDensity.current
                    val shouldLoadMore = remember(density) {
                        derivedStateOf {
                            val totalItems = discoverListState.layoutInfo.totalItemsCount
                            val lastVisibleIndex =
                                discoverListState.layoutInfo.visibleItemsInfo.lastOrNull()?.index
                                    ?: 0
                            totalItems > 0 && lastVisibleIndex >= totalItems - 3
                        }
                    }

                    LaunchedEffect(shouldLoadMore.value) {
                        if (shouldLoadMore.value) {
                            discoverViewModel.loadNextPage()
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun DefaultAbilityPluginSelector(
    ability: PluginAbility,
    state: StateFlow<List<PluginEntry>>,
    selectedPlugin: PluginEntry? = null,
    onSelected: (PluginEntry?) -> Unit = { },
) {
    val plugins by state.collectAsStateWithLifecycle()
    val noPluginsText = stringResource(Res.string.settings_plugins_no_plugins)

    val menuItems = buildList {
        if (plugins.isNotEmpty()) {
            plugins.forEach { plugin ->
                val isSelected = selectedPlugin?.name == plugin.name
                add(
                    AdaptiveMenuItem(
                        label = plugin.name,
                        onClick = { onSelected(plugin) },
                        selected = isSelected,
                    )
                )
            }
        } else {
            add(
                AdaptiveMenuItem(
                    label = noPluginsText,
                    onClick = { },
                    enabled = false,
                )
            )
        }
    }

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(
            modifier = Modifier.weight(1f),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Surface(
                modifier = Modifier.clip(RoundedCornerShape(8.dp)),
                color = when (ability) {
                    PluginAbility.METADATA -> Color(0xFF4CAF50).copy(alpha = 0.1f)
                    PluginAbility.AUDIO -> Color(0xFF2196F3).copy(alpha = 0.1f)
                    PluginAbility.LYRICS -> Color(0xFFFFC107).copy(alpha = 0.1f)
                    PluginAbility.SCROBBLE -> Color(0xFF9C27B0).copy(alpha = 0.1f)
                }
            ) {
                Icon(
                    imageVector = when (ability) {
                        PluginAbility.METADATA -> Iconsax.IconsaxDocumentText
                        PluginAbility.AUDIO -> Iconsax.IconsaxMusic
                        PluginAbility.LYRICS -> Iconsax.IconsaxTextalignLeft
                        PluginAbility.SCROBBLE -> Iconsax.IconsaxSound
                    },
                    contentDescription = stringResource(
                        Res.string.settings_plugins_plugin_content_description,
                        ability.displayLabel()
                    ),
                    modifier = Modifier.padding(8.dp),
                    tint = when (ability) {
                        PluginAbility.METADATA -> Color(0xFF4CAF50)
                        PluginAbility.AUDIO -> Color(0xFF2196F3)
                        PluginAbility.LYRICS -> Color(0xFFFFC107)
                        PluginAbility.SCROBBLE -> Color(0xFF9C27B0)
                    }
                )
            }

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    stringResource(
                        Res.string.settings_plugins_default_ability_title,
                        ability.displayLabel()
                    ),
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurface
                )
                if (selectedPlugin != null) {
                    Text(
                        selectedPlugin.name,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.padding(top = 4.dp)
                    )
                } else {
                    Text(
                        stringResource(Res.string.settings_plugins_no_selection),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(top = 4.dp)
                    )
                }
            }
        }

        AdaptiveDropdownBottomSheet(
            items = menuItems,
            headerDisplayMode = HeaderDisplayMode.OnlyInBottomSheet,
            header = {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    Surface(
                        modifier = Modifier.clip(RoundedCornerShape(8.dp)),
                        color = when (ability) {
                            PluginAbility.METADATA -> Color(0xFF4CAF50).copy(alpha = 0.1f)
                            PluginAbility.AUDIO -> Color(0xFF2196F3).copy(alpha = 0.1f)
                            PluginAbility.LYRICS -> Color(0xFFFFC107).copy(alpha = 0.1f)
                            PluginAbility.SCROBBLE -> Color(0xFF9C27B0).copy(alpha = 0.1f)
                        }
                    ) {
                        Icon(
                            imageVector = when (ability) {
                                PluginAbility.METADATA -> Iconsax.IconsaxDocumentText
                                PluginAbility.AUDIO -> Iconsax.IconsaxMusic
                                PluginAbility.LYRICS -> Iconsax.IconsaxTextalignLeft
                                PluginAbility.SCROBBLE -> Iconsax.IconsaxSound
                            },
                            contentDescription = null,
                            modifier = Modifier.padding(8.dp),
                            tint = when (ability) {
                                PluginAbility.METADATA -> Color(0xFF4CAF50)
                                PluginAbility.AUDIO -> Color(0xFF2196F3)
                                PluginAbility.LYRICS -> Color(0xFFFFC107)
                                PluginAbility.SCROBBLE -> Color(0xFF9C27B0)
                            }
                        )
                    }
                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            stringResource(
                                Res.string.settings_plugins_default_ability_title,
                                ability.displayLabel()
                            ),
                            style = MaterialTheme.typography.titleMedium,
                        )
                        selectedPlugin?.let {
                            Text(
                                it.name,
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.primary,
                            )
                        }
                    }
                }
            },
            trigger = { onClick ->
                OutlineButton(onClick = onClick) {
                    Text(
                        if (selectedPlugin != null) {
                            stringResource(Res.string.settings_plugins_action_change)
                        } else {
                            stringResource(Res.string.settings_plugins_action_select) + "  "
                        },
                    )
                    Icon(
                        imageVector = if (selectedPlugin != null) Iconsax.IconsaxEdit else Iconsax.IconsaxArrowDown4,
                        contentDescription = null,
                        modifier = Modifier.size(14.dp),
                    )
                }
            },
        )
    }
}

@Composable
private fun PluginAbility.displayLabel(): String {
    return when (this) {
        PluginAbility.METADATA -> stringResource(Res.string.settings_plugins_ability_metadata)
        PluginAbility.AUDIO -> stringResource(Res.string.settings_plugins_ability_audio)
        PluginAbility.LYRICS -> stringResource(Res.string.settings_plugins_ability_lyrics)
        PluginAbility.SCROBBLE -> stringResource(Res.string.settings_plugins_ability_scrobble)
    }
}

