import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/readable-number.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useForceUpdate.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class ArtistProfile extends HookConsumerWidget {
  final String artistId;
  final logger = getLogger(ArtistProfile);
  ArtistProfile(this.artistId, {Key? key}) : super(key: key);

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
    final update = useForceUpdate();

    final Playback playback = ref.watch(playbackProvider);

    final artistsSnapshot = ref.watch(artistProfileQuery(artistId));
    final isFollowingSnapshot =
        ref.watch(currentUserFollowsArtistQuery(artistId));
    final topTracksSnapshot = ref.watch(artistTopTracksQuery(artistId));
    final albums = ref.watch(artistAlbumsQuery(artistId));
    final relatedArtists = ref.watch(artistRelatedArtistsQuery(artistId));

    return SafeArea(
      child: Scaffold(
        appBar: const PageWindowTitleBar(
          leading: BackButton(),
        ),
        body: artistsSnapshot.when<Widget>(
            data: (data) {
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
                            imageToUrlString(data.images),
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
                                child: Text(data.type!.toUpperCase(),
                                    style: chipTextVariant?.copyWith(
                                        color: Colors.white)),
                              ),
                              Text(
                                data.name!,
                                style: breakpoint.isSm
                                    ? textTheme.headline4
                                    : textTheme.headline2,
                              ),
                              Text(
                                "${toReadableNumber(data.followers!.total!.toDouble())} followers",
                                style: breakpoint.isSm
                                    ? textTheme.bodyText1
                                    : textTheme.headline5,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isFollowingSnapshot.when(
                                      data: (isFollowing) {
                                        return OutlinedButton(
                                          onPressed: () async {
                                            try {
                                              isFollowing
                                                  ? await spotify.me.unfollow(
                                                      FollowingType.artist,
                                                      [artistId],
                                                    )
                                                  : await spotify.me.follow(
                                                      FollowingType.artist,
                                                      [artistId],
                                                    );
                                            } catch (e, stack) {
                                              logger.e(
                                                "FollowButton.onPressed",
                                                e,
                                                stack,
                                              );
                                            } finally {
                                              ref.refresh(
                                                currentUserFollowsArtistQuery(
                                                    artistId),
                                              );
                                            }
                                          },
                                          child: Text(
                                            isFollowing
                                                ? "Following"
                                                : "Follow",
                                          ),
                                        );
                                      },
                                      error: (error, stackTrace) => Container(),
                                      loading: () =>
                                          const CircularProgressIndicator
                                              .adaptive()),
                                  IconButton(
                                    icon: const Icon(Icons.share_rounded),
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                            text: data.externalUrls?.spotify),
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
                      ],
                    ),
                    const SizedBox(height: 50),
                    topTracksSnapshot.when(
                      data: (topTracks) {
                        final isPlaylistPlaying =
                            playback.currentPlaylist?.id == data.id;
                        playPlaylist(List<Track> tracks,
                            {Track? currentTrack}) async {
                          currentTrack ??= tracks.first;
                          if (!isPlaylistPlaying) {
                            playback.setCurrentPlaylist = CurrentPlaylist(
                              tracks: tracks,
                              id: data.id!,
                              name: "${data.name!} To Tracks",
                              thumbnail: imageToUrlString(data.images),
                            );
                            playback.setCurrentTrack = currentTrack;
                          } else if (isPlaylistPlaying &&
                              currentTrack.id != null &&
                              currentTrack.id != playback.currentTrack?.id) {
                            playback.setCurrentTrack = currentTrack;
                          }
                          await playback.startPlaying();
                        }

                        return Column(children: [
                          Row(
                            children: [
                              Text(
                                "Top Tracks",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: Icon(isPlaylistPlaying
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded),
                                  color: Colors.white,
                                  onPressed: () =>
                                      playPlaylist(topTracks.toList()),
                                ),
                              )
                            ],
                          ),
                          ...topTracks.toList().asMap().entries.map((track) {
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
                                topTracks.toList(),
                                currentTrack: track.value,
                              ),
                            );
                          }),
                        ]);
                      },
                      error: (error, stack) =>
                          Text("Failed to find top tracks $error"),
                      loading: () => const Center(
                          child: CircularProgressIndicator.adaptive()),
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
                            GoRouter.of(context).push(
                              "/artist-album/$artistId",
                              extra: data.name ?? "KRTX",
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    albums.when(
                      data: (albums) {
                        return Scrollbar(
                          controller: scrollController,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: albums.items
                                      ?.map((album) => AlbumCard(album))
                                      .toList() ??
                                  [],
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrack) =>
                          Text("Failed to get Artist albums $error"),
                      loading: () => const CircularProgressIndicator.adaptive(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Fans also likes",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 10),
                    relatedArtists.when(
                      data: (artists) {
                        return Center(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: artists
                                .map((artist) => ArtistCard(artist))
                                .toList(),
                          ),
                        );
                      },
                      error: (error, stackTrack) =>
                          Text("Failed to get Artist albums $error"),
                      loading: () => const CircularProgressIndicator.adaptive(),
                    ),
                  ],
                ),
              );
            },
            error: (_, __) => const Text("Life's miserable"),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive())),
      ),
    );
  }
}
