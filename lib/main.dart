import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:catcher/catcher.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/collections/cache_keys.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/components/shared/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/entities/cache_track.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/audio_player_provider.dart';
import 'package:spotube/provider/downloader_provider.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/provider/youtube_provider.dart';
import 'package:spotube/services/mobile_audio_service.dart';
import 'package:spotube/services/pocketbase.dart';
import 'package:spotube/themes/dark_theme.dart';
import 'package:spotube/themes/light_theme.dart';
import 'package:spotube/utils/platform.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

final bowl = QueryBowl();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CacheTrackAdapter());
  Hive.registerAdapter(CacheTrackEngagementAdapter());
  Hive.registerAdapter(CacheTrackSkipSegmentAdapter());
  await Env.configure();
  await initializePocketBase();
  if (kIsDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
      title: "Spotube",
    );
    setWindowMinSize(const Size(kReleaseMode ? 1020 : 300, 700));
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      final localStorage = await SharedPreferences.getInstance();
      final rawSize = localStorage.getString(LocalStorageKeys.windowSizeInfo);
      final savedSize = rawSize != null ? json.decode(rawSize) : null;
      final wasMaximized = savedSize?["maximized"] ?? false;
      final double? height = savedSize?["height"];
      final double? width = savedSize?["width"];
      await windowManager.setResizable(true);
      if (wasMaximized) {
        await windowManager.maximize();
      } else if (height != null && width != null) {
        await windowManager.setSize(Size(width, height));
      }
      await windowManager.show();
    });
  }
  MobileAudioService? audioServiceHandler;

  Catcher(
    debugConfig: CatcherOptions(
      SilentReportMode(),
      [
        ConsoleHandler(
          enableDeviceParameters: false,
          enableApplicationParameters: false,
        ),
        FileHandler(await getLogsPath(), printLogs: false),
        SnackbarHandler(
          const Duration(seconds: 5),
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: () {
              ScaffoldMessenger.of(
                Catcher.navigatorKey!.currentContext!,
              ).hideCurrentSnackBar();
            },
          ),
        ),
      ],
    ),
    releaseConfig: CatcherOptions(SilentReportMode(), [
      FileHandler(await getLogsPath(), printLogs: false),
    ]),
    runAppFunction: () {
      runApp(
        Builder(
          builder: (context) {
            return ProviderScope(
              overrides: [
                playbackProvider.overrideWith(
                  (ref) {
                    final youtube = ref.watch(youtubeProvider);
                    final player = ref.watch(audioPlayerProvider);

                    final playback = Playback(
                      player: player,
                      youtube: youtube,
                      ref: ref,
                    );

                    if (audioServiceHandler == null) {
                      AudioService.init(
                        builder: () => MobileAudioService(playback),
                        config: const AudioServiceConfig(
                          androidNotificationChannelId: 'com.krtirtho.Spotube',
                          androidNotificationChannelName: 'Spotube',
                          androidNotificationOngoing: true,
                        ),
                      ).then(
                        (value) {
                          playback.mobileAudioService = value;
                          audioServiceHandler = value;
                        },
                      );
                    }

                    return playback;
                  },
                ),
                downloaderProvider.overrideWith(
                  (ref) {
                    return Downloader(
                      ref,
                      queueInstance,
                      yt: ref.watch(youtubeProvider),
                      downloadPath: ref.watch(
                        userPreferencesProvider.select(
                          (s) => s.downloadLocation,
                        ),
                      ),
                      onFileExists: (track) {
                        final logger = getLogger(Downloader);
                        try {
                          logger.v(
                            "[onFileExists] download confirmation for ${track.name}",
                          );
                          return showPlatformAlertDialog<bool>(
                            context,
                            builder: (_) =>
                                ReplaceDownloadedDialog(track: track),
                          ).then((s) => s ?? false);
                        } catch (e, stack) {
                          Catcher.reportCheckedError(e, stack);
                          return false;
                        }
                      },
                    );
                  },
                )
              ],
              child: QueryBowlScope(
                bowl: bowl,
                child: const Spotube(),
              ),
            );
          },
        ),
      );
    },
  );
}

class Spotube extends StatefulHookConsumerWidget {
  const Spotube({Key? key}) : super(key: key);

  @override
  SpotubeState createState() => SpotubeState();

  /// ↓↓ ADDED
  /// InheritedWidget style accessor to our State object.
  static SpotubeState of(BuildContext context) =>
      context.findAncestorStateOfType<SpotubeState>()!;
}

class SpotubeState extends ConsumerState<Spotube> with WidgetsBindingObserver {
  final logger = getLogger(Spotube);
  SharedPreferences? localStorage;

  Size? prevSize;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(((value) => localStorage = value));
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        appPlatform = Theme.of(context).platform;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() async {
    super.didChangeMetrics();
    if (kIsMobile) return;
    final size = await windowManager.getSize();
    final windowSameDimension =
        prevSize?.width == size.width && prevSize?.height == size.height;

    if (localStorage == null || windowSameDimension) return;
    final isMaximized = await windowManager.isMaximized();
    localStorage!.setString(
      LocalStorageKeys.windowSizeInfo,
      jsonEncode({
        'maximized': isMaximized,
        'width': size.width,
        'height': size.height,
      }),
    );
    prevSize = size;
  }

  TargetPlatform appPlatform = TargetPlatform.android;

  void changePlatform(TargetPlatform targetPlatform) {
    appPlatform = targetPlatform;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(userPreferencesProvider.select((s) => s.themeMode));
    final accentMaterialColor =
        ref.watch(userPreferencesProvider.select((s) => s.accentColorScheme));
    final backgroundMaterialColor = ref
        .watch(userPreferencesProvider.select((s) => s.backgroundColorScheme));
    final player = ref.watch(audioPlayerProvider);
    final youtube = ref.watch(youtubeProvider);

    useEffect(() {
      return () {
        player.dispose();
        youtube.close();
      };
    }, []);

    platform = appPlatform;

    return PlatformApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: 'Spotube',
      builder: (context, child) {
        return DragToResizeArea(child: child!);
      },
      androidTheme: lightTheme(
        accentMaterialColor: accentMaterialColor,
        backgroundMaterialColor: backgroundMaterialColor,
      ),
      androidDarkTheme: darkTheme(
        accentMaterialColor: accentMaterialColor,
        backgroundMaterialColor: backgroundMaterialColor,
      ),
      linuxTheme: linuxTheme,
      linuxDarkTheme: linuxDarkTheme,
      iosTheme: themeMode == ThemeMode.dark ? iosDarkTheme : iosTheme,
      windowsTheme: windowsTheme,
      windowsDarkTheme: windowsDarkTheme,
      macosTheme: macosTheme,
      macosDarkTheme: macosDarkTheme,
      themeMode: themeMode,
      shortcuts: PlatformProperty.all({
        ...WidgetsApp.defaultShortcuts.map((key, value) {
          return MapEntry(
            LogicalKeySet.fromSet(key.triggers?.toSet() ?? {}),
            value,
          );
        }),
        LogicalKeySet(LogicalKeyboardKey.space): PlayPauseIntent(ref),
        LogicalKeySet(LogicalKeyboardKey.comma, LogicalKeyboardKey.control):
            NavigationIntent(router, "/settings"),
        LogicalKeySet(
          LogicalKeyboardKey.keyB,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): HomeTabIntent(ref, tab: HomeTabs.browse),
        LogicalKeySet(
          LogicalKeyboardKey.keyS,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): HomeTabIntent(ref, tab: HomeTabs.search),
        LogicalKeySet(
          LogicalKeyboardKey.keyL,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): HomeTabIntent(ref, tab: HomeTabs.library),
        LogicalKeySet(
          LogicalKeyboardKey.keyY,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): HomeTabIntent(ref, tab: HomeTabs.lyrics),
        LogicalKeySet(
          LogicalKeyboardKey.keyW,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): CloseAppIntent(),
      }),
      actions: PlatformProperty.all({
        ...WidgetsApp.defaultActions,
        PlayPauseIntent: PlayPauseAction(),
        NavigationIntent: NavigationAction(),
        HomeTabIntent: HomeTabAction(),
        CloseAppIntent: CloseAppAction(),
      }),
    );
  }
}
