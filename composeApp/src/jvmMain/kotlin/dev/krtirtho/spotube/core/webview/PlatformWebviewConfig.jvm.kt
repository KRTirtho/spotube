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

package dev.krtirtho.spotube.core.webview

import dev.krtirtho.spotube.core.paths.Paths
import io.github.kdroidfilter.webview.web.WebViewState
import io.github.vinceglb.filekit.utils.div
import io.github.vinceglb.filekit.utils.toPath
import org.koin.core.context.GlobalContext

actual fun platformWebviewConfig(webView: WebViewState) {
    val paths = GlobalContext.get().get<Paths>()

    webView.webSettings.desktopWebSettings.dataDirectory =
        (paths.getApplicationCacheDirPath().toPath() / "webview_data").toString()
}