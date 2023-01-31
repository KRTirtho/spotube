import 'package:flutter/material.dart';
import 'package:spotube/extensions/theme.dart';

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
    splashFactory: NoSplash.splashFactory,
    primarySwatch: accentMaterialColor,
    backgroundColor: backgroundMaterialColor[900],
    scaffoldBackgroundColor: backgroundMaterialColor[900],
    dialogBackgroundColor: backgroundMaterialColor[800],
    shadowColor: Colors.black26,
    buttonTheme: ButtonThemeData(
      buttonColor: accentMaterialColor,
    ),
    iconTheme: IconThemeData(size: 16, color: Colors.grey[50]),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: accentMaterialColor[400]!,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: backgroundMaterialColor[800]!,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: backgroundMaterialColor[800],
      unselectedIconTheme: IconThemeData(
        color: Colors.grey[300],
        opacity: 1,
        size: 18,
      ),
      selectedIconTheme: IconThemeData(
        color: backgroundMaterialColor[850],
        size: 18,
      ),
      selectedLabelTextStyle: TextStyle(color: accentMaterialColor[300]),
      unselectedLabelTextStyle: TextStyle(color: Colors.grey[300]),
      indicatorColor: accentMaterialColor[300],
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: backgroundMaterialColor[900],
      height: 45,
      indicatorColor: accentMaterialColor[300],
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(
            color: Colors.grey[900],
            size: 18,
          );
        }
        return IconThemeData(
          color: Colors.grey[300],
          size: 18,
        );
      }),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: backgroundMaterialColor[900],
      elevation: 20,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: accentMaterialColor[300],
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
    canvasColor: backgroundMaterialColor[800],
    listTileTheme: const ListTileThemeData(horizontalTitleGap: 0),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return accentMaterialColor[500];
        }
        return null;
      }),
    ),
    tabBarTheme: TabBarTheme(
      indicator: const BoxDecoration(color: Colors.transparent),
      labelColor: accentMaterialColor[500],
      unselectedLabelColor: Colors.white,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      unselectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundMaterialColor[900],
    ),
  );
}
