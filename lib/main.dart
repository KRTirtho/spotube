import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Artist/ArtistAlbumView.dart';
import 'package:spotube/components/Artist/ArtistProfile.dart';
import 'package:spotube/components/Home/Home.dart';
import 'package:spotube/components/Playlist/PlaylistView.dart';
import 'package:spotube/components/Settings.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/ThemeProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();
  runApp(ProviderScope(child: MyApp()));
  doWhenWindowReady(() {
    appWindow.minSize =
        Size(Platform.isAndroid || Platform.isIOS ? 280 : 359, 700);
    appWindow.size = const Size(900, 700);
    appWindow.alignment = Alignment.center;
    appWindow.maximize();
    appWindow.show();
  });
}

class MyApp extends HookConsumerWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: "/settings",
        pageBuilder: (context, state) => SpotubePage(
          child: const Settings(),
        ),
      ),
      GoRoute(
        path: "/album/:id",
        pageBuilder: (context, state) {
          assert(state.extra is AlbumSimple);
          return SpotubePage(child: AlbumView(state.extra as AlbumSimple));
        },
      ),
      GoRoute(
        path: "/artist/:id",
        pageBuilder: (context, state) {
          assert(state.params["id"] != null);
          return SpotubePage(child: ArtistProfile(state.params["id"]!));
        },
      ),
      GoRoute(
        path: "/artist-album/:id",
        pageBuilder: (context, state) {
          assert(state.params["id"] != null);
          assert(state.extra is String);
          return SpotubePage(
            child: ArtistAlbumView(
              state.params["id"]!,
              state.extra as String,
            ),
          );
        },
      ),
      GoRoute(
        path: "/playlist/:id",
        pageBuilder: (context, state) {
          assert(state.extra is PlaylistSimple);
          return SpotubePage(
            child: PlaylistView(state.extra as PlaylistSimple),
          );
        },
      ),
    ],
  );
  @override
  Widget build(BuildContext context, ref) {
    var themeMode = ref.watch(themeProvider);
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
      return null;
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
