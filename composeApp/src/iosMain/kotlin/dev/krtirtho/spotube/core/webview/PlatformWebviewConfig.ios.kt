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

import io.github.kdroidfilter.webview.web.WebViewState
import kotlinx.cinterop.ExperimentalForeignApi
import platform.Foundation.NSDate
import platform.Foundation.NSHTTPCookieStorage
import platform.Foundation.distantPast
import platform.WebKit.WKWebsiteDataStore
import platform.WebKit.WKWebsiteDataTypeCookies
import platform.WebKit.WKWebsiteDataTypeLocalStorage

actual fun platformWebviewConfig(webView: WebViewState, pluginId: String?) {
}

@OptIn(ExperimentalForeignApi::class)
actual suspend fun platformClearWebviewData(pluginId: String?) {
    if (pluginId == null) return
    
    val dataStore = WKWebsiteDataStore.defaultDataStore()
    val dataTypes = setOf(WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage)
    dataStore.removeDataOfTypes(dataTypes, NSDate.distantPast) {}
    
    NSHTTPCookieStorage.sharedHTTPCookieStorage.removeCookiesSinceDate(NSDate.distantPast)
}