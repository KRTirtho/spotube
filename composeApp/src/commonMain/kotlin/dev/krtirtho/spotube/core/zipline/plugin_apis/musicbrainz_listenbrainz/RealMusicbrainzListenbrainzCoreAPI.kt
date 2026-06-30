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

package dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz

import arrow.core.Either
import com.kroegerama.openapi.kmp.gen.companion.appendSerializedQueryParameter
import dev.krtirtho.plugin_interfaces.host_apis.PersistedStorageAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.core.CoreAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.core.PluginUpdateInfo
import dev.krtirtho.spotube.core.webview.WebViewController
import dev.krtirtho.spotube.listenbrainz.Api
import dev.krtirtho.spotube.listenbrainz.Auth
import dev.krtirtho.spotube.listenbrainz.api.LbCoreApi
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import net.swiftzer.semver.SemVer

class RealMusicbrainzListenbrainzCoreAPI(
    private val scope: CoroutineScope,
    private val webViewController: WebViewController,
    private val persistedStorage: PersistedStorageAPI
) : CoreAPI {
    init {
        scope.launch {
            val token = persistedStorage.getString("listenbrainz_auth_token")
            if (token != null) {
                auth = Auth.ApiKeyAuth { token }
                Api.setAuthProvider(auth!!)
                loggedInState.value = true
            } else {
                loggedInState.value = false
            }
        }
    }

    override suspend fun checkPluginUpdates(currentVersion: SemVer): PluginUpdateInfo? {
        return null
    }

    override fun supportMarkdownText(currentVersion: SemVer): String {
        return "Keep supporting Spotube!"
    }

    override val requiresAuthentication = true

    private val loggedInState = MutableStateFlow(false)
    override val loggedInFlow = loggedInState.asStateFlow()

    private var auth: Auth? = null

    override suspend fun login() {
        webViewController.navigateToHTML(
            """
            <!DOCTYPE html>
            <html>
                <head>
                    <title>Login to Listenbrainz</title>
                </head>
                <body>
                    <h1>Login to Listenbrainz</h1>
                    <form id="loginForm">
                        <input type="password" id="password" placeholder="API Token" />
                        <button id="loginButton" type="submit">Login</button>
                    </form>
                    <span id="mirror">Mirror: </span>
                </body>
            </html>
            <script type="text/javascript">
                document.addEventListener("DOMContentLoaded", function() {
                    const input = document.getElementById("password");
                    const mirror = document.getElementById("mirror");
                    input.addEventListener("input", function() {
                        mirror.textContent = "Mirror: " + input.value;
                    });        
                    
                    const form = document.getElementById("loginForm");
                    const initBridge = () => form.addEventListener("submit", function(event) {
                        try {
                            event.preventDefault();
                            const passwordInput = document.getElementById("password");
                            const token = passwordInput.value.trim();
                            if (token) {
                                sendMessage(token);
                            } else {
                                mirror.textContent = "Error: API token cannot be empty.";
                                console.error("API token cannot be empty.");
                            }
                        } catch (error) {
                            mirror.textContent = "Error: " + error.message;
                            console.error("Error during form submission:", error);
                        }
                    });
                    
                    if(window.bridgeReady) {
                        initBridge();
                    } else {
                        window.addEventListener('onBridgeReady', initBridge);
                    }
                });
            </script>
        """.trimIndent()
        )

        println("[RealMusicbrainzListenbrainzCoreAPI.login] Waiting for postMessagesFlow message")
        val actualCreds = webViewController.postMessagesFlow
            .onEach {
                println("[postMessagesFlow.onEach] Received token from WebView: $it")
            }
            .filter { it.isNotBlank() }
            .first()
        println("Received token from WebView: $actualCreds")
        auth = Auth.ApiKeyAuth {
            actualCreds
        }
        Api.setAuthProvider(auth = auth!!)
        when (val res = LbCoreApi.validateToken {
            appendSerializedQueryParameter("token", actualCreds)
        }) {
            is Either.Left -> {
                webViewController.closeWebview()
                throw res.value
            }

            is Either.Right -> {
                if (!res.value.data.valid) {
                    webViewController.closeWebview()
                    throw Exception("Invalid token")
                }
                persistedStorage.putString("listenbrainz_auth_token", actualCreds)
                loggedInState.value = true
                webViewController.closeWebview()
            }
        }
    }

    override suspend fun logout() {
        if (auth == null) return
        Api.clearAuthProvider(auth!!)
        auth = null
        persistedStorage.remove("listenbrainz_auth_token")
        loggedInState.value = false
    }
}