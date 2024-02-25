import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/getting_started/blur_card.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GettingStartedScreenSupportSection extends HookConsumerWidget {
  const GettingStartedScreenSupportSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlurCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(SpotubeIcons.heartFilled, color: Colors.pink),
                    const SizedBox(width: 8),
                    Text(
                      "Help this project grow",
                      style:
                          textTheme.titleMedium?.copyWith(color: Colors.pink),
                    ),
                  ],
                ),
                const Gap(16),
                const Text(
                  "Spotube is an open-source project. You can help this project grow by contributing to the project, reporting bugs, or suggesting new features.",
                ),
                const Gap(16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(SpotubeIcons.github),
                      label: const Text("Contribute on GitHub"),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await launchUrlString(
                          "https://github.com/KRTirtho/spotube",
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    const Gap(16),
                    FilledButton.icon(
                      icon: const Icon(SpotubeIcons.openCollective),
                      label: const Text("Donate on Open Collective"),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xff4cb7f6),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await launchUrlString(
                          "https://opencollective.com/spotube",
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: TextButton.icon(
                    icon: const Icon(SpotubeIcons.anonymous),
                    label: const Text("Browse anonymously"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      KVStoreService.doneGettingStarted = true;
                      context.go("/");
                    },
                  ),
                ),
                const Gap(16),
                FilledButton.icon(
                  icon: const Icon(SpotubeIcons.spotify),
                  label: const Text("Connect Spotify Account"),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xff1db954),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    KVStoreService.doneGettingStarted = true;
                    context.push("/login");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
