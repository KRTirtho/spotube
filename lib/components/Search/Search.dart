import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerPlaybuttonCard.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/components/Shared/AnonymousFallback.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/components/Shared/Waypoint.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

final searchTermStateProvider = StateProvider<String>((ref) => "");

class Search extends HookConsumerWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final Auth auth = ref.watch(authProvider);
    final albumController = useScrollController();
    final playlistController = useScrollController();
    final artistController = useScrollController();
    final breakpoint = useBreakpoints();

    final getVariables = useCallback(
      () => Tuple2(
        ref.read(searchTermStateProvider),
        ref.read(spotifyProvider),
      ),
      [],
    );

    final searchTrack = useInfiniteQuery(
        job: searchQueryJob(SearchType.track.key),
        externalData: getVariables());
    final searchAlbum = useInfiniteQuery(
        job: searchQueryJob(SearchType.album.key),
        externalData: getVariables());
    final searchPlaylist = useInfiniteQuery(
        job: searchQueryJob(SearchType.playlist.key),
        externalData: getVariables());
    final searchArtist = useInfiniteQuery(
        job: searchQueryJob(SearchType.artist.key),
        externalData: getVariables());

    if (auth.isAnonymous) {
      return const AnonymousFallback();
    }

    void onSearch() {
      for (final query in [
        searchTrack,
        searchAlbum,
        searchPlaylist,
        searchArtist,
      ]) {
        query.enabled = false;
        query.fetched = true;
        query.setExternalData(getVariables());
        query.refetch();
      }
    }

    return SafeArea(
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              color: Theme.of(context).backgroundColor,
              child: PlatformTextField(
                onChanged: (value) {
                  ref.read(searchTermStateProvider.notifier).state = value;
                },
                suffix: PlatformFilledButton(
                  onPressed: onSearch,
                  child: const Icon(Icons.search_rounded),
                ),
                placeholder: "Search...",
                onSubmitted: (value) {
                  onSearch();
                },
              ),
            ),
            HookBuilder(
              builder: (context) {
                Playback playback = ref.watch(playbackProvider);
                List<AlbumSimple> albums = [];
                List<Artist> artists = [];
                List<Track> tracks = [];
                List<PlaylistSimple> playlists = [];
                final pages = [
                  ...searchTrack.pages,
                  ...searchAlbum.pages,
                  ...searchPlaylist.pages,
                  ...searchArtist.pages,
                ].expand<Page>((page) => page ?? []).toList();
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
                            Text(
                              "Songs",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          if (searchTrack.isLoading &&
                              !searchTrack.isFetchingNextPage)
                            const CircularProgressIndicator()
                          else if (searchTrack.hasError)
                            Text(
                                searchTrack.error?[searchTrack.pageParams.last])
                          else
                            ...tracks.asMap().entries.map((track) {
                              String duration =
                                  "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                              return TrackTile(
                                playback,
                                track: track,
                                duration: duration,
                                isActive: playback.track?.id == track.value.id,
                                onTrackPlayButtonPressed: (currentTrack) async {
                                  var isPlaylistPlaying =
                                      playback.playlist?.id != null &&
                                          playback.playlist?.id ==
                                              currentTrack.id;
                                  if (!isPlaylistPlaying) {
                                    playback.playPlaylist(
                                      CurrentPlaylist(
                                        tracks: [currentTrack],
                                        id: currentTrack.id!,
                                        name: currentTrack.name!,
                                        thumbnail: TypeConversionUtils
                                            .image_X_UrlString(
                                          currentTrack.album?.images,
                                          placeholder:
                                              ImagePlaceholder.albumArt,
                                        ),
                                      ),
                                    );
                                  } else if (isPlaylistPlaying &&
                                      currentTrack.id != null &&
                                      currentTrack.id != playback.track?.id) {
                                    playback.play(currentTrack);
                                  }
                                },
                              );
                            }),
                          if (searchTrack.hasNextPage && tracks.isNotEmpty)
                            Center(
                              child: PlatformTextButton(
                                onPressed: searchTrack.isFetchingNextPage
                                    ? null
                                    : () => searchTrack.fetchNextPage(),
                                child: searchTrack.isFetchingNextPage
                                    ? const CircularProgressIndicator()
                                    : const Text("Load more"),
                              ),
                            ),
                          if (playlists.isNotEmpty)
                            Text(
                              "Playlists",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          const SizedBox(height: 10),
                          if (searchPlaylist.isLoading &&
                              !searchPlaylist.isFetchingNextPage)
                            const CircularProgressIndicator()
                          else if (searchPlaylist.hasError)
                            Text(searchPlaylist
                                .error?[searchPlaylist.pageParams.last])
                          else
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
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: playlistController,
                                  child: Row(
                                    children: [
                                      ...playlists.mapIndexed(
                                        (i, playlist) {
                                          if (i == playlists.length - 1 &&
                                              searchPlaylist.hasNextPage) {
                                            return Waypoint(
                                              onEnter: () {
                                                searchPlaylist.fetchNextPage();
                                              },
                                              child:
                                                  const ShimmerPlaybuttonCard(
                                                      count: 1),
                                            );
                                          }
                                          return PlaylistCard(playlist);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          if (artists.isNotEmpty)
                            Text(
                              "Artists",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          const SizedBox(height: 10),
                          if (searchArtist.isLoading &&
                              !searchArtist.isFetchingNextPage)
                            const CircularProgressIndicator()
                          else if (searchArtist.hasError)
                            Text(searchArtist
                                .error?[searchArtist.pageParams.last])
                          else
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
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: artistController,
                                  child: Row(
                                    children: [
                                      ...artists.mapIndexed(
                                        (i, artist) {
                                          if (i == artists.length - 1 &&
                                              searchArtist.hasNextPage) {
                                            return Waypoint(
                                              onEnter: () {
                                                searchArtist.fetchNextPage();
                                              },
                                              child:
                                                  const ShimmerPlaybuttonCard(
                                                      count: 1),
                                            );
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
                          const SizedBox(height: 20),
                          if (albums.isNotEmpty)
                            Text(
                              "Albums",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          const SizedBox(height: 10),
                          if (searchAlbum.isLoading &&
                              !searchAlbum.isFetchingNextPage)
                            const CircularProgressIndicator()
                          else if (searchAlbum.hasError)
                            Text(
                                searchAlbum.error?[searchAlbum.pageParams.last])
                          else
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
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: albumController,
                                  child: Row(
                                    children: [
                                      ...albums.mapIndexed((i, album) {
                                        if (i == albums.length - 1 &&
                                            searchAlbum.hasNextPage) {
                                          return Waypoint(
                                            onEnter: () {
                                              searchAlbum.fetchNextPage();
                                            },
                                            child: const ShimmerPlaybuttonCard(
                                                count: 1),
                                          );
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
