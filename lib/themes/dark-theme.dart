import 'package:flutter/material.dart';
import 'package:spotube/extensions/ShimmerColorTheme.dart';

ThemeData darkTheme({
  required MaterialColor accentMaterialColor,
  required MaterialColor backgroundMaterialColor,
}) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: [
      ShimmerColorTheme(
        shimmerBackgroundColor: backgroundMaterialColor[700],
        shimmerColor: backgroundMaterialColor[800],
      )
    ],
    primaryColor: accentMaterialColor,
    primarySwatch: accentMaterialColor,
    backgroundColor: backgroundMaterialColor[900],
    scaffoldBackgroundColor: backgroundMaterialColor[900],
    dialogBackgroundColor: backgroundMaterialColor[800],
    shadowColor: Colors.black26,
    buttonTheme: ButtonThemeData(
      buttonColor: accentMaterialColor,
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
          color: backgroundMaterialColor[800]!,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: backgroundMaterialColor[800],
      unselectedIconTheme: IconThemeData(color: Colors.grey[300], opacity: 1),
      selectedIconTheme: IconThemeData(color: backgroundMaterialColor[850]),
      selectedLabelTextStyle: TextStyle(color: accentMaterialColor[300]),
      unselectedLabelTextStyle: TextStyle(color: Colors.grey[300]),
      indicatorColor: accentMaterialColor[300],
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: backgroundMaterialColor[800],
      height: 55,
      indicatorColor: accentMaterialColor[300],
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: backgroundMaterialColor[900],
      elevation: 20,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: accentMaterialColor[300],
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: backgroundMaterialColor[800],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
    dialogTheme: DialogTheme(backgroundColor: backgroundMaterialColor[900]),
    cardColor: backgroundMaterialColor[800],
    canvasColor: backgroundMaterialColor[900],
  );
}
