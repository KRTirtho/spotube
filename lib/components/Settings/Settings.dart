import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Settings/About.dart';
import 'package:spotube/components/Settings/ColorSchemePickerDialog.dart';
import 'package:spotube/components/Shared/AdaptiveListTile.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/SpotifyMarkets.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/platform.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Settings extends HookConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final UserPreferences preferences = ref.watch(userPreferencesProvider);
    final Auth auth = ref.watch(authProvider);

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

    var ytSearchFormatController = useTextEditingController(
      text: preferences.ytSearchFormat,
    );

    return SafeArea(
      child: Scaffold(
        appBar: PageWindowTitleBar(
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
                    const Text(
                      " Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    if (auth.isAnonymous)
                      AdaptiveListTile(
                        leading: Icon(
                          Icons.login_rounded,
                          color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        trailing: (context, update) => ElevatedButton(
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
                      ),
                    if (auth.isLoggedIn)
                      Builder(builder: (context) {
                        Auth auth = ref.watch(authProvider);
                        return ListTile(
                          leading: const Icon(Icons.logout_rounded),
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
                          trailing: ElevatedButton(
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
                            child: const Text("Logout"),
                          ),
                        );
                      }),
                    const Text(
                      " Appearance",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(Icons.dashboard_rounded),
                      title: const Text("Layout Mode"),
                      subtitle: const Text(
                        "Override responsive layout mode settings",
                      ),
                      trailing: (context, update) => DropdownButton<LayoutMode>(
                        value: preferences.layoutMode,
                        items: const [
                          DropdownMenuItem(
                            value: LayoutMode.adaptive,
                            child: Text(
                              "Adaptive",
                            ),
                          ),
                          DropdownMenuItem(
                            value: LayoutMode.compact,
                            child: Text(
                              "Compact",
                            ),
                          ),
                          DropdownMenuItem(
                            value: LayoutMode.extended,
                            child: Text("Extended"),
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
                      leading: const Icon(Icons.dark_mode_outlined),
                      title: const Text("Theme"),
                      trailing: (context, update) => DropdownButton<ThemeMode>(
                        value: preferences.themeMode,
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(
                              "Dark",
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(
                              "Light",
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text("System"),
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
                      leading: const Icon(Icons.palette_outlined),
                      title: const Text("Accent Color Scheme"),
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
                    ListTile(
                      leading: const Icon(Icons.format_color_fill_rounded),
                      title: const Text("Background Color Scheme"),
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
                    ListTile(
                      leading: const Icon(Icons.album_rounded),
                      title: const Text("Rotating Album Art"),
                      trailing: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: preferences.rotatingAlbumArt,
                        onChanged: (state) {
                          preferences.setRotatingAlbumArt(state);
                        },
                      ),
                    ),
                    const Text(
                      " Playback",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(Icons.multitrack_audio_rounded),
                      title: const Text("Audio Quality"),
                      trailing: (context, update) =>
                          DropdownButton<AudioQuality>(
                        value: preferences.audioQuality,
                        items: const [
                          DropdownMenuItem(
                            value: AudioQuality.high,
                            child: Text(
                              "High",
                            ),
                          ),
                          DropdownMenuItem(
                            value: AudioQuality.low,
                            child: Text("Low"),
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
                    if (kIsMobile)
                      ListTile(
                        leading: const Icon(Icons.download_for_offline_rounded),
                        title: const Text(
                          "Pre download and play",
                        ),
                        subtitle: const Text(
                          "Instead of streaming audio, download bytes and play instead (Recommended for higher bandwidth users)",
                        ),
                        trailing: Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor,
                          value: preferences.androidBytesPlay,
                          onChanged: (state) {
                            preferences.setAndroidBytesPlay(state);
                          },
                        ),
                      ),
                    ListTile(
                      leading: const Icon(Icons.fast_forward_rounded),
                      title: const Text(
                        "Skip non-music segments (SponsorBlock)",
                      ),
                      trailing: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: preferences.skipSponsorSegments,
                        onChanged: (state) {
                          preferences.setSkipSponsorSegments(state);
                        },
                      ),
                    ),
                    const Text(
                      " Search",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(Icons.shopping_bag_rounded),
                      title: Text(
                        "Market Place",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      subtitle: Text(
                        "Recommendation Country",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      trailing: (context, update) => ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: DropdownButton(
                          isExpanded: true,
                          value: preferences.recommendationMarket,
                          items: spotifyMarkets
                              .map(
                                (country) => (DropdownMenuItem(
                                  value: country.first,
                                  child: Text(country.last),
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
                      leading: const Icon(Icons.screen_search_desktop_rounded),
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
                      subtitle: const Text("(Case sensitive)"),
                      breakOn: Breakpoints.lg,
                      trailing: (context, update) => ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: TextField(
                          controller: ytSearchFormatController,
                          decoration: InputDecoration(
                            isDense: true,
                            suffix: ElevatedButton(
                              child: const Icon(Icons.save_rounded),
                              onPressed: () {
                                preferences.setYtSearchFormat(
                                  ytSearchFormatController.value.text,
                                );
                              },
                            ),
                          ),
                          onSubmitted: (value) {
                            preferences.setYtSearchFormat(value);
                            update?.call(() {});
                          },
                        ),
                      ),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(Icons.low_priority_rounded),
                      title: const SizedBox(
                        height: 50,
                        width: 180,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            "Track Match Algorithm",
                            maxLines: 1,
                          ),
                        ),
                      ),
                      trailing: (context, update) =>
                          DropdownButton<SpotubeTrackMatchAlgorithm>(
                        value: preferences.trackMatchAlgorithm,
                        items: const [
                          DropdownMenuItem(
                            value: SpotubeTrackMatchAlgorithm.authenticPopular,
                            child: Text(
                              "Popular from Author",
                            ),
                          ),
                          DropdownMenuItem(
                            value: SpotubeTrackMatchAlgorithm.popular,
                            child: Text(
                              "Accurately Popular",
                            ),
                          ),
                          DropdownMenuItem(
                            value: SpotubeTrackMatchAlgorithm.youtube,
                            child: Text("YouTube's Top choice"),
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
                    const Text(
                      " Downloads",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined),
                      title: const Text("Download Location"),
                      subtitle: Text(preferences.downloadLocation),
                      trailing: ElevatedButton(
                        onPressed: pickDownloadLocation,
                        child: const Icon(Icons.folder_rounded),
                      ),
                      onTap: pickDownloadLocation,
                    ),
                    ListTile(
                      leading: const Icon(Icons.lyrics_rounded),
                      title: const Text("Download lyrics along with the Track"),
                      trailing: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: preferences.saveTrackLyrics,
                        onChanged: (state) {
                          preferences.setSaveTrackLyrics(state);
                        },
                      ),
                    ),
                    const Text(
                      " About",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    AdaptiveListTile(
                      leading: const Icon(
                        Icons.favorite_border_rounded,
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
                      trailing: (context, update) => ElevatedButton.icon(
                        icon: const Icon(Icons.favorite_outline_rounded),
                        label: const Text("Please Sponsor/Donate"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[100],
                          foregroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () {
                          launchUrlString(
                            "https://opencollective.com/spotube",
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.update_rounded),
                      title: const Text("Check for Update"),
                      trailing: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: preferences.checkUpdate,
                        onChanged: (checked) =>
                            preferences.setCheckUpdate(checked),
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
