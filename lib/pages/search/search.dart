import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/shared/dialogs/prompt_dialog.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:collection/collection.dart';

final searchTermStateProvider = StateProvider<String>((ref) => "");

class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    ref.watch(AuthenticationNotifier.provider);
    final authenticationNotifier =
        ref.watch(AuthenticationNotifier.provider.notifier);
    final albumController = useScrollController();
    final playlistController = useScrollController();
    final artistController = useScrollController();
    final mediaQuery = MediaQuery.of(context);

    final searchTerm = ref.watch(searchTermStateProvider);

    final searchTrack =
        useQueries.search.query(ref, searchTerm, SearchType.track);
    final searchAlbum =
        useQueries.search.query(ref, searchTerm, SearchType.album);
    final searchPlaylist =
        useQueries.search.query(ref, searchTerm, SearchType.playlist);
    final searchArtist =
        useQueries.search.query(ref, searchTerm, SearchType.artist);

    Future<void> onSearch() async {
      await Future.wait([
        searchTrack.reset(),
        searchAlbum.reset(),
        searchPlaylist.reset(),
        searchArtist.reset(),
      ]).then((_) {
        return Future.wait([
          searchTrack.refreshAll(),
          searchAlbum.refreshAll(),
          searchPlaylist.refreshAll(),
          searchArtist.refreshAll(),
        ]);
      });
    }

    final queries = [searchTrack, searchAlbum, searchPlaylist, searchArtist];
    final isFetching = queries.every(
          (s) => s.isLoadingPage || s.isRefreshingPage || !s.hasPageData,
        ) &&
        searchTerm.isNotEmpty;

    final resultWidget = HookBuilder(
      builder: (context) {
        final playlist = ref.watch(ProxyPlaylistNotifier.provider);
        final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
        List<AlbumSimple> albums = [];
        List<Artist> artists = [];
        List<Track> tracks = [];
        List<PlaylistSimple> playlists = [];
        final pages = [
          ...searchTrack.pages,
          ...searchAlbum.pages,
          ...searchPlaylist.pages,
          ...searchArtist.pages,
        ].expand<Page>((page) => page).toList();
        for (MapEntry<int, Page> page in pages.asMap().entries) {
          for (var item in page.value.items ?? []) {
            if (item is AlbumSimple) {
              albums.add(item);
            } else if (item is PlaylistSimple) {
              playlists.add(item);
            } else if (item is Artist) {
              artists.add(item);
            } else if (item is Track) {
              tracks.add(item);
            }
          }
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tracks.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        context.l10n.songs,
                        style: theme.textTheme.titleLarge!,
                      ),
                    ),
                  if (searchTrack.isLoadingPage)
                    const CircularProgressIndicator()
                  else if (searchTrack.hasPageError)
                    Text(
                      searchTrack.errors.lastOrNull?.toString() ?? "",
                    )
                  else
                    ...tracks.mapIndexed((i, track) {
                      return TrackTile(
                        index: i,
                        track: track,
                        onTap: () async {
                          final isTrackPlaying =
                              playlist.activeTrack?.id == track.id;
                          if (!isTrackPlaying && context.mounted) {
                            final shouldPlay = (playlist.tracks.length) > 20
                                ? await showPromptDialog(
                                    context: context,
                                    title: context.l10n.playing_track(
                                      track.name!,
                                    ),
                                    message: context.l10n.queue_clear_alert(
                                      playlist.tracks.length,
                                    ),
                                  )
                                : true;

                            if (shouldPlay) {
                              await playlistNotifier.load(
                                [track],
                                autoPlay: true,
                              );
                            }
                          }
                        },
                      );
                    }),
                  if (searchTrack.hasNextPage && tracks.isNotEmpty)
                    Center(
                      child: TextButton(
                        onPressed: searchTrack.isRefreshingPage
                            ? null
                            : () => searchTrack.fetchNext(),
                        child: searchTrack.isRefreshingPage
                            ? const CircularProgressIndicator()
                            : Text(context.l10n.load_more),
                      ),
                    ),
                  if (playlists.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        context.l10n.playlists,
                        style: theme.textTheme.titleLarge!,
                      ),
                    ),
                  const SizedBox(height: 10),
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: Scrollbar(
                      scrollbarOrientation: mediaQuery.lgAndUp
                          ? ScrollbarOrientation.bottom
                          : ScrollbarOrientation.top,
                      controller: playlistController,
                      child: Waypoint(
                        onTouchEdge: () {
                          searchPlaylist.fetchNext();
                        },
                        controller: playlistController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: playlistController,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              ...playlists.mapIndexed(
                                (i, playlist) {
                                  if (i == playlists.length - 1 &&
                                      searchPlaylist.hasNextPage) {
                                    return const ShimmerPlaybuttonCard(
                                        count: 1);
                                  }
                                  return PlaylistCard(playlist);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (searchPlaylist.isLoadingPage)
                    const CircularProgressIndicator(),
                  if (searchPlaylist.hasPageError)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        searchPlaylist.errors.lastOrNull?.toString() ?? "",
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (artists.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        context.l10n.artists,
                        style: theme.textTheme.titleLarge!,
                      ),
                    ),
                  const SizedBox(height: 10),
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: Scrollbar(
                      controller: artistController,
                      child: Waypoint(
                        controller: artistController,
                        onTouchEdge: () {
                          searchArtist.fetchNext();
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: artistController,
                          child: Row(
                            children: [
                              ...artists.mapIndexed(
                                (i, artist) {
                                  if (i == artists.length - 1 &&
                                      searchArtist.hasNextPage) {
                                    return const ShimmerPlaybuttonCard(
                                        count: 1);
                                  }
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: ArtistCard(artist),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (searchArtist.isLoadingPage)
                    const CircularProgressIndicator(),
                  if (searchArtist.hasPageError)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        searchArtist.errors.lastOrNull?.toString() ?? "",
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (albums.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        context.l10n.albums,
                        style: theme.textTheme.titleLarge!,
                      ),
                    ),
                  const SizedBox(height: 10),
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: Scrollbar(
                      controller: albumController,
                      child: Waypoint(
                        controller: albumController,
                        onTouchEdge: () {
                          searchAlbum.fetchNext();
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: albumController,
                          child: Row(
                            children: [
                              ...albums.mapIndexed((i, album) {
                                if (i == albums.length - 1 &&
                                    searchAlbum.hasNextPage) {
                                  return const ShimmerPlaybuttonCard(count: 1);
                                }
                                return AlbumCard(
                                  TypeConversionUtils.simpleAlbum_X_Album(
                                    album,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (searchAlbum.isLoadingPage)
                    const CircularProgressIndicator(),
                  if (searchAlbum.hasPageError)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        searchAlbum.errors.lastOrNull?.toString() ?? "",
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: kIsDesktop && !kIsMacOS ? const PageWindowTitleBar() : null,
        body: !authenticationNotifier.isLoggedIn
            ? const AnonymousFallback()
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    color: theme.scaffoldBackgroundColor,
                    child: TextField(
                      autofocus: queries.none((s) => s.hasPageData),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(SpotubeIcons.search),
                        hintText: "${context.l10n.search}...",
                      ),
                      onSubmitted: (value) async {
                        ref.read(searchTermStateProvider.notifier).state =
                            value;
                        // Fl-Query is too fast, so we need to delay the search
                        // to prevent spamming the API :)
                        Timer(const Duration(milliseconds: 50), () {
                          onSearch();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: searchTerm.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: mediaQuery.size.height * 0.2,
                                ),
                                Icon(
                                  SpotubeIcons.web,
                                  size: 120,
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.7),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  context.l10n.search_to_get_results,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.onBackground
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            )
                          : isFetching
                              ? Container(
                                  constraints: BoxConstraints(
                                    maxWidth: mediaQuery.lgAndUp
                                        ? mediaQuery.size.width * 0.5
                                        : mediaQuery.size.width,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        context.l10n.crunching_results,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: theme.colorScheme.onBackground
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const LinearProgressIndicator(),
                                    ],
                                  ),
                                )
                              : resultWidget,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
