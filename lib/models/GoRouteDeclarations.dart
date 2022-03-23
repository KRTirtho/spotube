import 'package:go_router/go_router.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Artist/ArtistAlbumView.dart';
import 'package:spotube/components/Artist/ArtistProfile.dart';
import 'package:spotube/components/Home/Home.dart';
import 'package:spotube/components/Login.dart';
import 'package:spotube/components/Player/PlayerView.dart';
import 'package:spotube/components/Playlist/PlaylistView.dart';
import 'package:spotube/components/Settings.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';

GoRouter createGoRouter() => GoRouter(
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => Home(),
        ),
        GoRoute(
          path: "/login",
          pageBuilder: (context, state) => SpotubePage(
            child: Login(),
          ),
        ),
        GoRoute(
          path: "/settings",
          pageBuilder: (context, state) => SpotubePage(
            child: const Settings(),
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
          path: "/artist-album/:id",
          pageBuilder: (context, state) {
            assert(state.params["id"] != null);
            assert(state.extra is String);
            return SpotubePage(
              child: ArtistAlbumView(
                state.params["id"]!,
                state.extra as String,
              ),
            );
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
            return SpotubePage(
              child: const PlayerView(),
            );
          },
        )
      ],
    );
