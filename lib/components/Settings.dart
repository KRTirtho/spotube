import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Settings/SettingsHotkeyTile.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/main.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  TextEditingController? _textEditingController;
  String? _geniusAccessToken;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController?.addListener(() {
      setState(() {
        _geniusAccessToken = _textEditingController?.value.text;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences preferences = ref.watch(userPreferencesProvider);

    return Scaffold(
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
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: preferences.geniusAccessToken,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _geniusAccessToken != null
                        ? () async {
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();
                            preferences
                                .setGeniusAccessToken(_geniusAccessToken);
                            localStorage.setString(
                                LocalStorageKeys.geniusAccessToken,
                                _geniusAccessToken!);
                            setState(() {
                              _geniusAccessToken = null;
                            });
                            _textEditingController?.text = "";
                          }
                        : null,
                    child: const Text("Save"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Theme"),
                DropdownButton<ThemeMode>(
                  value: MyApp.of(context)?.getThemeMode(),
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
                      MyApp.of(context)?.setThemeMode(value);
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 10),
            Builder(builder: (context) {
              Auth auth = ref.watch(authProvider);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Log out of this account"),
                  ElevatedButton(
                    child: const Text("Logout"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () async {
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      await localStorage.clear();
                      auth.logout();
                      Navigator.of(context).pop();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
