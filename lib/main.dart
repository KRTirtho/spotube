import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:spotube/models/GoRouteDeclarations.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:spotube/themes/dark-theme.dart';
import 'package:spotube/themes/light-theme.dart';
import 'package:spotube/utils/AudioPlayerHandler.dart';

void main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'oss.krtirtho.Spotube',
  //   androidNotificationChannelName: 'Spotube',
  //   androidNotificationOngoing: true,
  // );
  AudioPlayerHandler audioPlayerHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.krtirtho.Spotube',
      androidNotificationChannelName: 'Spotube',
      androidNotificationOngoing: true,
    ),
  );
  if (!Platform.isAndroid && !Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await hotKeyManager.unregisterAll();
    doWhenWindowReady(() {
      appWindow.minSize =
          Size(Platform.isAndroid || Platform.isIOS ? 280 : 359, 700);
      appWindow.size = const Size(900, 700);
      appWindow.alignment = Alignment.center;
      appWindow.maximize();
      appWindow.title = "Spotube";
      appWindow.show();
    });
  }
  runApp(ProviderScope(
    child: Spotube(),
    overrides: [
      playbackProvider.overrideWithProvider(ChangeNotifierProvider(
        (ref) {
          final youtube = ref.watch(youtubeProvider);
          final preferences = ref.watch(userPreferencesProvider);
          return Playback(
            player: audioPlayerHandler,
            youtube: youtube,
            preferences: preferences,
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
