import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/hooks/utils/use_breakpoint_value.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/utils/primitive_utils.dart';

class ArtistPageHeader extends HookConsumerWidget {
  final String artistId;
  const ArtistPageHeader({super.key, required this.artistId});

  @override
  Widget build(BuildContext context, ref) {
    final artistQuery = ref.watch(artistProvider(artistId));
    final artist = artistQuery.asData?.value ?? FakeData.artist;

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

    final auth = ref.watch(authenticationProvider);
    ref.watch(blacklistProvider);
    final blacklistNotifier = ref.watch(blacklistProvider.notifier);
    final isBlackListed = blacklistNotifier.containsArtist(artist);

    final image = artist.images.asUrlString(
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
                        if (auth.asData?.value != null)
                          Consumer(
                            builder: (context, ref, _) {
                              final isFollowingQuery = ref
                                  .watch(artistIsFollowingProvider(artist.id!));
                              final followingArtistNotifier =
                                  ref.watch(followedArtistsProvider.notifier);

                              return switch (isFollowingQuery) {
                                AsyncData(value: final following) => Builder(
                                    builder: (context) {
                                      if (following) {
                                        return OutlinedButton(
                                          onPressed: () async {
                                            await followingArtistNotifier
                                                .removeArtists([artist.id!]);
                                          },
                                          child: Text(context.l10n.following),
                                        );
                                      }

                                      return FilledButton(
                                        onPressed: () async {
                                          await followingArtistNotifier
                                              .saveArtists([artist.id!]);
                                        },
                                        child: Text(context.l10n.follow),
                                      );
                                    },
                                  ),
                                AsyncError() => const SizedBox(),
                                _ => const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(),
                                  )
                              };
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
                              await ref
                                  .read(blacklistProvider.notifier)
                                  .remove(artist.id!);
                            } else {
                              await ref.read(blacklistProvider.notifier).add(
                                    BlacklistTableCompanion.insert(
                                      name: artist.name!,
                                      elementId: artist.id!,
                                      elementType: BlacklistedType.artist,
                                    ),
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
