import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
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

    final theme = Theme.of(context);
    final ThemeData(:typography) = theme;

    final auth = ref.watch(authenticationProvider);
    ref.watch(blacklistProvider);
    final blacklistNotifier = ref.watch(blacklistProvider.notifier);
    final isBlackListed = blacklistNotifier.containsArtist(artist);

    final image = artist.images.asUrlString(
      placeholder: ImagePlaceholder.artist,
    );

    final actions = Skeleton.keep(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (auth.asData?.value != null)
            Consumer(
              builder: (context, ref, _) {
                final isFollowingQuery = ref.watch(
                  artistIsFollowingProvider(artist.id!),
                );
                final followingArtistNotifier = ref.watch(
                  followedArtistsProvider.notifier,
                );

                return switch (isFollowingQuery) {
                  AsyncData(value: final following) => Builder(
                      builder: (context) {
                        if (following) {
                          return Button.outline(
                            onPressed: () async {
                              await followingArtistNotifier
                                  .removeArtists([artist.id!]);
                            },
                            child: Text(context.l10n.following),
                          );
                        }

                        return Button.primary(
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
          Tooltip(
            tooltip: TooltipContainer(
              child: Text(context.l10n.add_artist_to_blacklist),
            ),
            child: IconButton(
              icon: Icon(
                SpotubeIcons.userRemove,
                color: !isBlackListed ? Colors.red[400] : null,
              ),
              variance: isBlackListed
                  ? ButtonVariance.destructive
                  : ButtonVariance.ghost,
              onPressed: () async {
                if (isBlackListed) {
                  await ref.read(blacklistProvider.notifier).remove(artist.id!);
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
          ),
          IconButton.ghost(
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

              showToast(
                context: context,
                location: ToastLocation.topRight,
                dismissible: true,
                builder: (context, overlay) {
                  return SurfaceCard(
                    child: Text(
                      context.l10n.artist_url_copied,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constrains) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: theme.borderRadiusXl,
                      child: UniversalImage(
                        path: image,
                        width: constrains.mdAndUp ? 200 : 120,
                        height: constrains.mdAndUp ? 200 : 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Gap(20),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlineBadge(
                                child:
                                    Text(context.l10n.artist).small().muted(),
                              ),
                              if (isBlackListed) ...[
                                const Gap(5),
                                DestructiveBadge(
                                  child: Text(context.l10n.blacklisted).small(),
                                ),
                              ]
                            ],
                          ),
                          const Gap(10),
                          Flexible(
                            child: AutoSizeText(
                              artist.name!,
                              style: constrains.smAndDown
                                  ? typography.h4
                                  : typography.h3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 14,
                            ),
                          ),
                          const Gap(5),
                          Flexible(
                            child: AutoSizeText(
                              context.l10n.followers(
                                PrimitiveUtils.toReadableNumber(
                                  artist.followers!.total!.toDouble(),
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 12,
                            ).muted(),
                          ),
                          if (constrains.mdAndUp) ...[
                            const Gap(20),
                            actions,
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
                if (constrains.smAndDown) ...[
                  const Gap(20),
                  actions,
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
