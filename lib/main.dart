import 'dart:io';

import 'package:args/args.dart';
import 'package:catcher/catcher.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/shared/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/entities/cache_track.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/downloader_provider.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/pocketbase.dart';
import 'package:spotube/services/youtube.dart';
import 'package:spotube/themes/theme.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:system_theme/system_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/hooks/use_init_sys_tray.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main(List<String> rawArgs) async {
  final parser = ArgParser();

  parser.addFlag(
    'verbose',
    abbr: 'v',
    help: 'Verbose mode',
    defaultsTo: !kReleaseMode,
    callback: (verbose) {
      if (verbose) {
        logEnv['VERBOSE'] = 'true';
        logEnv['DEBUG'] = 'true';
        logEnv['ERROR'] = 'true';
      }
    },
  );
  parser.addFlag(
    "version",
    help: "Print version and exit",
    negatable: false,
  );

  parser.addFlag("help", abbr: "h", negatable: false);

  final arguments = parser.parse(rawArgs);

  if (arguments["help"] == true) {
    print(parser.usage);
    exit(0);
  }

  if (arguments["version"] == true) {
    final package = await PackageInfo.fromPlatform();
    print("Spotube v${package.version}");
    exit(0);
  }

  await PipedSpotube.initialize();
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (DesktopTools.platform.isWindows || DesktopTools.platform.isLinux) {
    MediaKit.ensureInitialized();
  }

  await DesktopTools.ensureInitialized(
    DesktopWindowOptions(
      hideTitleBar: true,
      title: "Spotube",
      backgroundColor: Colors.transparent,
      minimumSize: const Size(300, 700),
    ),
  );

  await SystemTheme.accentColor.load();
  MetadataGod.initialize();
  await QueryClient.initialize(
    cachePrefix: "oss.krtirtho.spotube",
    cacheDir: (await getApplicationSupportDirectory()).path,
  );
  await PersistedStateNotifier.initializeBoxes();
  Hive.registerAdapter(CacheTrackAdapter());
  Hive.registerAdapter(CacheTrackEngagementAdapter());
  Hive.registerAdapter(CacheTrackSkipSegmentAdapter());

  Catcher(
    enableLogger: arguments["verbose"],
    debugConfig: CatcherOptions(
      SilentReportMode(),
      [
        ConsoleHandler(
          enableDeviceParameters: false,
          enableApplicationParameters: false,
        ),
        FileHandler(await getLogsPath(), printLogs: false),
      ],
    ),
    releaseConfig: CatcherOptions(SilentReportMode(), [
      if (arguments["verbose"] ?? false)
        ConsoleHandler(
          enableDeviceParameters: false,
          enableApplicationParameters: false,
        ),
      FileHandler(
        await getLogsPath(),
        printLogs: false,
      ),
    ]),
    runAppFunction: () {
      runApp(
        Builder(
          builder: (context) {
            return ProviderScope(
              overrides: [
                downloaderProvider.overrideWith(
                  (ref) {
                    return Downloader(
                      ref,
                      queueInstance,
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
                          return showDialog<bool>(
                            context: context,
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
              child: QueryClientProvider(
                staleDuration: const Duration(minutes: 30),
                child: const Spotube(),
              ),
            );
          },
        ),
      );
    },
  );
  await initializePocketBase();
}

class Spotube extends StatefulHookConsumerWidget {
  const Spotube({Key? key}) : super(key: key);

  @override
  SpotubeState createState() => SpotubeState();

  static SpotubeState of(BuildContext context) =>
      context.findAncestorStateOfType<SpotubeState>()!;
}

class SpotubeState extends ConsumerState<Spotube> {
  final logger = getLogger(Spotube);
  SharedPreferences? localStorage;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(((value) => localStorage = value));
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(userPreferencesProvider.select((s) => s.themeMode));
    final accentMaterialColor =
        ref.watch(userPreferencesProvider.select((s) => s.accentColorScheme));
    final locale = ref.watch(userPreferencesProvider.select((s) => s.locale));
    final paletteColor =
        ref.watch(paletteProvider.select((s) => s?.dominantColor?.color));

    useInitSysTray(ref);

    useEffect(() {
      FlutterNativeSplash.remove();
      return () {
        /// For enabling hot reload for audio player
        if (!kDebugMode) return;
        audioPlayer.dispose();
        // youtube.close();
      };
    }, []);

    return MaterialApp.router(
      supportedLocales: L10n.all,
      locale: locale.languageCode == "system" ? null : locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: 'Spotube',
      builder: (context, child) {
        return DragToResizeArea(child: child!);
      },
      themeMode: themeMode,
      theme: theme(paletteColor ?? accentMaterialColor, Brightness.light),
      darkTheme: theme(paletteColor ?? accentMaterialColor, Brightness.dark),
      shortcuts: {
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
      },
      actions: {
        ...WidgetsApp.defaultActions,
        PlayPauseIntent: PlayPauseAction(),
        NavigationIntent: NavigationAction(),
        HomeTabIntent: HomeTabAction(),
        CloseAppIntent: CloseAppAction(),
      },
    );
  }
}
