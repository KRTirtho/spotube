import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
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
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:collection/collection.dart';

final searchTermStateProvider = StateProvider<String>((ref) => "");

class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(AuthenticationNotifier.provider);
    final authenticationNotifier =
        ref.watch(AuthenticationNotifier.provider.notifier);
    final albumController = useScrollController();
    final playlistController = useScrollController();
    final artistController = useScrollController();
    final breakpoint = useBreakpoints();

    final searchTerm = ref.watch(searchTermStateProvider);

    final searchTrack =
        useQueries.search.query(ref, searchTerm, SearchType.track);
    final searchAlbum =
        useQueries.search.query(ref, searchTerm, SearchType.album);
    final searchPlaylist =
        useQueries.search.query(ref, searchTerm, SearchType.playlist);
    final searchArtist =
        useQueries.search.query(ref, searchTerm, SearchType.artist);

    void onSearch() {
      for (final query in [
        searchTrack,
        searchAlbum,
        searchPlaylist,
        searchArtist,
      ]) {
        query.refreshAll();
      }
    }

    return SafeArea(
      child: PlatformScaffold(
        appBar: kIsDesktop && !kIsMacOS ? PageWindowTitleBar() : null,
        body: !authenticationNotifier.isLoggedIn
            ? const AnonymousFallback()
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    color: PlatformTheme.of(context).scaffoldBackgroundColor,
                    child: PlatformTextField(
                      prefixIcon: SpotubeIcons.search,
                      prefixIconColor: PlatformProperty.only(
                        ios:
                            PlatformTheme.of(context).textTheme?.caption?.color,
                        other: null,
                      ).resolve(platform!),
                      placeholder: "Search...",
                      onSubmitted: (value) {
                        ref.read(searchTermStateProvider.notifier).state =
                            value;
                        onSearch();
                      },
                    ),
                  ),
                  HookBuilder(
                    builder: (context) {
                      final playlist =
                          ref.watch(PlaylistQueueNotifier.provider);
                      final playlistNotifier =
                          ref.watch(PlaylistQueueNotifier.notifier);
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
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tracks.isNotEmpty)
                                  PlatformText.headline("Songs"),
                                if (searchTrack.isLoadingPage)
                                  const PlatformCircularProgressIndicator()
                                else if (searchTrack.hasPageError)
                                  PlatformText(searchTrack.errors.lastOrNull
                                          ?.toString() ??
                                      "")
                                else
                                  ...tracks.asMap().entries.map((track) {
                                    String duration =
                                        "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                                    return TrackTile(
                                      playlist,
                                      track: track,
                                      duration: duration,
                                      isActive: playlist?.activeTrack.id ==
                                          track.value.id,
                                      onTrackPlayButtonPressed:
                                          (currentTrack) async {
                                        final isTrackPlaying =
                                            playlist?.activeTrack.id ==
                                                currentTrack.id;
                                        if (!isTrackPlaying &&
                                            context.mounted) {
                                          final shouldPlay =
                                              (playlist?.tracks.length ?? 0) >
                                                      20
                                                  ? await showPromptDialog(
                                                      context: context,
                                                      title:
                                                          "Playing ${currentTrack.name}",
                                                      message:
                                                          "This will clear the current queue. "
                                                          "${playlist?.tracks.length ?? 0} tracks will be removed\n"
                                                          "Do you want to continue?",
                                                    )
                                                  : true;

                                          if (shouldPlay) {
                                            await playlistNotifier
                                                .loadAndPlay([currentTrack]);
                                          }
                                        }
                                      },
                                    );
                                  }),
                                if (searchTrack.hasNextPage &&
                                    tracks.isNotEmpty)
                                  Center(
                                    child: PlatformTextButton(
                                      onPressed: searchTrack.isRefreshingPage
                                          ? null
                                          : () => searchTrack.fetchNext(),
                                      child: searchTrack.isRefreshingPage
                                          ? const PlatformCircularProgressIndicator()
                                          : const PlatformText("Load more"),
                                    ),
                                  ),
                                if (playlists.isNotEmpty)
                                  PlatformText.headline("Playlists"),
                                const SizedBox(height: 10),
                                ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                    },
                                  ),
                                  child: Scrollbar(
                                    scrollbarOrientation:
                                        breakpoint > Breakpoints.md
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
                                        child: Row(
                                          children: [
                                            ...playlists.mapIndexed(
                                              (i, playlist) {
                                                if (i == playlists.length - 1 &&
                                                    searchPlaylist
                                                        .hasNextPage) {
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
                                  const PlatformCircularProgressIndicator(),
                                if (searchPlaylist.hasPageError)
                                  PlatformText(
                                    searchPlaylist.errors.lastOrNull
                                            ?.toString() ??
                                        "",
                                  ),
                                const SizedBox(height: 20),
                                if (artists.isNotEmpty)
                                  PlatformText.headline("Artists"),
                                const SizedBox(height: 10),
                                ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
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
                                                  margin: const EdgeInsets
                                                          .symmetric(
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
                                  const PlatformCircularProgressIndicator(),
                                if (searchArtist.hasPageError)
                                  PlatformText(
                                    searchArtist.errors.lastOrNull
                                            ?.toString() ??
                                        "",
                                  ),
                                const SizedBox(height: 20),
                                if (albums.isNotEmpty)
                                  PlatformText.subheading("Albums"),
                                const SizedBox(height: 10),
                                ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
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
                                                return const ShimmerPlaybuttonCard(
                                                    count: 1);
                                              }
                                              return AlbumCard(
                                                TypeConversionUtils
                                                    .simpleAlbum_X_Album(
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
                                  const PlatformCircularProgressIndicator(),
                                if (searchAlbum.hasPageError)
                                  PlatformText(
                                    searchAlbum.errors.lastOrNull?.toString() ??
                                        "",
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
      ),
    );
  }
}
