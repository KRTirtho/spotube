import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart' hide Search;
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Artist/ArtistProfile.dart';
import 'package:spotube/components/Home/Genres.dart';
import 'package:spotube/components/Home/Shell.dart';
import 'package:spotube/components/Library/UserLibrary.dart';
import 'package:spotube/components/Login/LoginTutorial.dart';
import 'package:spotube/components/Login/TokenLogin.dart';
import 'package:spotube/components/Lyrics/Lyrics.dart';
import 'package:spotube/components/Player/PlayerView.dart';
import 'package:spotube/components/Playlist/PlaylistView.dart';
import 'package:spotube/components/Search/Search.dart';
import 'package:spotube/components/Settings/Settings.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/components/Login/WebViewLogin.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellRouteNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: shellRouteNavigatorKey,
      builder: (context, state, child) => Shell(child: child),
      routes: [
        GoRoute(
          path: "/",
          pageBuilder: (context, state) => const SpotubePage(child: Genres()),
        ),
        GoRoute(
          path: "/search",
          name: "Search",
          pageBuilder: (context, state) => const SpotubePage(child: Search()),
        ),
        GoRoute(
          path: "/library",
          name: "Library",
          pageBuilder: (context, state) =>
              const SpotubePage(child: UserLibrary()),
        ),
        GoRoute(
          path: "/lyrics",
          name: "Lyrics",
          pageBuilder: (context, state) => const SpotubePage(child: Lyrics()),
        ),
        GoRoute(
          path: "/settings",
          pageBuilder: (context, state) => const SpotubePage(
            child: Settings(),
          ),
        ),
        GoRoute(
          path: "/album/:id",
          pageBuilder: (context, state) {
            assert(state.extra is AlbumSimple);
            return SpotubePage(child: AlbumView(state.extra as AlbumSimple));
          },
        ),
        GoRoute(
          path: "/artist/:id",
          pageBuilder: (context, state) {
            assert(state.params["id"] != null);
            return SpotubePage(child: ArtistProfile(state.params["id"]!));
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
      path: "/login",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => SpotubePage(
        child: kIsMobile ? const WebViewLogin() : const TokenLogin(),
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
