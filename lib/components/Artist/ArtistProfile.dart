import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Artist/ArtistAlbumView.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/helpers/readable-number.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class ArtistProfile extends StatefulWidget {
  final String artistId;
  const ArtistProfile(this.artistId, {Key? key}) : super(key: key);

  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  @override
  Widget build(BuildContext context) {
    SpotifyApi spotify = context.watch<SpotifyDI>().spotifyApi;
    return Scaffold(
      appBar: const PageWindowTitleBar(
        leading: BackButton(),
      ),
      body: FutureBuilder<Artist>(
        future: spotify.artists.get(widget.artistId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 50),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.18,
                      backgroundImage: CachedNetworkImageProvider(
                        snapshot.data!.images!.first.url!,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(snapshot.data!.type!.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: Colors.white)),
                            ),
                            Text(
                              snapshot.data!.name!,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Text(
                              "${toReadableNumber(snapshot.data!.followers!.total!.toDouble())} followers",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                // TODO: Implement check if user follows this artist
                                // LIMITATION: spotify-dart lib
                                FutureBuilder(
                                    future: Future.value(true),
                                    builder: (context, snapshot) {
                                      return OutlinedButton(
                                        onPressed: () async {
                                          // TODO: make `follow/unfollow` artists button work
                                          // LIMITATION: spotify-dart lib
                                        },
                                        child: Text(snapshot.data == true
                                            ? "Following"
                                            : "Follow"),
                                      );
                                    }),
                                IconButton(
                                  icon: const Icon(Icons.share_rounded),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                          text: snapshot
                                              .data?.externalUrls?.spotify),
                                    ).then((val) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          width: 300,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            "Artist URL copied to clipboard",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                FutureBuilder<Iterable<Track>>(
                  future:
                      spotify.artists.getTopTracks(snapshot.data!.id!, "US"),
                  builder: (context, trackSnapshot) {
                    if (!trackSnapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    Playback playback = context.watch<Playback>();
                    var isPlaylistPlaying =
                        playback.currentPlaylist?.id == snapshot.data?.id;
                    playPlaylist(List<Track> tracks, {Track? currentTrack}) {
                      currentTrack ??= tracks.first;
                      if (!isPlaylistPlaying) {
                        playback.setCurrentPlaylist = CurrentPlaylist(
                          tracks: tracks,
                          id: snapshot.data!.id!,
                          name: "${snapshot.data!.name!} To Tracks",
                          thumbnail: snapshot.data!.images!.first.url!,
                        );
                        playback.setCurrentTrack = currentTrack;
                      } else if (isPlaylistPlaying &&
                          currentTrack.id != null &&
                          currentTrack.id != playback.currentTrack?.id) {
                        playback.setCurrentTrack = currentTrack;
                      }
                    }

                    return Column(children: [
                      Row(
                        children: [
                          Text(
                            "Top Tracks",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          IconButton(
                            icon: Icon(isPlaylistPlaying
                                ? Icons.stop_circle_rounded
                                : Icons.play_circle_filled_rounded),
                            color: Theme.of(context).primaryColor,
                            onPressed: trackSnapshot.hasData
                                ? () =>
                                    playPlaylist(trackSnapshot.data!.toList())
                                : null,
                          )
                        ],
                      ),
                      ...trackSnapshot.data?.map((track) {
                            String duration =
                                "${track.duration?.inMinutes.remainder(60)}:${zeroPadNumStr(track.duration?.inSeconds.remainder(60) ?? 0)}";
                            return Row(
                              children: [
                                if (track.album != null &&
                                    track.album!.images!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) {
                                          return Container(
                                            height: 40,
                                            width: 40,
                                            color: Colors.green[300],
                                          );
                                        },
                                        imageUrl:
                                            track.album!.images!.last.url!,
                                        maxHeightDiskCache: 40,
                                        maxWidthDiskCache: 40,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        track.name ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      artistsToClickableArtists(
                                          track.artists ?? []),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      LinkText(
                                        track.album!.name!,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AlbumView(track.album!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(duration)
                              ],
                            );
                          }).toList() ??
                          [],
                    ]);
                  },
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Albums",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    TextButton(
                      child: const Text("See All"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ArtistAlbumView(
                            widget.artistId,
                            snapshot.data?.name ?? "KRTX",
                          ),
                        ));
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Album>>(
                  future: spotify.artists
                      .albums(snapshot.data!.id!)
                      .getPage(5, 0)
                      .then((al) => al.items?.toList() ?? []),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    return Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: snapshot.data
                                ?.map((album) => AlbumCard(album))
                                .toList() ??
                            [],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Fans also likes",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                FutureBuilder<Iterable<Artist>>(
                  future: spotify.artists.getRelatedArtists(widget.artistId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    return Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: snapshot.data
                                ?.map((artist) => ArtistCard(artist))
                                .toList() ??
                            [],
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
