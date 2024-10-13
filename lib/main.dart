import 'dart:async';
import 'dart:ui';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/collections/initializers.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/hooks/configurators/use_close_behavior.dart';
import 'package:spotube/hooks/configurators/use_deep_linking.dart';
import 'package:spotube/hooks/configurators/use_disable_battery_optimizations.dart';
import 'package:spotube/hooks/configurators/use_fix_window_stretching.dart';
import 'package:spotube/hooks/configurators/use_get_storage_perms.dart';
import 'package:spotube/hooks/configurators/use_has_touch.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/audio_player/audio_player_streams.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/server/bonsoir.dart';
import 'package:spotube/provider/server/server.dart';
import 'package:spotube/provider/tray_manager/tray_manager.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/cli/cli.dart';
import 'package:spotube/services/kv_store/encrypted_kv_store.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/services/wm_tools/wm_tools.dart';
import 'package:spotube/themes/theme.dart';
import 'package:spotube/utils/migrations/hive.dart';
import 'package:spotube/utils/migrations/sandbox.dart';
import 'package:spotube/utils/platform.dart';
import 'package:system_theme/system_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:window_manager/window_manager.dart';

Future<void> main(List<String> rawArgs) async {
  if (rawArgs.contains("web_view_title_bar")) {
    WidgetsFlutterBinding.ensureInitialized();
    if (runWebViewTitleBarWidget(rawArgs)) {
      return;
    }
  }
  final arguments = await startCLI(rawArgs);
  AppLogger.initialize(arguments["verbose"]);

  AppLogger.runZoned(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    await registerWindowsScheme("spotify");

    tz.initializeTimeZones();

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    MediaKit.ensureInitialized();

    await migrateMacOsFromSandboxToNoSandbox();

    // force High Refresh Rate on some Android devices (like One Plus)
    if (kIsAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }

    if (kIsDesktop) {
      await windowManager.setPreventClose(true);
    }

    await SystemTheme.accentColor.load();

    if (!kIsWeb) {
      MetadataGod.initialize();
    }

    if (kIsDesktop) {
      await FlutterDiscordRPC.initialize(Env.discordAppId);
    }

    if (kIsWindows) {
      await SMTCWindows.initialize();
    }

    await KVStoreService.initialize();
    await EncryptedKvStoreService.initialize();

    final hiveCacheDir =
        kIsWeb ? null : (await getApplicationSupportDirectory()).path;

    Hive.init(hiveCacheDir);

    final database = AppDatabase();

    await migrateFromHiveToDrift(database);

    if (kIsDesktop) {
      await localNotifier.setup(appName: "Spotube");
      await WindowManagerTools.initialize();
    }

    runApp(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) => database),
        ],
        observers: const [
          AppLoggerProviderObserver(),
        ],
        child: const Spotube(),
      ),
    );
  });
}

class Spotube extends HookConsumerWidget {
  const Spotube({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeMode =
        ref.watch(userPreferencesProvider.select((s) => s.themeMode));
    final accentMaterialColor =
        ref.watch(userPreferencesProvider.select((s) => s.accentColorScheme));
    final isAmoledTheme =
        ref.watch(userPreferencesProvider.select((s) => s.amoledDarkTheme));
    final locale = ref.watch(userPreferencesProvider.select((s) => s.locale));
    final paletteColor =
        ref.watch(paletteProvider.select((s) => s?.dominantColor?.color));
    final router = ref.watch(routerProvider);
    final hasTouchSupport = useHasTouch();

    ref.listen(audioPlayerStreamListenersProvider, (_, __) {});
    ref.listen(bonsoirProvider, (_, __) {});
    ref.listen(connectClientsProvider, (_, __) {});
    ref.listen(serverProvider, (_, __) {});
    ref.listen(trayManagerProvider, (_, __) {});

    useFixWindowStretching();
    useDisableBatteryOptimizations();
    useDeepLinking(ref);
    useCloseBehavior(ref);
    useGetStoragePermissions(ref);

    useEffect(() {
      FlutterNativeSplash.remove();

      return () {
        /// For enabling hot reload for audio player
        if (!kDebugMode) return;
        audioPlayer.dispose();
      };
    }, []);

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
        child = ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: hasTouchSupport
                ? {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.invertedStylus,
                  }
                : null,
          ),
          child: child!,
        );

        if (kIsDesktop && !kIsMacOS) child = DragToResizeArea(child: child);

        return child;
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
