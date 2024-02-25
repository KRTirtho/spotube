import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/getting_started/sections/greeting.dart';
import 'package:spotube/pages/getting_started/sections/playback.dart';
import 'package:spotube/pages/getting_started/sections/region.dart';
import 'package:spotube/pages/getting_started/sections/support.dart';

class GettingStarting extends HookConsumerWidget {
  const GettingStarting({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:colorScheme) = Theme.of(context);
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
      appBar: PageWindowTitleBar(
        backgroundColor: Colors.transparent,
        actions: [
          ListenableBuilder(
            listenable: pageController,
            builder: (context, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pageController.hasClients &&
                        (pageController.page == 0 || pageController.page == 3)
                    ? const SizedBox()
                    : TextButton(
                        onPressed: () {
                          pageController.animateToPage(
                            3,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          context.l10n.skip_this_nonsense,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: colorScheme.primary,
                          ),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.bengaliPatternsBg.provider(),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              colorScheme.background.withOpacity(0.2),
              BlendMode.srcOver,
            ),
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
