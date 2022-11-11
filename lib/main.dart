import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Shared/ReplaceDownloadedFileDialog.dart';
import 'package:spotube/entities/CacheTrack.dart';
import 'package:spotube/models/GoRouteDeclarations.dart';
import 'package:spotube/models/Intents.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/services/MobileAudioService.dart';
import 'package:spotube/themes/dark-theme.dart';
import 'package:spotube/themes/light-theme.dart';
import 'package:spotube/utils/platform.dart';

final bowl = QueryBowl(refetchOnExternalDataChange: true);
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CacheTrackAdapter());
  Hive.registerAdapter(CacheTrackEngagementAdapter());
  Hive.registerAdapter(CacheTrackSkipSegmentAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsDesktop) {
    doWhenWindowReady(() async {
      final localStorage = await SharedPreferences.getInstance();
      final rawSize = localStorage.getString(LocalStorageKeys.windowSizeInfo);
      final savedSize = rawSize != null ? json.decode(rawSize) : null;
      final double? height = savedSize?["height"];
      final double? width = savedSize?["width"];
      appWindow.minSize = const Size(359, 700);
      appWindow.alignment = Alignment.center;
      appWindow.title = "Spotube";
      if (height != null && width != null && height >= 700 && width >= 359) {
        appWindow.size = Size(width, height);
      } else {
        appWindow.maximize();
      }
      appWindow.show();
    });
  }
  MobileAudioService? audioServiceHandler;
  runApp(
    Builder(
      builder: (context) {
        return ProviderScope(
          overrides: [
            playbackProvider.overrideWithProvider(
              ChangeNotifierProvider(
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
            ),
            downloaderProvider.overrideWithProvider(
              ChangeNotifierProvider(
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
                              ReplaceDownloadedFileDialog(track: track),
                        ).then((s) => s ?? false);
                      } catch (e, stack) {
                        logger.e(
                          "onFileExists",
                          e,
                          stack,
                        );
                        return false;
                      }
                    },
                  );
                },
              ),
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final windowSameDimension = kIsMobile
        ? false
        : prevSize?.width == appWindow.size.width &&
            prevSize?.height == appWindow.size.height;

    if (localStorage == null || windowSameDimension || kIsMobile) return;
    localStorage!.setString(
      LocalStorageKeys.windowSizeInfo,
      jsonEncode({
        'width': appWindow.isMaximized ? 0.0 : appWindow.size.width,
        'height': appWindow.isMaximized ? 0.0 : appWindow.size.height,
      }),
    );
    prevSize = appWindow.size;
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
      windowButtonConfig: PlatformWindowButtonConfig(
        isMaximized: () => appWindow.isMaximized,
        onClose: appWindow.close,
        onRestore: appWindow.restore,
        onMaximize: appWindow.maximize,
        onMinimize: appWindow.minimize,
      ),
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
