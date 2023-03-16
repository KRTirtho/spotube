import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/components/shared/adaptive/adaptive_list_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final auth = ref.watch(AuthenticationNotifier.provider);
    final theme = Theme.of(context);

    final pickColorScheme = useCallback((ColorSchemeType schemeType) {
      return () => showDialog(
          context: context,
          builder: (context) {
            return ColorSchemePickerDialog(
              schemeType: schemeType,
            );
          });
    }, []);

    final pickDownloadLocation = useCallback(() async {
      final dirStr = await FilePicker.platform.getDirectoryPath(
        dialogTitle: "Download Location",
      );
      if (dirStr == null) return;
      preferences.setDownloadLocation(dirStr);
    }, [preferences.downloadLocation]);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: const PageWindowTitleBar(
          title: Text("Settings"),
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
                      " Account",
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
                            "Login with your Spotify account",
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
                          child: Text("Connect with Spotify".toUpperCase()),
                        ),
                      )
                    else
                      Builder(builder: (context) {
                        return ListTile(
                          leading: const Icon(SpotubeIcons.logout),
                          title: const SizedBox(
                            height: 50,
                            width: 180,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                "Log out of this account",
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
                            child: const Text("Logout"),
                          ),
                        );
                      }),
                    Text(
                      " Appearance",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.dashboard),
                      title: const Text("Layout Mode"),
                      subtitle: const Text(
                        "Override responsive layout mode settings",
                      ),
                      trailing: (context, update) => DropdownMenu<LayoutMode>(
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(
                            value: LayoutMode.adaptive,
                            label: "Adaptive",
                          ),
                          DropdownMenuEntry(
                            value: LayoutMode.compact,
                            label: "Compact",
                          ),
                          DropdownMenuEntry(
                            value: LayoutMode.extended,
                            label: "Extended",
                          ),
                        ],
                        initialSelection: preferences.layoutMode,
                        onSelected: (value) {
                          if (value != null) {
                            preferences.setLayoutMode(value);
                            update?.call(() {});
                          }
                        },
                      ),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.darkMode),
                      title: const Text("Theme"),
                      trailing: (context, update) => DropdownMenu<ThemeMode>(
                        initialSelection: preferences.themeMode,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(
                            value: ThemeMode.dark,
                            label: "Dark",
                          ),
                          DropdownMenuEntry(
                            value: ThemeMode.light,
                            label: "Light",
                          ),
                          DropdownMenuEntry(
                            value: ThemeMode.system,
                            label: "System",
                          ),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            preferences.setThemeMode(value);
                            update?.call(() {});
                          }
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(SpotubeIcons.palette),
                      title: const Text("Accent Color"),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      trailing: ColorTile.compact(
                        color: preferences.accentColorScheme,
                        onPressed: pickColorScheme(ColorSchemeType.accent),
                        isActive: true,
                      ),
                      onTap: pickColorScheme(ColorSchemeType.accent),
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.album),
                      title: const Text("Rotating Album Art"),
                      value: preferences.rotatingAlbumArt,
                      onChanged: (state) {
                        preferences.setRotatingAlbumArt(state);
                      },
                    ),
                    Text(
                      " Playback",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.audioQuality),
                      title: const Text("Audio Quality"),
                      trailing: (context, update) => DropdownMenu<AudioQuality>(
                        initialSelection: preferences.audioQuality,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(
                            value: AudioQuality.high,
                            label: "High",
                          ),
                          DropdownMenuEntry(
                            value: AudioQuality.low,
                            label: "Low",
                          ),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            preferences.setAudioQuality(value);
                            update?.call(() {});
                          }
                        },
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.download),
                      title: const Text("Pre download and play"),
                      subtitle: const Text(
                        "Instead of streaming audio, download bytes and play instead (Recommended for higher bandwidth users)",
                      ),
                      value: preferences.predownload,
                      onChanged: (state) {
                        preferences.setPredownload(state);
                      },
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.fastForward),
                      title: const Text(
                        "Skip non-music segments (SponsorBlock)",
                      ),
                      value: preferences.skipSponsorSegments,
                      onChanged: (state) {
                        preferences.setSkipSponsorSegments(state);
                      },
                    ),
                    ListTile(
                      leading: const Icon(SpotubeIcons.playlistRemove),
                      title: const Text("Blacklist"),
                      subtitle: const Text(
                        "Blacklisted tracks and artists",
                      ),
                      onTap: () {
                        GoRouter.of(context).push("/settings/blacklist");
                      },
                      trailing: const Icon(SpotubeIcons.angleRight),
                    ),
                    Text(
                      " Search",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.shoppingBag),
                      title: const Text("Market Place"),
                      subtitle: const Text("Recommendation Country"),
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
                      " Downloads",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: const Icon(SpotubeIcons.download),
                      title: const Text("Download Location"),
                      subtitle: Text(preferences.downloadLocation),
                      trailing: FilledButton(
                        onPressed: pickDownloadLocation,
                        child: const Icon(SpotubeIcons.folder),
                      ),
                      onTap: pickDownloadLocation,
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.lyrics),
                      title: const Text("Download lyrics along with the Track"),
                      value: preferences.saveTrackLyrics,
                      onChanged: (state) {
                        preferences.setSaveTrackLyrics(state);
                      },
                    ),
                    Text(
                      " About",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(
                        SpotubeIcons.heart,
                        color: Colors.pink,
                      ),
                      title: const SizedBox(
                        height: 50,
                        width: 200,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "We know you Love Spotube",
                            maxLines: 1,
                            style: TextStyle(
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
                          children: const [
                            Icon(SpotubeIcons.heart),
                            SizedBox(width: 5),
                            Text("Please Sponsor/Donate"),
                          ],
                        ),
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(SpotubeIcons.update),
                      title: const Text("Check for Update"),
                      value: preferences.checkUpdate,
                      onChanged: (checked) =>
                          preferences.setCheckUpdate(checked),
                    ),
                    ListTile(
                      leading: const Icon(SpotubeIcons.info),
                      title: const Text("About Spotube"),
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
