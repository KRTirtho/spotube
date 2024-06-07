import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/getting_started/blur_card.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/utils/platform.dart';

class GettingStartedPageGreetingSection extends HookConsumerWidget {
  final VoidCallback onNext;
  const GettingStartedPageGreetingSection({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme) = Theme.of(context);

    return Center(
      child: BlurCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.spotubeLogoPng.image(height: 200),
            const Gap(24),
            Text(
              "Spotube",
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(4),
            Text(
              kIsMobile
                  ? context.l10n.freedom_of_music_palm
                  : context.l10n.freedom_of_music,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Gap(84),
            Directionality(
              textDirection: TextDirection.rtl,
              child: FilledButton.icon(
                onPressed: onNext,
                icon: const Icon(SpotubeIcons.angleRight),
                label: Text(context.l10n.get_started),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
