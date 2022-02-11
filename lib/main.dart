import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Home.dart';
import 'package:spotube/models/LocalStorageKeys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();
  runApp(const ProviderScope(child: MyApp()));
  doWhenWindowReady(() {
    appWindow.minSize = const Size(900, 700);
    appWindow.size = const Size(900, 700);
    appWindow.alignment = Alignment.center;
    appWindow.maximize();
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String? themeMode = localStorage.getString(LocalStorageKeys.themeMode);

      setState(() {
        switch (themeMode) {
          case "light":
            _themeMode = ThemeMode.light;
            break;
          case "dark":
            _themeMode = ThemeMode.dark;
            break;
          default:
            _themeMode = ThemeMode.system;
        }
      });
    });
    super.initState();
  }

  void setThemeMode(ThemeMode themeMode) {
    SharedPreferences.getInstance().then((localStorage) {
      localStorage.setString(
          LocalStorageKeys.themeMode, themeMode.toString().split(".").last);
      setState(() {
        _themeMode = themeMode;
      });
    });
  }

  ThemeMode getThemeMode() {
    return _themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.blueGrey[900],
          elevation: 20,
        ),
        canvasColor: Colors.blueGrey[900],
      ),
      themeMode: _themeMode,
      home: const Home(),
    );
  }
}
