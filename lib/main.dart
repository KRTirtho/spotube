import 'package:catcher/catcher.dart';
import 'package:device_preview/device_preview.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/hooks/use_disable_battery_optimizations.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/models/skip_segment.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/cli/cli.dart';
import 'package:spotube/services/connectivity_adapter.dart';
import 'package:spotube/themes/theme.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:system_theme/system_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/hooks/use_init_sys_tray.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

Future<void> main(List<String> rawArgs) async {
  final arguments = await startCLI(rawArgs);

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  MediaKit.ensureInitialized();

  // force High Refresh Rate on some Android devices (like One Plus)
  if (DesktopTools.platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
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

  if (!kIsWeb) {
    MetadataGod.initialize();
  }

  final hiveCacheDir =
      kIsWeb ? null : (await getApplicationSupportDirectory()).path;

  await QueryClient.initialize(
    cachePrefix: "oss.krtirtho.spotube",
    cacheDir: hiveCacheDir,
    connectivity: FlQueryInternetConnectionCheckerAdapter(),
  );
  Hive.registerAdapter(MatchedTrackAdapter());
  Hive.registerAdapter(SkipSegmentAdapter());
  Hive.registerAdapter(SearchModeAdapter());

  // Cache versioning entities with Adapter
  MatchedTrack.version = 'v1';
  SkipSegment.version = 'v1';

  await Hive.openLazyBox<MatchedTrack>(
    MatchedTrack.boxName,
    path: hiveCacheDir,
  );
  await Hive.openLazyBox(
    SkipSegment.boxName,
    path: hiveCacheDir,
  );
  await PersistedStateNotifier.initializeBoxes(
    path: hiveCacheDir,
  );

  Catcher(
    enableLogger: arguments["verbose"],
    debugConfig: CatcherOptions(
      SilentReportMode(),
      [
        ConsoleHandler(
          enableDeviceParameters: false,
          enableApplicationParameters: false,
        ),
        if (!kIsWeb) FileHandler(await getLogsPath(), printLogs: false),
      ],
    ),
    releaseConfig: CatcherOptions(
      SilentReportMode(),
      [
        if (arguments["verbose"] ?? false) ConsoleHandler(),
        if (!kIsWeb)
          FileHandler(
            await getLogsPath(),
            printLogs: false,
          ),
      ],
    ),
    runAppFunction: () {
      runApp(
        DevicePreview(
          availableLocales: L10n.all,
          enabled: false,
          data: const DevicePreviewData(
            isEnabled: false,
            orientation: Orientation.portrait,
          ),
          builder: (context) {
            return ProviderScope(
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
    final isAmoledTheme =
        ref.watch(userPreferencesProvider.select((s) => s.amoledDarkTheme));
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

    useDisableBatteryOptimizations();

    final lightTheme = useMemoized(
      () => theme(paletteColor ?? accentMaterialColor, Brightness.light, false),
      [paletteColor, accentMaterialColor],
    );
    final darkTheme = useMemoized(
      () => theme(
        paletteColor ?? accentMaterialColor,
        Brightness.dark,
        isAmoledTheme,
      ),
      [paletteColor, accentMaterialColor, isAmoledTheme],
    );

    return MaterialApp.router(
      supportedLocales: L10n.all,
      locale: locale.languageCode == "system" ? null : locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Spotube',
      builder: (context, child) {
        return DevicePreview.appBuilder(
          context,
          DragToResizeArea(child: child!),
        );
      },
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
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
          LogicalKeyboardKey.digit1,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): HomeTabIntent(ref, tab: HomeTabs.browse),
        LogicalKeySet(
          LogicalKeyboardKey.digit2,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): HomeTabIntent(ref, tab: HomeTabs.search),
        LogicalKeySet(
          LogicalKeyboardKey.digit3,
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
        ): HomeTabIntent(ref, tab: HomeTabs.library),
        LogicalKeySet(
          LogicalKeyboardKey.digit4,
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
