import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/components/Shared/AnonymousFallback.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

final searchTermStateProvider = StateProvider<String>((ref) => "");

class Search extends HookConsumerWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final Auth auth = ref.watch(authProvider);
    final searchTerm = ref.watch(searchTermStateProvider);
    final controller =
        useTextEditingController(text: ref.read(searchTermStateProvider));
    final albumController = useScrollController();
    final playlistController = useScrollController();
    final artistController = useScrollController();
    final breakpoint = useBreakpoints();

    if (auth.isAnonymous) {
      return const Expanded(child: AnonymousFallback());
    }
    final searchSnapshot = ref.watch(searchQuery(searchTerm));

    return Expanded(
      child: SafeArea(
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
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    isDense: true,
                    suffix: ElevatedButton(
                      child: const Icon(Icons.search_rounded),
                      onPressed: () {
                        ref.read(searchTermStateProvider.notifier).state =
                            controller.value.text;
                      },
                    ),
                    hintStyle: const TextStyle(height: 2),
                    hintText: "Search...",
                  ),
                  onSubmitted: (value) {
                    ref.read(searchTermStateProvider.notifier).state =
                        controller.value.text;
                  },
                ),
              ),
              searchSnapshot.when(
                data: (data) {
                  Playback playback = ref.watch(playbackProvider);
                  List<AlbumSimple> albums = [];
                  List<Artist> artists = [];
                  List<Track> tracks = [];
                  List<PlaylistSimple> playlists = [];
                  for (MapEntry<int, Page> page in data.asMap().entries) {
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
                            vertical: 8, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (tracks.isNotEmpty)
                              Text(
                                "Songs",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ...tracks.asMap().entries.map((track) {
                              String duration =
                                  "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                              return TrackTile(
                                playback,
                                track: track,
                                duration: duration,
                                thumbnailUrl:
                                    TypeConversionUtils.image_X_UrlString(
                                  track.value.album?.images,
                                  placeholder: ImagePlaceholder.albumArt,
                                ),
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
                            if (albums.isNotEmpty)
                              Text(
                                "Albums",
                                style: Theme.of(context).textTheme.headline5,
                              ),
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
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: albumController,
                                  child: Row(
                                    children: albums.map((album) {
                                      return AlbumCard(
                                        TypeConversionUtils.simpleAlbum_X_Album(
                                          album,
                                        ),
                                      );
                                    }).toList(),
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
                                    children: artists
                                        .map(
                                          (artist) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: ArtistCard(artist),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (playlists.isNotEmpty)
                              Text(
                                "Playlists",
                                style: Theme.of(context).textTheme.headline5,
                              ),
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
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: playlistController,
                                  child: Row(
                                    children: playlists
                                        .map(
                                          (playlist) => PlaylistCard(playlist),
                                        )
                                        .toList(),
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
                error: (error, __) => Text("Error $error"),
                loading: () => const CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
