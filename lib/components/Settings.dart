import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Settings/SettingsHotkeyTile.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/ThemeProvider.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Settings extends HookConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final ThemeMode theme = ref.watch(themeProvider);
    final Auth auth = ref.watch(authProvider);
    var geniusAccessToken = useState<String?>(null);
    TextEditingController textEditingController = useTextEditingController();

    textEditingController.addListener(() {
      geniusAccessToken.value = textEditingController.value.text;
    });

    return SafeArea(
      child: Scaffold(
        appBar: PageWindowTitleBar(
          leading: const BackButton(),
          center: Text(
            "Settings",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: Padding(
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
                      controller: textEditingController,
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
                              preferences.setGeniusAccessToken(
                                  geniusAccessToken.value);
                              localStorage.setString(
                                  LocalStorageKeys.geniusAccessToken,
                                  geniusAccessToken.value ?? "");

                              geniusAccessToken.value = null;

                              textEditingController.text = "";
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
                    value: theme,
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
                        ref.read(themeProvider.notifier).state = value;
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              if (auth.isAnonymous)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Login with your Spotify"),
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
              const Text("Spotube v1.2.0"),
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
    );
  }
}
