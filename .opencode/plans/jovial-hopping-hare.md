# WebRTC Support for Group Jam & Remote Control

## Overview
Add two peer-to-peer features to Spotube:
1. **Listen Together (Group Jam)**: Multi-user synced queue over WebRTC data channels (star topology, manual SDP exchange)
2. **Remote Control**: LAN-only device control via WebSocket on the existing `LocalServer` (extended with control routes). No WebRTC needed for this feature.

Both features share UI patterns (adaptive dialogs for play interception) but use different transport layers based on their requirements.

---

## Prerequisites (One-Time Setup)

Before starting implementation:

1. **Initialize webrtc-rs submodule**:
   ```bash
   cd build/webrtc-rs && git submodule update --init --recursive
   ```
   The `rtc` crate (Sans-I/O core) is a git submodule and must be initialized before building.

2. **Verify dns-sd-kt availability**:
   - Published to Maven Central: `com.appstractive:dns-sd-kt:1.1.0`
   - No setup needed; just add to `libs.versions.toml`

3. **Verify Rust toolchain**:
   - Existing uniffi setup already works (discord-rpc, metadata modules)
   - Ensure `cargo` is available and can build for all targets

---

## Architecture Decisions (Confirmed)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| WebRTC implementation | `webrtc-rs` via uniffi | Single codebase, identical behavior across platforms |
| Jam topology | Star (host ↔ peers) | Simpler, scales better, matches host-authority model |
| Remote Control transport | TCP/WebSocket only | LAN-only, so WebRTC is overkill; direct connection is simpler |
| Jam signaling | Manual SDP exchange | No server infrastructure needed; users copy-paste or scan QR |

---

## Phase 0: Rust Uniffi WebRTC Module

### Goal
Add `webrtc-rs` to the existing Rust crate and expose a uniffi API for WebRTC peer connections and data channels.

### Library Details (from `build/webrtc-rs`)
- **Crate**: `webrtc` v0.21.0-beta.1 (pure Rust, no external C/C++ libs)
- **Architecture**: Sans-I/O core (`rtc` crate) + async API layer
- **Async runtime**: tokio (default) or smol
- **Crypto**: `ring` (default) or `aws-lc-rs`
- **Key types**:
  - `PeerConnection` (trait) — created via `PeerConnectionBuilder::build()`
  - `DataChannel` (trait) — created via `peer.create_data_channel()`
  - `RTCSessionDescription` — SDP offer/answer
  - `RTCIceCandidateInit` — ICE candidates
  - `PeerConnectionEventHandler` (trait) — callback interface for events
  - `DataChannelEvent` (enum) — polled via `dc.poll().await`
- **Event model**: PeerConnection uses callbacks; DataChannel uses polling
- **Submodule**: `rtc` git submodule must be initialized before building

### Files to Modify
- `composeApp/Cargo.toml` — add `webrtc` dependency
- `composeApp/src/commonMain/rust/lib.rs` — register new module
- `composeApp/src/commonMain/rust/webrtc_p2p.rs` — **NEW**: uniffi API

### Implementation

1. **Initialize webrtc-rs submodule** (one-time setup):
   ```bash
   cd build/webrtc-rs && git submodule update --init --recursive
   ```

2. **Add webrtc-rs dependency** to `composeApp/Cargo.toml`:
   ```toml
   [dependencies]
   webrtc = { path = "../build/webrtc-rs", features = ["runtime-tokio", "crypto-ring"] }
   tokio = { version = "1", features = ["full"] }
   async-trait = "0.1"
   ```
   
   **Note**: Using path dependency to the local clone. For production, switch to crates.io version once stable.

3. **Define uniffi API** in `webrtc_p2p.rs`:
   
   **Core objects**:
   ```rust
   #[uniffi::export]
   pub struct PeerConnectionWrapper {
       pc: Arc<dyn PeerConnection>,
       runtime: Arc<dyn Runtime>,
   }
   
   #[uniffi::export]
   impl PeerConnectionWrapper {
       pub async fn create_offer(&self) -> Result<String, WebrtcError> {
           let offer = self.pc.create_offer(None).await?;
           Ok(offer.sdp)
       }
       
       pub async fn set_remote_answer(&self, answer: String) -> Result<(), WebrtcError> {
           let desc = RTCSessionDescription::answer(answer)?;
           self.pc.set_remote_description(desc).await?;
           Ok(())
       }
       
       pub async fn create_answer(&self) -> Result<String, WebrtcError> {
           let answer = self.pc.create_answer(None).await?;
           Ok(answer.sdp)
       }
       
       pub async fn set_remote_offer(&self, offer: String) -> Result<(), WebrtcError> {
           let desc = RTCSessionDescription::offer(offer)?;
           self.pc.set_remote_description(desc).await?;
           Ok(())
       }
       
       pub async fn send_data(&self, channel: String, data: String) -> Result<(), WebrtcError> {
           // Find or cache data channel by label
           // ...
           Ok(())
       }
       
       pub async fn close(&self) -> Result<(), WebrtcError> {
           self.pc.close().await?;
           Ok(())
       }
   }
   ```
   
   **Callback interface for events**:
   ```rust
   #[uniffi::export(callback_interface)]
   pub trait PeerConnectionEventHandler {
       fn on_ice_candidate(&self, candidate: String);
       fn on_connection_state_change(&self, state: String);
       fn on_data_channel(&self, label: String);
       fn on_data_channel_message(&self, label: String, data: String);
   }
   ```
   
   **Factory function**:
   ```rust
   #[uniffi::export]
   pub async fn create_peer_connection(
       ice_servers: Vec<String>,
       handler: Arc<dyn PeerConnectionEventHandler>,
   ) -> Result<PeerConnectionWrapper, WebrtcError> {
       // Build RTCConfiguration from ice_servers
       // Create MediaEngine, Registry
       // Build PeerConnection with handler wrapper
       // Spawn task to poll data channel events and forward to handler
       Ok(PeerConnectionWrapper { pc, runtime })
   }
   ```
   
   **Key challenge**: webrtc-rs is fully async, but uniffi callbacks are synchronous. Solution:
   - Wrap the `PeerConnectionEventHandler` trait in a Rust adapter that spawns async tasks
   - Use `tokio::sync::mpsc` channels to bridge async events → sync callbacks
   - For DataChannel polling, spawn a background task that calls `dc.poll().await` in a loop and forwards messages to the Kotlin handler

4. **Register module** in `lib.rs`:
   ```rust
   mod webrtc_p2p;
   pub use webrtc_p2p::*;
   ```

5. **Cross-compilation considerations**:
   - **Good news**: webrtc-rs is pure Rust (no libwebrtc/BoringSSL C++ deps)
   - **Crypto**: `ring` compiles from source for all targets (requires C compiler for Android/iOS)
   - **JVM desktop**: Should work out of the box
   - **Android**: Requires NDK + `ring` cross-compilation setup (well-supported)
   - **iOS**: Requires `ring` cross-compilation for aarch64-apple-ios
   - **Gobley plugin**: Already configured for multi-target Rust builds in `composeApp/build.gradle.kts`

### Verification
- Initialize submodule: `cd build/webrtc-rs && git submodule update --init --recursive`
- Build Rust crate: `cargo build --release` in `composeApp/`
- Verify Kotlin bindings are generated in `uniffi.compose_app.*`
- Write a simple Kotlin test that creates a peer connection and exchanges SDP

---

## Phase 1: Remote Control (LAN-only, extend existing LocalServer)

### Goal
Allow users to control playback on another device on the same LAN. Opt-in via settings. DNS-SD for discovery (via dns-sd-kt). Extend the existing `LocalServer` with WebSocket routes for control commands — no separate server needed.

### 1.1 Settings & Permissions

#### Files to Modify
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/settings/SettingsModels.kt` — add fields to `UserSettings`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/settings/sections/PlaybackSection.kt` — add toggle UI
- `composeApp/src/commonMain/composeResources/values/strings.xml` — add strings
- `composeApp/src/androidMain/AndroidManifest.xml` — add permissions
- `iosApp/iosApp/Info.plist` — add Bonjour services

#### Implementation
1. **Add to `UserSettings`**:
   ```kotlin
   val allowRemoteControl: Boolean = false,
   val allowedRemoteDevices: List<String> = emptyList(), // device IDs
   ```

2. **Add toggle UI** in `PlaybackSection.kt`:
   - Use `SwitchSettingCard` for "Allow remote control"
   - Add a "Manage allowed devices" item that navigates to a sub-screen (see `Routes.Blacklist` pattern)

3. **Add string resources**:
   ```xml
   <string name="settings_allow_remote_control_title">Allow Remote Control</string>
   <string name="settings_allow_remote_control_subtitle">Let other devices on your network control playback</string>
   ```

4. **Android permissions** (dns-sd-kt requires these):
   ```xml
   <!-- Already present -->
   <uses-permission android:name="android.permission.INTERNET" />
   
   <!-- Required by dns-sd-kt for mDNS multicast -->
   <uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE" />
   
   <!-- Required on Android 16+ (Baklava) -->
   <uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" />
   ```
   
   **Note**: dns-sd-kt uses `androidx.startup` to auto-initialize `Context` — no manual init needed.

5. **iOS Info.plist** (add to `iosApp/iosApp/Info.plist`):
   ```xml
   <key>NSLocalNetworkUsageDescription</key>
   <string>Spotube needs access to your local network to discover and control other devices.</string>
   <key>NSBonjourServices</key>
   <array>
     <string>_spotube-ctrl._tcp</string>
   </array>
   ```
   
   **Note**: dns-sd-kt's Apple backend uses `NWBrowser` (Network.framework) + custom Swift bridge. The `NSBonjourServices` key is required for Bonjour discovery to work.

### 1.2 DNS-SD Discovery

#### Library Details (from `build/dns-sd-kt`)
- **Maven Central**: `com.appstractive:dns-sd-kt:1.1.0`
- **KMP library**: supports Android, JVM, iOS (arm64 + simulatorArm64), macOS, tvOS
- **Fully coroutine/Flow-based** — no callback-style API
- **Platform backends**:
  - Android: `NsdManager` (pure Kotlin)
  - JVM: `JmDNS 3.6.3` (pure Java)
  - Apple: `NWBrowser` + `NSNetService` + custom Swift bridge via `spm4kmp`
- **Two-phase resolution**: `DiscoveryEvent.Discovered` → call `resolve()` → `DiscoveryEvent.Resolved` with addresses
- **Auto-init on Android**: uses `androidx.startup` to grab `Context`

#### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/discovery/DeviceDiscoveryService.kt` — wraps dns-sd-kt APIs

#### Files to Modify
- `gradle/libs.versions.toml` — add dns-sd-kt dependency
- `composeApp/build.gradle.kts` — add to commonMain dependencies

#### Implementation

1. **Add dns-sd-kt dependency** to `gradle/libs.versions.toml`:
   ```toml
   [versions]
   dns-sd-kt = "1.1.0"
   
   [libraries]
   dns-sd-kt = { module = "com.appstractive:dns-sd-kt", version.ref = "dns-sd-kt" }
   ```

2. **Add to `composeApp/build.gradle.kts`** in `commonMain.dependencies`:
   ```kotlin
   implementation(libs.dns.sd.kt)
   ```

3. **Create `DeviceDiscoveryService`** in `commonMain` (no expect/actual needed — dns-sd-kt handles platform differences):
   ```kotlin
   class DeviceDiscoveryService {
       private val serviceType = "_spotube-ctrl._tcp"
       
       fun discoverDevices(): Flow<DiscoveryEvent> = discoverServices(serviceType)
       
       suspend fun registerDevice(deviceId: String, deviceName: String, port: Int): NetService {
           val service = createNetService(
               type = serviceType,
               name = deviceName,
               port = port,
               txt = mapOf("deviceId" to deviceId),
           )
           service.register()
           return service
       }
   }
   ```

4. **Usage in ViewModel**:
   ```kotlin
   // Discover devices
   discoveryService.discoverDevices()
       .onEach { event ->
           when (event) {
               is DiscoveryEvent.Discovered -> {
                   event.resolve() // trigger address resolution
                   // Add to discovered devices list (addresses may be empty)
               }
               is DiscoveryEvent.Resolved -> {
                   // Update with resolved addresses/host
               }
               is DiscoveryEvent.Removed -> {
                   // Remove from list
               }
           }
       }
       .launchIn(viewModelScope)
   ```

5. **Register in Koin** in `Modules.kt`:
   ```kotlin
   single { DeviceDiscoveryService() }
   ```

6. **No expect/actual needed** — dns-sd-kt is a KMP library that handles platform differences internally. The Apple targets use Swift interop via `spm4kmp`, which is transparent to consumers.

### 1.3 Control Server (Extend LocalServer)

#### Decision: Reuse Existing LocalServer
The app already has a Ktor CIO-based `LocalServer` running on `127.0.0.1:<playbackProxyServerPort>` for the playback proxy. We'll extend it with WebSocket routes for control commands. When remote control is enabled, the server binds to `0.0.0.0` (LAN-accessible); otherwise it stays on `127.0.0.1` (local-only).

#### Files to Modify
- `gradle/libs.versions.toml` — add `ktor-server-websockets`, `ktor-client-websockets`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/server/LocalServer.kt` — add WebSocket routes, conditional bind to `0.0.0.0`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/di/Modules.kt` — update LocalServer registration

#### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/remote/RemoteControlHandler.kt` — handles control messages
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/remote/RemoteControlProtocol.kt` — message definitions
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/remote/RemotePlayerProxy.kt` — wraps AudioPlayerInterface for remote control

#### Implementation
1. **Add WebSocket dependencies** to `libs.versions.toml`:
   ```toml
   ktor-server-websockets = { module = "io.ktor:ktor-server-websockets", version.ref = "ktor" }
   ktor-client-websockets = { module = "io.ktor:ktor-client-websockets", version.ref = "ktor" }
   ```

2. **Extend `LocalServer.kt`**:
   - Add `RemoteControlHandler` constructor parameter
   - In `configureRoutes()`, install `WebSockets` plugin and add `/control` WebSocket route
   - In `restartServer()`, check `settings.allowRemoteControl`:
     - If enabled: bind to `0.0.0.0` (LAN-accessible)
     - If disabled: bind to `127.0.0.1` (local-only, current behavior)
   - Add a watcher that restarts the server when `allowRemoteControl` setting changes

   ```kotlin
   private suspend fun restartServer(port: Int) {
       val allowRemoteControl = settingsViewModel.settingsState.value?.allowRemoteControl ?: false
       val host = if (allowRemoteControl) "0.0.0.0" else "127.0.0.1"
       
       serverState.value = embeddedServer(
           factory = CIO,
           host = host,
           port = port,
           module = { configureRoutes() }
       ).also { engine ->
           engine.start(wait = false)
       }
   }
   
   private fun Application.configureRoutes() {
       install(WebSockets)
       routing {
           get("/health") { call.respondText("ok") }
           // ... existing routes ...
           
           webSocket("/control") {
               remoteControlHandler.handleConnection(this)
           }
       }
   }
   ```

3. **Define protocol** in `RemoteControlProtocol.kt`:
   ```kotlin
   @Serializable
   sealed class RemoteControlMessage {
       @Serializable data class Play(val trackId: String) : RemoteControlMessage()
       @Serializable data class Pause(val unit: Unit = Unit) : RemoteControlMessage()
       @Serializable data class Seek(val positionMs: Long) : RemoteControlMessage()
       @Serializable data class SetVolume(val volume: Float) : RemoteControlMessage()
       @Serializable data class AddToQueue(val trackId: String) : RemoteControlMessage()
       // ... etc
   }
   
   @Serializable
   sealed class RemoteStateUpdate {
       @Serializable data class PlayerState(val state: PlayerUiState) : RemoteStateUpdate()
       @Serializable data class QueueUpdate(val queue: List<QueueEntry>) : RemoteStateUpdate()
   }
   ```

4. **Create `RemoteControlHandler`**:
   - Handles incoming WebSocket connections on the controlled device
   - Checks `settings.allowRemoteControl` before accepting (rejects immediately if disabled)
   - Shows connection request dialog (allow/allow-always/deny) via a callback injected from the UI layer
   - On acceptance: forwards commands to `AudioPlayerInterface` and `AudioPlayerQueue`
   - Broadcasts state updates (player state, queue) to the connected controller

5. **Create `RemotePlayerProxy`**:
   - Wraps `AudioPlayerInterface` and `AudioPlayerQueue` on the controlling device
   - Sends commands over WebSocket to the controlled device
   - Receives state updates and exposes them as StateFlows
   - **Implementation note**: Full interface implementation is complex. Alternative: create a separate `RemotePlayerState` StateFlow that mirrors remote state, and the UI uses it instead of `rememberPlayerUiState()`.

6. **Register in Koin** in `Modules.kt`:
   ```kotlin
   single { RemoteControlHandler(get(), get(), get()) }
   // LocalServer constructor updated; no other DI changes needed
   ```

### Key Simplification
By reusing `LocalServer`, we eliminate the need for:
- A separate WebSocket server
- Separate port management
- Duplicate Ktor configuration

The server becomes a multi-purpose local server: playback proxy (always) + control endpoint (when enabled).

### 1.4 UI: Devices Screen

#### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/devices/DevicesScreen.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/devices/DevicesViewModel.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/devices/RemotePlayerScreen.kt`

#### Files to Modify
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/navigation/NavigationModule.kt` — add `Routes.Devices`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/shell/AppSidebar.kt` — add "Devices" button at bottom
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/home/HomeScreen.kt` — add "Devices" icon to TopAppBar actions

#### Implementation
1. **Add route** to `NavigationModule.kt`:
   ```kotlin
   @Serializable
   data object Devices : Routes
   
   navigation<Routes.Devices> {
       DevicesScreen(...)
   }
   ```

2. **Add sidebar button** in `AppSidebar.kt` (after line 177):
   ```kotlin
   SidebarItem(
       title = "Devices",
       icon = Icons.Default.Devices,
       onClick = { navigator.navigate(Routes.Devices) }
   )
   ```

3. **Add TopAppBar action** in `HomeScreen.kt`:
   ```kotlin
   ApplicationMainBar(
       actions = {
           IconButton(onClick = { navigator.navigate(Routes.Devices) }) {
               Icon(Icons.Default.Devices, "Devices")
           }
       }
   )
   ```

4. **DevicesScreen**:
   - Shows list of discovered devices (from `DeviceDiscoveryService`)
   - Each device shows name, IP, and connection status
   - Clicking a device initiates connection (WebSocket)
   - After connection, navigates to `RemotePlayerScreen`

5. **RemotePlayerScreen**:
   - Similar to `AppExpandedPlayer` but uses `RemotePlayerProxy` instead of local `AudioPlayerInterface`
   - All controls (play/pause/seek/volume/queue) forward to remote device

### 1.5 Connection Request Flow

#### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/remote/ConnectionRequestDialog.kt`

#### Implementation
1. When a new device tries to connect, `RemoteControlService` shows a dialog:
   ```kotlin
   AdaptiveDialogBottomSheet(
       title = { Text("Remote Control Request") },
       content = {
           Text("Device '${deviceName}' wants to control playback")
       },
       actions = {
           Button(onClick = { deny() }) { Text("Deny") }
           Button(onClick = { allow(always = false) }) { Text("Allow") }
           Button(onClick = { allow(always = true) }) { Text("Allow Always") }
       }
   )
   ```

2. If "Allow Always", add device ID to `settings.allowedRemoteDevices`

---

## Phase 2: Group Jam (WebRTC, Manual SDP)

### Goal
Multi-user synced queue over WebRTC data channels. Host creates session, shares SDP offer (via copy-paste or QR), guests join. Star topology (host ↔ peers).

### 2.1 Jam Session Service

#### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/jam/JamSessionService.kt` — manages WebRTC connections
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/jam/JamProtocol.kt` — message definitions
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/jam/QueueSyncManager.kt` — syncs queue state

#### Implementation
1. **Define protocol** in `JamProtocol.kt`:
   ```kotlin
   @Serializable
   sealed class JamMessage {
       // Host → Peers
       @Serializable data class QueueState(val queue: List<QueueEntry>, val currentIndex: Int) : JamMessage()
       @Serializable data class PlaybackCommand(val command: PlaybackCommand) : JamMessage()
       @Serializable data class ParticipantList(val participants: List<Participant>) : JamMessage()
       
       // Peers → Host
       @Serializable data class SuggestTrack(val trackId: String) : JamMessage()
       @Serializable data class SuggestPlaylist(val playlistId: String) : JamMessage()
       @Serializable data class ChatMessage(val text: String) : JamMessage()
   }
   
   data class Participant(val id: String, val name: String, val isHost: Boolean)
   ```

2. **Create `JamSessionService`** using the uniffi WebRTC API from Phase 0:
   ```kotlin
   class JamSessionService(
       private val audioPlayerQueue: AudioPlayerQueue,
       private val audioPlayer: AudioPlayerInterface,
   ) {
       private var peerConnection: PeerConnectionWrapper? = null
       private val _participants = MutableStateFlow<List<Participant>>(emptyList())
       val participants: StateFlow<List<Participant>> = _participants
       
       suspend fun createSession(): String {
           // Create peer connection with ICE servers
           peerConnection = create_peer_connection(
               iceServers = listOf("stun:stun.l.google.com:19302"),
               handler = object : PeerConnectionEventHandler {
                   override fun on_ice_candidate(candidate: String) {
                       // ICE candidates are bundled into SDP (non-trickle mode)
                   }
                   override fun on_data_channel_message(label: String, data: String) {
                       // Parse JamMessage and handle
                   }
                   // ... other callbacks
               }
           )
           
           // Create data channel for jam messages
           // Create SDP offer and return it for sharing
           val offer = peerConnection!!.create_offer()
           return offer
       }
       
       suspend fun joinSession(offer: String): String {
           // Create peer connection
           peerConnection = create_peer_connection(...)
           
           // Set remote offer and create answer
           peerConnection!!.set_remote_offer(offer)
           val answer = peerConnection!!.create_answer()
           return answer
       }
       
       suspend fun sendMessage(message: JamMessage) {
           val json = Json.encodeToString(message)
           peerConnection?.send_data("jam", json)
       }
   }
   ```
   
   **Key points**:
   - Uses `uniffi.compose_app.create_peer_connection()` from Phase 0
   - Host creates multiple peer connections (one per guest) — star topology
   - Data channel labeled "jam" for all jam messages
   - SDP exchange is manual (copy-paste or QR code)

3. **Create `QueueSyncManager`**:
   - On host: wraps `AudioPlayerQueue`, intercepts all queue mutations, broadcasts them via `JamSessionService.sendMessage()`
   - On guest: receives queue mutations, applies them to local queue
   - Handles conflict resolution (host authority: host's commands always win)

4. **Register in Koin**:
   ```kotlin
   single { JamSessionService(get(), get()) }
   ```

### 2.2 Jam Session UI

#### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/jam/JamScreen.kt` — create/join session
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/jam/JamViewModel.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/jam/JamSessionScreen.kt` — active session view
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/jam/SdpExchangeDialog.kt` — copy-paste SDP

#### Files to Modify
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/navigation/NavigationModule.kt` — add `Routes.Jam`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/shell/AppSidebar.kt` — add "Group Jam" button
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/home/HomeScreen.kt` — add "Group Jam" icon to TopAppBar

#### Implementation
1. **Add route**:
   ```kotlin
   @Serializable
   data object Jam : Routes
   
   navigation<Routes.Jam> {
       JamScreen(...)
   }
   ```

2. **Add sidebar button** (above "Devices"):
   ```kotlin
   SidebarItem(
       title = "Group Jam",
       icon = Icons.Default.Group,
       onClick = { navigator.navigate(Routes.Jam) }
   )
   ```

3. **JamScreen**:
   - Two tabs: "Create Session" and "Join Session"
   - **Create Session**:
     - Generates SDP offer via `JamSessionService`
     - Shows SDP as copyable text and QR code
     - Waits for guests to connect
   - **Join Session**:
     - Text field to paste SDP offer
     - QR code scanner (optional)
     - Generates SDP answer and shows it for host to paste back

4. **JamSessionScreen**:
   - Shows list of participants (from `JamSessionService`)
   - Shows current track and queue
   - Playback controls (only work for host; guests send suggestions)
   - Suggest track/playlist buttons
   - Chat/messages area (optional)

5. **SdpExchangeDialog**:
   - Shows SDP string in a `TextField` (read-only for offer, editable for answer)
   - "Copy" button
   - "Paste" button (for answer)
   - QR code display (using a QR generation library)

### 2.3 Play Interception

#### Files to Modify
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/playlist/PlaylistViewModel.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/album/AlbumViewModel.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/artist/ArtistScreen.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/search/SearchScreen.kt`

#### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/jam/PlayDestinationPicker.kt`

#### Implementation
1. **Create `PlayDestinationPicker`**:
   ```kotlin
   @Composable
   fun PlayDestinationPicker(
       onPlayLocally: () -> Unit,
       onSuggestToJam: () -> Unit,
       onDismiss: () -> Unit
   ) {
       AdaptiveDialogBottomSheet(
           title = { Text("Play Where?") },
           content = {
               Column {
                   Button(onClick = onPlayLocally) { Text("Play on This Device") }
                   Button(onClick = onSuggestToJam) { Text("Suggest to Jam Session") }
               }
           },
           onDismiss = onDismiss
       )
   }
   ```

2. **Modify ViewModels**:
   - In `PlaylistViewModel.playPlaylist()`, check if `JamSessionService.isActive`
   - If active, show `PlayDestinationPicker` instead of calling `playbackHelper.playPlaylist()` directly
   - If user chooses "Suggest to Jam", call `JamSessionService.suggestPlaylist(playlistId)`

3. **Apply same pattern** to `AlbumViewModel`, `ArtistScreen`, `SearchScreen`

---

## Phase 3: Deep-Link Handling (Optional Enhancement)

### Goal
Allow users to open `spotube://jam/<session-id>` links to join a Jam session. With manual SDP exchange, the deep link can contain a session ID + a short-lived token, and the actual SDP exchange happens in the app.

### Files to Modify
- `composeApp/src/androidMain/AndroidManifest.xml` — add intent filter
- `iosApp/iosApp/ContentView.swift` — add `onOpenURL` handler
- `composeApp/src/jvmMain/kotlin/dev/krtirtho/spotube/main.kt` — parse command-line args

### Files to Create
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/deeplink/DeepLinkService.kt` — expect interface
- Platform actuals

### Implementation
1. **Android**: Add intent filter to `MainActivity`:
   ```xml
   <intent-filter>
       <action android:name="android.intent.action.VIEW" />
       <category android:name="android.intent.category.DEFAULT" />
       <category android:name="android.intent.category.BROWSABLE" />
       <data android:scheme="spotube" android:host="jam" />
   </intent-filter>
   ```

2. **iOS**: Add `onOpenURL` in `ContentView.swift`:
   ```swift
   .onOpenURL { url in
       // Pass to Compose via a callback
   }
   ```

3. **Desktop**: Parse `args` in `main.kt`:
   ```kotlin
   fun main(args: Array<String>) {
       val deepLink = args.firstOrNull { it.startsWith("spotube://") }
       // Pass to Compose
   }
   ```

4. **DeepLinkService**: Parse URL, navigate to `Routes.Jam(sessionId)`

---

## Implementation Order

1. **Phase 0**: Rust uniffi WebRTC module (foundation for Jam)
2. **Phase 1**: Remote Control (simpler, LAN-only, no WebRTC needed)
   - 1.1 Settings & Permissions
   - 1.2 DNS-SD Discovery (using dns-sd-kt)
   - 1.3 Extend LocalServer with WebSocket control routes + conditional bind
   - 1.4 UI: Devices Screen
   - 1.5 Connection Request Flow
3. **Phase 2**: Group Jam (WebRTC, manual SDP)
   - 2.1 Jam Session Service
   - 2.2 Jam Session UI
   - 2.3 Play Interception
4. **Phase 3**: Deep-Link Handling (optional, can be deferred)

---

## Key Files Summary

### Rust
- `composeApp/Cargo.toml` — add `webrtc` dependency
- `composeApp/src/commonMain/rust/lib.rs` — register `webrtc_p2p` module
- `composeApp/src/commonMain/rust/webrtc_p2p.rs` — **NEW**: uniffi API

### Settings
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/settings/SettingsModels.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/settings/sections/PlaybackSection.kt`

### Remote Control
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/discovery/DeviceDiscoveryService.kt` — **NEW**: wraps dns-sd-kt
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/remote/RemoteControlHandler.kt` — **NEW**: handles WebSocket control connections
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/remote/RemoteControlProtocol.kt` — **NEW**: message definitions
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/remote/RemotePlayerProxy.kt` — **NEW**: remote player state proxy
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/devices/DevicesScreen.kt` — **NEW**
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/devices/RemotePlayerScreen.kt` — **NEW**
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/server/LocalServer.kt` — **MODIFIED**: add WebSocket routes, conditional bind

### Group Jam
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/jam/JamSessionService.kt` — **NEW**
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/jam/JamScreen.kt` — **NEW**
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/jam/JamSessionScreen.kt` — **NEW**

### Navigation & UI
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/core/navigation/NavigationModule.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/shell/AppSidebar.kt`
- `composeApp/src/commonMain/kotlin/dev/krtirtho/spotube/modules/home/HomeScreen.kt`

### Permissions
- `composeApp/src/androidMain/AndroidManifest.xml`
- `iosApp/iosApp/Info.plist`

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| `webrtc-rs` `rtc` submodule not initialized | Document in setup: `cd build/webrtc-rs && git submodule update --init --recursive` |
| `ring` crypto cross-compilation for Android/iOS | Well-supported; may need NDK env vars for Android. Test early. |
| webrtc-rs is pre-release (0.21.0-beta.1) | API is stabilizing; pin version. Monitor for 1.0 release. |
| dns-sd-kt Apple targets use Swift interop (`spm4kmp`) | Published Maven Central artifacts include cinterop bindings. Should work transparently. |
| Manual SDP exchange is poor UX | Add QR code scanning as an alternative (Phase 2.2) |
| Queue sync conflicts in Jam | Host authority model: host's commands always win |
| WebRTC data channel reliability | Use ordered, reliable data channels (default in webrtc-rs) |
| Uniffi async/sync bridge for webrtc-rs | Use `tokio::sync::mpsc` channels to bridge async events → sync callbacks |

---

## Testing Strategy

1. **Unit tests**: Test protocol serialization, queue sync logic
2. **Integration tests**: Test WebSocket server/client, DNS-SD discovery
3. **Manual tests**: 
   - Remote Control: Two devices on same LAN, control playback from one to another
   - Group Jam: Three devices (1 host + 2 guests), sync queue and playback
4. **Cross-platform tests**: Verify on Android, iOS, JVM desktop (Linux/Windows/macOS)
