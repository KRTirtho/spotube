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

package dev.krtirtho.spotube

import java.awt.Desktop
import java.net.URI

class JVMPlatform : Platform {
    override val name: String = "Java ${System.getProperty("java.version")}"
    override val type: PlatformType = System.getProperty("os.name").let { osName ->
        when {
            osName.contains("win", ignoreCase = true) -> PlatformType.Windows
            osName.contains("mac", ignoreCase = true) -> PlatformType.MacOS
            osName.contains("nix", ignoreCase = true) || osName.contains(
                "nux",
                ignoreCase = true
            ) || osName.contains("aix", ignoreCase = true) -> PlatformType.Linux

            else -> PlatformType.Unknown
        }
    }
}

actual fun getPlatform(): Platform = JVMPlatform()

actual fun openUrlInBrowser(url: String) {
    Desktop.getDesktop().browse(URI(url))
}