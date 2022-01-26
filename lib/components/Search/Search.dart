import 'package:flutter/material.dart' hide Page;
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/simple-album-to-album.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;

  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SpotifyApi spotify = context.watch<SpotifyDI>().spotifyApi;

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Search..."),
                    controller: _controller,
                    onSubmitted: (value) {
                      setState(() {
                        searchTerm = _controller.value.text;
                      });
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
                    setState(() {
                      searchTerm = _controller.value.text;
                    });
                  },
                ),
              ],
            ),
          ),
          FutureBuilder<List<Page>>(
            future: searchTerm.isNotEmpty
                ? spotify.search.get(searchTerm).first(10)
                : null,
            builder: (context, snapshot) {
              if (!snapshot.hasData && searchTerm.isNotEmpty) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (!snapshot.hasData && searchTerm.isEmpty) {
                return Container();
              }
              Playback playback = context.watch<Playback>();
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                          return TracksTableView.buildTrackTile(
                            context,
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
                            },
                          );
                        }),
                        if (albums.isNotEmpty)
                          Text(
                            "Albums",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        const SizedBox(height: 10),
                        Center(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: albums.map((album) {
                              return AlbumCard(simpleAlbumToAlbum(album));
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (artists.isNotEmpty)
                          Text(
                            "Artists",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        const SizedBox(height: 10),
                        Center(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: artists.map((artist) {
                              return ArtistCard(artist);
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (playlists.isNotEmpty)
                          Text(
                            "Playlists",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        const SizedBox(height: 10),
                        Center(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: playlists.map((playlist) {
                              return PlaylistCard(playlist);
                            }).toList(),
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
    );
  }
}
