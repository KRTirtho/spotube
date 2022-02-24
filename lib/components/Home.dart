import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth2/oauth2.dart' show AuthorizationException;
import 'package:spotify/spotify.dart' hide Image, Player, Search;

import 'package:spotube/components/Category/CategoryCard.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/components/Home/SpotubeNavigationBar.dart';
import 'package:spotube/components/Login.dart';
import 'package:spotube/components/Lyrics.dart';
import 'package:spotube/components/Search/Search.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Player/Player.dart';
import 'package:spotube/components/Library/UserLibrary.dart';
import 'package:spotube/helpers/oauth-login.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/SpotifyDI.dart';

List<String> spotifyScopes = [
  "user-library-read",
  "user-library-modify",
  "user-read-private",
  "user-read-email",
  "user-follow-read",
  "user-follow-modify",
  "playlist-read-collaborative"
];

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final PagingController<int, Category> _pagingController =
      PagingController(firstPageKey: 0);

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String? clientId = localStorage.getString(LocalStorageKeys.clientId);
      String? clientSecret =
          localStorage.getString(LocalStorageKeys.clientSecret);
      String? accessToken =
          localStorage.getString(LocalStorageKeys.accessToken);
      String? refreshToken =
          localStorage.getString(LocalStorageKeys.refreshToken);
      String? expirationStr =
          localStorage.getString(LocalStorageKeys.expiration);
      DateTime? expiration =
          expirationStr != null ? DateTime.parse(expirationStr) : null;
      try {
        Auth auth = ref.read(authProvider);

        if (clientId != null && clientSecret != null) {
          SpotifyApi spotifyApi = SpotifyApi(
            SpotifyApiCredentials(
              clientId,
              clientSecret,
              accessToken: accessToken,
              refreshToken: refreshToken,
              expiration: expiration,
              scopes: spotifyScopes,
            ),
          );
          SpotifyApiCredentials credentials = await spotifyApi.getCredentials();
          if (credentials.accessToken?.isNotEmpty ?? false) {
            auth.setAuthState(
              clientId: clientId,
              clientSecret: clientSecret,
              accessToken:
                  credentials.accessToken, // accessToken can be new/refreshed
              refreshToken: refreshToken,
              expiration: credentials.expiration,
              isLoggedIn: true,
            );
          }
        }
        _pagingController.addPageRequestListener((pageKey) async {
          try {
            SpotifyApi spotifyApi = ref.read(spotifyProvider);
            Page<Category> categories = await spotifyApi.categories
                .list(country: "US")
                .getPage(15, pageKey);

            var items = categories.items!.toList();
            if (pageKey == 0) {
              Category category = Category();
              category.id = "user-featured-playlists";
              category.name = "Featured";
              items.insert(0, category);
            }

            if (categories.isLast && categories.items != null) {
              _pagingController.appendLastPage(items);
            } else if (categories.items != null) {
              _pagingController.appendPage(items, categories.nextOffset);
            }
          } catch (e) {
            _pagingController.error = e;
          }
        });
      } on AuthorizationException catch (_) {
        if (clientId != null && clientSecret != null) {
          oauthLogin(
            ref.read(authProvider),
            clientId: clientId,
            clientSecret: clientSecret,
          );
        }
      } catch (e, stack) {
        print("[Home.initState]: $e");
        print(stack);
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  _onSelectedIndexChanged(int index) => setState(() {
        _selectedIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    Auth auth = ref.watch(authProvider);
    final width = MediaQuery.of(context).size.width;
    if (!auth.isLoggedIn) {
      return const Login();
    }

    return Scaffold(
      body: Column(
        children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: width > 400 && width <= 700
                              ? 72
                              : width > 700
                                  ? 256
                                  : 0),
                      color:
                          Theme.of(context).navigationRailTheme.backgroundColor,
                      child: MoveWindow(),
                    ),
                    Expanded(child: MoveWindow()),
                    if (!Platform.isMacOS) const TitleBarActionButtons(),
                  ],
                )),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Sidebar(
                  selectedIndex: _selectedIndex,
                  onSelectedIndexChanged: _onSelectedIndexChanged,
                ),
                // contents of the spotify
                if (_selectedIndex == 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PagedListView(
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<Category>(
                          itemBuilder: (context, item, index) {
                            return CategoryCard(item);
                          },
                        ),
                      ),
                    ),
                  ),
                if (_selectedIndex == 1) const Search(),
                if (_selectedIndex == 2) const UserLibrary(),
                if (_selectedIndex == 3) const Lyrics(),
              ],
            ),
          ),
          // player itself
          const Player(),
          SpotubeNavigationBar(
            selectedIndex: _selectedIndex,
            onSelectedIndexChanged: _onSelectedIndexChanged,
          ),
        ],
      ),
    );
  }
}
