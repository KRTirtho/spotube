import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/pages/home/genres/genre_playlists.dart';
import 'package:spotube/pages/home/genres/genres.dart';
import 'package:spotube/pages/playlist/playlist.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class HomeGenresSection extends HookConsumerWidget {
  const HomeGenresSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = context.theme;
    final mediaQuery = MediaQuery.sizeOf(context);

    final categoriesQuery = ref.watch(categoriesProvider);
    final categories = useMemoized(
      () =>
          categoriesQuery.asData?.value
              .where((c) => (c.icons?.length ?? 0) > 0)
              .take(mediaQuery.mdAndDown ? 6 : 10)
              .toList() ??
          [
            FakeData.category,
          ],
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
        SliverToBoxAdapter(
          child: SizedBox(
            height: 280 * theme.scaling,
            child: Carousel(
              transition: const CarouselTransition.sliding(gap: 24),
              sizeConstraint: CarouselSizeConstraint.fixed(
                mediaQuery.mdAndUp
                    ? mediaQuery.width * .6
                    : mediaQuery.width * .95,
              ),
              itemCount: categories.length,
              autoplaySpeed: const Duration(seconds: 2),
              duration: const Duration(seconds: 5),
              pauseOnHover: true,
              direction: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                final playlists =
                    ref.watch(categoryPlaylistsProvider(category.id!));
                final playlistsData = playlists.asData?.value.items.take(8) ??
                    List.generate(5, (index) => FakeData.playlistSimple);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: theme.borderRadiusXxl,
                    border: Border.all(
                      color: theme.colorScheme.border,
                      width: 1,
                    ),
                    image: DecorationImage(
                      image: UniversalImage.imageProvider(
                        category.icons!.first.url!,
                      ),
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.background.withAlpha(125),
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                    ),
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
                              context.pushNamed(
                                GenrePlaylistsPage.name,
                                pathParameters: {'categoryId': category.id!},
                                extra: category,
                              );
                            },
                            child: Text(
                              context.l10n.view_all,
                              style: const TextStyle(color: Colors.white),
                            ).muted(),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Skeleton.ignore(
                          child: Skeletonizer(
                            enabled: playlists.isLoading,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 12,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (final playlist in playlistsData)
                                    Container(
                                      width: 115 * theme.scaling,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.background
                                            .withAlpha(75),
                                        borderRadius: theme.borderRadiusMd,
                                      ),
                                      child: SurfaceBlur(
                                        borderRadius: theme.borderRadiusMd,
                                        surfaceBlur: theme.surfaceBlur,
                                        child: Button(
                                          style:
                                              ButtonVariance.secondary.copyWith(
                                            padding: (context, states, value) =>
                                                const EdgeInsets.all(8),
                                            decoration:
                                                (context, states, value) {
                                              final decoration = ButtonVariance
                                                      .secondary
                                                      .decoration(
                                                          context, states)
                                                  as BoxDecoration;

                                              if (states.isNotEmpty) {
                                                return decoration;
                                              }

                                              return decoration.copyWith(
                                                color: decoration.color
                                                    ?.withAlpha(180),
                                              );
                                            },
                                          ),
                                          onPressed: () {
                                            context.pushNamed(
                                              PlaylistPage.name,
                                              pathParameters: {
                                                "id": playlist.id!,
                                              },
                                              extra: playlist,
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    theme.borderRadiusSm,
                                                child: UniversalImage(
                                                  path: (playlist.images)!
                                                      .asUrlString(
                                                    placeholder:
                                                        ImagePlaceholder
                                                            .collection,
                                                    index: 1,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  height: 100 * theme.scaling,
                                                  width: 100 * theme.scaling,
                                                ),
                                              ),
                                              Text(
                                                playlist.name!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ).semiBold().small(),
                                              if (playlist.description != null)
                                                Text(
                                                  playlist.description
                                                          ?.unescapeHtml()
                                                          .cleanHtml() ??
                                                      "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).xSmall().muted(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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
