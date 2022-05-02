import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:oauth2/oauth2.dart' show AuthorizationException;
import 'package:spotify/spotify.dart' hide Image, Player, Search;

import 'package:spotube/components/Category/CategoryCard.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/components/Home/SpotubeNavigationBar.dart';
import 'package:spotube/components/Lyrics/SyncedLyrics.dart';
import 'package:spotube/components/Search/Search.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Player/Player.dart';
import 'package:spotube/components/Library/UserLibrary.dart';
import 'package:spotube/helpers/get-random-element.dart';
import 'package:spotube/helpers/oauth-login.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/hooks/useHotKeys.dart';
import 'package:spotube/hooks/usePagingController.dart';
import 'package:spotube/hooks/useSharedPreferences.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/UserPreferences.dart';

List<String> spotifyScopes = [
  "playlist-modify-public",
  "playlist-modify-private",
  "user-library-read",
  "user-library-modify",
  "user-read-private",
  "user-read-email",
  "user-follow-read",
  "user-follow-modify",
  "playlist-read-collaborative"
];

class Home extends HookConsumerWidget {
  Home({Key? key}) : super(key: key);
  final logger = getLogger(Home);

  @override
  Widget build(BuildContext context, ref) {
    Auth auth = ref.watch(authProvider);
    String recommendationMarket = ref.watch(userPreferencesProvider.select(
      (value) => (value.recommendationMarket),
    ));

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

    final listener = useCallback((int pageKey) async {
      final spotify = ref.read(spotifyProvider);

      try {
        Page<Category> categories = await spotify.categories
            .list(country: recommendationMarket)
            .getPage(15, pageKey);

        final items = categories.items!.toList();
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
        logger.e("pagingController.addPageRequestListener", e, stack);
      }
    }, [recommendationMarket]);

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

      try {
        final DateTime? expiration =
            expirationStr != null ? DateTime.parse(expirationStr) : null;
        final anonCred = getRandomElement(spotifySecrets);
        SpotifyApiCredentials apiCredentials =
            clientId != null && clientSecret != null
                ? SpotifyApiCredentials(
                    clientId,
                    clientSecret,
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    expiration: expiration,
                    scopes: spotifyScopes,
                  )
                : SpotifyApiCredentials(
                    anonCred["clientId"],
                    anonCred["clientSecret"],
                  );

        SpotifyApi spotify = SpotifyApi(apiCredentials);
        if (clientId != null && clientSecret != null) {
          spotify.getCredentials().then((credentials) {
            if (credentials.accessToken?.isNotEmpty == true) {
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
            pagingController.addPageRequestListener(listener);
            // the world is full of surprises and the previously working
            // fine pageRequestListener now doesn't notify the listeners
            // automatically after assigning a listener. So doing it manually
            pagingController.notifyPageRequestListeners(0);
          }).catchError((e, stack) {
            if (e is AuthorizationException) {
              oauthLogin(
                auth,
                clientId: clientId,
                clientSecret: clientSecret,
              );
            }
            logger.e("useEffect.spotify.getCredentials", e, stack);
          });
        } else {
          pagingController.addPageRequestListener(listener);
          pagingController.notifyPageRequestListeners(0);
        }
      } catch (e, stack) {
        logger.e("initState", e, stack);
      }
      return () {
        pagingController.removePageRequestListener(listener);
      };
    }, [localStorage]);

    final titleBarContents = Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: titleBarDragMaxWidth.toDouble(),
                  ),
                  color: Theme.of(context).navigationRailTheme.backgroundColor,
                  child: MoveWindow(),
                ),
                Expanded(child: MoveWindow()),
                if (!Platform.isMacOS && !Platform.isAndroid && !Platform.isIOS)
                  const TitleBarActionButtons(),
              ],
            ))
          ],
        ));

    final brightness = Theme.of(context).brightness;

    useEffect(() {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: brightness == Brightness.dark
              ? Colors.blueGrey[900]
              : Colors.white, // status bar color
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      );
      return null;
    }, [brightness]);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Platform.isAndroid || Platform.isIOS
                ? titleBarContents
                : WindowTitleBarBox(child: titleBarContents),
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
                  if (_selectedIndex.value == 3) const SyncedLyrics(),
                ],
              ),
            ),
            // player itself
            Player(),
            SpotubeNavigationBar(
              selectedIndex: _selectedIndex.value,
              onSelectedIndexChanged: _onSelectedIndexChanged,
            ),
          ],
        ),
      ),
    );
  }
}
