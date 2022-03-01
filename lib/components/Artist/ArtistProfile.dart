import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Artist/ArtistAlbumView.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/readable-number.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class ArtistProfile extends HookConsumerWidget {
  final String artistId;
  const ArtistProfile(this.artistId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    SpotifyApi spotify = ref.watch(spotifyProvider);
    final scrollController = useScrollController();
    final parentScrollController = useScrollController();
    final textTheme = Theme.of(context).textTheme;
    final chipTextVariant = useBreakpointValue(
      sm: textTheme.bodySmall,
      md: textTheme.bodyMedium,
      lg: textTheme.headline6,
      xl: textTheme.headline6,
      xxl: textTheme.headline6,
    );

    final avatarWidth = useBreakpointValue(
      sm: MediaQuery.of(context).size.width * 0.50,
      md: MediaQuery.of(context).size.width * 0.40,
      lg: MediaQuery.of(context).size.width * 0.18,
      xl: MediaQuery.of(context).size.width * 0.18,
      xxl: MediaQuery.of(context).size.width * 0.18,
    );

    final breakpoint = useBreakpoints();

    return Scaffold(
      appBar: const PageWindowTitleBar(
        leading: BackButton(),
      ),
      body: FutureBuilder<Artist>(
        future: spotify.artists.get(artistId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return SingleChildScrollView(
            controller: parentScrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    const SizedBox(width: 50),
                    CircleAvatar(
                      radius: avatarWidth,
                      backgroundImage: CachedNetworkImageProvider(
                        imageToUrlString(snapshot.data!.images),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(snapshot.data!.type!.toUpperCase(),
                                style: chipTextVariant?.copyWith(
                                    color: Colors.white)),
                          ),
                          Text(
                            snapshot.data!.name!,
                            style: breakpoint.isSm
                                ? textTheme.headline4
                                : textTheme.headline2,
                          ),
                          Text(
                            "${toReadableNumber(snapshot.data!.followers!.total!.toDouble())} followers",
                            style: breakpoint.isSm
                                ? textTheme.bodyText1
                                : textTheme.headline5,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
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
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                    Playback playback = ref.watch(playbackProvider);
                    var isPlaylistPlaying =
                        playback.currentPlaylist?.id == snapshot.data?.id;
                    playPlaylist(List<Track> tracks, {Track? currentTrack}) {
                      currentTrack ??= tracks.first;
                      if (!isPlaylistPlaying) {
                        playback.setCurrentPlaylist = CurrentPlaylist(
                          tracks: tracks,
                          id: snapshot.data!.id!,
                          name: "${snapshot.data!.name!} To Tracks",
                          thumbnail: imageToUrlString(snapshot.data?.images),
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: Icon(isPlaylistPlaying
                                  ? Icons.stop_rounded
                                  : Icons.play_arrow_rounded),
                              color: Colors.white,
                              onPressed: trackSnapshot.hasData
                                  ? () =>
                                      playPlaylist(trackSnapshot.data!.toList())
                                  : null,
                            ),
                          )
                        ],
                      ),
                      ...trackSnapshot.data
                              ?.toList()
                              .asMap()
                              .entries
                              .map((track) {
                            String duration =
                                "${track.value.duration?.inMinutes.remainder(60)}:${zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                            String? thumbnailUrl = imageToUrlString(
                                track.value.album?.images,
                                index:
                                    (track.value.album?.images?.length ?? 1) -
                                        1);
                            return TrackTile(
                              playback,
                              duration: duration,
                              track: track,
                              thumbnailUrl: thumbnailUrl,
                              onTrackPlayButtonPressed: (currentTrack) =>
                                  playPlaylist(
                                trackSnapshot.data!.toList(),
                                currentTrack: track.value,
                              ),
                            );
                          }) ??
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
                        Navigator.of(context).push(SpotubePageRoute(
                          child: ArtistAlbumView(
                            artistId,
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
                    return Scrollbar(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: snapshot.data
                                  ?.map((album) => AlbumCard(album))
                                  .toList() ??
                              [],
                        ),
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
                  future: spotify.artists.getRelatedArtists(artistId),
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
