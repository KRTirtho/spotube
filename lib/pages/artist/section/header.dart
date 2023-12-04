import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_breakpoint_value.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class ArtistPageHeader extends HookConsumerWidget {
  final String artistId;
  const ArtistPageHeader({Key? key, required this.artistId}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final queryClient = useQueryClient();
    final artistQuery = useQueries.artist.get(ref, artistId);
    final artist = artistQuery.data ?? FakeData.artist;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final ThemeData(:textTheme) = theme;

    final chipTextVariant = useBreakpointValue(
      xs: textTheme.bodySmall,
      sm: textTheme.bodySmall,
      md: textTheme.bodyMedium,
      lg: textTheme.bodyLarge,
      xl: textTheme.titleSmall,
      xxl: textTheme.titleMedium,
    );

    final spotify = ref.read(spotifyProvider);
    final auth = ref.watch(AuthenticationNotifier.provider);
    final blacklist = ref.watch(BlackListNotifier.provider);
    final isBlackListed = blacklist.contains(
      BlacklistedElement.artist(artistId, artist.name!),
    );

    final image = TypeConversionUtils.image_X_UrlString(
      artist.images,
      placeholder: ImagePlaceholder.artist,
    );

    return LayoutBuilder(
      builder: (context, constrains) {
        return Center(
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: constrains.smAndDown
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            direction: constrains.smAndDown ? Axis.vertical : Axis.horizontal,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: kElevationToShadow[2],
                  borderRadius: BorderRadius.circular(35),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: UniversalImage(
                    path: image,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(20),
              Column(
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
                        child: Skeleton.keep(
                          child: Text(
                            artist.type!.toUpperCase(),
                            style: chipTextVariant.copyWith(
                              color: Colors.white,
                            ),
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
                              borderRadius: BorderRadius.circular(50)),
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
                    artist.name!,
                    style: mediaQuery.smAndDown
                        ? textTheme.headlineSmall
                        : textTheme.headlineMedium,
                  ),
                  Text(
                    context.l10n.followers(
                      PrimitiveUtils.toReadableNumber(
                        artist.followers!.total!.toDouble(),
                      ),
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: mediaQuery.mdAndUp ? FontWeight.bold : null,
                    ),
                  ),
                  const Gap(20),
                  Skeleton.keep(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (auth != null)
                          HookBuilder(
                            builder: (context) {
                              final isFollowingQuery =
                                  useQueries.artist.doIFollow(ref, artistId);

                              final followUnfollow = useCallback(() async {
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

                                  queryClient.refreshInfiniteQueryAllPages(
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
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (isFollowingQuery.data!) {
                                return OutlinedButton(
                                  onPressed: followUnfollow,
                                  child: Text(context.l10n.following),
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
                          tooltip: context.l10n.add_artist_to_blacklist,
                          icon: Icon(
                            SpotubeIcons.userRemove,
                            color:
                                !isBlackListed ? Colors.red[400] : Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                isBlackListed ? Colors.red[400] : null,
                          ),
                          onPressed: () async {
                            if (isBlackListed) {
                              ref
                                  .read(BlackListNotifier.provider.notifier)
                                  .remove(
                                    BlacklistedElement.artist(
                                        artist.id!, artist.name!),
                                  );
                            } else {
                              ref.read(BlackListNotifier.provider.notifier).add(
                                    BlacklistedElement.artist(
                                        artist.id!, artist.name!),
                                  );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(SpotubeIcons.share),
                          onPressed: () async {
                            if (artist.externalUrls?.spotify != null) {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: artist.externalUrls!.spotify!,
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
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
