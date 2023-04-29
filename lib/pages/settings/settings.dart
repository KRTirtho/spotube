import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/env.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/components/shared/adaptive/adaptive_list_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/downloader_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final auth = ref.watch(AuthenticationNotifier.provider);
    final isDownloading =
        ref.watch(downloaderProvider.select((s) => s.currentlyRunning > 0));
    final theme = Theme.of(context);

    final pickColorScheme = useCallback(() {
      return () => showDialog(
          context: context,
          builder: (context) {
            return const ColorSchemePickerDialog();
          });
    }, []);

    final pickDownloadLocation = useCallback(() async {
      final dirStr = await FilePicker.platform.getDirectoryPath(
        dialogTitle: context.l10n.download_location,
      );
      if (dirStr == null) return;
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
                    Text(
                      " ${context.l10n.account}",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (auth == null)
                      AdaptiveListTile(
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
                        trailing: (context, update) => FilledButton(
                          onPressed: () {
                            GoRouter.of(context).push("/login");
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          child: Text(
                            context.l10n.connect_with_spotify.toUpperCase(),
                          ),
                        ),
                      )
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
                                  .read(
                                      AuthenticationNotifier.provider.notifier)
                                  .logout();
                              GoRouter.of(context).pop();
                            },
                            child: Text(context.l10n.logout),
                          ),
                        );
                      }),
                    Text(
                      " ${context.l10n.language_region}",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: const Icon(SpotubeIcons.language),
                      title: Text(context.l10n.language),
                      trailing: DropdownButton<Locale>(
                        value: preferences.locale,
                        items: [
                          DropdownMenuItem(
                            value: const Locale("system"),
                            child: Text(context.l10n.system_default),
                          ),
                          for (final locale in L10n.all)
                            DropdownMenuItem(
                              value: locale,
                              child: Text(locale.languageCode),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            preferences.setLocale(value);
                          }
                        },
                      ),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.shoppingBag),
                      title: Text(context.l10n.market_place_region),
                      subtitle: Text(context.l10n.recommendation_country),
                      trailing: (context, update) => ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: DropdownMenu(
                          initialSelection: preferences.recommendationMarket,
                          dropdownMenuEntries: spotifyMarkets
                              .map(
                                (country) => DropdownMenuEntry(
                                  value: country.first,
                                  label: country.last,
                                ),
                              )
                              .toList(),
                          onSelected: (value) {
                            if (value == null) return;
                            preferences.setRecommendationMarket(
                              value as String,
                            );
                            update?.call(() {});
                          },
                        ),
                      ),
                    ),
                    Text(
                      " ${context.l10n.appearance}",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.dashboard),
                      title: Text(context.l10n.layout_mode),
                      subtitle: Text(context.l10n.override_layout_settings),
                      trailing: (context, update) => DropdownButton<LayoutMode>(
                        items: [
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
                        value: preferences.layoutMode,
                        onChanged: (value) {
                          if (value != null) {
                            preferences.setLayoutMode(value);
                            update?.call(() {});
                          }
                        },
                      ),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.darkMode),
                      title: Text(context.l10n.theme),
                      trailing: (context, update) => DropdownButton<ThemeMode>(
                        value: preferences.themeMode,
                        items: [
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
                            update?.call(() {});
                          }
                        },
                      ),
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
                      subtitle: Text(context.l10n.sync_album_color_description),
                      value: preferences.albumColorSync,
                      onChanged: preferences.setAlbumColorSync,
                    ),
                    Text(
                      " ${context.l10n.playback}",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.audioQuality),
                      title: Text(context.l10n.audio_quality),
                      trailing: (context, update) =>
                          DropdownButton<AudioQuality>(
                        value: preferences.audioQuality,
                        items: [
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
                            update?.call(() {});
                          }
                        },
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.download),
                      title: Text(context.l10n.pre_download_play),
                      subtitle:
                          Text(context.l10n.pre_download_play_description),
                      value: preferences.predownload,
                      onChanged: (state) {
                        preferences.setPredownload(state);
                      },
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.fastForward),
                      title: Text(context.l10n.skip_non_music),
                      value: preferences.skipSponsorSegments,
                      onChanged: (state) {
                        preferences.setSkipSponsorSegments(state);
                      },
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
                    Text(
                      " ${context.l10n.downloads}",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Tooltip(
                      message: isDownloading
                          ? context.l10n.wait_for_download_to_finish
                          : "",
                      child: ListTile(
                        leading: const Icon(SpotubeIcons.download),
                        title: Text(context.l10n.download_location),
                        subtitle: Text(preferences.downloadLocation),
                        trailing: FilledButton(
                          onPressed:
                              isDownloading ? null : pickDownloadLocation,
                          child: const Icon(SpotubeIcons.folder),
                        ),
                        onTap: isDownloading ? null : pickDownloadLocation,
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.lyrics),
                      title: Text(context.l10n.download_lyrics),
                      value: preferences.saveTrackLyrics,
                      onChanged: (state) {
                        preferences.setSaveTrackLyrics(state);
                      },
                    ),
                    if (DesktopTools.platform.isDesktop) ...[
                      Text(
                        " ${context.l10n.desktop}",
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      AdaptiveListTile(
                        leading: const Icon(SpotubeIcons.close),
                        title: Text(context.l10n.close_behavior),
                        trailing: (context, update) =>
                            DropdownButton<CloseBehavior>(
                          value: preferences.closeBehavior,
                          items: [
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
                              update?.call(() {});
                            }
                          },
                        ),
                      ),
                      SwitchListTile(
                        secondary: const Icon(SpotubeIcons.tray),
                        title: Text(context.l10n.show_tray_icon),
                        value: preferences.showSystemTrayIcon,
                        onChanged: preferences.setShowSystemTrayIcon,
                      ),
                    ],
                    Text(
                      " ${context.l10n.about}",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
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
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.pinkAccent),
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
