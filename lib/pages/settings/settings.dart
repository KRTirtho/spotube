import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/components/shared/adaptive/adaptive_list_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/main.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final Auth auth = ref.watch(authProvider);

    final pickColorScheme = useCallback((ColorSchemeType schemeType) {
      return () => showPlatformAlertDialog(context, builder: (context) {
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

    var ytSearchFormatController = useTextEditingController(
      text: preferences.ytSearchFormat,
    );

    return SafeArea(
      child: PlatformScaffold(
        appBar: PageWindowTitleBar(
          center: PlatformText.headline("Settings"),
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
                    PlatformText(
                      " Account",
                      style: PlatformTextTheme.of(context)
                          .headline
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (auth.isAnonymous)
                      AdaptiveListTile(
                        leading: Icon(
                          SpotubeIcons.login,
                          color: PlatformTheme.of(context).primaryColor,
                        ),
                        title: SizedBox(
                          height: 50,
                          width: 200,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              "Login with your Spotify account",
                              maxLines: 1,
                              style: TextStyle(
                                color: PlatformTheme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        trailing: (context, update) => PlatformFilledButton(
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
                          child: PlatformText(
                              "Connect with Spotify".toUpperCase()),
                        ),
                      ),
                    if (auth.isLoggedIn)
                      Builder(builder: (context) {
                        Auth auth = ref.watch(authProvider);
                        return PlatformListTile(
                          leading: const Icon(SpotubeIcons.logout),
                          title: SizedBox(
                            height: 50,
                            width: 180,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                "Log out of this account",
                                maxLines: 1,
                                style: PlatformTextTheme.of(context).body,
                              ),
                            ),
                          ),
                          trailing: PlatformFilledButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () async {
                              auth.logout();
                              GoRouter.of(context).pop();
                            },
                            child: const PlatformText("Logout"),
                          ),
                        );
                      }),
                    PlatformText(
                      " Appearance",
                      style: PlatformTextTheme.of(context)
                          .headline
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.dashboard),
                      title: const PlatformText("Layout Mode"),
                      subtitle: const PlatformText(
                        "Override responsive layout mode settings",
                      ),
                      trailing: (context, update) =>
                          PlatformDropDownMenu<LayoutMode>(
                        value: preferences.layoutMode,
                        items: [
                          PlatformDropDownMenuItem(
                            value: LayoutMode.adaptive,
                            child: const PlatformText(
                              "Adaptive",
                            ),
                          ),
                          PlatformDropDownMenuItem(
                            value: LayoutMode.compact,
                            child: const PlatformText(
                              "Compact",
                            ),
                          ),
                          PlatformDropDownMenuItem(
                            value: LayoutMode.extended,
                            child: const PlatformText("Extended"),
                          ),
                        ],
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
                      title: const PlatformText("Theme"),
                      trailing: (context, update) =>
                          PlatformDropDownMenu<ThemeMode>(
                        value: preferences.themeMode,
                        items: [
                          PlatformDropDownMenuItem(
                            value: ThemeMode.dark,
                            child: const PlatformText("Dark"),
                          ),
                          PlatformDropDownMenuItem(
                            value: ThemeMode.light,
                            child: const PlatformText("Light"),
                          ),
                          PlatformDropDownMenuItem(
                            value: ThemeMode.system,
                            child: const PlatformText("System"),
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
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.platform),
                      title: const PlatformText("Mimic Platform"),
                      trailing: (context, update) =>
                          DropdownButton<TargetPlatform>(
                        value: Spotube.of(context).appPlatform,
                        items: const [
                          DropdownMenuItem(
                            value: TargetPlatform.android,
                            child: PlatformText("Android (Material You)"),
                          ),
                          DropdownMenuItem(
                            value: TargetPlatform.iOS,
                            child: PlatformText("iOS (Cupertino)"),
                          ),
                          DropdownMenuItem(
                            value: TargetPlatform.macOS,
                            child: PlatformText("macOS (Aqua)"),
                          ),
                          DropdownMenuItem(
                            value: TargetPlatform.linux,
                            child: PlatformText("Linux (GTK+Libadwaita)"),
                          ),
                          DropdownMenuItem(
                            value: TargetPlatform.windows,
                            child: PlatformText("Windows 11 (Fluent UI)"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            Spotube.of(context).changePlatform(value);
                            update?.call(() {});
                          }
                        },
                      ),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.palette),
                      title: const PlatformText("Accent Color Scheme"),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      trailing: ColorTile(
                        color: preferences.accentColorScheme,
                        onPressed: pickColorScheme(ColorSchemeType.accent),
                        isActive: true,
                      ),
                      onTap: pickColorScheme(ColorSchemeType.accent),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.colorBucket),
                      title: const PlatformText("Background Color Scheme"),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      trailing: ColorTile(
                        color: preferences.backgroundColorScheme,
                        onPressed: pickColorScheme(ColorSchemeType.background),
                        isActive: true,
                      ),
                      onTap: pickColorScheme(ColorSchemeType.background),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.album),
                      title: const PlatformText("Rotating Album Art"),
                      trailing: PlatformSwitch(
                        value: preferences.rotatingAlbumArt,
                        onChanged: (state) {
                          preferences.setRotatingAlbumArt(state);
                        },
                      ),
                    ),
                    PlatformText(
                      " Playback",
                      style: PlatformTextTheme.of(context)
                          .headline
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.audioQuality),
                      title: const PlatformText("Audio Quality"),
                      trailing: (context, update) =>
                          PlatformDropDownMenu<AudioQuality>(
                        value: preferences.audioQuality,
                        items: [
                          PlatformDropDownMenuItem(
                            value: AudioQuality.high,
                            child: const PlatformText(
                              "High",
                            ),
                          ),
                          PlatformDropDownMenuItem(
                            value: AudioQuality.low,
                            child: const PlatformText("Low"),
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
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.download),
                      title: const PlatformText(
                        "Pre download and play",
                      ),
                      subtitle: const PlatformText(
                        "Instead of streaming audio, download bytes and play instead (Recommended for higher bandwidth users)",
                      ),
                      trailing: PlatformSwitch(
                        value: preferences.predownload,
                        onChanged: (state) {
                          preferences.setPredownload(state);
                        },
                      ),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.fastForward),
                      title: const PlatformText(
                        "Skip non-music segments (SponsorBlock)",
                      ),
                      trailing: PlatformSwitch(
                        value: preferences.skipSponsorSegments,
                        onChanged: (state) {
                          preferences.setSkipSponsorSegments(state);
                        },
                      ),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.playlistRemove),
                      title: const PlatformText("Blacklist"),
                      subtitle: const PlatformText(
                        "Blacklisted tracks and artists",
                      ),
                      onTap: () {
                        GoRouter.of(context).push("/settings/blacklist");
                      },
                      trailing: const Icon(SpotubeIcons.angleRight),
                    ),
                    PlatformText(
                      " Search",
                      style: PlatformTextTheme.of(context)
                          .headline
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.shoppingBag),
                      title: const PlatformText("Market Place"),
                      subtitle: PlatformText.caption(
                        "Recommendation Country",
                      ),
                      trailing: (context, update) => ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: PlatformDropDownMenu(
                          value: preferences.recommendationMarket,
                          items: spotifyMarkets
                              .map(
                                (country) => (PlatformDropDownMenuItem(
                                  value: country.first,
                                  child: PlatformText(country.last),
                                )),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            preferences.setRecommendationMarket(
                              value as String,
                            );
                            update?.call(() {});
                          },
                        ),
                      ),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.screenSearch),
                      title: const SizedBox(
                        height: 50,
                        width: 200,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "Format of the YouTube Search term",
                            maxLines: 2,
                          ),
                        ),
                      ),
                      subtitle: const PlatformText("(Case sensitive)"),
                      breakOn: Breakpoints.lg,
                      trailing: (context, update) => ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: PlatformTextField(
                          controller: ytSearchFormatController,
                          suffix: PlatformFilledButton(
                            child: const Icon(SpotubeIcons.save),
                            onPressed: () {
                              preferences.setYtSearchFormat(
                                ytSearchFormatController.value.text,
                              );
                            },
                          ),
                          onSubmitted: (value) {
                            preferences.setYtSearchFormat(value);
                            update?.call(() {});
                          },
                        ),
                      ),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(SpotubeIcons.barChart),
                      title: SizedBox(
                        height: 50,
                        width: 180,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "Track Match Algorithm",
                            maxLines: 1,
                            style: PlatformTextTheme.of(context).body,
                          ),
                        ),
                      ),
                      trailing: (context, update) =>
                          PlatformDropDownMenu<SpotubeTrackMatchAlgorithm>(
                        value: preferences.trackMatchAlgorithm,
                        items: [
                          PlatformDropDownMenuItem(
                            value: SpotubeTrackMatchAlgorithm.authenticPopular,
                            child: const PlatformText(
                              "Popular from Author",
                            ),
                          ),
                          PlatformDropDownMenuItem(
                            value: SpotubeTrackMatchAlgorithm.popular,
                            child: const PlatformText(
                              "Accurately Popular",
                            ),
                          ),
                          PlatformDropDownMenuItem(
                            value: SpotubeTrackMatchAlgorithm.youtube,
                            child: const PlatformText("YouTube's Top choice"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            preferences.setTrackMatchAlgorithm(value);
                            update?.call(() {});
                          }
                        },
                      ),
                    ),
                    PlatformText(
                      " Downloads",
                      style: PlatformTextTheme.of(context)
                          .headline
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.download),
                      title: const PlatformText("Download Location"),
                      subtitle: PlatformText(preferences.downloadLocation),
                      trailing: PlatformFilledButton(
                        onPressed: pickDownloadLocation,
                        child: const Icon(SpotubeIcons.folder),
                      ),
                      onTap: pickDownloadLocation,
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.lyrics),
                      title: const PlatformText(
                          "Download lyrics along with the Track"),
                      trailing: PlatformSwitch(
                        value: preferences.saveTrackLyrics,
                        onChanged: (state) {
                          preferences.setSaveTrackLyrics(state);
                        },
                      ),
                    ),
                    PlatformText(
                      " About",
                      style: PlatformTextTheme.of(context)
                          .headline
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
                      trailing: (context, update) => PlatformFilledButton(
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
                            PlatformText("Please Sponsor/Donate"),
                          ],
                        ),
                      ),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.update),
                      title: const PlatformText("Check for Update"),
                      trailing: PlatformSwitch(
                        value: preferences.checkUpdate,
                        onChanged: (checked) =>
                            preferences.setCheckUpdate(checked),
                      ),
                    ),
                    PlatformListTile(
                      leading: const Icon(SpotubeIcons.info),
                      title: const PlatformText("About Spotube"),
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
