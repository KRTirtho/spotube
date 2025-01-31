import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart' hide Offset;
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/gradients.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/modules/home/sections/genres/genre_card_playlist_card.dart';
import 'package:spotube/provider/spotify/spotify.dart';

final random = Random();
final gradientState = StateProvider.family(
  (ref, String id) => gradients[random.nextInt(gradients.length)],
);

class GenreSectionCard extends HookConsumerWidget {
  final Category category;
  const GenreSectionCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final playlists = category == FakeData.category
        ? null
        : ref.watch(categoryPlaylistsProvider(category.id!));
    final playlistsData = playlists?.asData?.value.items.take(8) ??
        List.generate(5, (index) => FakeData.playlistSimple);

    final randomGradient = ref.watch(gradientState(category.id!));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: theme.borderRadiusXxl,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.foreground,
            offset: const Offset(0, 5),
            blurRadius: 7,
            spreadRadius: -5,
          ),
        ],
        image: DecorationImage(
          image: UniversalImage.imageProvider(
            category.icons!.first.url!,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: theme.borderRadiusXxl,
          gradient: randomGradient
              .withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name!,
                  style: const TextStyle(color: Colors.white),
                ).h3(),
                Button.link(
                  onPressed: () {
                    context.navigateTo(
                      GenrePlaylistsRoute(
                        id: category.id!,
                        category: category,
                      ),
                    );
                  },
                  child: Text(
                    context.l10n.view_all,
                    style: const TextStyle(color: Colors.white),
                  ).muted(),
                ),
              ],
            ),
            if (playlists?.hasError != true)
              Expanded(
                child: Skeleton.ignore(
                  child: Skeletonizer(
                    enabled: playlists?.isLoading ?? false,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: playlistsData.length,
                      separatorBuilder: (context, index) => const Gap(12),
                      itemBuilder: (context, index) {
                        final playlist = playlistsData.elementAt(index);

                        return GenreSectionCardPlaylistCard(playlist: playlist);
                      },
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
