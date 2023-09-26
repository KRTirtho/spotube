import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/collections/language_codes.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/components/settings/section_card_with_heading.dart';
import 'package:spotube/components/shared/adaptive/adaptive_list_tile.dart';
import 'package:spotube/components/shared/adaptive/adaptive_select_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/provider/piped_instances_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final auth = ref.watch(AuthenticationNotifier.provider);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final pickColorScheme = useCallback(() {
      return () => showDialog(
          context: context,
          builder: (context) {
            return const ColorSchemePickerDialog();
          });
    }, []);

    final pickDownloadLocation = useCallback(() async {
      String? dirStr = await getDirectoryPath(
        initialDirectory: preferences.downloadLocation,
      );
      if (dirStr == null) return;
      if (DesktopTools.platform.isAndroid && dirStr.startsWith("content://")) {
        dirStr =
            "/storage/emulated/0/${Uri.decodeFull(dirStr).split("primary:").last}";
      }
      preferences.setDownloadLocation(dirStr);
    }, [preferences.downloadLocation]);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: PageWindowTitleBar(
          title: Text(context.l10n.settings),
          centerTitle: true,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1366),
                child: ListView(
                  children: [
                    SectionCardWithHeading(
                      heading: context.l10n.account,
                      children: [
                        if (auth == null)
                          LayoutBuilder(builder: (context, constrains) {
                            return ListTile(
                              leading: Icon(
                                SpotubeIcons.login,
                                color: theme.colorScheme.primary,
                              ),
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  context.l10n.login_with_spotify,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              onTap: constrains.mdAndUp
                                  ? null
                                  : () {
                                      GoRouter.of(context).push("/login");
                                    },
                              trailing: constrains.smAndDown
                                  ? null
                                  : FilledButton(
                                      onPressed: () {
                                        GoRouter.of(context).push("/login");
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        context.l10n.connect_with_spotify
                                            .toUpperCase(),
                                      ),
                                    ),
                            );
                          })
                        else
                          Builder(builder: (context) {
                            return ListTile(
                              leading: const Icon(SpotubeIcons.logout),
                              title: SizedBox(
                                height: 50,
                                width: 180,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    context.l10n.logout_of_this_account,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              trailing: FilledButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () async {
                                  ref
                                      .read(AuthenticationNotifier
                                          .provider.notifier)
                                      .logout();
                                  GoRouter.of(context).pop();
                                },
                                child: Text(context.l10n.logout),
                              ),
                            );
                          }),
                      ],
                    ),
                    SectionCardWithHeading(
                      heading: context.l10n.language_region,
                      children: [
                        AdaptiveSelectTile<Locale>(
                          value: preferences.locale,
                          onChanged: (locale) {
                            if (locale == null) return;
                            preferences.setLocale(locale);
                          },
                          title: Text(context.l10n.language),
                          secondary: const Icon(SpotubeIcons.language),
                          options: [
                            DropdownMenuItem(
                              value: const Locale("system", "system"),
                              child: Text(context.l10n.system_default),
                            ),
                            for (final locale in L10n.all)
                              DropdownMenuItem(
                                value: locale,
                                child: Builder(builder: (context) {
                                  final isoCodeName =
                                      LanguageLocals.getDisplayLanguage(
                                    locale.languageCode,
                                  );
                                  return Text(
                                    "${isoCodeName.name} (${isoCodeName.nativeName})",
                                  );
                                }),
                              ),
                          ],
                        ),
                        AdaptiveSelectTile<Market>(
                          breakLayout: mediaQuery.lgAndUp,
                          secondary: const Icon(SpotubeIcons.shoppingBag),
                          title: Text(context.l10n.market_place_region),
                          subtitle: Text(context.l10n.recommendation_country),
                          value: preferences.recommendationMarket,
                          onChanged: (value) {
                            if (value == null) return;
                            preferences.setRecommendationMarket(value);
                          },
                          options: spotifyMarkets
                              .map(
                                (country) => DropdownMenuItem(
                                  value: country.$1,
                                  child: Text(country.$2),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    SectionCardWithHeading(
                      heading: context.l10n.appearance,
                      children: [
                        AdaptiveSelectTile<LayoutMode>(
                          secondary: const Icon(SpotubeIcons.dashboard),
                          title: Text(context.l10n.layout_mode),
                          subtitle: Text(context.l10n.override_layout_settings),
                          value: preferences.layoutMode,
                          onChanged: (value) {
                            if (value != null) {
                              preferences.setLayoutMode(value);
                            }
                          },
                          options: [
                            DropdownMenuItem(
                              value: LayoutMode.adaptive,
                              child: Text(context.l10n.adaptive),
                            ),
                            DropdownMenuItem(
                              value: LayoutMode.compact,
                              child: Text(context.l10n.compact),
                            ),
                            DropdownMenuItem(
                              value: LayoutMode.extended,
                              child: Text(context.l10n.extended),
                            ),
                          ],
                        ),
                        AdaptiveSelectTile<ThemeMode>(
                          secondary: const Icon(SpotubeIcons.darkMode),
                          title: Text(context.l10n.theme),
                          value: preferences.themeMode,
                          options: [
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text(context.l10n.dark),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text(context.l10n.light),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text(context.l10n.system),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              preferences.setThemeMode(value);
                            }
                          },
                        ),
                        SwitchListTile(
                          secondary: const Icon(SpotubeIcons.amoled),
                          title: Text(context.l10n.use_amoled_dark_theme),
                          value: preferences.amoledDarkTheme,
                          onChanged: preferences.setAmoledDarkTheme,
                        ),
                        ListTile(
                          leading: const Icon(SpotubeIcons.palette),
                          title: Text(context.l10n.accent_color),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          trailing: ColorTile.compact(
                            color: preferences.accentColorScheme,
                            onPressed: pickColorScheme(),
                            isActive: true,
                          ),
                          onTap: pickColorScheme(),
                        ),
                        SwitchListTile(
                          secondary: const Icon(SpotubeIcons.colorSync),
                          title: Text(context.l10n.sync_album_color),
                          subtitle:
                              Text(context.l10n.sync_album_color_description),
                          value: preferences.albumColorSync,
                          onChanged: preferences.setAlbumColorSync,
                        ),
                      ],
                    ),
                    SectionCardWithHeading(
                      heading: context.l10n.playback,
                      children: [
                        AdaptiveSelectTile<AudioQuality>(
                          secondary: const Icon(SpotubeIcons.audioQuality),
                          title: Text(context.l10n.audio_quality),
                          value: preferences.audioQuality,
                          options: [
                            DropdownMenuItem(
                              value: AudioQuality.high,
                              child: Text(context.l10n.high),
                            ),
                            DropdownMenuItem(
                              value: AudioQuality.low,
                              child: Text(context.l10n.low),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              preferences.setAudioQuality(value);
                            }
                          },
                        ),
                        AdaptiveSelectTile<YoutubeApiType>(
                          secondary: const Icon(SpotubeIcons.api),
                          title: Text(context.l10n.youtube_api_type),
                          value: preferences.youtubeApiType,
                          options: YoutubeApiType.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.label),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            preferences.setYoutubeApiType(value);
                          },
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: preferences.youtubeApiType ==
                                  YoutubeApiType.youtube
                              ? const SizedBox.shrink()
                              : Consumer(builder: (context, ref, child) {
                                  final instanceList =
                                      ref.watch(pipedInstancesFutureProvider);

                                  return instanceList.when(
                                    data: (data) {
                                      return AdaptiveSelectTile<String>(
                                        secondary:
                                            const Icon(SpotubeIcons.piped),
                                        title:
                                            Text(context.l10n.piped_instance),
                                        subtitle: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: context
                                                    .l10n.piped_description,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                              const TextSpan(text: "\n"),
                                              TextSpan(
                                                text:
                                                    context.l10n.piped_warning,
                                                style:
                                                    theme.textTheme.labelMedium,
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
                                                        text:
                                                            "${e.name.trim()}\n",
                                                        style: theme.textTheme
                                                            .labelLarge,
                                                      ),
                                                      TextSpan(
                                                        text: e.locations
                                                            .map(
                                                                countryCodeToEmoji)
                                                            .join(""),
                                                        style: GoogleFonts
                                                            .notoColorEmoji(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            preferences.setPipedInstance(value);
                                          }
                                        },
                                      );
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, stackTrace) =>
                                        Text(error.toString()),
                                  );
                                }),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: preferences.youtubeApiType ==
                                  YoutubeApiType.youtube
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
                                    preferences.setSearchMode(value);
                                  },
                                ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: preferences.searchMode ==
                                      SearchMode.youtubeMusic &&
                                  preferences.youtubeApiType ==
                                      YoutubeApiType.piped
                              ? const SizedBox.shrink()
                              : SwitchListTile(
                                  secondary: const Icon(SpotubeIcons.skip),
                                  title: Text(context.l10n.skip_non_music),
                                  value: preferences.skipNonMusic,
                                  onChanged: (state) {
                                    preferences.setSkipNonMusic(state);
                                  },
                                ),
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
                          secondary: const Icon(SpotubeIcons.playlistRemove),
                          title: Text(context.l10n.normalize_audio),
                          subtitle: Text(context.l10n.blacklist_description),
                          value: preferences.normalizeAudio,
                          onChanged: preferences.setNormalizeAudio,
                        ),
                      ],
                    ),
                    SectionCardWithHeading(
                      heading: context.l10n.downloads,
                      children: [
                        ListTile(
                          leading: const Icon(SpotubeIcons.download),
                          title: Text(context.l10n.download_location),
                          subtitle: Text(preferences.downloadLocation),
                          trailing: FilledButton(
                            onPressed: pickDownloadLocation,
                            child: const Icon(SpotubeIcons.folder),
                          ),
                          onTap: pickDownloadLocation,
                        ),
                        SwitchListTile(
                          secondary: const Icon(SpotubeIcons.lyrics),
                          title: Text(context.l10n.download_lyrics),
                          value: preferences.saveTrackLyrics,
                          onChanged: (state) {
                            preferences.setSaveTrackLyrics(state);
                          },
                        ),
                      ],
                    ),
                    if (DesktopTools.platform.isDesktop)
                      SectionCardWithHeading(
                        heading: context.l10n.desktop,
                        children: [
                          AdaptiveSelectTile<CloseBehavior>(
                            secondary: const Icon(SpotubeIcons.close),
                            title: Text(context.l10n.close_behavior),
                            value: preferences.closeBehavior,
                            options: [
                              DropdownMenuItem(
                                value: CloseBehavior.close,
                                child: Text(context.l10n.close),
                              ),
                              DropdownMenuItem(
                                value: CloseBehavior.minimizeToTray,
                                child: Text(context.l10n.minimize_to_tray),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                preferences.setCloseBehavior(value);
                              }
                            },
                          ),
                          SwitchListTile(
                            secondary: const Icon(SpotubeIcons.tray),
                            title: Text(context.l10n.show_tray_icon),
                            value: preferences.showSystemTrayIcon,
                            onChanged: preferences.setShowSystemTrayIcon,
                          ),
                          SwitchListTile(
                            secondary: const Icon(SpotubeIcons.window),
                            title: Text(context.l10n.use_system_title_bar),
                            value: preferences.systemTitleBar,
                            onChanged: preferences.setSystemTitleBar,
                          ),
                        ],
                      ),
                    if (!kIsWeb)
                      SectionCardWithHeading(
                        heading: context.l10n.developers,
                        children: [
                          ListTile(
                            leading: const Icon(SpotubeIcons.logs),
                            title: Text(context.l10n.logs),
                            trailing: const Icon(SpotubeIcons.angleRight),
                            onTap: () {
                              GoRouter.of(context).push("/settings/logs");
                            },
                          )
                        ],
                      ),
                    SectionCardWithHeading(
                      heading: context.l10n.about,
                      children: [
                        AdaptiveListTile(
                          leading: const Icon(
                            SpotubeIcons.heart,
                            color: Colors.pink,
                          ),
                          title: SizedBox(
                            height: 50,
                            width: 200,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                context.l10n.u_love_spotube,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          trailing: (context, update) => FilledButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red[100]),
                              foregroundColor: const MaterialStatePropertyAll(
                                  Colors.pinkAccent),
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(15)),
                            ),
                            onPressed: () {
                              launchUrlString(
                                "https://opencollective.com/spotube",
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(SpotubeIcons.heart),
                                const SizedBox(width: 5),
                                Text(context.l10n.please_sponsor),
                              ],
                            ),
                          ),
                        ),
                        if (Env.enableUpdateChecker)
                          SwitchListTile(
                            secondary: const Icon(SpotubeIcons.update),
                            title: Text(context.l10n.check_for_updates),
                            value: preferences.checkUpdate,
                            onChanged: (checked) =>
                                preferences.setCheckUpdate(checked),
                          ),
                        ListTile(
                          leading: const Icon(SpotubeIcons.info),
                          title: Text(context.l10n.about_spotube),
                          trailing: const Icon(SpotubeIcons.angleRight),
                          onTap: () {
                            GoRouter.of(context).push("/settings/about");
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
