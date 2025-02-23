import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/modules/home/sections/genres/genre_card.dart';
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
              .take(6)
              .toList() ??
          [
            FakeData.category,
          ],
      [categoriesQuery.asData?.value],
    );
    final controller = useMemoized(() => CarouselController(), []);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.genres,
                style: context.theme.typography.h4,
              ),
              Button.link(
                onPressed: () {
                  context.navigateTo(const GenreRoute());
                },
                child: Text(
                  context.l10n.browse_all,
                ).muted(),
              ),
            ],
          ),
        ),
        const Gap(8),
        Stack(
          children: [
            SizedBox(
              height: 280 * theme.scaling,
              child: Carousel(
                controller: controller,
                transition: const CarouselTransition.sliding(gap: 24),
                sizeConstraint: CarouselSizeConstraint.fixed(
                  mediaQuery.mdAndUp
                      ? mediaQuery.width * .6
                      : mediaQuery.width * .95,
                ),
                itemCount: categories.length,
                pauseOnHover: true,
                direction: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return Skeletonizer(
                    enabled: categoriesQuery.isLoading,
                    child: GenreSectionCard(category: category),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                height: 280 * theme.scaling,
                width: (mediaQuery.mdAndUp ? 60 : 40) * theme.scaling,
                alignment: Alignment.center,
                child: IconButton.secondary(
                  shape: ButtonShape.circle,
                  size: mediaQuery.mdAndUp
                      ? const ButtonSize(1.3)
                      : ButtonSize.normal,
                  icon: const Icon(SpotubeIcons.angleLeft),
                  onPressed: () {
                    controller.animatePrevious(
                      const Duration(seconds: 1),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                height: 280 * theme.scaling,
                width: (mediaQuery.mdAndUp ? 60 : 40) * theme.scaling,
                alignment: Alignment.center,
                child: IconButton.secondary(
                  shape: ButtonShape.circle,
                  size: mediaQuery.mdAndUp
                      ? const ButtonSize(1.3)
                      : ButtonSize.normal,
                  icon: const Icon(SpotubeIcons.angleRight),
                  onPressed: () {
                    controller.animateNext(
                      const Duration(seconds: 1),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        Center(
          child: CarouselDotIndicator(
            itemCount: categories.length,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
