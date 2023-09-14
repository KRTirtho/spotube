---
title: Getting Started With Spotube
cover_image: https://github.com/KRTirtho/spotube/raw/master/assets/spotube-screenshot.png
date: "September 14, 2023"
author: Kingkor Roy Tirtho
author_avatar_url: https://avatars.githubusercontent.com/u/61944859?v=4
tags:
  - getting-started
  - spotube
summary: You installed Spotube, don't know what to do now? Then don't worry we Gotchu covered here. We'll guide you through the basics of using Spotube & how you can use it to enrich your daily life with music.
---

So installing Spotube is done. It’s a new app & although most of the things can be understood just by using the app as the UI is descriptive but still sometimes newcomers become overwhelmed by its UI & functionalities. In this article, we’re going to guide you through the problems that you can face while using Spotube by misunderstanding

## Login with Spotify

The most common issue with Spotube when someone uses it for the first is with its Login mechanism. Spotube is a Spotify client. And Spotify clients usually require *Premium Accounts* as the Spotify Server only allows premium accounts to download music. But **in Spotube you don’t need a Premium Account**

### Android Login
It's super easy to login with Spotify account in Spotube Android version. Just tap on the "⚙️ Settings" > "Connect with Spotify" button & it'll navigate to official Spotify login page where user can enter their credentials safely & get logged in

### Desktop Login
Unfortunately, there's currently no way to run webview inside Flutter apps in desktop. Thus the user have to manually get the cookies from [accounts.spotify.com](https://accounts.spotify.com)
Just like Android, go to "⚙️ Settings" > "Connect with Spotify". Now it'll open a login page that accepts `sp_dc` & `sp_key` or `sp_gaid` cookie values
There's already a button named ***"Follow along the Step by Step guide"*** to open the tutorial on how to get these cookies
Although there's a tutorial available in the app, here's a quick guide on how to get these cookies

1. Open [accounts.spotify.com](https://accounts.spotify.com) in your browser
1. Login with your Spotify account
1. Open the Developer Tools (F12)
   1. Chrome/Chrome-based browsers: Go to Application Tab
   1. Firefox: Go to Storage Tab
1. Find the Cookies section & copy the values of `sp_dc` & `sp_key` or `sp_gaid` cookies
1. Paste the values in the respective fields in Spotube & press the "Login" button
1. Done! You're logged in

## Playing Playlists & Tracks

You can play any playlists in the Home Screen of Spotube just by pressing the Play button of the playlist. But this is not just it. You can also play any playlist from starting from any track of the playlist and this available in all platform unlike Spotify which doesn't allow this kind stupid simple stuff in the Mobile App.
Just tap on any Playlist's Cover Image & from the track list, tap the little Play button next to the track from which you want the playlist to start playing.

![Bpfau.png](https://s6.imgcdn.dev/Bpfau.png)


## Sing along with any Song with **Synced Lyrics** just like Karaoke

Yes, Spotube support Synced Lyrics too. So, if you wanna sing along with your favorite Music Track but don't know the Lyrics Spotube got you covered & now even you can sing along. Here's how, just play any playlist/album/track & press on the Lyrics Button in the Sidebar (desktop/tablet) or inside Player Page (mobile) & the Synced Lyrics will automatically start playing with the Audio Track

![BpttL.png](https://s6.imgcdn.dev/BpttL.png)


## Discover Weekly Playlist

Spotube categorizes playlists by Genre & always shows the most trending playlists in the home screen. In Spotube the Music isn't personalized & it shows you the playlists with best music. So the experience is more vast & what you experience is genuinely what you love & want to listen to not forced or manipulated to

But there's one question, **where the heck is my Discover Weekly playlist**?
It's there. But doesn't show up in the home screen because it's a special kind of playlist that Spotify doesn't allow third-party clients to access unless the User specifically searches for it. You can find your Discover Weekly playlist by simply searching on Spotube's search page like below

![BpVcB.png](https://s6.imgcdn.dev/BpVcB.png)