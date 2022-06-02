import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/components/Shared/AnonymousFallback.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/simple-album-to-album.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class Search extends HookConsumerWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final SpotifyApi spotify = ref.watch(spotifyProvider);
    final Auth auth = ref.watch(authProvider);
    final controller = useTextEditingController();
    final searchTerm = useState("");
    final albumController = useScrollController();
    final playlistController = useScrollController();
    final artistController = useScrollController();
    final breakpoint = useBreakpoints();

    if (auth.isAnonymous) {
      return const Expanded(child: AnonymousFallback());
    }

    return Expanded(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(hintText: "Search..."),
                      controller: controller,
                      onSubmitted: (value) {
                        searchTerm.value = controller.value.text;
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  MaterialButton(
                    elevation: 3,
                    splashColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 21),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: const Icon(Icons.search_rounded),
                    onPressed: () {
                      searchTerm.value = controller.value.text;
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Page>>(
              future: searchTerm.value.isNotEmpty
                  ? spotify.search.get(searchTerm.value).first(10)
                  : null,
              builder: (context, snapshot) {
                if (!snapshot.hasData && searchTerm.value.isNotEmpty) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (!snapshot.hasData && searchTerm.value.isEmpty) {
                  return Container();
                }
                Playback playback = ref.watch(playbackProvider);
                List<AlbumSimple> albums = [];
                List<Artist> artists = [];
                List<Track> tracks = [];
                List<PlaylistSimple> playlists = [];
                for (MapEntry<int, Page> page
                    in snapshot.data?.asMap().entries ?? []) {
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
                                "${track.value.duration?.inMinutes.remainder(60)}:${zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                            return TrackTile(
                              playback,
                              track: track,
                              duration: duration,
                              thumbnailUrl:
                                  imageToUrlString(track.value.album?.images),
                              onTrackPlayButtonPressed: (currentTrack) async {
                                var isPlaylistPlaying =
                                    playback.currentPlaylist?.id != null &&
                                        playback.currentPlaylist?.id ==
                                            currentTrack.id;
                                if (!isPlaylistPlaying) {
                                  playback.setCurrentPlaylist = CurrentPlaylist(
                                    tracks: [currentTrack],
                                    id: currentTrack.id!,
                                    name: currentTrack.name!,
                                    thumbnail: imageToUrlString(
                                        currentTrack.album?.images),
                                  );
                                  playback.setCurrentTrack = currentTrack;
                                } else if (isPlaylistPlaying &&
                                    currentTrack.id != null &&
                                    currentTrack.id !=
                                        playback.currentTrack?.id) {
                                  playback.setCurrentTrack = currentTrack;
                                }
                                await playback.startPlaying();
                              },
                            );
                          }),
                          if (albums.isNotEmpty)
                            Text(
                              "Albums",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          const SizedBox(height: 10),
                          Scrollbar(
                            controller: albumController,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: albumController,
                              child: Row(
                                children: albums.map((album) {
                                  return AlbumCard(simpleAlbumToAlbum(album));
                                }).toList(),
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
                          Scrollbar(
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
                          const SizedBox(height: 20),
                          if (playlists.isNotEmpty)
                            Text(
                              "Playlists",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          const SizedBox(height: 10),
                          Scrollbar(
                            scrollbarOrientation: breakpoint > Breakpoints.md
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
