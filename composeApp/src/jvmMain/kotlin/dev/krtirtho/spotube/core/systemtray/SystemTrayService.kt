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

package dev.krtirtho.spotube.core.systemtray

import dev.krtirtho.spotube.core.audioplayer.AudioPlayerInterface
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.LoopState
import dev.krtirtho.spotube.core.audioplayer.PlayerState
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.modules.saved_tracks.SavedTracksRepository
import dev.krtirtho.spotube.modules.settings.SettingsProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent
import java.awt.BorderLayout
import java.awt.Color
import java.awt.Dimension
import java.awt.Image
import java.awt.SystemTray
import java.awt.Toolkit
import java.awt.TrayIcon
import java.awt.event.FocusAdapter
import java.awt.event.FocusEvent
import java.awt.event.MouseAdapter
import java.awt.event.MouseEvent
import java.awt.event.WindowAdapter
import java.awt.event.WindowEvent
import java.awt.image.BufferedImage
import javax.swing.BorderFactory
import javax.swing.BoxLayout
import javax.swing.JCheckBoxMenuItem
import javax.swing.JDialog
import javax.swing.JLabel
import javax.swing.JMenu
import javax.swing.JMenuItem
import javax.swing.JPanel
import javax.swing.JPopupMenu
import javax.swing.SwingUtilities
import javax.swing.UIManager

class SystemTrayService(
    private val audioPlayer: AudioPlayerInterface,
    private val audioPlayerQueue: AudioPlayerQueue,
    private val settingsProvider: SettingsProvider,
    private val savedTracksRepository: SavedTracksRepository,
) : KoinComponent, AutoCloseable {

    private val logger by injectLogger<SystemTrayService>()
    private val scope = CoroutineScope(Dispatchers.Default + SupervisorJob())

    private var trayIcon: TrayIcon? = null
    private var menuDialog: TrayMenuDialog? = null

    private var windowVisible: Boolean = true
    private var onToggleWindowVisibility: (() -> Unit)? = null
    private var onExit: (() -> Unit)? = null

    @Volatile
    private var started = false

    private val volumeStep = 0.05f

    fun start(
        onToggleWindowVisibility: () -> Unit,
        onExit: () -> Unit,
    ) {
        this.onToggleWindowVisibility = onToggleWindowVisibility
        this.onExit = onExit

        if (started) {
            return
        }
        started = true

        if (!SystemTray.isSupported()) {
            logger.w { "System tray is not supported on this platform" }
            return
        }

        SwingUtilities.invokeLater {
            try {
                val trayImage = createTrayIconImage()
                val icon = TrayIcon(trayImage, "Spotube")
                icon.isImageAutoSize = true
                icon.addMouseListener(object : MouseAdapter() {
                    override fun mouseClicked(e: MouseEvent) {
                        if (e.button == MouseEvent.BUTTON1 && e.clickCount == 2) {
                            onToggleWindowVisibility.invoke()
                        } else if (e.button == MouseEvent.BUTTON3) {
                            showMenuDialog(icon, e.xOnScreen, e.yOnScreen)
                        }
                    }
                })

                val systemTray = SystemTray.getSystemTray()
                systemTray.add(icon)
                this.trayIcon = icon

                logger.i { "System tray initialized" }
                observeState()
            } catch (e: Exception) {
                logger.e(e) { "Failed to initialize system tray" }
            }
        }
    }

    private fun showMenuDialog(icon: TrayIcon, x: Int, y: Int) {
        val dialog = menuDialog
        if (dialog != null && dialog.isVisible) {
            dialog.dispose()
            menuDialog = null
            return
        }

        val newDialog = TrayMenuDialog().apply {
            isUndecorated = true
            isAlwaysOnTop = true
            focusableWindowState = true
            setAutoRequestFocus(true)
            background = Color(0, 0, 0, 0)
        }

        val panel = JPanel()
        panel.layout = BoxLayout(panel, BoxLayout.Y_AXIS)
        panel.border = BorderFactory.createCompoundBorder(
            BorderFactory.createLineBorder(Color(80, 80, 80), 1),
            BorderFactory.createEmptyBorder(4, 4, 4, 4)
        )
        panel.background = UIManager.getColor("PopupMenu.background") ?: Color(45, 45, 45)

        newDialog.contentPane.layout = BorderLayout()
        newDialog.contentPane.add(panel, BorderLayout.CENTER)
        newDialog.addWindowFocusListener(object : WindowAdapter() {
            override fun windowLostFocus(e: WindowEvent) {
                newDialog.isVisible = false
                newDialog.dispose()
                if (menuDialog === newDialog) menuDialog = null
            }
        })

        menuDialog = newDialog
        rebuildMenuPanel(panel, newDialog)
        newDialog.pack()

        val screenBounds = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment()
            .defaultScreenDevice.defaultConfiguration.bounds
        val dialogWidth = newDialog.width
        val dialogHeight = newDialog.height
        val posX = if (x + dialogWidth > screenBounds.width) x - dialogWidth else x
        val posY = if (y + dialogHeight > screenBounds.height) y - dialogHeight else y
        newDialog.setLocation(posX, posY)
        newDialog.isVisible = true
        newDialog.requestFocus()
    }

    private fun rebuildMenuPanel(panel: JPanel, dialog: JDialog) {
        panel.removeAll()
        val state = currentState
        if (state == null) {
            panel.add(createDisabledLabel("Loading..."))
            return
        }

        val media = state.mediaItem
        val trackTitle = media?.title ?: "No track playing"
        val trackArtist = media?.artist ?: ""

        panel.add(createDisabledLabel(
            if (trackArtist.isNotEmpty()) "$trackTitle - $trackArtist" else trackTitle
        ))
        panel.add(createSeparator())

        panel.add(createMenuItem(if (windowVisible) "Hide Window" else "Show Window") {
            onToggleWindowVisibility?.invoke()
        })
        panel.add(createSeparator())

        val isPlaying = state.playerState == PlayerState.PLAYING
        panel.add(createMenuItem(if (isPlaying) "Pause" else "Play") {
            scope.launch { if (isPlaying) audioPlayer.pause() else audioPlayer.play() }
        })
        panel.add(createMenuItem("Next Track") {
            scope.launch { audioPlayer.skipToNext() }
        })
        panel.add(createMenuItem("Previous Track") {
            scope.launch { audioPlayer.skipToPrevious() }
        })
        panel.add(createSeparator())

        panel.add(createCheckBoxMenuItem("Shuffle", state.shuffleEnabled) {
            scope.launch { audioPlayer.shuffle(!state.shuffleEnabled) }
        })

        val loopSubMenu = JPanel()
        loopSubMenu.layout = BoxLayout(loopSubMenu, BoxLayout.Y_AXIS)
        loopSubMenu.background = panel.background
        val loopGroup = javax.swing.ButtonGroup()
        val loopNone = javax.swing.JRadioButtonMenuItem("Loop: OFF", state.loopState == LoopState.NONE)
        val loopOne = javax.swing.JRadioButtonMenuItem("Loop: ONE", state.loopState == LoopState.ONE)
        val loopAll = javax.swing.JRadioButtonMenuItem("Loop: ALL", state.loopState == LoopState.ALL)
        loopGroup.add(loopNone)
        loopGroup.add(loopOne)
        loopGroup.add(loopAll)
        loopNone.addActionListener { scope.launch { audioPlayer.loop(LoopState.NONE) } }
        loopOne.addActionListener { scope.launch { audioPlayer.loop(LoopState.ONE) } }
        loopAll.addActionListener { scope.launch { audioPlayer.loop(LoopState.ALL) } }
        loopSubMenu.add(loopNone)
        loopSubMenu.add(loopOne)
        loopSubMenu.add(loopAll)
        panel.add(createSubMenuLabel("Loop"))
        panel.add(loopSubMenu)
        panel.add(createSeparator())

        val volumePercent = (state.volume * 100).toInt()
        panel.add(createDisabledLabel("Volume: $volumePercent%"))
        panel.add(createMenuItem("Volume +") {
            scope.launch {
                val newVol = (state.volume + volumeStep).coerceAtMost(1f)
                audioPlayer.setVolume(newVol)
            }
        })
        panel.add(createMenuItem("Volume -") {
            scope.launch {
                val newVol = (state.volume - volumeStep).coerceAtLeast(0f)
                audioPlayer.setVolume(newVol)
            }
        })
        val isMuted = state.volume <= 0f
        panel.add(createMenuItem(if (isMuted) "Unmute" else "Mute") {
            scope.launch { audioPlayer.setVolume(if (isMuted) 0.5f else 0f) }
        })
        panel.add(createSeparator())

        val currentTrackId = (state.currentEntry as? QueueEntry.StreamingTrack)?.track?.id
        val isLiked = currentTrackId != null && state.savedTrackIds.contains(currentTrackId)
        val likeLabel = if (currentTrackId == null) "Like (No track)" else if (isLiked) "Unlike Track" else "Like Track"
        panel.add(createMenuItem(likeLabel, enabled = currentTrackId != null) {
            val trackId = currentTrackId ?: return@createMenuItem
            scope.launch {
                if (isLiked) savedTracksRepository.removeSavedTracks(listOf(trackId))
                else savedTracksRepository.saveTracks(listOf(trackId))
            }
        })
        panel.add(createSeparator())

        panel.add(createMenuItem("Exit") { onExit?.invoke() })

        panel.revalidate()
        panel.repaint()
        dialog.pack()
    }

    @Volatile
    private var currentState: TrayState? = null

    private fun observeState() {
        scope.launch {
            combine(
                audioPlayer.playerStateFlow,
                audioPlayer.currentMediaItemFlow,
                audioPlayer.loopStateFlow,
                audioPlayer.shuffleModeFlow,
                audioPlayer.volumeFlow,
                audioPlayerQueue.currentQueueEntryFlow,
                savedTracksRepository.savedTracksIdsFlow,
            ) { values ->
                TrayState(
                    playerState = values[0] as PlayerState,
                    mediaItem = values[1] as dev.krtirtho.spotube.core.audioplayer.MediaItem?,
                    loopState = values[2] as LoopState,
                    shuffleEnabled = values[3] as Boolean,
                    volume = values[4] as Float,
                    currentEntry = values[5] as QueueEntry?,
                    savedTrackIds = @Suppress("UNCHECKED_CAST") (values[6] as Set<String>),
                )
            }.collect { state ->
                currentState = state
                SwingUtilities.invokeLater {
                    updateTooltip(state)
                    menuDialog?.let { dialog ->
                        val panel = dialog.contentPane.getComponent(0) as? JPanel
                        if (panel != null) rebuildMenuPanel(panel, dialog)
                    }
                }
            }
        }
    }

    private fun updateTooltip(state: TrayState) {
        val icon = trayIcon ?: return
        val media = state.mediaItem
        icon.toolTip = if (media != null) {
            "Spotube - ${media.title} by ${media.artist}"
        } else {
            "Spotube"
        }
    }

    private fun createMenuItem(label: String, enabled: Boolean = true, action: () -> Unit): JMenuItem {
        return JMenuItem(label).apply {
            isEnabled = enabled
            maximumSize = Dimension(Int.MAX_VALUE, preferredSize.height)
            addActionListener { action() }
        }
    }

    private fun createCheckBoxMenuItem(label: String, selected: Boolean, action: () -> Unit): JCheckBoxMenuItem {
        return JCheckBoxMenuItem(label, selected).apply {
            maximumSize = Dimension(Int.MAX_VALUE, preferredSize.height)
            addActionListener { action() }
        }
    }

    private fun createDisabledLabel(text: String): JLabel {
        return JLabel(text).apply {
            foreground = Color(150, 150, 150)
            maximumSize = Dimension(Int.MAX_VALUE, preferredSize.height)
            alignmentX = java.awt.Component.LEFT_ALIGNMENT
        }
    }

    private fun createSubMenuLabel(text: String): JLabel {
        return JLabel(text).apply {
            foreground = UIManager.getColor("MenuItem.foreground") ?: Color.WHITE
            maximumSize = Dimension(Int.MAX_VALUE, preferredSize.height)
            alignmentX = java.awt.Component.LEFT_ALIGNMENT
        }
    }

    private fun createSeparator(): javax.swing.JSeparator {
        return javax.swing.JSeparator().apply {
            maximumSize = Dimension(Int.MAX_VALUE, 2)
        }
    }

    fun setWindowVisible(visible: Boolean) {
        windowVisible = visible
    }

    override fun close() {
        menuDialog?.dispose()
        menuDialog = null
        trayIcon?.let {
            try {
                SystemTray.getSystemTray().remove(it)
            } catch (e: Exception) {
                logger.e(e) { "Failed to remove tray icon" }
            }
        }
        trayIcon = null
    }

    private fun createTrayIconImage(): Image {
        val resource = javaClass.classLoader.getResource("icon.png")
            ?: javaClass.classLoader.getResource("icons/spotube.png")
        if (resource != null) {
            return Toolkit.getDefaultToolkit().getImage(resource)
        }
        val img = BufferedImage(16, 16, BufferedImage.TYPE_INT_ARGB)
        val g = img.createGraphics()
        g.color = Color(34, 197, 94)
        g.fillOval(0, 0, 16, 16)
        g.color = Color.WHITE
        g.fillOval(5, 5, 6, 6)
        g.dispose()
        return img
    }

    private class TrayMenuDialog : JDialog()

    private data class TrayState(
        val playerState: PlayerState,
        val mediaItem: dev.krtirtho.spotube.core.audioplayer.MediaItem?,
        val loopState: LoopState,
        val shuffleEnabled: Boolean,
        val volume: Float,
        val currentEntry: QueueEntry?,
        val savedTrackIds: Set<String>,
    )
}
