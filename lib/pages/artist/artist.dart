import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/shimmers/shimmer_artist_profile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/artist/artist_album_list.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class ArtistPage extends HookConsumerWidget {
  final String artistId;
  final logger = getLogger(ArtistPage);
  ArtistPage(this.artistId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    SpotifyApi spotify = ref.watch(spotifyProvider);
    final parentScrollController = useScrollController();
    final textTheme = Theme.of(context).textTheme;
    final chipTextVariant = useBreakpointValue(
      sm: textTheme.bodySmall,
      md: textTheme.bodyMedium,
      lg: textTheme.bodyLarge,
      xl: textTheme.titleSmall,
      xxl: textTheme.titleMedium,
    );

    final avatarWidth = useBreakpointValue(
      sm: MediaQuery.of(context).size.width * 0.50,
      md: MediaQuery.of(context).size.width * 0.40,
      lg: MediaQuery.of(context).size.width * 0.18,
      xl: MediaQuery.of(context).size.width * 0.18,
      xxl: MediaQuery.of(context).size.width * 0.18,
    );

    final breakpoint = useBreakpoints();

    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final playlist = ref.watch(PlaylistQueueNotifier.provider);

    final auth = ref.watch(AuthenticationNotifier.provider);

    return SafeArea(
      child: Scaffold(
        appBar: const PageWindowTitleBar(
          leading: BackButton(),
        ),
        body: HookBuilder(
          builder: (context) {
            final artistsQuery = useQueries.artist.get(ref, artistId);

            if (artistsQuery.isLoading || !artistsQuery.hasData) {
              return const ShimmerArtistProfile();
            } else if (artistsQuery.hasError) {
              return Center(
                child: Text(artistsQuery.error.toString()),
              );
            }

            final data = artistsQuery.data!;

            final blacklist = ref.watch(BlackListNotifier.provider);
            final isBlackListed = blacklist.contains(
              BlacklistedElement.artist(artistId, data.name!),
            );

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
                        backgroundImage: UniversalImage.imageProvider(
                          TypeConversionUtils.image_X_UrlString(
                            data.images,
                            placeholder: ImagePlaceholder.artist,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    data.type!.toUpperCase(),
                                    style: chipTextVariant?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (isBlackListed) ...[
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.red[400],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Text(
                                      "Blacklisted",
                                      style: chipTextVariant?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            Text(
                              data.name!,
                              style: breakpoint.isSm
                                  ? textTheme.headlineSmall
                                  : textTheme.headlineMedium,
                            ),
                            Text(
                              "${PrimitiveUtils.toReadableNumber(data.followers!.total!.toDouble())} followers",
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight:
                                    breakpoint.isSm ? null : FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (auth != null)
                                  HookBuilder(
                                    builder: (context) {
                                      final isFollowingQuery = useQueries.artist
                                          .doIFollow(ref, artistId);

                                      if (isFollowingQuery.isLoading ||
                                          !isFollowingQuery.hasData) {
                                        return const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      final queryBowl = QueryClient.of(context);

                                      return FilledButton(
                                        onPressed: () async {
                                          try {
                                            isFollowingQuery.data!
                                                ? await spotify.me.unfollow(
                                                    FollowingType.artist,
                                                    [artistId],
                                                  )
                                                : await spotify.me.follow(
                                                    FollowingType.artist,
                                                    [artistId],
                                                  );
                                            await isFollowingQuery.refresh();

                                            queryBowl
                                                .refreshInfiniteQueryAllPages(
                                                    "user-following-artists");
                                          } finally {
                                            QueryClient.of(context).refreshQuery(
                                                "user-follows-artists-query/$artistId");
                                          }
                                        },
                                        child: Text(
                                          isFollowingQuery.data!
                                              ? "Following"
                                              : "Follow",
                                        ),
                                      );
                                    },
                                  ),
                                const SizedBox(width: 5),
                                IconButton(
                                  tooltip: "Add to blacklisted artists",
                                  icon: Icon(
                                    SpotubeIcons.userRemove,
                                    color: !isBlackListed
                                        ? Colors.red[400]
                                        : Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        isBlackListed ? Colors.red[400] : null,
                                  ),
                                  onPressed: () async {
                                    if (isBlackListed) {
                                      ref
                                          .read(BlackListNotifier
                                              .provider.notifier)
                                          .remove(
                                            BlacklistedElement.artist(
                                                data.id!, data.name!),
                                          );
                                    } else {
                                      ref
                                          .read(BlackListNotifier
                                              .provider.notifier)
                                          .add(
                                            BlacklistedElement.artist(
                                                data.id!, data.name!),
                                          );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(SpotubeIcons.share),
                                  onPressed: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                          text: data.externalUrls?.spotify),
                                    );

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
                  HookBuilder(
                    builder: (context) {
                      final topTracksQuery = useQueries.artist.topTracksOf(
                        ref,
                        artistId,
                      );

                      final isPlaylistPlaying =
                          playlistNotifier.isPlayingPlaylist(
                        topTracksQuery.data ?? <Track>[],
                      );

                      if (topTracksQuery.isLoading || !topTracksQuery.hasData) {
                        return const CircularProgressIndicator();
                      } else if (topTracksQuery.hasError) {
                        return Center(
                          child: Text(topTracksQuery.error.toString()),
                        );
                      }

                      final topTracks = topTracksQuery.data!;

                      void playPlaylist(List<Track> tracks,
                          {Track? currentTrack}) async {
                        currentTrack ??= tracks.first;
                        if (!isPlaylistPlaying) {
                          playlistNotifier.loadAndPlay(tracks,
                              active: tracks
                                  .indexWhere((s) => s.id == currentTrack?.id));
                        } else if (isPlaylistPlaying &&
                            currentTrack.id != null &&
                            currentTrack.id != playlist?.activeTrack.id) {
                          await playlistNotifier.playTrack(currentTrack);
                        }
                      }

                      return Column(children: [
                        Row(
                          children: [
                            Text(
                              "Top Tracks",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (!isPlaylistPlaying)
                              IconButton(
                                icon: const Icon(
                                  SpotubeIcons.queueAdd,
                                ),
                                onPressed: () {
                                  playlistNotifier.add(topTracks.toList());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      width: 300,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        "Added ${topTracks.length} tracks to queue",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(width: 5),
                            IconButton(
                              icon: Icon(
                                isPlaylistPlaying
                                    ? SpotubeIcons.stop
                                    : SpotubeIcons.play,
                                color: Colors.white,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              onPressed: () => playPlaylist(topTracks.toList()),
                            )
                          ],
                        ),
                        ...topTracks.toList().asMap().entries.map((track) {
                          String duration =
                              "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                          return TrackTile(
                            playlist,
                            duration: duration,
                            track: track,
                            isActive:
                                playlist?.activeTrack.id == track.value.id,
                            onTrackPlayButtonPressed: (currentTrack) =>
                                playPlaylist(
                              topTracks.toList(),
                              currentTrack: track.value,
                            ),
                          );
                        }),
                      ]);
                    },
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Albums",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  ArtistAlbumList(artistId),
                  const SizedBox(height: 20),
                  Text(
                    "Fans also likes",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  HookBuilder(
                    builder: (context) {
                      final relatedArtists = useQueries.artist.relatedArtistsOf(
                        ref,
                        artistId,
                      );

                      if (relatedArtists.isLoading || !relatedArtists.hasData) {
                        return const CircularProgressIndicator();
                      } else if (relatedArtists.hasError) {
                        return Center(
                          child: Text(relatedArtists.error.toString()),
                        );
                      }

                      return Center(
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: relatedArtists.data!
                              .map((artist) => ArtistCard(artist))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
