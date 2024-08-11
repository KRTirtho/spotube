import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart' hide Search;
import 'package:spotube/models/spotify/recommendation_seeds.dart';
import 'package:spotube/pages/album/album.dart';
import 'package:spotube/pages/connect/connect.dart';
import 'package:spotube/pages/connect/control/control.dart';
import 'package:spotube/pages/getting_started/getting_started.dart';
import 'package:spotube/pages/home/feed/feed_section.dart';
import 'package:spotube/pages/home/genres/genre_playlists.dart';
import 'package:spotube/pages/home/genres/genres.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/pages/lastfm_login/lastfm_login.dart';
import 'package:spotube/pages/library/local_folder.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate_result.dart';
import 'package:spotube/pages/lyrics/mini_lyrics.dart';
import 'package:spotube/pages/playlist/liked_playlist.dart';
import 'package:spotube/pages/playlist/playlist.dart';
import 'package:spotube/pages/profile/profile.dart';
import 'package:spotube/pages/search/search.dart';
import 'package:spotube/pages/settings/blacklist.dart';
import 'package:spotube/pages/settings/about.dart';
import 'package:spotube/pages/settings/logs.dart';
import 'package:spotube/pages/stats/albums/albums.dart';
import 'package:spotube/pages/stats/artists/artists.dart';
import 'package:spotube/pages/stats/fees/fees.dart';
import 'package:spotube/pages/stats/minutes/minutes.dart';
import 'package:spotube/pages/stats/playlists/playlists.dart';
import 'package:spotube/pages/stats/stats.dart';
import 'package:spotube/pages/stats/streams/streams.dart';
import 'package:spotube/pages/track/track.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:spotube/components/spotube_page_route.dart';
import 'package:spotube/pages/artist/artist.dart';
import 'package:spotube/pages/library/library.dart';
import 'package:spotube/pages/lyrics/lyrics.dart';
import 'package:spotube/pages/root/root_app.dart';
import 'package:spotube/pages/settings/settings.dart';
import 'package:spotube/pages/mobile_login/mobile_login.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellRouteNavigatorKey = GlobalKey<NavigatorState>();
final routerProvider = Provider((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: shellRouteNavigatorKey,
        builder: (context, state, child) => RootApp(child: child),
        routes: [
          GoRoute(
            path: "/",
            name: HomePage.name,
            redirect: (context, state) async {
              final auth = await ref.read(authenticationProvider.future);

              if (auth == null && !KVStoreService.doneGettingStarted) {
                return "/getting-started";
              }

              return null;
            },
            pageBuilder: (context, state) =>
                const SpotubePage(child: HomePage()),
            routes: [
              GoRoute(
                path: "genres",
                name: GenrePage.name,
                pageBuilder: (context, state) =>
                    const SpotubePage(child: GenrePage()),
              ),
              GoRoute(
                path: "genre/:categoryId",
                name: GenrePlaylistsPage.name,
                pageBuilder: (context, state) => SpotubePage(
                  child: GenrePlaylistsPage(
                    category: state.extra as Category,
                  ),
                ),
              ),
              GoRoute(
                path: "feeds/:feedId",
                name: HomeFeedSectionPage.name,
                pageBuilder: (context, state) => SpotubePage(
                  child: HomeFeedSectionPage(
                    sectionUri: state.pathParameters["feedId"] as String,
                  ),
                ),
              )
            ],
          ),
          GoRoute(
            path: "/search",
            name: SearchPage.name,
            pageBuilder: (context, state) =>
                const SpotubePage(child: SearchPage()),
          ),
          GoRoute(
              path: "/library",
              name: LibraryPage.name,
              pageBuilder: (context, state) =>
                  const SpotubePage(child: LibraryPage()),
              routes: [
                GoRoute(
                  path: "generate",
                  name: PlaylistGeneratorPage.name,
                  pageBuilder: (context, state) =>
                      const SpotubePage(child: PlaylistGeneratorPage()),
                  routes: [
                    GoRoute(
                      path: "result",
                      name: PlaylistGenerateResultPage.name,
                      pageBuilder: (context, state) => SpotubePage(
                        child: PlaylistGenerateResultPage(
                          state: state.extra as GeneratePlaylistProviderInput,
                        ),
                      ),
                    )
                  ],
                ),
                GoRoute(
                  path: "local",
                  name: LocalLibraryPage.name,
                  pageBuilder: (context, state) {
                    assert(state.extra is String);
                    return SpotubePage(
                      child: LocalLibraryPage(state.extra as String,
                          isDownloads:
                              state.uri.queryParameters["downloads"] != null),
                    );
                  },
                ),
              ]),
          GoRoute(
            path: "/lyrics",
            name: LyricsPage.name,
            pageBuilder: (context, state) =>
                const SpotubePage(child: LyricsPage()),
          ),
          GoRoute(
            path: "/settings",
            name: SettingsPage.name,
            pageBuilder: (context, state) => const SpotubePage(
              child: SettingsPage(),
            ),
            routes: [
              GoRoute(
                path: "blacklist",
                name: BlackListPage.name,
                pageBuilder: (context, state) => SpotubeSlidePage(
                  child: const BlackListPage(),
                ),
              ),
              if (!kIsWeb)
                GoRoute(
                  path: "logs",
                  name: LogsPage.name,
                  pageBuilder: (context, state) => SpotubeSlidePage(
                    child: const LogsPage(),
                  ),
                ),
              GoRoute(
                path: "about",
                name: AboutSpotube.name,
                pageBuilder: (context, state) => SpotubeSlidePage(
                  child: const AboutSpotube(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: "/album/:id",
            name: AlbumPage.name,
            pageBuilder: (context, state) {
              assert(state.extra is AlbumSimple);
              return SpotubePage(
                child: AlbumPage(album: state.extra as AlbumSimple),
              );
            },
          ),
          GoRoute(
            path: "/artist/:id",
            name: ArtistPage.name,
            pageBuilder: (context, state) {
              assert(state.pathParameters["id"] != null);
              return SpotubePage(
                  child: ArtistPage(state.pathParameters["id"]!));
            },
          ),
          GoRoute(
            path: "/playlist/:id",
            name: PlaylistPage.name,
            pageBuilder: (context, state) {
              assert(state.extra is PlaylistSimple);
              return SpotubePage(
                child: state.pathParameters["id"] == "user-liked-tracks"
                    ? LikedPlaylistPage(playlist: state.extra as PlaylistSimple)
                    : PlaylistPage(playlist: state.extra as PlaylistSimple),
              );
            },
          ),
          GoRoute(
            path: "/track/:id",
            name: TrackPage.name,
            pageBuilder: (context, state) {
              final id = state.pathParameters["id"]!;
              return SpotubePage(
                child: TrackPage(trackId: id),
              );
            },
          ),
          GoRoute(
            path: "/connect",
            name: ConnectPage.name,
            pageBuilder: (context, state) => const SpotubePage(
              child: ConnectPage(),
            ),
            routes: [
              GoRoute(
                path: "control",
                name: ConnectControlPage.name,
                pageBuilder: (context, state) {
                  return const SpotubePage(
                    child: ConnectControlPage(),
                  );
                },
              )
            ],
          ),
          GoRoute(
            path: "/profile",
            name: ProfilePage.name,
            pageBuilder: (context, state) =>
                const SpotubePage(child: ProfilePage()),
          ),
          GoRoute(
            path: "/stats",
            name: StatsPage.name,
            pageBuilder: (context, state) => const SpotubePage(
              child: StatsPage(),
            ),
            routes: [
              GoRoute(
                path: "minutes",
                name: StatsMinutesPage.name,
                pageBuilder: (context, state) => const SpotubePage(
                  child: StatsMinutesPage(),
                ),
              ),
              GoRoute(
                path: "streams",
                name: StatsStreamsPage.name,
                pageBuilder: (context, state) => const SpotubePage(
                  child: StatsStreamsPage(),
                ),
              ),
              GoRoute(
                path: "fees",
                name: StatsStreamFeesPage.name,
                pageBuilder: (context, state) => const SpotubePage(
                  child: StatsStreamFeesPage(),
                ),
              ),
              GoRoute(
                path: "artists",
                name: StatsArtistsPage.name,
                pageBuilder: (context, state) => const SpotubePage(
                  child: StatsArtistsPage(),
                ),
              ),
              GoRoute(
                path: "albums",
                name: StatsAlbumsPage.name,
                pageBuilder: (context, state) => const SpotubePage(
                  child: StatsAlbumsPage(),
                ),
              ),
              GoRoute(
                path: "playlists",
                name: StatsPlaylistsPage.name,
                pageBuilder: (context, state) => const SpotubePage(
                  child: StatsPlaylistsPage(),
                ),
              ),
            ],
          )
        ],
      ),
      GoRoute(
        path: "/mini-player",
        name: MiniLyricsPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => SpotubePage(
          child: MiniLyricsPage(prevSize: state.extra as Size),
        ),
      ),
      GoRoute(
        path: "/getting-started",
        name: GettingStarting.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => const SpotubePage(
          child: GettingStarting(),
        ),
      ),
      GoRoute(
        path: "/login",
        name: WebViewLogin.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => const SpotubePage(
          child: WebViewLogin(),
        ),
      ),
      GoRoute(
        path: "/lastfm-login",
        name: LastFMLoginPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const SpotubePage(child: LastFMLoginPage()),
      ),
    ],
  );
});
