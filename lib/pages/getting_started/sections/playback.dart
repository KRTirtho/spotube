import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/modules/getting_started/blur_card.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

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

    // final audioSourceToDescription = useMemoized(
    //     () => {
    //           AudioSource.youtube: "${context.l10n.youtube_source_description}\n"
    //               "${context.l10n.highest_quality("148kbps mp4, 128kbps opus")}",
    //           AudioSource.piped: context.l10n.piped_source_description,
    //           AudioSource.jiosaavn:
    //               "${context.l10n.jiosaavn_source_description}\n"
    //                   "${context.l10n.highest_quality("320kbps mp4")}",
    //           AudioSource.invidious: context.l10n.invidious_source_description,
    //           AudioSource.dabMusic: "${context.l10n.dab_music_source_description}\n"
    //               "${context.l10n.highest_quality("320kbps mp3, HI-RES 24bit 44.1kHz-96kHz flac")}",
    //         },
    //     []);

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
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(context.l10n.select_audio_source).semiBold().large(),
            // ),
            // const Gap(16),
            // RadioGroup<AudioSource>(
            //   value: preferences.audioSource,
            //   onChanged: (value) {
            //     preferencesNotifier.setAudioSource(value);
            //   },
            //   child: Wrap(
            //     spacing: 6,
            //     runSpacing: 6,
            //     children: [
            //       for (final source in AudioSource.values)
            //         Badge(
            //           isLabelVisible: source == AudioSource.dabMusic,
            //           label: const Text("NEW"),
            //           backgroundColor: Colors.lime[300],
            //           textColor: Colors.black,
            //           child: RadioCard(
            //             value: source,
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 audioSourceToIconMap[source]!,
            //                 Text(source.label),
            //               ],
            //             ),
            //           ),
            //         ),
            //     ],
            //   ),
            // ),
            // const Gap(16),
            // Text(
            //   audioSourceToDescription[preferences.audioSource]!,
            // ).small().muted(),
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
