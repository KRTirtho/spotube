# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [2.7.0](https://github.com/KRTirtho/spotube/compare/v2.6.0...v2.7.0) (2023-03-07)


### Features

* add or remove track, playlist or album to queue support ([b8f3493](https://github.com/KRTirtho/spotube/commit/b8f3493138a9acd91d19efe67cfd1c0c7c269ae6))
* basic command line argument support ([025c1ae](https://github.com/KRTirtho/spotube/commit/025c1ae20461c2ac9124b3ef41e21ff01f100498))
* black list artist or track ([947c143](https://github.com/KRTirtho/spotube/commit/947c14353e15227400a6310673f3b850b2ff024f))
* bring pre download on desktop, disable pre download for long videos ([1d82bb0](https://github.com/KRTirtho/spotube/commit/1d82bb098717c7321d3e338f071c7661987fc3be))
* category/genre filter ([1dfec05](https://github.com/KRTirtho/spotube/commit/1dfec05eec7ee60cc9f6a3a97af37aef112063f1))
* centralized icon collection with new icon set and nav bar labels hidden ([e7acb9e](https://github.com/KRTirtho/spotube/commit/e7acb9ed5cb02826b8da559818f1fccfcf7f143c))
* compact search bar for genres and user_local_tracks page ([c343ccc](https://github.com/KRTirtho/spotube/commit/c343ccc2932868e3c1205d8cc625a9dfe9d78707))
* compatibility with fl-query nextPage method change ([7617439](https://github.com/KRTirtho/spotube/commit/761743991520609dd2b2dcb12cd6e4e75a8f6925))
* configure pocketbase, generate dart types, update playback to use server instead of hive cache ([ad90c11](https://github.com/KRTirtho/spotube/commit/ad90c11ab0c9f1aaba9ae9226d6076ea590f1a29))
* failsafe pocketbase requests, removal of unneeded preferences options & vertical playbutton actions ([d68d150](https://github.com/KRTirtho/spotube/commit/d68d150d3f42260f889d86927378c2f746bb6993))
* **home:** personalized section ([9080441](https://github.com/KRTirtho/spotube/commit/9080441b875ceb91260bbad79291365a98d5be95))
* individual shuffle and repeat/loop button of player ([f79223c](https://github.com/KRTirtho/spotube/commit/f79223cd41c61d9836d25e7bc2811c6515ba00c8))
* **lyrics:** use official spotify API for fetching lyrics and add zoom controls ([10d0660](https://github.com/KRTirtho/spotube/commit/10d0660972f008df0d11c280b681ce3b78f05d0b))
* **mobile:** pull to refresh support in all refreshable list views ([9f959ce](https://github.com/KRTirtho/spotube/commit/9f959ce77cd95cfc34d01af1f5cf53dd4206b6a6))
* new logo and compact search in playlist/album in mobile ([dc96cb3](https://github.com/KRTirtho/spotube/commit/dc96cb38cea8dc13738083f4850d22792d071019))
* search/filter tracks inside playlist or album ([a06cd0d](https://github.com/KRTirtho/spotube/commit/a06cd0da84cc03a2a7cadbc80d70556cb0cf9310))
* show snackbar on adding playlist or tracks to queue ([6bc1d32](https://github.com/KRTirtho/spotube/commit/6bc1d32a88ae516f77d149b83bcd536d2c888513))
* **theme:** use material3 monet for colors and remove background color preference ([60ede5f](https://github.com/KRTirtho/spotube/commit/60ede5f92b732691d53850290d9667435298a857))
* use catcher to handle exceptions ([84d94b0](https://github.com/KRTirtho/spotube/commit/84d94b05bc269a1676a261df2b12e508e10e4c0e))
* use typed assets instead of hard coded paths ([59561ab](https://github.com/KRTirtho/spotube/commit/59561abdc2540576fc95b34b3b55def63567000a))
* user local tracks searchbar ([e7f3f4e](https://github.com/KRTirtho/spotube/commit/e7f3f4eae49fe27a52fc3866fa4f6f2efb2aa479))
* **user-library:** filtering support for user albums and user artists ([0b58155](https://github.com/KRTirtho/spotube/commit/0b58155d434f2de6359be77d7beee4484dbb7b2a))
* **user-library:** search for user playlists ([af4d56f](https://github.com/KRTirtho/spotube/commit/af4d56fd41e57cbe6d87883e87e6b4469aaba52f))


### Bug Fixes

* **about:** license text hidden in the bottom of smaller screen devices ([e158dd0](https://github.com/KRTirtho/spotube/commit/e158dd0cec5657e495b538e86c412b06974a9f49))
* **about:** wrong link of License ([a4a7f1a](https://github.com/KRTirtho/spotube/commit/a4a7f1a74f9df82927403ca93aec508a13315ae8))
* genre and sidebar user logo not loading ([710f172](https://github.com/KRTirtho/spotube/commit/710f172dee45f60ed3e5ed83017eb538d6a626bf))
* lyrics modal sheet out of safe area so use 80% of screen height instead of full ([3db28f4](https://github.com/KRTirtho/spotube/commit/3db28f43b4200d03f7758e8c395d8430e0f89333))
* lyrics not changing on track change ([c809d2d](https://github.com/KRTirtho/spotube/commit/c809d2daba4beaea7c4f16c6bb0edef9efa825b8))
* lyrics not refetching when tracked changed while being in another page and sidebar user avatar not showing on startup ([bd12675](https://github.com/KRTirtho/spotube/commit/bd126751e9594fbc926bbcad7b9a2c577fce074a))
* macOS logo placement ([c6a5d5f](https://github.com/KRTirtho/spotube/commit/c6a5d5f7b1b1fad3a0b5e63c02c847a149e72efe))
* mobile track collection search bar position and page_window_title_bar exception on mobile platforms ([d0aaa97](https://github.com/KRTirtho/spotube/commit/d0aaa971fe358b9cb5dc7a35cc82eaf6520f7ab4))
* **play_overlay:** show progress indicator on song loading ([7803a48](https://github.com/KRTirtho/spotube/commit/7803a48237c91f2a57bcc86fbd30ad879142c8ff))
* **playback:** not skipping track's  sponsorblock segments ([60a5847](https://github.com/KRTirtho/spotube/commit/60a5847ae68836bbbeef748254c674c81fa5c3ea))
* playbutton card play state not changing ([ee46d09](https://github.com/KRTirtho/spotube/commit/ee46d0970be9e227793494a41e25c0c469847cd0))
* **playbutton_card:** play and add to queue needs 2 clicks work ([bdd7098](https://github.com/KRTirtho/spotube/commit/bdd70984e6670813e508786e74cd2ea4a1fe1d53))
* **playbutton_card:** play and non play state correction ([b327ffb](https://github.com/KRTirtho/spotube/commit/b327ffb1084b43e5c78e13994f65fb30b3a7e67e))
* **playbutton_card:** title text overflow ([39ee0a9](https://github.com/KRTirtho/spotube/commit/39ee0a92a8f3d74d243db206fe034330f75c0588))
* **playbutton:** playing state is not updating when playlist is actually playing ([9bad8c9](https://github.com/KRTirtho/spotube/commit/9bad8c9eb88f7c91091a669b642b92474df0f128))
* **player_queue:** large clear button and macos exception ([0e43504](https://github.com/KRTirtho/spotube/commit/0e43504e18d2315fb1b7975b67bd2c596cbfb1bc))
* **playlist_queue:** load method not preserving the active track before filtering blacklisted tracks ([42b3e11](https://github.com/KRTirtho/spotube/commit/42b3e111f844f6de6a145de2760ccfd7e97e623b))
* pre downloading not working properly, audio service circular deps and sibling not loading for backend track ([3ccb525](https://github.com/KRTirtho/spotube/commit/3ccb525260a83ba54021a353b15ed3cda6e9c876))
* search track play button isn't working ([0751f5e](https://github.com/KRTirtho/spotube/commit/0751f5e3173882f3aeed67027854e5054b689693))
* **search:** grey screen, only tracks update on new search string, playlists,albums,artists show up before hitting return/submit ([a774817](https://github.com/KRTirtho/spotube/commit/a774817240ef813cb95f82f53ccb798ef9acb51d))
* **search:** has to submit twice for search results ([f5dc76a](https://github.com/KRTirtho/spotube/commit/f5dc76a98f55f0f032a6fe4208465899f932355a))
* titlebar maximize+restore button not working and less responsive title bar buttons ([8a6ba3b](https://github.com/KRTirtho/spotube/commit/8a6ba3b35f0b6b42cf60920e945ac2065c886ecb))
* **track_collection_view:** hide search bar when sliver is collapsed ([3d6d244](https://github.com/KRTirtho/spotube/commit/3d6d2444beed153a2b6663d6153684b2974f4152))
* **track_tile:**  cannot see track index above 99 ([78b3273](https://github.com/KRTirtho/spotube/commit/78b3273e441cdaa6d4a410ddfe29837dc1aa7000))
* **track_tile:** track action popup not showing on narrow screens ([0c54f2d](https://github.com/KRTirtho/spotube/commit/0c54f2dcd4474b63db4c517b0e7332cbd3ab51e9))
* **ui:** scaffold exception in fluent_ui ([8ce2192](https://github.com/KRTirtho/spotube/commit/8ce2192e5cb08e3a8be5ead510ab35b274bef2ef))
* use chosen market for new release ([c6bf9b6](https://github.com/KRTirtho/spotube/commit/c6bf9b67995161a8bf7c3782188d01e8859c18e9))

## [2.6.0](https://github.com/KRTirtho/spotube/compare/v2.5.0...v2.6.0) (2022-12-09)


### Features

* add selected tracks to playlists, optimistic playlist remove track ([3386dac](https://github.com/KRTirtho/spotube/commit/3386dac78ee49b9e3504f5c05bf1e7b362a2e8a2))
* added shuffle button in playlist and album section ([1fad95f](https://github.com/KRTirtho/spotube/commit/1fad95f6e370606a9faf6f2bb9738dc360e23918))
* **android-playback:** option to download track bytes and play instead of Streaming ([dcc8ba5](https://github.com/KRTirtho/spotube/commit/dcc8ba5a54286b252d53c9c14918971bf7bea8cc))
* change default platform option and platform specific back button ([36c5e02](https://github.com/KRTirtho/spotube/commit/36c5e02f18374100f61cc3f2957c27bfc0d8511f))
* dialog logo for macos, settings more width for country picker ([5e96913](https://github.com/KRTirtho/spotube/commit/5e96913ba34230e7a15d62060d5dae28d80e3630))
* initial platform_ui integration ([9eee573](https://github.com/KRTirtho/spotube/commit/9eee573ce928aa6c03dcb50bf1521350d2de32cc))
* libadwaita theming, track tile and PlayButtonCard play button icon fix ([e795e23](https://github.com/KRTirtho/spotube/commit/e795e23e42e5f1f832963b2a4506df89b7df5baa))
* **lyrics:** tabs for both synced and static lyrics [#182](https://github.com/KRTirtho/spotube/issues/182) ([6b6907a](https://github.com/KRTirtho/spotube/commit/6b6907af3fdb327312ad4dd9e16b3e2a850ed896))
* new refined about page, update checker only check for same update channel ([4cadfa9](https://github.com/KRTirtho/spotube/commit/4cadfa93750cc9b3f8fbe7b60f8161a77d2a12f6))
* pause track when seeking forward/back and keep audio session alive when paused/interrupted ([bc8a04e](https://github.com/KRTirtho/spotube/commit/bc8a04e5442ba3abe1b04ab325769559f37d9802))
* platform bottom navigation bar add ([ff14469](https://github.com/KRTirtho/spotube/commit/ff1446982f0260c6fe231970aa6ed61c273fdf07))
* platform slider and progress indicator integration ([46b00ba](https://github.com/KRTirtho/spotube/commit/46b00bafdf71a4add61cf50168a32198c3293181))
* platform title bar buttons add ([54048cb](https://github.com/KRTirtho/spotube/commit/54048cbfc37d9a40c020eb81ab67b9dd5428f0d7))
* **playback:** change current track youtube source panel and tooltips for player icon buttons ([4b21cc8](https://github.com/KRTirtho/spotube/commit/4b21cc829954fb079d1a0081b9147377063da3ec))
* Player and Playbutton theme respect to platform ([512446d](https://github.com/KRTirtho/spotube/commit/512446dcab72aa1d7bce18e5a5793f6be8f30fcb))
* player queue and sibling tracks platform decoration ([39a7794](https://github.com/KRTirtho/spotube/commit/39a77945d132d90ff323b0a22edc2a12a4749888))
* **PlayerView:** shortcut button for opening lyrics [#273](https://github.com/KRTirtho/spotube/issues/273) ([1d4847a](https://github.com/KRTirtho/spotube/commit/1d4847ab0a0b18d5bc27257b3db863b995dc5843))
* rename files to snake_case and reorganize folder structure ([7c25e1c](https://github.com/KRTirtho/spotube/commit/7c25e1cc8a35eb8aee2268799c05f299204fa3f5))
* replace all types of buttons with platform buttons ([69739b4](https://github.com/KRTirtho/spotube/commit/69739b457296a6b209aa6f73beb378ae1f089ac5))
* rpm packaging support ([067e9ac](https://github.com/KRTirtho/spotube/commit/067e9ac53ee85775c9ec35457fac9e064e72e4c0))
* **search:** infinite scroll for tracks, artists, playlists and albums ([e6761a6](https://github.com/KRTirtho/spotube/commit/e6761a6f8eadf4ab260723253a8e00121b6365b5))
* set platform to default platform on start up ([472da6b](https://github.com/KRTirtho/spotube/commit/472da6b8b1c3e06b666da58351f3feafbfe6c98a))
* shuffle keep playing track at top, linux title bar drag no working ([1223cf2](https://github.com/KRTirtho/spotube/commit/1223cf2629c6615b0c48e9e6742b68341f33c7f8))
* sidebar download count and proper progress color in playbutton ([a10bc5b](https://github.com/KRTirtho/spotube/commit/a10bc5b8d89207ac86872dd25f3258e47c2141a5))
* static shimmer for track tile, playbutton card and track tile ([3ed8b0f](https://github.com/KRTirtho/spotube/commit/3ed8b0fda2cb8145a2bc6c8f8c6af82db6a40547))
* tablet mode navigation bar & windows semi transparent bg, ([3282370](https://github.com/KRTirtho/spotube/commit/3282370f74f323c00116fa8626fd1440ee9d4922))
* **title_bar:** platform specific title bar ([e659e3c](https://github.com/KRTirtho/spotube/commit/e659e3c56fb02ad8a1c5114bf80074f0324cc4f1))
* titlebar complete compatibility, platform specific login, library tabbar in titlebar ([b3c27d1](https://github.com/KRTirtho/spotube/commit/b3c27d1fca233ea079803fe49134abc528376df3))
* use platform checkbox ([2211505](https://github.com/KRTirtho/spotube/commit/2211505d713cef752d07cafb9791a49e8095eee2))
* window blur effect add ([b0db5e7](https://github.com/KRTirtho/spotube/commit/b0db5e7d8246f98835e7ce6656c8aa7620e46bec))


### Bug Fixes

* **ArtistCard:** linux shadow ([c186881](https://github.com/KRTirtho/spotube/commit/c1868817e5abb8a4152646f00a0395933fee7823))
* **auth:** refresh access token timer not working ([b3ac5ca](https://github.com/KRTirtho/spotube/commit/b3ac5ca3bbb6d5af154f4b5d715d1f19ca2f46e2))
* bottom navigation bar settings tile not active when selected ([43557e4](https://github.com/KRTirtho/spotube/commit/43557e40df269757c2d5236a455308ea6478d95a))
* dialog logo in android, lyrics visible timer adjust button ([3c6803b](https://github.com/KRTirtho/spotube/commit/3c6803bb3fac8eee9166764089724194a48509c6))
* heart button showing when not logged in, wrong login redirect ([4dc26af](https://github.com/KRTirtho/spotube/commit/4dc26af23d12f76cbfdfbf4e37b0c11fcc484d3f))
* horizontal infinite lists doesn't fill the screen ([69995be](https://github.com/KRTirtho/spotube/commit/69995bea1c6342c9212e5b22ef50bdfd6e7eba45))
* ios dialog action buttons, local tracks crashing app, shimmer color and android wrong status bar color ([90c1200](https://github.com/KRTirtho/spotube/commit/90c1200a087f796690de0cfc8cc607d2bff44282))
* **login:** not working in android in Brazil or Ukraine regions ([0b79a11](https://github.com/KRTirtho/spotube/commit/0b79a1181c37cf06fbfa3bfb3854cfd47097016e))
* **macos:** black text in dark mode ([fb9c0e4](https://github.com/KRTirtho/spotube/commit/fb9c0e44be93997fc852bf0260e8a8608000c023))
* **macos:** white text color in dark mode, text field white background ([e086b52](https://github.com/KRTirtho/spotube/commit/e086b520e745e65771136cbfa842ae0693c44872))
* **mobile:** SafeArea bugs and back button color ([a8330ef](https://github.com/KRTirtho/spotube/commit/a8330ef2e1112012bbae19ee6a5c27a26c5fb719))
* null exception in themes ([9465d92](https://github.com/KRTirtho/spotube/commit/9465d92fa032b8598a0752767dcec9af2541d222))
* platform_ui local path ([00d0d38](https://github.com/KRTirtho/spotube/commit/00d0d38b5450aeb877195afdfb9424f83762d178))
* player view artist link when local playlist is playing, lyric delay adjust button alignment ([ee5c417](https://github.com/KRTirtho/spotube/commit/ee5c417ac396ef0b1796fa74a6a494181e6e0396))
* remove windows background ([6942964](https://github.com/KRTirtho/spotube/commit/694296418787c460bb3fa63ab30f3b0eed9184dc))
* search field ios dark icon , lyrics tabbar ios background color ([be56ad4](https://github.com/KRTirtho/spotube/commit/be56ad44773ebcd14777d80b61e26875698dc18a))
* settings Title alignment and play button card ripple effect in other platforms ([3b6bf27](https://github.com/KRTirtho/spotube/commit/3b6bf27a984f5d4836143638396ed4b467c0eae7))
* shuffle play logic ([65cad07](https://github.com/KRTirtho/spotube/commit/65cad07e3a6e2188c53159057f9c3d4fe89706ea))
* small minwidth of window in desktop, linux wrong light theme accent color, search field transparent background ([5b0e22c](https://github.com/KRTirtho/spotube/commit/5b0e22c1b639f2f57d92cb70cd11f56e30e0a457))
* tooltips of menu and adaptive pop up menu ([261aaf1](https://github.com/KRTirtho/spotube/commit/261aaf191c51bc12b28c602ee160d53d3eacf3a5))
* update download dialog blocking the UI ([3925f74](https://github.com/KRTirtho/spotube/commit/3925f743951e51f138cc3ca865fa167c34e776ef))
* user playlists not updating after creating/deleting, artist follow not updating after follow/unfollow ([6cc2a18](https://github.com/KRTirtho/spotube/commit/6cc2a185d0c4c19f176e6f65b8ada19ebc76af5e))
* **windows:** windows global title bar ([bd18f19](https://github.com/KRTirtho/spotube/commit/bd18f198217538f0089d5a1c4288dd97f982661b))

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