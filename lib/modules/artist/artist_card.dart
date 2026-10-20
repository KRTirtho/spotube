import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_components.dart';
import 'package:spotube/theme/spotify_typography.dart';

class ArtistCard extends HookConsumerWidget {
  final SpotubeFullArtistObject artist;
  const ArtistCard(this.artist, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    final isBlackListed = ref.watch(
      blacklistProvider.select(
        (blacklist) => blacklist.asData?.value.any(
          (element) => element.elementId == artist.id,
        ),
      ),
    );

    return SizedBox(
      width: 150,
      child: HoverBuilder(
        builder: (context, hovering) {
          final imageUrl = artist.images.asUrlString(
            placeholder: ImagePlaceholder.artist,
          );
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 150,
                        height: 150,
                        color: SpotifyColors.surface,
                        child: const Icon(SpotubeIcons.artist,
                            color: SpotifyColors.secondaryText, size: 40),
                      ),
                      loadingBuilder: (context, chunk, total) => Container(
                        width: 150,
                        height: 150,
                        color: SpotifyColors.surface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  context.navigateTo(ArtistRoute(artistId: artist.id));
                },
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  artist.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SpotifyColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              if (isBlackListed == true) ...[
                Text(
                  context.l10n.blacklisted.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.red,
                    fontSize: 11,
                  ),
                ),
              ] else
                Text(
                  context.l10n.artist.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: SpotifyColors.disabledText,
                    fontSize: 11,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
