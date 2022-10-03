import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Artist/ArtistProfile.dart';
import 'package:spotube/components/Home/Home.dart';
import 'package:spotube/components/Login/LoginTutorial.dart';
import 'package:spotube/components/Login/TokenLogin.dart';
import 'package:spotube/components/Player/PlayerView.dart';
import 'package:spotube/components/Playlist/PlaylistView.dart';
import 'package:spotube/components/Settings/Settings.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/components/Login/WebViewLogin.dart';

GoRouter createGoRouter() => GoRouter(
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => Home(),
        ),
        GoRoute(
          path: "/login",
          pageBuilder: (context, state) => SpotubePage(
            child: kIsMobile ? const WebViewLogin() : const TokenLogin(),
          ),
        ),
        GoRoute(
          path: "/login-tutorial",
          pageBuilder: (context, state) => const SpotubePage(
            child: LoginTutorial(),
          ),
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
        GoRoute(
          path: "/player",
          pageBuilder: (context, state) {
            return const SpotubePage(
              child: PlayerView(),
            );
          },
        ),
      ],
    );
