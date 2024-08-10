import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/gradients.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/home/genres/genre_playlists.dart';
import 'package:spotube/pages/home/genres/genres.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class HomeGenresSection extends HookConsumerWidget {
  const HomeGenresSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final categoriesQuery = ref.watch(categoriesProvider);
    final categories = useMemoized(
      () =>
          categoriesQuery.asData?.value
              .where((c) => (c.icons?.length ?? 0) > 0)
              .take(mediaQuery.mdAndDown ? 6 : 10)
              .toList() ??
          <Category>[],
      [mediaQuery.mdAndDown, categoriesQuery.asData?.value],
    );

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.genres,
                  style: textTheme.headlineSmall,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    onPressed: () {
                      context.pushNamed(GenrePage.name);
                    },
                    icon: const Icon(SpotubeIcons.angleRight),
                    label: Text(
                      context.l10n.browse_all,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverGap(8),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: Skeletonizer.sliver(
            enabled: categoriesQuery.isLoading,
            child: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: mediaQuery.mdAndDown ? 200 : 250,
                mainAxisExtent: 50,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categoriesQuery.isLoading
                  ? mediaQuery.mdAndDown
                      ? 6
                      : 10
                  : categories.length,
              itemBuilder: (context, index) {
                final category =
                    categories.elementAtOrNull(index) ?? FakeData.category;

                return HookBuilder(builder: (context) {
                  final (:gradient, :textColor) = useMemoized(
                    () {
                      final gradient =
                          gradients[Random().nextInt(gradients.length)];
                      final text = gradient.colors
                              .take(2)
                              .any((c) => c.computeLuminance() > 0.5)
                          ? Colors.grey[900]
                          : Colors.white;
                      return (
                        gradient: LinearGradient(
                          colors: gradient.colors
                              .map((c) => c.withOpacity(0.8))
                              .toList(),
                        ),
                        textColor: text
                      );
                    },
                    [],
                  );

                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        GenrePlaylistsPage.name,
                        pathParameters: {
                          "categoryId": category.id!,
                        },
                        extra: category,
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: UniversalImage.imageProvider(
                            category.icons!.first.url!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: colorScheme.surfaceContainerHighest,
                          gradient: categoriesQuery.isLoading ? null : gradient,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            category.name!,
                            style: textTheme.titleMedium
                                ?.copyWith(color: textColor),
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
