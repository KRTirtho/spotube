import 'package:catcher/catcher.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart' hide Search;
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate.dart';
import 'package:spotube/pages/lyrics/mini_lyrics.dart';
import 'package:spotube/pages/search/search.dart';
import 'package:spotube/pages/settings/blacklist.dart';
import 'package:spotube/pages/settings/about.dart';
import 'package:spotube/pages/settings/logs.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/components/shared/spotube_page_route.dart';
import 'package:spotube/pages/album/album.dart';
import 'package:spotube/pages/artist/artist.dart';
import 'package:spotube/pages/library/library.dart';
import 'package:spotube/pages/desktop_login/login_tutorial.dart';
import 'package:spotube/pages/desktop_login/desktop_login.dart';
import 'package:spotube/pages/lyrics/lyrics.dart';
import 'package:spotube/pages/player/player.dart';
import 'package:spotube/pages/playlist/playlist.dart';
import 'package:spotube/pages/root/root_app.dart';
import 'package:spotube/pages/settings/settings.dart';
import 'package:spotube/pages/mobile_login/mobile_login.dart';

import '../pages/library/playlist_generate/playlist_generate_result.dart';

final rootNavigatorKey = Catcher.navigatorKey;
final shellRouteNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: shellRouteNavigatorKey,
      builder: (context, state, child) => RootApp(child: child),
      routes: [
        GoRoute(
          path: "/",
          pageBuilder: (context, state) => const SpotubePage(child: HomePage()),
        ),
        GoRoute(
          path: "/search",
          name: "Search",
          pageBuilder: (context, state) =>
              const SpotubePage(child: SearchPage()),
        ),
        GoRoute(
            path: "/library",
            name: "Library",
            pageBuilder: (context, state) =>
                const SpotubePage(child: LibraryPage()),
            routes: [
              GoRoute(
                  path: "generate",
                  pageBuilder: (context, state) =>
                      const SpotubePage(child: PlaylistGeneratorPage()),
                  routes: [
                    GoRoute(
                      path: "result",
                      pageBuilder: (context, state) => SpotubePage(
                        child: PlaylistGenerateResultPage(
                          state:
                              state.extra as PlaylistGenerateResultRouteState,
                        ),
                      ),
                    ),
                  ]),
            ]),
        GoRoute(
          path: "/lyrics",
          name: "Lyrics",
          pageBuilder: (context, state) =>
              const SpotubePage(child: LyricsPage()),
        ),
        GoRoute(
          path: "/settings",
          pageBuilder: (context, state) => const SpotubePage(
            child: SettingsPage(),
          ),
          routes: [
            GoRoute(
              path: "blacklist",
              pageBuilder: (context, state) => SpotubeSlidePage(
                child: const BlackListPage(),
              ),
            ),
            GoRoute(
              path: "logs",
              pageBuilder: (context, state) => SpotubeSlidePage(
                child: const LogsPage(),
              ),
            ),
            GoRoute(
              path: "about",
              pageBuilder: (context, state) => SpotubeSlidePage(
                child: const AboutSpotube(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "/album/:id",
          pageBuilder: (context, state) {
            assert(state.extra is AlbumSimple);
            return SpotubePage(child: AlbumPage(state.extra as AlbumSimple));
          },
        ),
        GoRoute(
          path: "/artist/:id",
          pageBuilder: (context, state) {
            assert(state.params["id"] != null);
            return SpotubePage(child: ArtistPage(state.params["id"]!));
          },
        ),
        GoRoute(
          path: "/playlist/:id",
          pageBuilder: (context, state) {
            assert(state.extra is PlaylistSimple);
            return SpotubePage(
              child: PlaylistView(state.extra as PlaylistSimple),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: "/mini-player",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => const SpotubePage(
        child: MiniLyricsPage(),
      ),
    ),
    GoRoute(
      path: "/login",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => SpotubePage(
        child: kIsMobile ? const WebViewLogin() : const DesktopLoginPage(),
      ),
    ),
    GoRoute(
      path: "/login-tutorial",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => const SpotubePage(
        child: LoginTutorial(),
      ),
    ),
    GoRoute(
      path: "/player",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        return const SpotubePage(
          child: PlayerView(),
        );
      },
    ),
  ],
);
