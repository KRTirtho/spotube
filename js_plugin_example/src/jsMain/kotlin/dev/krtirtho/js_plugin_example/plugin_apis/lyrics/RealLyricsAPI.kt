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

package dev.krtirtho.js_plugin_example.plugin_apis.lyrics

import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.LyricType
import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.LyricsAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.SyncLyricsLine

class RealLyricsAPI : LyricsAPI {
    override val supportedLyricTypes: List<LyricType> = listOf(LyricType.STATIC, LyricType.SYNCED)

    override suspend fun getStaticLyrics(trackId: String): String {
        return """
            Dummy lyrics for track $trackId
            
            Verse 1:
            This is a placeholder line
            Singing through the test design
            
            Chorus:
            La la la, plugin sample song
            Everything compiles all along
        """.trimIndent()
    }

    override suspend fun getSyncedLyrics(trackId: String): List<SyncLyricsLine> {
        return listOf(
            SyncLyricsLine(time = 0L, text = "[$trackId] Intro"),
            SyncLyricsLine(time = 10_000L, text = "This is a synced dummy lyric line"),
            SyncLyricsLine(time = 20_000L, text = "Another line appears right on time"),
            SyncLyricsLine(time = 30_000L, text = "Chorus: La la la, plugin sample song"),
            SyncLyricsLine(time = 40_000L, text = "Outro: End of demo lyrics")
        )
    }
}