import 'package:audio_service/audio_service.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dbus/dbus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/entities/CacheTrack.dart';
import 'package:spotube/interfaces/media_player2.dart';
import 'package:spotube/models/GoRouteDeclarations.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/DBus.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/themes/dark-theme.dart';
import 'package:spotube/themes/light-theme.dart';
import 'package:spotube/utils/AudioPlayerHandler.dart';
import 'package:spotube/utils/platform.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CacheTrackAdapter());
  Hive.registerAdapter(CacheTrackEngagementAdapter());
  AudioPlayerHandler audioPlayerHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.krtirtho.Spotube',
      androidNotificationChannelName: 'Spotube',
      androidNotificationOngoing: true,
    ),
  );
  if (kIsDesktop) {
    WidgetsFlutterBinding.ensureInitialized();
    // final client = DBusClient.session();
    // await client.registerObject(Media_Player());
    doWhenWindowReady(() {
      appWindow.minSize = const Size(359, 700);
      appWindow.alignment = Alignment.center;
      appWindow.title = "Spotube";
      appWindow.maximize();
      appWindow.show();
    });
  }
  runApp(ProviderScope(
    child: Spotube(),
    overrides: [
      playbackProvider.overrideWithProvider(ChangeNotifierProvider(
        (ref) {
          final youtube = ref.watch(youtubeProvider);
          final dbus = ref.watch(dbusClientProvider);
          return Playback(
            player: audioPlayerHandler,
            youtube: youtube,
            ref: ref,
            dbus: dbus,
          );
        },
      ))
    ],
  ));
}

class Spotube extends HookConsumerWidget {
  final GoRouter _router = createGoRouter();
  final logger = getLogger(Spotube);

  Spotube({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
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

    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'Spotube',
      theme: lightTheme(
        accentMaterialColor: accentMaterialColor,
        backgroundMaterialColor: backgroundMaterialColor,
      ),
      darkTheme: darkTheme(
        accentMaterialColor: accentMaterialColor,
        backgroundMaterialColor: backgroundMaterialColor,
      ),
      themeMode: themeMode,
    );
  }
}
