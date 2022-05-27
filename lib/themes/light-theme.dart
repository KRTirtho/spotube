import 'package:flutter/material.dart';

final materialWhite = MaterialColor(Colors.white.value, {
  50: Colors.white,
  100: Colors.blueGrey[50]!,
  200: Colors.white,
  300: Colors.white,
  400: Colors.white,
  500: Colors.blueGrey,
  600: Colors.white,
  700: Colors.white,
  800: Colors.white,
  900: Colors.white,
});

ThemeData lightTheme({
  required MaterialColor accentMaterialColor,
  required MaterialColor backgroundMaterialColor,
}) {
  return ThemeData(
    useMaterial3: true,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: accentMaterialColor[800],
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    cardColor: backgroundMaterialColor[50],
    canvasColor: backgroundMaterialColor[50],
  );
}
