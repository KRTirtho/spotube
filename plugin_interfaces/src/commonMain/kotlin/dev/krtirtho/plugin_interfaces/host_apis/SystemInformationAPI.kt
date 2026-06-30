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

package dev.krtirtho.plugin_interfaces.host_apis

import app.cash.zipline.ZiplineService

const val SystemInformationAPI_SERVICE_NAME = "SystemInformationAPI"

interface SystemInformationAPI : ZiplineService {
    /**
     * ISO 8601 format, e.g. "America/New_York"
     */
    fun getTimeZone(): String

    /**
     * ISO 639-1 language code, e.g. "en"
     */
    fun getLocale(): String

    /**
     * Operating system name, e.g. "Windows", "macOS", "Linux", "iOS", "Android"
     */
    fun getOperatingSystem(): String

    /**
     * Application version, e.g. "1.0.0"
     */
    fun getAppVersion(): String
}