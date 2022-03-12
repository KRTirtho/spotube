import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/hooks/useHotKeys.dart';
import 'package:spotube/hooks/usePagingController.dart';
import 'package:spotube/hooks/useSharedPreferences.dart';
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

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Auth auth = ref.watch(authProvider);

    final pagingController =
        usePagingController<int, Category>(firstPageKey: 0);
    final int titleBarDragMaxWidth = useBreakpointValue(
      md: 72,
      lg: 256,
      sm: 0,
      xl: 0,
      xxl: 0,
    );
    final _selectedIndex = useState(0);
    _onSelectedIndexChanged(int index) => _selectedIndex.value = index;

    final localStorage = useSharedPreferences();

    // initializing global hot keys
    useHotKeys(ref);

    useEffect(() {
      if (localStorage == null) return null;
      final String? clientId =
          localStorage.getString(LocalStorageKeys.clientId);
      final String? clientSecret =
          localStorage.getString(LocalStorageKeys.clientSecret);
      final String? accessToken =
          localStorage.getString(LocalStorageKeys.accessToken);
      final String? refreshToken =
          localStorage.getString(LocalStorageKeys.refreshToken);
      final String? expirationStr =
          localStorage.getString(LocalStorageKeys.expiration);
      listener(pageKey) async {
        final spotify = ref.read(spotifyProvider);
        try {
          Page<Category> categories =
              await spotify.categories.list(country: "US").getPage(15, pageKey);

          var items = categories.items!.toList();
          if (pageKey == 0) {
            Category category = Category();
            category.id = "user-featured-playlists";
            category.name = "Featured";
            items.insert(0, category);
          }

          if (categories.isLast && categories.items != null) {
            pagingController.appendLastPage(items);
          } else if (categories.items != null) {
            pagingController.appendPage(items, categories.nextOffset);
          }
        } catch (e, stack) {
          pagingController.error = e;
          print("[Home.pagingController.addPageRequestListener] $e");
          print(stack);
        }
      }

      try {
        final DateTime? expiration =
            expirationStr != null ? DateTime.parse(expirationStr) : null;
        if (clientId != null && clientSecret != null) {
          SpotifyApi spotify = SpotifyApi(
            SpotifyApiCredentials(
              clientId,
              clientSecret,
              accessToken: accessToken,
              refreshToken: refreshToken,
              expiration: expiration,
              scopes: spotifyScopes,
            ),
          );
          spotify.getCredentials().then((credentials) {
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
            return null;
          }).then((_) {
            pagingController.addPageRequestListener(listener);
          }).catchError((e, stack) {
            if (e is AuthorizationException) {
              oauthLogin(
                auth,
                clientId: clientId,
                clientSecret: clientSecret,
              );
            }
            print("[Home.useEffect.spotify.getCredentials]: $e");
            print(stack);
          });
        }
      } catch (e, stack) {
        print("[Home.initState]: $e");
        print(stack);
      }
      return () {
        pagingController.removePageRequestListener(listener);
      };
    }, [localStorage]);

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
                        maxWidth: titleBarDragMaxWidth.toDouble(),
                      ),
                      color:
                          Theme.of(context).navigationRailTheme.backgroundColor,
                      child: MoveWindow(),
                    ),
                    Expanded(child: MoveWindow()),
                    if (!Platform.isMacOS) const TitleBarActionButtons(),
                  ],
                ))
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Sidebar(
                  selectedIndex: _selectedIndex.value,
                  onSelectedIndexChanged: _onSelectedIndexChanged,
                ),
                // contents of the spotify
                if (_selectedIndex.value == 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PagedListView(
                        pagingController: pagingController,
                        builderDelegate: PagedChildBuilderDelegate<Category>(
                          itemBuilder: (context, item, index) {
                            return CategoryCard(item);
                          },
                        ),
                      ),
                    ),
                  ),
                if (_selectedIndex.value == 1) const Search(),
                if (_selectedIndex.value == 2) const UserLibrary(),
                if (_selectedIndex.value == 3) const Lyrics(),
              ],
            ),
          ),
          // player itself
          const Player(),
          SpotubeNavigationBar(
            selectedIndex: _selectedIndex.value,
            onSelectedIndexChanged: _onSelectedIndexChanged,
          ),
        ],
      ),
    );
  }
}
