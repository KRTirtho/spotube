import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:spotube/extensions/ShimmerColorTheme.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;

final materialWhite = MaterialColor(Colors.white.value, {
  50: Colors.white,
  100: Colors.blueGrey[100]!,
  200: Colors.white,
  300: Colors.white,
  400: Colors.blueGrey[300]!,
  500: Colors.blueGrey,
  600: Colors.white,
  700: Colors.grey[700]!,
  800: Colors.white,
  900: Colors.white,
});

ThemeData lightTheme({
  required MaterialColor accentMaterialColor,
  required MaterialColor backgroundMaterialColor,
}) {
  return ThemeData(
    useMaterial3: true,
    extensions: [
      ShimmerColorTheme(
        shimmerBackgroundColor: backgroundMaterialColor[200],
        shimmerColor: backgroundMaterialColor[300],
      )
    ],
    primaryColor: accentMaterialColor,
    primarySwatch: accentMaterialColor,
    buttonTheme: ButtonThemeData(
      buttonColor: accentMaterialColor,
    ),
    shadowColor: Colors.grey[300],
    backgroundColor: backgroundMaterialColor[50],
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
          color: accentMaterialColor[400]!,
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
      backgroundColor: backgroundMaterialColor[100],
      indicatorColor: accentMaterialColor[300],
      selectedIconTheme: IconThemeData(color: accentMaterialColor[850]),
      unselectedIconTheme: IconThemeData(color: Colors.grey[850], opacity: 1),
      unselectedLabelTextStyle: TextStyle(
        color: Colors.grey[850],
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: backgroundMaterialColor[100],
      height: 55,
      indicatorColor: accentMaterialColor[300],
      iconTheme: MaterialStateProperty.all(
        IconThemeData(color: Colors.grey[850]),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: backgroundMaterialColor[50],
    ),
    splashFactory: NoSplash.splashFactory,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: accentMaterialColor[800],
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: backgroundMaterialColor[100],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
    cardColor: backgroundMaterialColor[50],
    canvasColor: backgroundMaterialColor[50],
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return accentMaterialColor[500];
        }
      }),
    ),
    tabBarTheme: TabBarTheme(
      indicator: const BoxDecoration(color: Colors.transparent),
      labelColor: accentMaterialColor[500],
      unselectedLabelColor: Colors.grey[850],
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      unselectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    ),
  );
}

final windowsTheme = FluentUI.ThemeData.light().copyWith(
  buttonTheme: FluentUI.ButtonThemeData(
    iconButtonStyle: FluentUI.ButtonStyle(
      iconSize: FluentUI.ButtonState.all(20),
    ),
  ),
);
final windowsDarkTheme = FluentUI.ThemeData.dark().copyWith(
  buttonTheme: FluentUI.ButtonThemeData(
    iconButtonStyle: FluentUI.ButtonStyle(
      iconSize: FluentUI.ButtonState.all(20),
    ),
  ),
);
final macosTheme = MacosThemeData.light().copyWith(
  pushButtonTheme: PushButtonThemeData(
    secondaryColor: Colors.white,
  ),
  iconTheme: MacosIconThemeData(size: 16),
  iconButtonTheme: MacosIconButtonThemeData(),
);
final macosDarkTheme = MacosThemeData.dark();
final iosTheme = CupertinoThemeData();
