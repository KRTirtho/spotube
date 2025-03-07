import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show ListTile;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/adaptive/adaptive_select_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/modules/settings/youtube_engine_not_installed_dialog.dart';
import 'package:spotube/provider/audio_player/sources/invidious_instances_provider.dart';
import 'package:spotube/provider/audio_player/sources/piped_instances_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/kv_store/kv_store.dart';

import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/youtube_engine/yt_dlp_engine.dart';
import 'package:spotube/utils/platform.dart';

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
        AdaptiveSelectTile<SourceQualities>(
          secondary: const Icon(SpotubeIcons.audioQuality),
          title: Text(context.l10n.audio_quality),
          value: preferences.audioQuality,
          options: [
            SelectItemButton(
              value: SourceQualities.high,
              child: Text(context.l10n.high),
            ),
            SelectItemButton(
              value: SourceQualities.medium,
              child: Text(context.l10n.medium),
            ),
            SelectItemButton(
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
        AdaptiveSelectTile<AudioSource>(
          secondary: const Icon(SpotubeIcons.api),
          title: Text(context.l10n.audio_source),
          value: preferences.audioSource,
          options: AudioSource.values
              .map((e) => SelectItemButton(
                    value: e,
                    child: Text(e.label),
                  ))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            preferencesNotifier.setAudioSource(value);
          },
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: preferences.audioSource != AudioSource.piped
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: const SizedBox.shrink(),
          secondChild: Consumer(
            builder: (context, ref, child) {
              final instanceList = ref.watch(pipedInstancesFutureProvider);

              return instanceList.when(
                data: (data) {
                  return AdaptiveSelectTile<String>(
                    secondary: const Icon(SpotubeIcons.piped),
                    title: Text(context.l10n.piped_instance),
                    subtitle: Text(
                      "${context.l10n.piped_description}\n"
                      "${context.l10n.piped_warning}",
                    ),
                    value: preferences.pipedInstance,
                    showValueWhenUnfolded: false,
                    trailing: [
                      Tooltip(
                        tooltip: TooltipContainer(
                          child: Text(context.l10n.add_custom_url),
                        ),
                        child: IconButton.outline(
                          icon: const Icon(SpotubeIcons.edit),
                          size: ButtonSize.small,
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (context) => HookBuilder(
                                builder: (context) {
                                  final controller =
                                      useShadcnTextEditingController(
                                    text: preferences.pipedInstance,
                                  );
                                  final formKey = useMemoized(
                                      () => GlobalKey<FormBuilderState>(), []);

                                  return Alert(
                                    title:
                                        Text(context.l10n.piped_instance).h4(),
                                    content: FormBuilder(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          const Gap(10),
                                          TextFormBuilderField(
                                            name: "url",
                                            controller: controller,
                                            placeholder: Text(
                                                context.l10n.piped_instance),
                                            validator:
                                                FormBuilderValidators.url(),
                                          ),
                                          const Gap(10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Button.secondary(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                      Text(context.l10n.cancel),
                                                ),
                                              ),
                                              const Gap(10),
                                              Expanded(
                                                child: Button.primary(
                                                  onPressed: () {
                                                    if (!formKey.currentState!
                                                        .saveAndValidate()) {
                                                      return;
                                                    }
                                                    preferencesNotifier
                                                        .setPipedInstance(
                                                      controller.text,
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                      Text(context.l10n.save),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                    options: [
                      if (data
                          .none((e) => e.apiUrl == preferences.pipedInstance))
                        SelectItemButton(
                          value: preferences.pipedInstance,
                          child: Text.rich(
                            TextSpan(
                              style: theme.typography.xSmall.copyWith(
                                color: theme.colorScheme.foreground,
                              ),
                              children: [
                                TextSpan(text: context.l10n.custom),
                                const TextSpan(text: "\n"),
                                TextSpan(text: preferences.pipedInstance),
                              ],
                            ),
                          ),
                        ),
                      for (final e in data.sortedBy((e) => e.name))
                        SelectItemButton(
                          value: e.apiUrl,
                          child: RichText(
                            text: TextSpan(
                              style: theme.typography.normal.copyWith(
                                color: theme.colorScheme.foreground,
                              ),
                              children: [
                                TextSpan(
                                  text: "${e.name.trim()}\n",
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
                    ],
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
            },
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: preferences.audioSource != AudioSource.invidious
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: const SizedBox.shrink(),
          secondChild: Consumer(
            builder: (context, ref, child) {
              final instanceList = ref.watch(invidiousInstancesProvider);

              return instanceList.when(
                data: (data) {
                  return AdaptiveSelectTile<String>(
                    secondary: const Icon(SpotubeIcons.piped),
                    title: Text(context.l10n.invidious_instance),
                    subtitle: Text(
                      "${context.l10n.invidious_description}\n"
                      "${context.l10n.invidious_warning}",
                    ),
                    trailing: [
                      Tooltip(
                        tooltip: TooltipContainer(
                          child: Text(context.l10n.add_custom_url),
                        ),
                        child: IconButton.outline(
                          icon: const Icon(SpotubeIcons.edit),
                          size: ButtonSize.small,
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.black.withValues(alpha: 0.5),
                              builder: (context) => HookBuilder(
                                builder: (context) {
                                  final controller =
                                      useShadcnTextEditingController(
                                    text: preferences.invidiousInstance,
                                  );
                                  final formKey = useMemoized(
                                      () => GlobalKey<FormBuilderState>(), []);

                                  return Alert(
                                    title: Text(context.l10n.invidious_instance)
                                        .h4(),
                                    content: FormBuilder(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          const Gap(10),
                                          TextFormBuilderField(
                                            name: "url",
                                            controller: controller,
                                            placeholder: Text(context
                                                .l10n.invidious_instance),
                                            validator:
                                                FormBuilderValidators.url(),
                                          ),
                                          const Gap(10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Button.secondary(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                      Text(context.l10n.cancel),
                                                ),
                                              ),
                                              const Gap(10),
                                              Expanded(
                                                child: Button.primary(
                                                  onPressed: () {
                                                    if (!formKey.currentState!
                                                        .saveAndValidate()) {
                                                      return;
                                                    }
                                                    preferencesNotifier
                                                        .setInvidiousInstance(
                                                      controller.text,
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                      Text(context.l10n.save),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                    value: preferences.invidiousInstance,
                    showValueWhenUnfolded: false,
                    options: [
                      if (data.none((e) =>
                          e.details.uri == preferences.invidiousInstance))
                        SelectItemButton(
                          value: preferences.invidiousInstance,
                          child: Text.rich(
                            TextSpan(
                              style: theme.typography.xSmall.copyWith(
                                color: theme.colorScheme.foreground,
                              ),
                              children: [
                                TextSpan(text: context.l10n.custom),
                                const TextSpan(text: "\n"),
                                TextSpan(text: preferences.invidiousInstance),
                              ],
                            ),
                          ),
                        ),
                      for (final e in data.sortedBy((e) => e.name))
                        SelectItemButton(
                          value: e.details.uri,
                          child: RichText(
                            text: TextSpan(
                              style: theme.typography.normal.copyWith(
                                color: theme.colorScheme.foreground,
                              ),
                              children: [
                                TextSpan(
                                  text: "${e.name.trim()}\n",
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
                    ],
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
            },
          ),
        ),
        switch (preferences.audioSource) {
          AudioSource.youtube => AdaptiveSelectTile<YoutubeClientEngine>(
              secondary: const Icon(SpotubeIcons.engine),
              title: Text(context.l10n.youtube_engine),
              value: preferences.youtubeClientEngine,
              options: YoutubeClientEngine.values
                  .where((e) => e.isAvailableForPlatform())
                  .map((e) => SelectItemButton(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;
                if (value == YoutubeClientEngine.ytDlp) {
                  final customPath = KVStoreService.getYoutubeEnginePath(value);
                  if (!await YtDlpEngine.isInstalled() &&
                      (customPath == null ||
                          !await File(customPath).exists()) &&
                      context.mounted) {
                    final hasInstalled = await showDialog<bool>(
                      context: context,
                      builder: (context) =>
                          YouTubeEngineNotInstalledDialog(engine: value),
                    );
                    if (hasInstalled != true) return;
                  }
                }
                preferencesNotifier.setYoutubeClientEngine(value);
              },
            ),
          AudioSource.piped ||
          AudioSource.invidious =>
            AdaptiveSelectTile<SearchMode>(
              secondary: const Icon(SpotubeIcons.search),
              title: Text(context.l10n.search_mode),
              value: preferences.searchMode,
              options: SearchMode.values
                  .map((e) => SelectItemButton(
                        value: e,
                        child: Text(e.label),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                preferencesNotifier.setSearchMode(value);
              },
            ),
          _ => const SizedBox.shrink(),
        },
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: preferences.searchMode == SearchMode.youtube &&
                  (preferences.audioSource == AudioSource.piped ||
                      preferences.audioSource == AudioSource.youtube ||
                      preferences.audioSource == AudioSource.invidious)
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: ListTile(
            leading: const Icon(SpotubeIcons.skip),
            title: Text(context.l10n.skip_non_music),
            trailing: Switch(
              value: preferences.skipNonMusic,
              onChanged: (state) {
                preferencesNotifier.setSkipNonMusic(state);
              },
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
        ListTile(
          title: Text(context.l10n.cache_music),
          subtitle: kIsMobile
              ? null
              : Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "${context.l10n.open} "),
                      TextSpan(
                        text: context.l10n.cache_folder.toLowerCase(),
                        recognizer: TapGestureRecognizer()
                          ..onTap = preferencesNotifier.openCacheFolder,
                        style: theme.typography.normal.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                ),
          leading: const Icon(SpotubeIcons.cache),
          trailing: Switch(
            value: preferences.cacheMusic,
            onChanged: preferencesNotifier.setCacheMusic,
          ),
        ),
        ListTile(
          leading: const Icon(SpotubeIcons.playlistRemove),
          title: Text(context.l10n.blacklist),
          subtitle: Text(context.l10n.blacklist_description),
          onTap: () {
            context.navigateTo(const BlackListRoute());
          },
          trailing: const Icon(SpotubeIcons.angleRight),
        ),
        ListTile(
          leading: const Icon(SpotubeIcons.normalize),
          title: Text(context.l10n.normalize_audio),
          trailing: Switch(
            value: preferences.normalizeAudio,
            onChanged: preferencesNotifier.setNormalizeAudio,
          ),
        ),
        if (preferences.audioSource != AudioSource.jiosaavn) ...[
          AdaptiveSelectTile<SourceCodecs>(
            popupConstraints: const BoxConstraints(maxWidth: 300),
            secondary: const Icon(SpotubeIcons.stream),
            title: Text(context.l10n.streaming_music_codec),
            value: preferences.streamMusicCodec,
            showValueWhenUnfolded: false,
            options: SourceCodecs.values
                .map((e) => SelectItemButton(
                      value: e,
                      child: Text(
                        e.label,
                        style: theme.typography.small,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              preferencesNotifier.setStreamMusicCodec(value);
            },
          ),
          AdaptiveSelectTile<SourceCodecs>(
            popupConstraints: const BoxConstraints(maxWidth: 300),
            secondary: const Icon(SpotubeIcons.file),
            title: Text(context.l10n.download_music_codec),
            value: preferences.downloadMusicCodec,
            showValueWhenUnfolded: false,
            options: SourceCodecs.values
                .map((e) => SelectItemButton(
                      value: e,
                      child: Text(
                        e.label,
                        style: theme.typography.small,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              preferencesNotifier.setDownloadMusicCodec(value);
            },
          ),
        ],
        ListTile(
            leading: const Icon(SpotubeIcons.repeat),
            title: Text(context.l10n.endless_playback),
            trailing: Switch(
              value: preferences.endlessPlayback,
              onChanged: preferencesNotifier.setEndlessPlayback,
            )),
        ListTile(
          title: Text(context.l10n.enable_connect),
          subtitle: Text(context.l10n.enable_connect_description),
          leading: const Icon(SpotubeIcons.connect),
          trailing: Switch(
            value: preferences.enableConnect,
            onChanged: preferencesNotifier.setEnableConnect,
          ),
        ),
      ],
    );
  }
}
