import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/fake.dart';
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
                  style: context.theme.typography.h4,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Button.link(
                    onPressed: () {
                      context.pushNamed(GenrePage.name);
                    },
                    leading: const Icon(SpotubeIcons.angleRight),
                    child: Text(
                      context.l10n.browse_all,
                    ).muted(),
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

                return Button(
                  style: ButtonVariance.secondary.copyWith(
                    padding: (context, states, value) {
                      return EdgeInsets.zero;
                    },
                  ),
                  onPressed: () {},
                  child: CardImage(
                    onPressed: () {
                      context.pushNamed(
                        GenrePlaylistsPage.name,
                        pathParameters: {
                          "categoryId": category.id!,
                        },
                        extra: category,
                      );
                    },
                    direction: Axis.horizontal,
                    image: UniversalImage(
                      path: category.icons!.first.url!,
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                    title: Text(category.name!),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
