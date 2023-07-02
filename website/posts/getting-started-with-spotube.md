---
title: Getting Started With Spotube
cover_image: https://github.com/KRTirtho/spotube/raw/master/assets/spotube-screenshot.png
date: "July 16, 2022"
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

Since Spotube doesn’t require premium accounts it needs to special workarounds to supply the Music for Free. Thus, the Login mechanism in Spotube is a bit lengthy, but it’s actually more secure than any other Spotify Clients as the data stays in your Account & doesn’t need to go through a middleware unlike other Spotify Clients

Now, let’s get through the login Part. For Login, you’ll need two special things

- Client ID
- Client Secret

**What is a Client ID?**

Client ID is kind of a Public key (ID)  that is a unique identifier for the Spotify API client & is usually used to pair with Client Secret

**What is a Client Secret?**

A client secret is **a secret known only to the application instance and the authorization server**. It protects Spotify Data by only granting tokens to authorized requestors

Now In Spotube, tap on the Settings Icon in the Sidebar/Bottom Bar & click on the **Login With Spotify** button.

Now you’ll have to open a browser & have to go to [developers.spotify.com/dashboard](https://developers.spotify.com/dashboard) & press the Login button

![step-1.png](https://rawcdn.githack.com/KRTirtho/spotube/0e10ddfa54113eb559308be1eb976b707dd7410c/assets/tutorial/step-1.png)

After Login, create a Spotify Developer App by clicking on the CREATE AN APP button. Give the App a name & description & hit CREATE. Finally, the view will look somewhat similar to below

![step-2.png](https://rawcdn.githack.com/KRTirtho/spotube/0e10ddfa54113eb559308be1eb976b707dd7410c/assets/tutorial/step-2.png)

Now comes the **Most Important Part…**

First Tap on the App to enter the dashboard page. In there, tap EDIT SETTINGS & a Dialog with multiple configuration will Open

![step-3a.jpg](https://rawcdn.githack.com/KRTirtho/spotube/0e10ddfa54113eb559308be1eb976b707dd7410c/assets/tutorial/step-3a.jpg)

Now find the **Redirect Uris** and type/paste `http://localhost:4304/auth/spotify/callback` in the field and press Add. Finally scroll down to the bottom section of the Dialog and press the SAVE button to save the changes

![step-3b.jpg](https://rawcdn.githack.com/KRTirtho/spotube/0e10ddfa54113eb559308be1eb976b707dd7410c/assets/tutorial/step-3b.jpg)

Now close the Dialog & see in the Left/Below of the EDIT SETTINGS button, there you’ll find **Client ID** and a SHOW CLIENT SECRET button. Copy the *Client ID* & paste it in the Spotube’s Text Field. Then tap/click on the SHOW CLIENT SECRET button to reveal the **Client Secret.** Finally, copy the **Client Secret** & paste it in the Spotube’s corresponding Text Field

![step-4.jpg](https://rawcdn.githack.com/KRTirtho/spotube/0e10ddfa54113eb559308be1eb976b707dd7410c/assets/tutorial/step-4.jpg)

Finally, press on the *Submit Button* which will open a Browser Window/Tab (desktop) or a Browser Application (android). Press/Click ALLOW button in that page & now you’re successfully Logged In with your Spotify Account in Spotube

Close the Browser Tab (optional) & Go back to Spotube and Enjoy your lifetime (probably) free Music

## Playing Playlists & Tracks

You can play any playlists in the Home Screen of Spotube just by pressing the Play button of the playlist. But this is not just it. You can also play any playlist from starting from any track of the playlist and this available in all platform unlike Spotify which doesn't allow this kind stupid simple stuff in the Mobile App
Just tap on any Playlist's Cover Image & from the track list, tap the little Play button next to the track from which you want the playlist to start playing.

![Bpfau.png](https://s6.imgcdn.dev/Bpfau.png)


## Sing along with any Song with **Synced Lyrics** just like Karaoke

Yes, Spotube support Synced Lyrics too (most of the popular English songs). So, if you wanna sing along with your favorite Music Track but don't know the Lyrics Spotube got you covered & now even you can sing along. Here's how, just play any playlist/album/track & press on the Lyrics Tab in the Sidebar (desktop/tablet) or Bottom Bar (mobile) & the Synced Lyrics will automatically start playing with the Audio Track

![BpttL.png](https://s6.imgcdn.dev/BpttL.png)


## Discover Weekly Playlist

Spotube categorizes playlists by Genre & always shows the most trending playlists in the home screen. In Spotube the Music isn't personalized & it shows you the playlists with best music. So the experience is more vast & what you experience is genuinely what you love & want to listen to not forced or manipulated to

But there's one question, **where the heck is my Discover Weekly playlist**?
It's there. But doesn't show up in the home screen because it's a special kind of playlist that Spotify doesn't allow third-party clients to access unless the User specifically searches for it. You can find your Discover Weekly playlist by simply searching on Spotube's search page like below

![BpVcB.png](https://s6.imgcdn.dev/BpVcB.png)