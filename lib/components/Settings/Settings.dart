import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Settings/ColorSchemePickerDialog.dart';
import 'package:spotube/components/Settings/SettingsHotkeyTile.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/hooks/usePackageInfo.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/SpotifyMarkets.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Settings extends HookConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final Auth auth = ref.watch(authProvider);
    final geniusAccessToken = useState<String?>(null);
    TextEditingController geniusTokenController = useTextEditingController();
    final ytSearchFormatController =
        useTextEditingController(text: preferences.ytSearchFormat);

    geniusTokenController.addListener(() {
      geniusAccessToken.value = geniusTokenController.value.text;
    });

    ytSearchFormatController.addListener(() {
      preferences.setYtSearchFormat(ytSearchFormatController.value.text);
    });

    final packageInfo = usePackageInfo(
      appName: 'Spotube',
      packageName: 'spotube',
    );

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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Genius Access Token",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: geniusTokenController,
                              decoration: InputDecoration(
                                hintText: preferences.geniusAccessToken,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: geniusAccessToken.value != null
                                  ? () async {
                                      SharedPreferences localStorage =
                                          await SharedPreferences.getInstance();
                                      if (geniusAccessToken.value != null &&
                                          geniusAccessToken.value!.isNotEmpty) {
                                        preferences.setGeniusAccessToken(
                                          geniusAccessToken.value!,
                                        );
                                        localStorage.setString(
                                            LocalStorageKeys.geniusAccessToken,
                                            geniusAccessToken.value!);
                                      }

                                      geniusAccessToken.value = null;
                                      geniusTokenController.text = "";
                                    }
                                  : null,
                              child: const Text("Save"),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Theme"),
                          DropdownButton<ThemeMode>(
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
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: const Text("Accent Color Scheme"),
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
                        trailing: ColorTile(
                          color: preferences.backgroundColorScheme,
                          onPressed:
                              pickColorScheme(ColorSchemeType.background),
                          isActive: true,
                        ),
                        onTap: pickColorScheme(ColorSchemeType.background),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Market Place (Recommendation Country)"),
                          DropdownButton(
                            value: preferences.recommendationMarket,
                            items: spotifyMarkets
                                .map((country) => (DropdownMenuItem(
                                      child: Text(country),
                                      value: country,
                                    )))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              preferences
                                  .setRecommendationMarket(value as String);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Download lyrics along with the Track"),
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            value: preferences.saveTrackLyrics,
                            onChanged: (state) {
                              preferences.setSaveTrackLyrics(state);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                                "Format of the YouTube Search term (Case sensitive)"),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: ytSearchFormatController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (auth.isAnonymous)
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text("Login with your Spotify account"),
                            ElevatedButton(
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
                            )
                          ],
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text("Check for Update)"),
                          ),
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            value: preferences.checkUpdate,
                            onChanged: (checked) =>
                                preferences.setCheckUpdate(checked),
                          )
                        ],
                      ),
                      if (auth.isLoggedIn)
                        Builder(builder: (context) {
                          Auth auth = ref.watch(authProvider);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Log out of this account"),
                              ElevatedButton(
                                child: const Text("Logout"),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                                onPressed: () async {
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  await localStorage.clear();
                                  auth.logout();
                                  GoRouter.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }),
                      const SizedBox(height: 40),
                      Text(
                        "Spotube v${packageInfo.version}",
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Author: "),
                          Hyperlink(
                            "Kingkor Roy Tirtho",
                            "https://github.com/KRTirtho",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: const [
                          Hyperlink(
                            "💚 Sponsor/Donate 💚",
                            "https://opencollective.com/spotube",
                          ),
                          Text(" • "),
                          Hyperlink(
                            "BSD-4-Clause LICENSE",
                            "https://github.com/KRTirtho/spotube/blob/master/LICENSE",
                          ),
                          Text(" • "),
                          Hyperlink(
                            "Bug Report",
                            "https://github.com/KRTirtho/spotube/issues/new?assignees=&labels=bug&template=bug_report.md&title=",
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text("© Spotube 2022. All rights reserved")
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
