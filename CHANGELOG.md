# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [2.5.0](https://github.com/KRTirtho/spotube/compare/v2.4.1...v2.5.0) (2022-10-13)


### Features

* animated transition of root PageWindowTitleBar ([ff35e06](https://github.com/KRTirtho/spotube/commit/ff35e06a6605fc7ec762e716fb7bdf6f7eb45732))
* **auth:** new authentication flow using cookies and webview in android ([756b910](https://github.com/KRTirtho/spotube/commit/756b91007ee747c10ed10aa7060af49b555a2eaf))
* **downloader:** replace /skip all choice for downloaded tracks ([88d7ce5](https://github.com/KRTirtho/spotube/commit/88d7ce55a59f673d60cd9e85ab062bcb1b7dcbc3))
* implemented go_route shell/nested route ([3e498a4](https://github.com/KRTirtho/spotube/commit/3e498a4827a1118e0b23faec7cf114272f7838d4))
* **keyboard shortcuts:** play/pause on space, seek position on left/right ([2734454](https://github.com/KRTirtho/spotube/commit/2734454717bbfb5d0621c6ea72fa755ef4fc8602))
* **keyboard-shortcuts:** home sidebar tab navigation and close app ([8f258e7](https://github.com/KRTirtho/spotube/commit/8f258e709ada418dbeef8d272af370b1741afd9c))
* smoother list using fl_query and waypoint ([c77b0e1](https://github.com/KRTirtho/spotube/commit/c77b0e198b215180d863747e35998a17aff92720))
* sort tracks in playlist, album and local tracks ([cb4bd25](https://github.com/KRTirtho/spotube/commit/cb4bd25df154455d225c426cfeaaea36ac09e9b7))
* use of smaller sized images in `TrackTile` ([0ca97b4](https://github.com/KRTirtho/spotube/commit/0ca97b495f2a9ece8356f7813fc0e37d1cdb8608))
* volume slider mouse scroll and preference for Rotating Album Art [#255](https://github.com/KRTirtho/spotube/issues/255) ([edb6f3c](https://github.com/KRTirtho/spotube/commit/edb6f3cd1c9ee2961040b2fe7a91c48577cee4f7))


### Bug Fixes

* **android:** file_picker and permission_handler failure for sdk < 33 ([139d4dc](https://github.com/KRTirtho/spotube/commit/139d4dc033d9aaa1d6882bf0f53e96a3b1e87c95))
* cached local track is fetched from network ([abf4a57](https://github.com/KRTirtho/spotube/commit/abf4a5763a2faeedeb93d54e66c1f2482295b326))
* categories not showing for oauth exception ([4df917e](https://github.com/KRTirtho/spotube/commit/4df917e65ee20cbcf42394cc141b1cdcdd6cc914))
* **desktop:** maximized window size is stored and window maximized state doesn't persist ([91d5d10](https://github.com/KRTirtho/spotube/commit/91d5d1003b09530ff3bc9a0aa93e382e943977e0))
* local audio doesn't get refreshed after getting permission ([618c6da](https://github.com/KRTirtho/spotube/commit/618c6da0ebddf3cc8e216743bbbb9220bcf40521))
* no appropriate output when playlist is empty [#201](https://github.com/KRTirtho/spotube/issues/201) ([dbb81de](https://github.com/KRTirtho/spotube/commit/dbb81de763df60eba62ef1256a7161ea6ca59b66))
* PlayerOverlay not hiding when not playing and unneeded bottom space in TrackTableView ([0ebac05](https://github.com/KRTirtho/spotube/commit/0ebac05a4be8e8f744a6c672d3bb9807d6f02e10))
* **web:** not building due to metadata_god ffi ([1191bf2](https://github.com/KRTirtho/spotube/commit/1191bf232d0797aaae7eff2f5d570acd49ce61bd))

## [2.4.1](https://github.com/KRTirtho/spotube/compare/v2.4.0...v2.4.1) (2022-09-13)


### Features

* add macos audio metadata tags support ([5866b0f](https://github.com/KRTirtho/spotube/commit/5866b0fcd661cf32060bb1485ea81634fbb9b90a))
* remove macos bounds for reading and writing audio metadata ([16064f6](https://github.com/KRTirtho/spotube/commit/16064f68e882b091401ace4b895e387f46635800))
* **search:** horizontal swipe scroll support for Desktop platform ([d5ff927](https://github.com/KRTirtho/spotube/commit/d5ff927c7273b6e72c5d775ee777f2cbd0d6d05c))


### Bug Fixes

* **artist-page:**   SpotubeMarqueeText used in ArtistCard crashes the app ([4279541](https://github.com/KRTirtho/spotube/commit/427954150ab65b250e79fc844fc864abff5b6972))
* **layout:** Fix adaptive UI not working correctly by providing a overriding option ([8c7adde](https://github.com/KRTirtho/spotube/commit/8c7adde890105e0267b71994b7928277f84553e5))
* **local-track:** throwing exception when downloadLocation is empty ([1a3556d](https://github.com/KRTirtho/spotube/commit/1a3556d39e8473cadb6143192c48465dc6485599))

## [2.4.0](https://github.com/KRTirtho/spotube/compare/v2.3.0...v2.4.0) (2022-09-09)


### Features

* Ability to change download location added ([816707c](https://github.com/KRTirtho/spotube/commit/816707c643f8d60d25bc08fd4c8005daa2ba9e63))
* add download multi tracks support for mobile platform ([0476bf7](https://github.com/KRTirtho/spotube/commit/0476bf7ceece034a927d1df6099d8b33036f8a9b))
* add download queue for desktop & initial playlist download support ([08f913e](https://github.com/KRTirtho/spotube/commit/08f913e9761d0f5c447af9dfb6eedb44b675498c))
* add download tab on library ([8d77b69](https://github.com/KRTirtho/spotube/commit/8d77b6900a81aab020e19397e788964b0ac499ff))
* add web support although nothing works just as expected ([2818ed5](https://github.com/KRTirtho/spotube/commit/2818ed5c9dadb9185a52762599c1dd0acd81e6bf))
* **broken:** Broken Warning! Initial Local Audio Player ([c3bf511](https://github.com/KRTirtho/spotube/commit/c3bf5119ebb7c17e8c32f149598508674b0acd39))
* **download:** track table view multi select improvement, tap to play track support, existing track replace confirmation dialog and bulk download confirmation dialog ([e217553](https://github.com/KRTirtho/spotube/commit/e21755322f2cd5f1fba00c5c8cd5c5d1f79e459d))
* **local-tracks:** complete support for local tracks ([e206f16](https://github.com/KRTirtho/spotube/commit/e206f16723ac989ad58006c1b3c90c6691d8cab3))
* **mpris:** MPRIS metadata are now updated in realtime ([d9addcd](https://github.com/KRTirtho/spotube/commit/d9addcda8e9562803bd73016148fab22560ee050))
* **playback:** add repeat track support [#166](https://github.com/KRTirtho/spotube/issues/166) ([cae9993](https://github.com/KRTirtho/spotube/commit/cae99934299bd197c68f626d6c10158d449770b9))
* **synced-lyrics:** animated active text size ([531fae6](https://github.com/KRTirtho/spotube/commit/531fae64f94b21551a7a0da363a9ab0d44f5d3b1))
* **ui:** adaptive TrackTile actions & Setting ListTile ([615d5ce](https://github.com/KRTirtho/spotube/commit/615d5ce901eb0512e84a120b7309c9053238ee36))


### Bug Fixes

* **adaptive-list-tile:** dialog content not updating when content has changed ([a1d4230](https://github.com/KRTirtho/spotube/commit/a1d423090c854ebe319a0fa03fd6e5c4007b1387))
* album & playlist card, player view and album view play button logic ([55852bd](https://github.com/KRTirtho/spotube/commit/55852bd15bc709d61fbba8cbea01ceca791d154c))
* **docs:** indentions ([4a291d5](https://github.com/KRTirtho/spotube/commit/4a291d5f20dabe68f3ed64071624dcbed8327329))
* **downloader:** downloaded track is corrupted for tagging ([2ab1fba](https://github.com/KRTirtho/spotube/commit/2ab1fba3d64147e3c5cf34756dce1cf6046d410a))
* **downloader:** flutter downloader exception on desktop platform and too much width of TrackTile index no. ([d668760](https://github.com/KRTirtho/spotube/commit/d6687603d148ad936530cca4d09e128a59b79b19))
* dropped flutter_downloader deps due to slow download speed and UserDownloads not showing for anonymous ([307a8e2](https://github.com/KRTirtho/spotube/commit/307a8e21df1e39123a1dca4c1b063eab50359581))
* flutter_downloader manifest configuration breaking android support ([f3a0f78](https://github.com/KRTirtho/spotube/commit/f3a0f78fb92ff7ee38b5a9ef9954575d4282f954))
* login screen not using safearea and no dialog bg-color found on light mode in AdaptivePopupMenuButton ([92bc611](https://github.com/KRTirtho/spotube/commit/92bc611c5e901dcabf34086be9287ac20317259a))
* **performance:** always running marquee text causes high GPU usage [#175](https://github.com/KRTirtho/spotube/issues/175) and UserArtist overflow on smaller displays ([a23ce61](https://github.com/KRTirtho/spotube/commit/a23ce614467b4297f495b824f0958ff07c21ae92))
* **playback:** shuffle button sometimes gets stuck and stops working [#183](https://github.com/KRTirtho/spotube/issues/183) ([4240433](https://github.com/KRTirtho/spotube/commit/4240433e3dde6ab948d2674e07e41c27c1f6eac8))
* **player-overlay:** flickering when a track is changed or navigated to another page ([e48b67c](https://github.com/KRTirtho/spotube/commit/e48b67cd47ae54ad9268aead268e444836a67b0d))
* **sidebar:** user image url ([747efc6](https://github.com/KRTirtho/spotube/commit/747efc6ee66bc6c7c917cc02bd134968a0781701))
* **synced-lyrics:** active lyrics contrast ratio ([aba1ba9](https://github.com/KRTirtho/spotube/commit/aba1ba932592923720a36395c057f78820dafecf))
* tabbar overflow in small screen, artist card too small title and synced lyrics contrast increased ([585de8c](https://github.com/KRTirtho/spotube/commit/585de8c1def9750826568317109b242a5e18f28c))

# v2.3.0

### New
- Playback Cache Support. So unfinished playlist and tracks remains cached & starts automatically when application is launched again
- Login Screen guided tutorial about how to obtain Client ID & Client Secret
- Signed Android Application so now longer need to uninstall the old version for installing the new one
- OS Media controls for Linux. Keyboard media keys now work in Linux
- New better, consistent & predictable Audio engine with proper event firing support (https://github.com/KRTirtho/spotube/pull/131)
- Custom Lyrics delay time. Can be used to delay negative amount of time too
- Playback Queue View support. Currently playing tracks or playlist can be viewed or changed from it or for doing other actions too (https://github.com/KRTirtho/spotube/issues/126)
- Android SeekBar support in Notification Panel & Lock Screen
- New Blur background design adapted to multiple components including Floating Player, Player View & Lyrics Tab
- New HighContrast Color Scheme addition which reduces battery consumption on OLED or AMOLED display devices (https://github.com/KRTirtho/spotube/issues/137)


### Improved
- Loading screens & animations. Now uses Skeleton Loading
- Playlist & Album Pages now show Album Art & extra metadata as Header with vibrant gradient background in a Sliver
- Playback is now more consistent & the API is simpler. Also its the single source of truth for AudioPlayback instead of the AudioServiceHandler
- Android Statusbar background color is now adaptive & less glitchy
- Home Genre playlists can be scrolled horizontally by dragging with mouse even in Desktop edition
- Track match Cache support for previously played tracks. This dramatically reduces track change latency & load on the YouTube search engine too

### Bug Fixes
- API rate limits inside TrackTile for multiple Follow queries at once
- Player doesn't stop when Application is exits or closed
- First Track of Playlist doesn't load sometimes
- Download Button doesn't show done symbol when track is already saved (https://github.com/KRTirtho/spotube/issues/138)
- Downloaded Music is 0kb sized when lyrics are downloaded alongside (https://github.com/KRTirtho/spotube/issues/122)

# v2.2.1

### Improved
- Page transitions defaulted to material you design

### Bug fixes 
- Mini Player flickering on random state updates
- Track More Options not showing when not logged in
- Wrong link to Client ID & Client Secret tutorial in Login page
- Changing preferences in Settings resets the entire Playback

# v2.2.0

### New
- Update checker
- Share options for playlists & track
- Android Skip to Next/Previous track from notification/lockscreen (https://github.com/KRTirtho/spotube/issues/91)
- Custom Accent Color Scheme support (Dark + Light)
- Custom Background Color Scheme support (Dark + Light)
- User customizable Audio Quality Option
- User customizable Track Matching Algorithm Option
- Material 3 Design Language and Flutter 3.0
- Caching in Playlists, Album, Search, Playlist Categories, Artist Profile & Lyrics
- M1 Mac support via MacOS Universal Binary (untested) (https://github.com/KRTirtho/spotube/pull/87)

### Improved
- Authentication is now persistent (no more re-login) 
- Settings Page. Shows application details in About Dialog
- Playlist Create Dialog Scrollable
### Bug fixes
- private playlists of current user aren't shown fix (https://github.com/KRTirtho/spotube/issues/92)
- refresh token error causing re-login (culprit: internal lib spotify-dart)
- Typo in Login instructions URL

# v2.1.0

### New
- Synced Lyrics (with fallback genius lyrics)
- Playlist create/delete
- Add/Remove tracks to own playlists
- Custom YouTube track search term template
- Downloading lyrics along with a track (can be toggled)
- Customize Marketplace location

### Improved
- Spotify track to youtube track algorithm
- Genius lyrics matching algorithm
- Download track. Checks if already exists & replaces on user command
- Wide screen responsiveness & adaptation
- Bigger Title display (replaced word-break with Marquee Text for better visibility) (https://github.com/KRTirtho/spotube/pull/47)

### Bug fixes
- Sequential playlist playback not working with latest webkit2gtk (https://github.com/KRTirtho/spotube/issues/46)
- Theme modification state doesn't persist (https://github.com/KRTirtho/spotube/issues/54)
- Wrong URI path for "Login with Spotify" tutorial (https://github.com/KRTirtho/spotube/issues/69)
- Card shadow showing in the background of TitleBar & Searchbar 

# v2.0.0 

### New
- Android Support https://github.com/KRTirtho/spotube/issues/24
- Responsive UI (Mobile, Tablet)
- Anonymous/Guest Account
- Mini floating player
- Full page PlayerView for smaller devices
- Horizontal CategoryCard Scroll & pagination for quicker access to Playlists
- Bottom bar for smaller devices
- Collapsed Sidebar for medium sized devices
- Persists Volume level
- Android NavigationPanel controls (OS media controls of Android)

### Improved
- Search - now scrolls & paginates for Playlists & Albums
- Authentication - allows guest accounts making authentication optional
- Lyrics - can be fetched without requiring GeniusAccessToken. This makes geniusAccessToken optional 
- UI snappiness & faster load times
- Simpler logic, faster calculations & better caching (flutter_hooks)
- shared state management - uses riverpod & hooks combination

### Bug fixes
- Can't play any song in macos https://github.com/KRTirtho/spotube/issues/23
- Downloaded tracks can't be played as they're WebAudio (.weba) instead of MP3
- delay while changing Playlist/Single tracks

# v1.2.0

### New
- Global custom reconfigurable *hotkey* support for playback controls (play-pause/next/previous)
- Credit section in the Settings page with important links
### Improved
- Macos support
- Genius (Lyrics Provider) access_token can be saved in the Login page too
- Better theme for dropdown-buttons

### Bug fixes
- broken authentication IPC on Mac OS (https://github.com/KRTirtho/spotube/pull/18)
- Mac OS's global appmenu's default APP_NAME replaced with Spotube
- location of back button on macOS (https://github.com/KRTirtho/spotube/pull/21)
- windows titlebar buttons appears on Mac OS
- genius access_token not loading on initial app start


# v1.1.0

### New
- MacOS support https://github.com/KRTirtho/spotube/pull/7
- Download currently playing track to `/home/<user>/Downloads/Spotube` (Linux, MacOS) or `C:\Users\<user>\Downloads\Spotube` (Windows)
- Play playlist from any song (index) instead of only the first track
- AlbumCard for showing album's metadata
- AlbumView aka show album tracks
- Play an album
- ArtistCard for showing artist metadata on the fly
- ArtistProfile for showing complete details of the artist
- Play artist's top tracks
- View Artist's "Fans also like" section
- Search page
- Play tracks from search result
- Click to open artist-profile/album everywhere in the application

### Improved
- UserLibrary album & artist tab
- PlaylistView simplified layout with `ListView` instead of `TableView`
- Control Theme from settings manually
- `PageWindowTitleBar` now acts as `appBar`

### Bug fixes
- Unsafe access to album art/artist/user Images with `.first` or `.last` causing accessing empty List error
- `url_launcher`'s unstable `canLaunch` method blocks OAuth login in certain *nix OSs
- Refresh token gets revoked & doesn't get renewed automatically
# v1.0.1

### Improved
- Placeholder avatar for User section powered by dicebear.com

### Bug fixes
- No fallback/placeholder image causing undefined behavior (#2)
- Unsafe access to empty List with List.first/List.last

# v1.0.0

### New
- Complete re-write in Flutter/Dart (799e13c)
- mpv & youtube-dl runtime dependencies dropped (07b1891)
- just_audio (libwinmedia + libwebkit2gtk-4.0-dev) + youtube_explode based playback & streaming
- lyrics are provided by genius.com (requires access_token) (d647d5e)
- inno_setup based windows/win32 GUI installer (dbf8a34)

### Improved
- Lower RAM & CPU usage. 2x less RAM usage & 20% less CPU usage
- Faster playback & smooth track change with proper shuffling support
- Automatic Dark mode support (system)
- 54% smaller bundle size (after compression)
- Available through package managers in Linux (Debian,  Arch, Flatpak & AppImage)

# v0.0.3

### New
- Automated installer for Windows (now doesn't require manual mpv-player install)
- Playback caching
- Retry button for ManualLyricDialog
- Support for downloading track
- Redirect to youtube video by clicking on the title of the track

### Improved
- Inapp Shortcuts.Now it doesn't interfere while typing in a input box in Search page

### Bug fixes
- Cached image didn't get deleted after exiting certain cache limit fix. Cache gets recreated after exiting the limit

# v0.0.2

### New
- Lyric Seek
- Support for images in playlist cards
- Infinite Query/Pagination support for Home & Genre pages
- Settings for configuring local configuration

### Improved
- Home Page Layout. Fixes the jiggering of Playlist Links on hover

### Bug Fixes
- `access_token not found` Error after OAuth Login with Spotify credentials (used to need a restart of the app to load the access_token)
- Volume level wasn't cached even after changing volume

# v0.0.1

Spotube v0.0.1 - initial release of the open source software for playing Spotify music using Youtube public API

### New
- Local playback handling
- Playback Queue
- Save to Liked Tracks/Playlists
- Bypass API rate limitation on basic usage using personal developer Apps for spotify API
- Youtube search & get handled using scrape-yt