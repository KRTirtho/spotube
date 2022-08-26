![Spotube](assets/spotube_banner.png)

<p align="center">
  <a href="https://spotube.netlify.app/">spotube.netlify.app</a>
</p>

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
  <a href="https://discord.gg/uJ94vxB6vg">
    <img alt="Discord" src="https://img.shields.io/discord/1012234096237350943?color=%2316ba58&label=Discord%20Server&logoColor=%2316ba58&style=flat-square">
  </a>
</p>


Spotube is a [Flutter](https://flutter.dev) based lightweight spotify client. It utilizes the power of Spotify & Youtube's public API & creates a hazardless, performant & resource friendly User Experience

#### <p align="center">Desktop</p>

![Application Desktop Screenshot](assets/spotube-screenshot.jpg)

#### <p align="center">Mobile</p>

![Application Mobile Screenshot](assets/mobile-screenshots/mobile-combined.jpg)

<p align="center">
  <a href="https://discord.gg/uJ94vxB6vg">
    <img src="https://discord.com/api/guilds/1012234096237350943/widget.png?style=banner2">
  </a>
</p>

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

# Support this project

<a href="https://patreon.com/krtirtho"><img src="https://user-images.githubusercontent.com/61944859/180249027-678b01b8-c336-451e-b147-6d84a5b9d0e7.png" width="250"/></a>
[!["Donate to out Collective"](https://opencollective.com/webpack/donate/button.png?color=blue)](https://opencollective.com/spotube)
[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/krtirtho)

# Installation

I'm always releasing newer versions of binary of the software each 2-3 month with minor changes & each 6-8 month with major changes. Grab the binaries

| Platform                                        | Package/Installation Method                                                                                                                                                                                                                                                                                               |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Android                                         | [<img width='240' alt='Android Download' src='https://www.remcsteuben.com/sites/default/files/images/apkdaddy%20download.png'/>][android-dlink]<br/>[<img width='240' alt='Android Download' src='https://user-images.githubusercontent.com/61944859/174589876-bace24c0-b3fd-4c4a-bdb4-6fa82b5853ec.png'/>][fdroid-dlink] |
| Debian/Ubuntu                                   | [<img width='240' alt='Linux Debian/Ubuntu Download' src='https://user-images.githubusercontent.com/61944859/169097994-e92aff78-fd75-4c93-b6e4-f072a4b5a7ed.png'/>][deb-dlink] <br/> Then run: `sudo apt install Spotube-linux-x86_64.deb`                                                                                |
| Flatpak                                         | `flatpak install com.github.KRTirtho.Spotube` <br/> <a href='https://flathub.org/apps/details/com.github.KRTirtho.Spotube'><img width='240' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-en.png'/></a>                                                                                  |
| Arch/Manjaro                                    | pamac: `pamac install spotube-bin` <br/> yay: `yay -Sy spotube-bin`                                                                                                                                                                                                                                                       |
| AppImage                                        | [<img width='240' alt='AppImage Download' src='https://user-images.githubusercontent.com/61944859/169455015-13385466-8901-48fe-ba90-b62d58b0be64.png'/>][appimage-dlink]<br/> **Note**: AppImages require [appimage-launcher](https://github.com/TheAssassin/AppImageLauncher) to be installed                            |
| Linux (tarball)                                 | [<img width='240' alt='Tarball Download' src='https://user-images.githubusercontent.com/61944859/169456985-e0ba1fd4-10e8-4cc0-ab94-337acc6e0295.png'/>][linux-dlink]                                                                                                                                                      |
| Windows                                         | [<img width='240' alt='Windows Download' src='https://get.todoist.help/hc/article_attachments/4403191721234/WindowsButton.svg'/>][win32-dlink]                                                                                                                                                                            |
| Windows (Chocolatey)                            | `choco install spotube`                                                                                                                                                                                                                                                                                                   |
| Windows (<a href="https://scoop.sh/">Scoop</a>) | `scoop bucket add extras`  <br/> `scoop install spotube`                                                                                                                                                                                                                                                                  |
| Windows (WinGet)                                | `winget install --id KRTirtho.Spotube`                                                                                                                                                                                                                                                                                    |
| MacOS                                           | [<img width='240' alt='MacOS Download' src='https://reachify.io/wp-content/uploads/2018/09/mac-download-button-1.png'/>][mac-dlink]                                                                                                                                                                                       |

> **Note!:** If you don't understand this download table. You can read [installation instructions][wiki-installation-instructions] from the wiki

## Nightly Builds
Get the latest nightly builds of Spotube [here](https://nightly.link/KRTirtho/spotube/workflows/spotube-nightly/build)

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
    <img width='720' alt='step-3-a' src='https://user-images.githubusercontent.com/61944859/172991668-fa40f247-1118-4aba-a749-e669b732fa4d.jpg' />
    <img width='720' alt='setp-3-b' src='https://user-images.githubusercontent.com/61944859/111768971-d308a180-88d2-11eb-9108-3e7444cef049.png'/>

  - Click on **SHOW CLIENT SECRET** to reveal the **clientSecret**. Then copy the **clientID**, **clientSecret** & paste in the **Spotube's** respective fields<br/>
    <img width='480' alt='step-4' src='https://user-images.githubusercontent.com/61944859/111769501-7fe31e80-88d3-11eb-8fc1-f3655dbd4711.png'/>

# TODO:
- [ ] Windows OS Media Control & Media Keys Support
- [ ] Spotify Listen Along
- [x] Skip non-music sections from Audio Track
- [ ] Language Translations/Localization

# Building from source

You can find the details [here](CONTRIBUTION.md#your-first-code-contribution)

# Things that don't work

- Shows & Podcasts aren't supported as it'd require premium anyway

# License

[BSD-4-Clause](/LICENSE)

Bu why? You can learn about it [here](https://dev.to/krtirtho/choosing-open-source-license-wisely-1m3p)

# Financial Contributors
## Backers
![Backers](https://opencollective.com/spotube/backer.svg?button=false)
![Donors](https://opencollective.com/spotube/tiers/donor.svg?button=false)

## Sponsors
![Donors](https://opencollective.com/spotube/tiers/sponsor.svg)

# Library/Plugin/Framework Credits

- [Flutter](https://flutter.dev/) - Flutter transforms the app development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded apps from a single codebase
- [Linux](https://www.linux.org/) - Linux is a family of open-source Unix-like operating systems based on the Linux kernel, an operating system kernel first released on September 17, 1991, by Linus Torvalds. Linux is typically packaged in a Linux distribution
- [AUR](https://aur.archlinux.org/) - AUR stands for Arch User Repository. It is a community-driven repository for Arch-based Linux distributions users
- [Flatpak](https://flatpak.org/) - Flatpak is a utility for software deployment and package management for Linux
- [spotify (dart)](https://github.com/rinukkusu/spotify-dart) - A dart library for interfacing with the Spotify API
- [audioplayers](https://github.com/bluefireteam/audioplayers) - A Flutter plugin to play multiple audio files simultaneously (Android/iOS)
- [youtube_explode_dart](https://github.com/Hexer10/youtube_explode_dart) - YoutubeExplode is a library that provides an interface to query metadata of YouTube videos, playlists and channels, as well as to resolve and download video streams and closed caption tracks
- [infinite_scroll_pagination](https://github.com/EdsonBueno/infinite_scroll_pagination) - Flutter package to help you lazily load and display pages of items as the user scrolls down your screen
- [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window) - A Flutter package that makes it easy to customize and work with your Flutter desktop app window on Windows, macOS and Linux
- [Inno Setup](https://jrsoftware.org/isinfo.php) - Inno Setup is a free installer for Windows programs by Jordan Russell and Martijn Laan
- [collection](https://github.com/dart-lang/collection) - The collection package for Dart contains a number of separate libraries with utility functions and classes that makes working with collections easier 
- [flutter_riverpod](https://riverpod.dev/) - A Reactive Caching and Data-binding Framework
- [flutter_hooks](https://github.com/rrousselGit/flutter_hooks) - React hooks for Flutter. Hooks are a new kind of object that manages a Widget life-cycles. They are used to increase code sharing between widgets and as a complete replacement for StatefulWidget
- [hooks_riverpod](https://riverpod.dev/) - Riverpod with hooks
- [go_router](https://github.com/flutter/packages/tree/main/packages/go_router) - A declarative router for Flutter based on Navigation 2 supporting deep linking, data-driven routes and more
- [palette_generator](https://github.com/flutter/packages/tree/main/packages/palette_generator) - Flutter package for generating palette colors from a source image.
- [logger](https://github.com/leisim/logger) - Small, easy to use and extensible logger which prints beautiful logs
- [flutter_launcher_icons](https://github.com/fluttercommunity/flutter_launcher_icons) - A package which simplifies the task of updating your Flutter app's launcher icon.
- [permission_handler](https://github.com/baseflow/flutter-permission-handler) - Permission plugin for Flutter. This plugin provides a cross-platform (iOS, Android) API to request and check permissions. 
- [marquee](https://github.com/MarcelGarus/marquee) - ⏩ A Flutter widget that scrolls text infinitely. Provides many customizations including custom scroll directions, durations, curves as well as pauses after every round
- [scroll_to_index](https://github.com/quire-io/scroll-to-index) - scroll to index with fixed/variable row height inside Flutter scrollable widget 
- [package_info_plus](https://github.com/fluttercommunity/plus_plugins/tree/main/packages/) - This Flutter plugin provides an API for querying information about an application package.
- [version](https://github.com/dartninja/version) - A dart library providing a Version class 
- [audio_service](https://github.com/ryanheise/audio_service) - Flutter plugin to play audio in the background while the screen is off.
- [skeleton_text](https://github.com/101Loop/Skeleton-Text) - Flutter package for Skeleton Text Animation
- [hive](https://github.com/hivedb/hive) - Lightweight and blazing fast key-value database written in pure Dart. 
- [dbus](https://github.com/canonical/dbus.dart) - Native Dart client library to use DBus
- [introduction_screen](https://github.com/pyozer/introduction_screen) - Add easily to your app an introduction screen to provide informations to new users
- [audio_session](https://github.com/ryanheise/audio_session) - Sets the iOS audio session category and Android audio attributes for your app, and manages your app's audio focus, mixing and ducking behaviour.


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
[fdroid-dlink]: https://f-droid.org/packages/oss.krtirtho.spotube/

[wiki-installation-instructions]: https://github.com/KRTirtho/spotube/wiki/Installation-Instrcutions
