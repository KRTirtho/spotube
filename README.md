![Spotube](assets/spotube_banner.png)

<p align="center">
  <a href="https://github.com/KRTirtho/spotube/actions/workflows/flutter-build.yml">
    <img alt="GitHub Action Status" src="https://img.shields.io/github/workflow/status/KRTirtho/spotube/Flutter%20Cross%20Build/build?color=%2316ba58&style=flat-square"/>
  </a>
  <a href="https://github.com/KRTirtho/Spotube/releases">
    <img alt="GitHub release" src="https://img.shields.io/github/v/release/KRTirtho/spotube?color=%2316ba58&style=flat-square"/>
  </a>
  <a href="LICENSE">
    <img alt="License" src="https://img.shields.io/aur/license/spotube-bin?color=%2316ba58&style=flat-square"/>
  </a>
  <a href="https://github.com/KRTirtho">
    <img alt="Maintainer" src="https://img.shields.io/badge/Maintainer-KRTirtho-%2316ba58?style=flat-square"/>
  </a>
  <a href="https://opencollective.com/spotube">
    <img alt="Open Collective backers and sponsors" src="https://img.shields.io/opencollective/all/spotube?color=%2316ba58&style=flat-square"/>
  </a>
</p>


Spotube is a [Flutter](https://flutter.dev) based lightweight spotify client. It utilizes the power of Spotify & Youtube's public API & creates a hazardless, performant & resource friendly User Experience
#### <p align="center">Desktop</p>

![Application Desktop Screenshot](assets/spotube-screenshot.png)

#### <p align="center">Mobile</p>

![Application Mobile Screenshot](assets/mobile-screenshots/mobile-combined.jpg)

# Features

Following are the features that currently spotube offers:

- Open Source
- Anonymous/Guest Login
- Cross platform
- No telemetry, diagnostics or user data collection
- Lightweight & resource friendly
- Native performance (Thanks to Flutter+Skia)
- Playback control is on user's machine instead of server based
- Small size & less data hungry
- No spotify or youtube ads since it uses all public & free APIs (But it's recommended to support the creators by watching/liking/subscribing to the artists youtube channel or add as favourite track in spotify. Mostly buying spotify premium is the best way to support their valuable creations)
- Synced Lyrics
- Downloadable track

<a href="https://www.producthunt.com/posts/spotube?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-spotube" target="_blank"><img src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=327965&theme=dark" alt="Spotube - A lightweight+free Spotify crossplatform-client made with flutter | Product Hunt" style="width: 250px; height: 54px;" width="250" height="54" /></a>

# Installation

I'm always releasing newer versions of binary of the software each 2-3 month with minor changes & each 6-8 month with major changes. Grab the binaries

| Platform             | Package/Installation Method                                                                                                                                                                                                                                                                    |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Android              | [<img width='240' alt='Android Download' src='https://www.remcsteuben.com/sites/default/files/images/apkdaddy%20download.png'/>][android-dlink]                                                                                                                                                |
| Debian/Ubuntu        | [<img width='240' alt='Linux Debian/Ubuntu Download' src='https://user-images.githubusercontent.com/61944859/169097994-e92aff78-fd75-4c93-b6e4-f072a4b5a7ed.png'/>][deb-dlink] <br/> Then run: `sudo apt install Spotube-linux-x86_64.deb`                                                     |
| Flatpak              | `flatpak install com.github.KRTirtho.Spotube` <br/> <a href='https://flathub.org/apps/details/com.github.KRTirtho.Spotube'><img width='240' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-en.png'/></a>                                                       |
| Arch/Manjaro         | pamac: `pamac install spotube-bin` <br/> yay: `yay -Sy spotube-bin`                                                                                                                                                                                                                            |
| AppImage             | [<img width='240' alt='AppImage Download' src='https://user-images.githubusercontent.com/61944859/169455015-13385466-8901-48fe-ba90-b62d58b0be64.png'/>][appimage-dlink]<br/> **Note**: AppImages require [appimage-launcher](https://github.com/TheAssassin/AppImageLauncher) to be installed |
| Linux (tarball)      | [<img width='240' alt='Tarball Download' src='https://user-images.githubusercontent.com/61944859/169456985-e0ba1fd4-10e8-4cc0-ab94-337acc6e0295.png'/>][linux-dlink]                                                                                                                           |
| Windows              | [<img width='240' alt='Windows Download' src='https://get.todoist.help/hc/article_attachments/4403191721234/WindowsButton.svg'/>][win32-dlink]                                                                                                                                                 |
| Windows (Chocolatey) | `choco install spotube`                                                                                                                                                                                                                                                                        |
| Windows (WinGet)     | `winget install --id KRTirtho.Spotube`                                                                                                                                                                                                                                                         |
| MacOS                | [<img width='240' alt='MacOS Download' src='https://reachify.io/wp-content/uploads/2018/09/mac-download-button-1.png'/>][mac-dlink]                                                                                                                                                            |

> **Note!:** If you don't understand this download table. You can read [installation instructions][wiki-installation-instructions] from the wiki

## Nightly Builds
Get the latest nightly builds of Spotube [here](https://nightly.link/KRTirtho/spotube/workflows/flutter-build/build)

## Optional Configurations
### Login with <b>Spotify</b>
  You need a spotify account & a developer app for

  - clientId
  - clientSecret

  **Grab credentials:**

  - Go to https://developer.spotify.com/dashboard/login & login with your spotify account (Skip if you're logged in)
    <img width='480' alt='Step 1' src='https://user-images.githubusercontent.com/61944859/111762106-d1d37680-88ca-11eb-9884-ec7a40c0dd27.png'/>

  - Create an web app for Spotify Public API<br/>
    <img width='480' alt='step 2' src='https://user-images.githubusercontent.com/61944859/111762507-473f4700-88cb-11eb-91f3-d480e9584883.png'/>

  - **MOST IMPORTANT:** Give the app a name & description. Then Edit settings & add `http://localhost:4304/auth/spotify/callback` as **Redirect URI** for the app. Its important for authenticating<br/>
    <img width='720' alt='setp-3' src='https://user-images.githubusercontent.com/61944859/111768971-d308a180-88d2-11eb-9108-3e7444cef049.png'/>

  - Click on **SHOW CLIENT SECRET** to reveal the **clientSecret**. Then copy the **clientID**, **clientSecret** & paste in the **Spotube's** respective fields<br/>
    <img width='480' alt='step-4' src='https://user-images.githubusercontent.com/61944859/111769501-7fe31e80-88d3-11eb-8fc1-f3655dbd4711.png'/>

### Setup <b>Genius Lyrics</b>

- Signup/Login into [genius](https://genius.com/signup) for **lyrics**
- Go To [Genius Developer Portal](https://genius.com/api-clients/new) for creating an API client<br/>
  <img width='480' alt='Step 2' src='https://user-images.githubusercontent.com/61944859/158823216-b4942731-c4c5-46c8-8b60-82a372b51cc5.png' />
- Generate & copy access token<br/>
  <img width='480' alt='Step 3' src='https://user-images.githubusercontent.com/61944859/158822817-f04da060-3094-4a3b-8ace-a936d0cda8db.png' />
- Paste the copied access token in Spotube's Settings<br/>
  <img width='480' alt='Step 4' src='https://user-images.githubusercontent.com/61944859/158823984-17f08534-5c92-41bc-918a-23194aad00f5.png' />

> **Note!**: No personal data or any kind of sensitive information won't be collected from spotify. Don't believe? See the code for yourself

# TODO:

- [x] Compile, Debug & Build for **MacOS**
- [x] Add support for show Lyric of currently playing track
- [x] Track download
- [ ] Support for playing/streaming podcasts/shows
- [x] Artist, User & Album pages
- [x] Android Support

# Building from source

You can find the details [here](CONTRIBUTION.md#your-first-code-contribution)

# Things that don't work

- Shows & Podcasts aren't supported as it'd require premium anyway
- OS Media Controls

# License

[BSD-4-Clause](/LICENSE)

Bu why? You can learn about it [here](https://dev.to/krtirtho/choosing-open-source-license-wisely-1m3p)

# Library/Plugin/Framework Credits

- [Flutter](https://flutter.dev/) - Flutter transforms the app development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded apps from a single codebase
- [Linux](https://www.linux.org/) - Linux is a family of open-source Unix-like operating systems based on the Linux kernel, an operating system kernel first released on September 17, 1991, by Linus Torvalds. Linux is typically packaged in a Linux distribution
- [AUR](https://aur.archlinux.org/) - AUR stands for Arch User Repository. It is a community-driven repository for Arch-based Linux distributions users
- [Flatpak](https://flatpak.org/) - Flatpak is a utility for software deployment and package management for Linux
- [spotify (dart)](https://github.com/rinukkusu/spotify-dart) - A dart library for interfacing with the Spotify API
- [just_audio](https://github.com/ryanheise/just_audio/tree/master/just_audio) - A feature-rich cross-platform audio player for Flutter that supports network audio streams too
- [libwinmedia](https://github.com/harmonoid/libwinmedia) - A cross-platform media playback library for C/C++ with good number of features (only Windows & Linux)
- [youtube_explode_dart](https://github.com/Hexer10/youtube_explode_dart) - YoutubeExplode is a library that provides an interface to query metadata of YouTube videos, playlists and channels, as well as to resolve and download video streams and closed caption tracks
- [infinite_scroll_pagination](https://github.com/EdsonBueno/infinite_scroll_pagination) - Flutter package to help you lazily load and display pages of items as the user scrolls down your screen
- [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window) - A Flutter package that makes it easy to customize and work with your Flutter desktop app window on Windows, macOS and Linux
- [hotkey_manager](https://github.com/leanflutter/hotkey_manager) - A flutter plugin that allow Flutter desktop apps to defines system/inapp wide hotkey
- [Inno Setup](https://jrsoftware.org/isinfo.php) - Inno Setup is a free installer for Windows programs by Jordan Russell and Martijn Laan
- [collection](https://github.com/dart-lang/collection) - The collection package for Dart contains a number of separate libraries with utility functions and classes that makes working with collections easier 
- [flutter_riverpod](https://riverpod.dev/) - A Reactive Caching and Data-binding Framework
- [flutter_hooks](https://github.com/rrousselGit/flutter_hooks) - React hooks for Flutter. Hooks are a new kind of object that manages a Widget life-cycles. They are used to increase code sharing between widgets and as a complete replacement for StatefulWidget
- [hooks_riverpod](https://riverpod.dev/) - Riverpod with hooks
- [go_router](https://github.com/flutter/packages/tree/main/packages/go_router) - A declarative router for Flutter based on Navigation 2 supporting deep linking, data-driven routes and more
- [palette_generator](https://github.com/flutter/packages/tree/main/packages/palette_generator) - Flutter package for generating palette colors from a source image.
- [audio_session](https://github.com/ryanheise/audio_session) - Sets the iOS audio session category and Android audio attributes for your app, and manages your app's audio focus, mixing and ducking behaviour.
- [logger](https://github.com/leisim/logger) - Small, easy to use and extensible logger which prints beautiful logs
- [flutter_launcher_icons](https://github.com/fluttercommunity/flutter_launcher_icons) - A package which simplifies the task of updating your Flutter app's launcher icon.
- [permission_handler](https://github.com/baseflow/flutter-permission-handler) - Permission plugin for Flutter. This plugin provides a cross-platform (iOS, Android) API to request and check permissions. 
- [marquee](https://github.com/MarcelGarus/marquee) - ⏩ A Flutter widget that scrolls text infinitely. Provides many customizations including custom scroll directions, durations, curves as well as pauses after every round
- [scroll_to_index](https://github.com/quire-io/scroll-to-index) - scroll to index with fixed/variable row height inside Flutter scrollable widget 
- [package_info_plus](https://github.com/fluttercommunity/plus_plugins/tree/main/packages/) - This Flutter plugin provides an API for querying information about an application package.


# Social handlers

Follow me on [Twitter](https://twitter.com/@krtirtho) for newer updates about this application


<p align="center">&copy; 2022 Spotube</p>


<!-- Variables/Text References -->
[win32-dlink]: https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-windows-x86_64-setup.exe
[deb-dlink]: https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-linux-x86_64.deb
[linux-dlink]: https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-linux-x86_64.tar.xz
[appimage-dlink]: https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-linux-x86_64.AppImage
[mac-dlink]: https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-macos-x86_64.dmg
[android-dlink]: https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-android-all-arch.apk

[wiki-installation-instructions]: https://github.com/KRTirtho/spotube/wiki/Installation-Instrcutions