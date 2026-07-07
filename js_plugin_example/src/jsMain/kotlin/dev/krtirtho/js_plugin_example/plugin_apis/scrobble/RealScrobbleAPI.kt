/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package dev.krtirtho.js_plugin_example.plugin_apis.scrobble

import dev.krtirtho.plugin_interfaces.plugin_apis.scrobble.ScrobbleAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.scrobble.ScrobbleTrack

class RealScrobbleAPI: ScrobbleAPI {
    override suspend fun scrobble(track: ScrobbleTrack) {
        // No Op
    }
}