import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/getting_started/blur_card.dart';
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
              "“Freedom of music${kIsMobile ? "in the palm of your hands" : ""}”",
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
                label: const Text("Let's get started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
