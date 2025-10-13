import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/getting_started/sections/greeting.dart';
import 'package:spotube/pages/getting_started/sections/playback.dart';
import 'package:spotube/pages/getting_started/sections/region.dart';
import 'package:spotube/pages/getting_started/sections/support.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class GettingStartedPage extends HookConsumerWidget {
  static const name = "getting_started";

  const GettingStartedPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final pageController = usePageController();

    final onNext = useCallback(() {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }, [pageController]);

    final onPrevious = useCallback(() {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }, [pageController]);

    return Scaffold(
      headers: [
        SafeArea(
          child: TitleBar(
            backgroundColor: Colors.transparent,
            surfaceBlur: 0,
            trailing: [
              ListenableBuilder(
                listenable: pageController,
                builder: (context, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: pageController.hasClients &&
                            (pageController.page == 0 ||
                                pageController.page == 3)
                        ? const SizedBox()
                        : Button.secondary(
                            onPressed: () {
                              pageController.animateToPage(
                                3,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(context.l10n.skip_this_nonsense),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
      floatingHeader: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bengaliPatternsBg.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: pageController,
          children: [
            GettingStartedPageGreetingSection(onNext: onNext),
            GettingStartedPageLanguageRegionSection(onNext: onNext),
            GettingStartedPagePlaybackSection(
              onNext: onNext,
              onPrevious: onPrevious,
            ),
            const GettingStartedScreenSupportSection(),
          ],
        ),
      ),
    );
  }
}
