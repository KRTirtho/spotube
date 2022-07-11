# v2.3.0

### New
- Playback Cache Support. So unfinished playlist and tracks remains cached & starts automatically when application is launched again
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