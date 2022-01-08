![Spotube](assets/spotube_banner.png)

Spotube is a [Flutter](https://flutter.dev) based lightweight spotify client. It utilizes the power of Spotify & Youtube's public API & creates a hazardless, performant & resource friendly User Experience
![Application Screenshot](assets/spotube-screenshot.png)

## Features

Following are the features that currently spotube offers:

- Open Source
- No telementry, diagnostics or user data collection
- Lightweight & resource friendly
- Near native performance (Thanks to Flutter+Skia)
- Playback control is on user's machine instead of server based
- Small size & less data hungry
- No spotify or youtube ads since it uses all public & free APIs (But it's recommended to support the creators by watching/liking/subscribing to the artists youtube channel or add as favourite track in spotify. Mostly buying spotify premium is the best way to support their valuable creations)
- Lyrics
- Downloadable track (WIP)

## Requirements (Linux🐧 only)

Don't worry **spotify premium isn't required**😱. But some extra packages are required.

- [MPV](https://mpv.io/installation/) player for playing the actual audio
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) for streaming the audio from youtube

Now, Install youtube-dl from

- official github repo: https://github.com/yt-dlp/yt-dlp#installation (recommended)

## Installation

I'm always releasing newer versions of binary of the software each 2-3 month with minor changes & each 6-8 month with major changes. Grab the binaries

All the binaries are located in the [releases](https://github.com/krtirtho/spotube/releases), just download

### Windows

Extract the **`Spotube-winx64-v<version>.zip`** & double click on **`install.bat`** & follow along the installer

### Linux

- **Ubuntu/Debian**
  Make sure you've fulfilled all the requirements
  ```bash
  sudo apt install spotube_linux-x86_64-v<version>.deb
  or
  sudo dpkg -i spotube_linux-x86_64-v<version>.deb
  ```
- **Others**: Navigate to the downloaded **`Spotube_linux-x86_64-v<version>.AppImage`**
  file & double click to run it

**I'll/try to upload the package binaries to linux debian/arch/ubuntu/snap/flatpack/redhat/chocolatey stores or software centers or repositories**

## Configuration

There are some configurations that needs to be done to start using this software

You need a spotify account & a developer app for

- clientId
- clientSecret

**Grab credentials:**

- Go to https://developer.spotify.com/dashboard/login & login with your spotify account (Skip if you're logged in)
  ![Step 1](https://user-images.githubusercontent.com/61944859/111762106-d1d37680-88ca-11eb-9884-ec7a40c0dd27.png)

- Create an web app for Spotify Public API
  ![step 2](https://user-images.githubusercontent.com/61944859/111762507-473f4700-88cb-11eb-91f3-d480e9584883.png)

- Give the app a name & description. Then Edit settings & add **http://localhost:4304/auth/spotify/callback** as **Redirect URI** for the app. Its important for authenticating
  ![setp-3](https://user-images.githubusercontent.com/61944859/111768971-d308a180-88d2-11eb-9108-3e7444cef049.png)

- Click on **SHOW CLIENT SECRET** to reveal the **clientSecret**. Then copy the **clientID**, **clientSecret** & paste in the **Spotube's** respective fields
  ![step-4](https://user-images.githubusercontent.com/61944859/111769501-7fe31e80-88d3-11eb-8fc1-f3655dbd4711.png)

Also, you need a [genius](https://genius.com) account for **lyrics** & a API Client for

- accessToken

> **Note!**: No personal data or any kind of sensitive information won't be collected from spotify. Don't believe? See the code for yourself

## TODO:

- [ ] Compile, Debug & Build for **MacOS**
- [x] Add support for show Lyric of currently playing track
- [ ] Track download
- [ ] Support for playing/streaming podcasts/shows
- [ ] Artist, User & Album pages

## Things that don't work

- Shows & Podcasts aren't supported as it'd require premium anyway
- OS Media Controls
- Global Media Shortcuts/Keyboard Media Buttons

#### Social handlers

Follow me on [Twitter](https://twitter.com/@krtirtho) for newer updates about this application
