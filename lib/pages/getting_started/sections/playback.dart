import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/getting_started/blur_card.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

final audioSourceToIconMap = {
  AudioSource.youtube: const Icon(
    SpotubeIcons.youtube,
    color: Colors.red,
    size: 20,
  ),
  AudioSource.piped: const Icon(SpotubeIcons.piped, size: 20),
  AudioSource.invidious: ClipRRect(
    borderRadius: BorderRadius.circular(26),
    child: Assets.invidious.image(width: 26, height: 26),
  ),
  AudioSource.jiosaavn: Assets.jiosaavn.image(width: 20, height: 20),
};

class GettingStartedPagePlaybackSection extends HookConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GettingStartedPagePlaybackSection({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.read(userPreferencesProvider.notifier);

    final audioSourceToDescription = useMemoized(
        () => {
              AudioSource.youtube: "${context.l10n.youtube_source_description}\n"
                  "${context.l10n.highest_quality("148kbps mp4, 128kbps opus")}",
              AudioSource.piped: context.l10n.piped_source_description,
              AudioSource.jiosaavn:
                  "${context.l10n.jiosaavn_source_description}\n"
                      "${context.l10n.highest_quality("320kbps mp")}",
              AudioSource.invidious: context.l10n.invidious_source_description,
            },
        []);

    return Center(
      child: BlurCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(SpotubeIcons.album, size: 16),
                const Gap(8),
                Text(context.l10n.playback).semiBold().large(),
              ],
            ),
            const Gap(16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(context.l10n.select_audio_source).semiBold().large(),
            ),
            const Gap(16),
            Select<AudioSource>(
              value: preferences.audioSource,
              onChanged: (value) {
                if (value == null) return;
                preferencesNotifier.setAudioSource(value);
              },
              placeholder: Text(preferences.audioSource.name.capitalize()),
              itemBuilder: (context, value) => Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  audioSourceToIconMap[value]!,
                  Text(value.name.capitalize()),
                ],
              ),
              popup: (context) {
                return SelectPopup(
                  items: SelectItemBuilder(
                    childCount: AudioSource.values.length,
                    builder: (context, index) {
                      final source = AudioSource.values[index];

                      return SelectItemButton(
                        value: source,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 6,
                          children: [
                            audioSourceToIconMap[source]!,
                            Text(source.name.capitalize()),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const Gap(16),
            Text(
              audioSourceToDescription[preferences.audioSource]!,
            ).small().muted(),
            const Gap(16),
            ButtonTile(
              title: Text(context.l10n.endless_playback),
              subtitle: Text(
                context.l10n.endless_playback_description,
              ).small().muted(),
              onPressed: () {
                preferencesNotifier
                    .setEndlessPlayback(!preferences.endlessPlayback);
              },
              trailing: Switch(
                value: preferences.endlessPlayback,
                onChanged: (value) {
                  preferencesNotifier.setEndlessPlayback(value);
                },
              ),
            ),
            const Gap(34),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button.secondary(
                  leading: const Icon(SpotubeIcons.angleLeft),
                  onPressed: onPrevious,
                  child: Text(context.l10n.previous),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Button.primary(
                    leading: const Icon(SpotubeIcons.angleRight),
                    onPressed: onNext,
                    child: Text(context.l10n.next),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
