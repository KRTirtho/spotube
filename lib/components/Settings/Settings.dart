import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Settings/About.dart';
import 'package:spotube/components/Settings/ColorSchemePickerDialog.dart';
import 'package:spotube/components/Settings/SettingsHotkeyTile.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/helpers/search-youtube.dart';
import 'package:spotube/models/SpotifyMarkets.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Settings extends HookConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final Auth auth = ref.watch(authProvider);
    final ytSearchFormatController =
        useTextEditingController(text: preferences.ytSearchFormat);

    ytSearchFormatController.addListener(() {
      preferences.setYtSearchFormat(ytSearchFormatController.value.text);
    });

    final pickColorScheme = useCallback((ColorSchemeType schemeType) {
      return () => showDialog(
          context: context,
          builder: (context) {
            return ColorSchemePickerDialog(
              schemeType: schemeType,
            );
          });
    }, []);

    return SafeArea(
      child: Scaffold(
        appBar: PageWindowTitleBar(
          leading: const BackButton(),
          center: Text(
            "Settings",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1366),
                child: ListView(
                  children: [
                    if (!Platform.isAndroid && !Platform.isIOS) ...[
                      SettingsHotKeyTile(
                        title: "Next track global shortcut",
                        currentHotKey: preferences.nextTrackHotKey,
                        onHotKeyRecorded: (value) {
                          preferences.setNextTrackHotKey(value);
                        },
                      ),
                      SettingsHotKeyTile(
                        title: "Prev track global shortcut",
                        currentHotKey: preferences.prevTrackHotKey,
                        onHotKeyRecorded: (value) {
                          preferences.setPrevTrackHotKey(value);
                        },
                      ),
                      SettingsHotKeyTile(
                        title: "Play/Pause global shortcut",
                        currentHotKey: preferences.playPauseHotKey,
                        onHotKeyRecorded: (value) {
                          preferences.setPlayPauseHotKey(value);
                        },
                      ),
                    ],
                    ListTile(
                      title: const Text("Theme"),
                      horizontalTitleGap: 10,
                      trailing: DropdownButton<ThemeMode>(
                        value: preferences.themeMode,
                        items: const [
                          DropdownMenuItem(
                            child: Text(
                              "Dark",
                            ),
                            value: ThemeMode.dark,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Light",
                            ),
                            value: ThemeMode.light,
                          ),
                          DropdownMenuItem(
                            child: Text("System"),
                            value: ThemeMode.system,
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            preferences.setThemeMode(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text("Accent Color Scheme"),
                      horizontalTitleGap: 10,
                      trailing: ColorTile(
                        color: preferences.accentColorScheme,
                        onPressed: pickColorScheme(ColorSchemeType.accent),
                        isActive: true,
                      ),
                      onTap: pickColorScheme(ColorSchemeType.accent),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text("Background Color Scheme"),
                      horizontalTitleGap: 10,
                      trailing: ColorTile(
                        color: preferences.backgroundColorScheme,
                        onPressed: pickColorScheme(ColorSchemeType.background),
                        isActive: true,
                      ),
                      onTap: pickColorScheme(ColorSchemeType.background),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title:
                          const Text("Market Place (Recommendation Country)"),
                      horizontalTitleGap: 10,
                      trailing: DropdownButton(
                        value: preferences.recommendationMarket,
                        items: spotifyMarkets
                            .map((country) => (DropdownMenuItem(
                                  child: Text(country),
                                  value: country,
                                )))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          preferences.setRecommendationMarket(value as String);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Download lyrics along with the Track"),
                      horizontalTitleGap: 10,
                      trailing: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: preferences.saveTrackLyrics,
                        onChanged: (state) {
                          preferences.setSaveTrackLyrics(state);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Format of the YouTube Search term (Case sensitive)",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: ytSearchFormatController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (auth.isAnonymous)
                      ListTile(
                        title: const Text("Login with your Spotify account"),
                        horizontalTitleGap: 10,
                        trailing: ElevatedButton(
                          child: Text("Connect with Spotify".toUpperCase()),
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
                        ),
                      ),
                    ListTile(
                      title: const Text("Check for Update"),
                      horizontalTitleGap: 10,
                      trailing: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: preferences.checkUpdate,
                        onChanged: (checked) =>
                            preferences.setCheckUpdate(checked),
                      ),
                    ),
                    ListTile(
                      title: const Text("Track Match Algorithm"),
                      horizontalTitleGap: 10,
                      trailing: DropdownButton<SpotubeTrackMatchAlgorithm>(
                        value: preferences.trackMatchAlgorithm,
                        items: const [
                          DropdownMenuItem(
                            child: Text(
                              "Popular from Author",
                            ),
                            value: SpotubeTrackMatchAlgorithm.authenticPopular,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Accurately Popular",
                            ),
                            value: SpotubeTrackMatchAlgorithm.popular,
                          ),
                          DropdownMenuItem(
                            child: Text("YouTube's choice is my choice"),
                            value: SpotubeTrackMatchAlgorithm.youtube,
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            preferences.setTrackMatchAlgorithm(value);
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Audio Quality"),
                      horizontalTitleGap: 10,
                      trailing: DropdownButton<AudioQuality>(
                        value: preferences.audioQuality,
                        items: const [
                          DropdownMenuItem(
                            child: Text(
                              "High",
                            ),
                            value: AudioQuality.high,
                          ),
                          DropdownMenuItem(
                            child: Text("Low"),
                            value: AudioQuality.low,
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            preferences.setAudioQuality(value);
                          }
                        },
                      ),
                    ),
                    if (auth.isLoggedIn)
                      Builder(builder: (context) {
                        Auth auth = ref.watch(authProvider);
                        return ListTile(
                          title: const Text("Log out of this account"),
                          horizontalTitleGap: 10,
                          trailing: ElevatedButton(
                            child: const Text("Logout"),
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
                          ),
                        );
                      }),
                    ListTile(
                      title: const Text(
                        "We know you Love Spotube",
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      horizontalTitleGap: 10,
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.favorite_outline_rounded),
                        label: const Text("Please Sponsor/Donate"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[100],
                          onPrimary: Colors.pinkAccent,
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () {
                          launchUrlString("https://opencollective.com/spotube",
                              mode: LaunchMode.externalApplication);
                        },
                      ),
                    ),
                    const About()
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
