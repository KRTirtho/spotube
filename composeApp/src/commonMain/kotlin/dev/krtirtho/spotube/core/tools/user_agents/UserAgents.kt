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

package dev.krtirtho.spotube.core.tools.user_agents

object UserAgents {
    private val agents = listOf(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Linux; Android 15; ALI-NX1 Build/HONORALI-N21) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/147.0.7727.92 Mobile Safari/537.36",
        "Mozilla/5.0 (Linux; Android 14; SM-A528B Build/UP1A.231005.007) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/147.0.7727.108 Mobile Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:68.0) Gecko/20100101 Firefox/68.0 Waterfox/56.6.2021.2816",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X10.14; rv:65.0) Gecko/20100101 Firefox/65.0 Waterfox/56.2.7",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Vivaldi/7.6.3797.63",
        "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.91 Safari/537.36 Vivaldi/1.92.917.39",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Vivaldi/7.5.3735.47"
    )

    fun random(): String = agents.random()
}
