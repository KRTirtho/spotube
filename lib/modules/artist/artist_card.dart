import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';

import 'package:spotube/provider/blacklist_provider.dart';

class ArtistCard extends HookConsumerWidget {
  final SpotubeFullArtistObject artist;
  const ArtistCard(this.artist, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final backgroundImage = UniversalImage.imageProvider(
      artist.images.asUrlString(
        placeholder: ImagePlaceholder.artist,
      ),
    );
    final isBlackListed = ref.watch(
      blacklistProvider.select(
        (blacklist) => blacklist.asData?.value.any(
          (element) => element.elementId == artist.id,
        ),
      ),
    );

    return SizedBox(
      width: 180,
      child: Button.card(
        onPressed: () {
          context.navigateTo(ArtistRoute(artistId: artist.id));
        },
        child: Column(
          children: [
            Avatar(
              initials: artist.name.trim()[0].toUpperCase(),
              provider: backgroundImage,
              size: 130,
            ),
            const Gap(10),
            AutoSizeText(
              artist.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: theme.typography.bold,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isBlackListed == true) ...[
                  DestructiveBadge(
                    child: Text(context.l10n.blacklisted.toUpperCase()),
                  ),
                  const Gap(5),
                ],
                SecondaryBadge(
                  child: Text(context.l10n.artist.toUpperCase()),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
