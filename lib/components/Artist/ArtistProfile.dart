import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Artist/ArtistAlbumList.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerArtistProfile.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class ArtistProfile extends HookConsumerWidget {
  final String artistId;
  final logger = getLogger(ArtistProfile);
  ArtistProfile(this.artistId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    SpotifyApi spotify = ref.watch(spotifyProvider);
    final parentScrollController = useScrollController();
    final textTheme = PlatformTheme.of(context).textTheme;
    final chipTextVariant = useBreakpointValue(
      sm: textTheme!.caption,
      md: textTheme.body,
      lg: textTheme.subheading,
      xl: textTheme.headline,
      xxl: textTheme.headline,
    );

    final avatarWidth = useBreakpointValue(
      sm: MediaQuery.of(context).size.width * 0.50,
      md: MediaQuery.of(context).size.width * 0.40,
      lg: MediaQuery.of(context).size.width * 0.18,
      xl: MediaQuery.of(context).size.width * 0.18,
      xxl: MediaQuery.of(context).size.width * 0.18,
    );

    final breakpoint = useBreakpoints();

    final Playback playback = ref.watch(playbackProvider);

    return SafeArea(
      child: PlatformScaffold(
        appBar: const PageWindowTitleBar(
          leading: BackButton(),
        ),
        body: HookBuilder(
          builder: (context) {
            final artistsQuery = useQuery(
              job: artistProfileQueryJob(artistId),
              externalData: spotify,
            );

            if (artistsQuery.isLoading || !artistsQuery.hasData) {
              return const ShimmerArtistProfile();
            } else if (artistsQuery.hasError) {
              return Center(
                child: PlatformText(artistsQuery.error.toString()),
              );
            }

            final data = artistsQuery.data!;

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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: PlatformText(data.type!.toUpperCase(),
                                  style: chipTextVariant?.copyWith(
                                      color: Colors.white)),
                            ),
                            PlatformText(
                              data.name!,
                              style: breakpoint.isSm
                                  ? textTheme.subheading
                                  : textTheme.headline,
                            ),
                            PlatformText(
                              "${PrimitiveUtils.toReadableNumber(data.followers!.total!.toDouble())} followers",
                              style: breakpoint.isSm
                                  ? textTheme.body
                                  : textTheme.body
                                      ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HookBuilder(
                                  builder: (context) {
                                    final isFollowingQuery = useQuery(
                                      job: currentUserFollowsArtistQueryJob(
                                          artistId),
                                      externalData: spotify,
                                    );

                                    if (isFollowingQuery.isLoading ||
                                        !isFollowingQuery.hasData) {
                                      return const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            PlatformCircularProgressIndicator(),
                                      );
                                    }

                                    return PlatformFilledButton(
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
                                        } catch (e, stack) {
                                          logger.e(
                                            "FollowButton.onPressed",
                                            e,
                                            stack,
                                          );
                                        } finally {
                                          QueryBowl.of(context).refetchQueries([
                                            currentUserFollowsArtistQueryJob(
                                                    artistId)
                                                .queryKey,
                                          ]);
                                        }
                                      },
                                      child: PlatformText(
                                        isFollowingQuery.data!
                                            ? "Following"
                                            : "Follow",
                                      ),
                                    );
                                  },
                                ),
                                PlatformIconButton(
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
                                          content: PlatformText(
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
                  HookBuilder(
                    builder: (context) {
                      final topTracksQuery = useQuery(
                        job: artistTopTracksQueryJob(artistId),
                        externalData: spotify,
                      );

                      if (topTracksQuery.isLoading || !topTracksQuery.hasData) {
                        return const PlatformCircularProgressIndicator();
                      } else if (topTracksQuery.hasError) {
                        return Center(
                          child: PlatformText(topTracksQuery.error.toString()),
                        );
                      }

                      final topTracks = topTracksQuery.data!;

                      final isPlaylistPlaying =
                          playback.playlist?.id == data.id;
                      playPlaylist(List<Track> tracks,
                          {Track? currentTrack}) async {
                        currentTrack ??= tracks.first;
                        if (!isPlaylistPlaying) {
                          await playback.playPlaylist(
                            CurrentPlaylist(
                              tracks: tracks,
                              id: data.id!,
                              name: "${data.name!} To Tracks",
                              thumbnail: TypeConversionUtils.image_X_UrlString(
                                data.images,
                                placeholder: ImagePlaceholder.artist,
                              ),
                            ),
                            tracks.indexWhere((s) => s.id == currentTrack?.id),
                          );
                        } else if (isPlaylistPlaying &&
                            currentTrack.id != null &&
                            currentTrack.id != playback.track?.id) {
                          await playback.play(currentTrack);
                        }
                      }

                      return Column(children: [
                        Row(
                          children: [
                            PlatformText(
                              "Top Tracks",
                              style:
                                  PlatformTheme.of(context).textTheme?.headline,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: PlatformIconButton(
                                icon: Icon(
                                  isPlaylistPlaying
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    playPlaylist(topTracks.toList()),
                              ),
                            )
                          ],
                        ),
                        ...topTracks.toList().asMap().entries.map((track) {
                          String duration =
                              "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                          return TrackTile(
                            playback,
                            duration: duration,
                            track: track,
                            isActive: playback.track?.id == track.value.id,
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
                  PlatformText(
                    "Albums",
                    style: PlatformTheme.of(context).textTheme?.headline,
                  ),
                  const SizedBox(height: 10),
                  ArtistAlbumList(artistId),
                  const SizedBox(height: 20),
                  PlatformText(
                    "Fans also likes",
                    style: PlatformTheme.of(context).textTheme?.headline,
                  ),
                  const SizedBox(height: 10),
                  HookBuilder(
                    builder: (context) {
                      final relatedArtists = useQuery(
                        job: artistRelatedArtistsQueryJob(artistId),
                        externalData: spotify,
                      );

                      if (relatedArtists.isLoading || !relatedArtists.hasData) {
                        return const PlatformCircularProgressIndicator();
                      } else if (relatedArtists.hasError) {
                        return Center(
                          child: PlatformText(relatedArtists.error.toString()),
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
