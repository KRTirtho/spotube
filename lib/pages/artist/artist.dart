import 'package:collection/collection.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/shimmers/shimmer_artist_profile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/track_tile/track_tile.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/artist/artist_album_list.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_breakpoint_value.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
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
    final theme = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final textTheme = theme.textTheme;
    final chipTextVariant = useBreakpointValue(
      xs: textTheme.bodySmall,
      sm: textTheme.bodySmall,
      md: textTheme.bodyMedium,
      lg: textTheme.bodyLarge,
      xl: textTheme.titleSmall,
      xxl: textTheme.titleMedium,
    );

    final mediaQuery = MediaQuery.of(context);

    final avatarWidth = useBreakpointValue(
      xs: mediaQuery.size.width * 0.50,
      sm: mediaQuery.size.width * 0.50,
      md: mediaQuery.size.width * 0.40,
      lg: mediaQuery.size.width * 0.18,
      xl: mediaQuery.size.width * 0.18,
      xxl: mediaQuery.size.width * 0.18,
    );

    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);

    final auth = ref.watch(AuthenticationNotifier.provider);

    final queryClient = useQueryClient();

    return SafeArea(
      bottom: false,
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

            return InterScrollbar(
              controller: parentScrollController,
              child: SingleChildScrollView(
                controller: parentScrollController,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          const SizedBox(width: 50),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: CircleAvatar(
                              radius: avatarWidth,
                              backgroundImage: UniversalImage.imageProvider(
                                TypeConversionUtils.image_X_UrlString(
                                  data.images,
                                  placeholder: ImagePlaceholder.artist,
                                ),
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
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Text(
                                        data.type!.toUpperCase(),
                                        style: chipTextVariant.copyWith(
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
                                          context.l10n.blacklisted,
                                          style: chipTextVariant.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                                Text(
                                  data.name!,
                                  style: mediaQuery.smAndDown
                                      ? textTheme.headlineSmall
                                      : textTheme.headlineMedium,
                                ),
                                Text(
                                  context.l10n.followers(
                                    PrimitiveUtils.toReadableNumber(
                                      data.followers!.total!.toDouble(),
                                    ),
                                  ),
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: mediaQuery.mdAndUp
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (auth != null)
                                      HookBuilder(
                                        builder: (context) {
                                          final isFollowingQuery = useQueries
                                              .artist
                                              .doIFollow(ref, artistId);

                                          final followUnfollow =
                                              useCallback(() async {
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

                                              queryClient
                                                  .refreshInfiniteQueryAllPages(
                                                      "user-following-artists");
                                            } finally {
                                              queryClient.refreshQuery(
                                                "user-follows-artists-query/$artistId",
                                              );
                                            }
                                          }, [isFollowingQuery]);

                                          if (isFollowingQuery.isLoading ||
                                              !isFollowingQuery.hasData) {
                                            return const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          if (isFollowingQuery.data!) {
                                            return OutlinedButton(
                                              onPressed: followUnfollow,
                                              child:
                                                  Text(context.l10n.following),
                                            );
                                          }

                                          return FilledButton(
                                            onPressed: followUnfollow,
                                            child: Text(context.l10n.follow),
                                          );
                                        },
                                      ),
                                    const SizedBox(width: 5),
                                    IconButton(
                                      tooltip:
                                          context.l10n.add_artist_to_blacklist,
                                      icon: Icon(
                                        SpotubeIcons.userRemove,
                                        color: !isBlackListed
                                            ? Colors.red[400]
                                            : Colors.white,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: isBlackListed
                                            ? Colors.red[400]
                                            : null,
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
                                        if (data.externalUrls?.spotify !=
                                            null) {
                                          await Clipboard.setData(
                                            ClipboardData(
                                              text: data.externalUrls!.spotify!,
                                            ),
                                          );
                                        }

                                        if (!context.mounted) return;

                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            width: 300,
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                              context.l10n.artist_url_copied,
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

                          final isPlaylistPlaying = playlist.containsTracks(
                            topTracksQuery.data ?? <Track>[],
                          );

                          if (topTracksQuery.isLoading ||
                              !topTracksQuery.hasData) {
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
                              playlistNotifier.load(
                                tracks,
                                initialIndex: tracks.indexWhere(
                                    (s) => s.id == currentTrack?.id),
                                autoPlay: true,
                              );
                            } else if (isPlaylistPlaying &&
                                currentTrack.id != null &&
                                currentTrack.id != playlist.activeTrack?.id) {
                              await playlistNotifier.jumpToTrack(currentTrack);
                            }
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      context.l10n.top_tracks,
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                  ),
                                  if (!isPlaylistPlaying)
                                    IconButton(
                                      icon: const Icon(
                                        SpotubeIcons.queueAdd,
                                      ),
                                      onPressed: () {
                                        playlistNotifier
                                            .addTracks(topTracks.toList());
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            width: 300,
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                              context.l10n.added_to_queue(
                                                topTracks.length,
                                              ),
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
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                    ),
                                    onPressed: () =>
                                        playPlaylist(topTracks.toList()),
                                  )
                                ],
                              ),
                              ...topTracks.mapIndexed((i, track) {
                                return TrackTile(
                                  index: i,
                                  track: track,
                                  onTap: () async {
                                    playPlaylist(
                                      topTracks.toList(),
                                      currentTrack: track,
                                    );
                                  },
                                );
                              }),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                      ArtistAlbumList(artistId),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.l10n.fans_also_like,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 10),
                      HookBuilder(
                        builder: (context) {
                          final relatedArtists =
                              useQueries.artist.relatedArtistsOf(
                            ref,
                            artistId,
                          );

                          if (relatedArtists.isLoading ||
                              !relatedArtists.hasData) {
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
