import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/models/GoRouteDeclarations.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/AudioPlayer.dart';
import 'package:spotube/provider/ThemeProvider.dart';
import 'package:spotube/provider/YouTube.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  if (Platform.isAndroid || Platform.isIOS) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'oss.krtirtho.Spotube',
      androidNotificationChannelName: 'Spotube',
      androidNotificationOngoing: true,
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await hotKeyManager.unregisterAll();
    doWhenWindowReady(() {
      appWindow.minSize =
          Size(Platform.isAndroid || Platform.isIOS ? 280 : 359, 700);
      appWindow.size = const Size(900, 700);
      appWindow.alignment = Alignment.center;
      appWindow.maximize();
      appWindow.show();
    });
  }
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  final GoRouter _router = createGoRouter();

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    var themeMode = ref.watch(themeProvider);
    var player = ref.watch(audioPlayerProvider);
    var youtube = ref.watch(youtubeProvider);
    useEffect(() {
      SharedPreferences.getInstance().then((localStorage) {
        String? themeMode = localStorage.getString(LocalStorageKeys.themeMode);
        var themeNotifier = ref.read(themeProvider.notifier);

        switch (themeMode) {
          case "light":
            themeNotifier.state = ThemeMode.light;
            break;
          case "dark":
            themeNotifier.state = ThemeMode.dark;
            break;
          default:
            themeNotifier.state = ThemeMode.system;
        }
      });
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
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.green,
        ),
        shadowColor: Colors.grey[300],
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.grey[850]),
          headline1: TextStyle(color: Colors.grey[850]),
          headline2: TextStyle(color: Colors.grey[850]),
          headline3: TextStyle(color: Colors.grey[850]),
          headline4: TextStyle(color: Colors.grey[850]),
          headline5: TextStyle(color: Colors.grey[850]),
          headline6: TextStyle(color: Colors.grey[850]),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.grey[850],
          horizontalTitleGap: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green[400]!,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.blueGrey[50],
          unselectedIconTheme:
              IconThemeData(color: Colors.grey[850], opacity: 1),
          unselectedLabelTextStyle: TextStyle(
            color: Colors.grey[850],
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.blueGrey[50],
          height: 55,
        ),
        cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        backgroundColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.blueGrey[900],
        dialogBackgroundColor: Colors.blueGrey[800],
        shadowColor: Colors.black26,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.green,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green[400]!,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.blueGrey[800],
          unselectedIconTheme: const IconThemeData(opacity: 1),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.blueGrey[800],
          height: 55,
        ),
        cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.blueGrey[900],
          elevation: 20,
        ),
        canvasColor: Colors.blueGrey[900],
      ),
      themeMode: themeMode,
    );
  }
}
