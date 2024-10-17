import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/adaptive/adaptive_select_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/audio_player/sources/invidious_instances_provider.dart';
import 'package:spotube/provider/audio_player/sources/piped_instances_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:spotube/services/sourced_track/enums.dart';

class SettingsPlaybackSection extends HookConsumerWidget {
  const SettingsPlaybackSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final theme = Theme.of(context);

    return SectionCardWithHeading(
      heading: context.l10n.playback,
      children: [
        const Gap(10),
        AdaptiveSelectTile<SourceQualities>(
          secondary: const Icon(SpotubeIcons.audioQuality),
          title: Text(context.l10n.audio_quality),
          value: preferences.audioQuality,
          options: [
            DropdownMenuItem(
              value: SourceQualities.high,
              child: Text(context.l10n.high),
            ),
            DropdownMenuItem(
              value: SourceQualities.medium,
              child: Text(context.l10n.medium),
            ),
            DropdownMenuItem(
              value: SourceQualities.low,
              child: Text(context.l10n.low),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              preferencesNotifier.setAudioQuality(value);
            }
          },
        ),
        const Gap(5),
        AdaptiveSelectTile<AudioSource>(
          secondary: const Icon(SpotubeIcons.api),
          title: Text(context.l10n.audio_source),
          value: preferences.audioSource,
          options: AudioSource.values
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.label),
                  ))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            preferencesNotifier.setAudioSource(value);
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: preferences.audioSource != AudioSource.piped
              ? const SizedBox.shrink()
              : Consumer(builder: (context, ref, child) {
                  final instanceList = ref.watch(pipedInstancesFutureProvider);

                  return instanceList.when(
                    data: (data) {
                      return AdaptiveSelectTile<String>(
                        secondary: const Icon(SpotubeIcons.piped),
                        title: Text(context.l10n.piped_instance),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: context.l10n.piped_description,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: context.l10n.piped_warning,
                                style: theme.textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                        value: preferences.pipedInstance,
                        showValueWhenUnfolded: false,
                        options: data
                            .sortedBy((e) => e.name)
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.apiUrl,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${e.name.trim()}\n",
                                        style: theme.textTheme.labelLarge,
                                      ),
                                      TextSpan(
                                        text: e.locations
                                            .map(countryCodeToEmoji)
                                            .join(""),
                                        style: GoogleFonts.notoColorEmoji(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            preferencesNotifier.setPipedInstance(value);
                          }
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Text(error.toString()),
                  );
                }),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: preferences.audioSource != AudioSource.invidious
              ? const SizedBox.shrink()
              : Consumer(builder: (context, ref, child) {
                  final instanceList = ref.watch(invidiousInstancesProvider);

                  return instanceList.when(
                    data: (data) {
                      return AdaptiveSelectTile<String>(
                        secondary: const Icon(SpotubeIcons.piped),
                        title: Text(context.l10n.invidious_instance),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: context.l10n.invidious_description,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: context.l10n.invidious_warning,
                                style: theme.textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                        value: preferences.invidiousInstance,
                        showValueWhenUnfolded: false,
                        options: data
                            .sortedBy((e) => e.name)
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.details.uri,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${e.name.trim()}\n",
                                        style: theme.textTheme.labelLarge,
                                      ),
                                      TextSpan(
                                        text: countryCodeToEmoji(
                                          e.details.region,
                                        ),
                                        style: GoogleFonts.notoColorEmoji(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            preferencesNotifier.setInvidiousInstance(value);
                          }
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Text(error.toString()),
                  );
                }),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: preferences.audioSource != AudioSource.piped
              ? const SizedBox.shrink()
              : AdaptiveSelectTile<SearchMode>(
                  secondary: const Icon(SpotubeIcons.search),
                  title: Text(context.l10n.search_mode),
                  value: preferences.searchMode,
                  options: SearchMode.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    preferencesNotifier.setSearchMode(value);
                  },
                ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: preferences.searchMode == SearchMode.youtube &&
                  (preferences.audioSource == AudioSource.piped ||
                      preferences.audioSource == AudioSource.youtube ||
                      preferences.audioSource == AudioSource.invidious)
              ? SwitchListTile(
                  secondary: const Icon(SpotubeIcons.skip),
                  title: Text(context.l10n.skip_non_music),
                  value: preferences.skipNonMusic,
                  onChanged: (state) {
                    preferencesNotifier.setSkipNonMusic(state);
                  },
                )
              : const SizedBox.shrink(),
        ),
        ListTile(
          leading: const Icon(SpotubeIcons.playlistRemove),
          title: Text(context.l10n.blacklist),
          subtitle: Text(context.l10n.blacklist_description),
          onTap: () {
            GoRouter.of(context).push("/settings/blacklist");
          },
          trailing: const Icon(SpotubeIcons.angleRight),
        ),
        SwitchListTile(
          secondary: const Icon(SpotubeIcons.normalize),
          title: Text(context.l10n.normalize_audio),
          value: preferences.normalizeAudio,
          onChanged: preferencesNotifier.setNormalizeAudio,
        ),
        if (preferences.audioSource != AudioSource.jiosaavn) ...[
          const Gap(5),
          AdaptiveSelectTile<SourceCodecs>(
            secondary: const Icon(SpotubeIcons.stream),
            title: Text(context.l10n.streaming_music_codec),
            value: preferences.streamMusicCodec,
            showValueWhenUnfolded: false,
            options: SourceCodecs.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.label,
                        style: theme.textTheme.labelMedium,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              preferencesNotifier.setStreamMusicCodec(value);
            },
          ),
          const Gap(5),
          AdaptiveSelectTile<SourceCodecs>(
            secondary: const Icon(SpotubeIcons.file),
            title: Text(context.l10n.download_music_codec),
            value: preferences.downloadMusicCodec,
            showValueWhenUnfolded: false,
            options: SourceCodecs.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.label,
                        style: theme.textTheme.labelMedium,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              preferencesNotifier.setDownloadMusicCodec(value);
            },
          )
        ],
        SwitchListTile(
          secondary: const Icon(SpotubeIcons.repeat),
          title: Text(context.l10n.endless_playback),
          value: preferences.endlessPlayback,
          onChanged: preferencesNotifier.setEndlessPlayback,
        ),
        SwitchListTile(
          title: Text(context.l10n.enable_connect),
          subtitle: Text(context.l10n.enable_connect_description),
          secondary: const Icon(SpotubeIcons.connect),
          value: preferences.enableConnect,
          onChanged: preferencesNotifier.setEnableConnect,
        ),
      ],
    );
  }
}
