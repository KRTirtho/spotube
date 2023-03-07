import 'package:adwaita/adwaita.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:spotube/extensions/theme.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

ThemeData theme(Color seed, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    shadow: Colors.black12,
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    listTileTheme: ListTileThemeData(
      horizontalTitleGap: 0,
      iconColor: scheme.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    iconTheme: IconThemeData(size: 16, color: scheme.onSurface),
    navigationBarTheme: const NavigationBarThemeData(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      height: 50,
      iconTheme: MaterialStatePropertyAll(
        IconThemeData(size: 18),
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      labelColor: scheme.primary,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      indicator: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

final windowsTheme = fluent_ui.ThemeData.light().copyWith(
  iconTheme: const IconThemeData(size: 16),
  buttonTheme: fluent_ui.ButtonThemeData(
    iconButtonStyle: fluent_ui.ButtonStyle(
      iconSize: fluent_ui.ButtonState.all(20),
    ),
  ),
);
final windowsDarkTheme = fluent_ui.ThemeData.dark().copyWith(
  iconTheme: const IconThemeData(size: 16),
  buttonTheme: fluent_ui.ButtonThemeData(
    iconButtonStyle: fluent_ui.ButtonStyle(
      iconSize: fluent_ui.ButtonState.all(20),
    ),
  ),
);
final macosTheme = MacosThemeData.light().copyWith(
  pushButtonTheme: const PushButtonThemeData(
    secondaryColor: Colors.white,
  ),
  iconTheme: const MacosIconThemeData(size: 16),
  typography: MacosTypography(color: Colors.grey[900]!),
);
final macosDarkTheme = MacosThemeData.dark().copyWith(
  pushButtonTheme: const PushButtonThemeData(
    secondaryColor: Colors.white,
  ),
  iconTheme: const MacosIconThemeData(size: 16),
  typography: MacosTypography(color: MacosColors.textColor),
);
const iosTheme = CupertinoThemeData(brightness: Brightness.light);
const iosDarkTheme = CupertinoThemeData(
  brightness: Brightness.dark,
);

final linuxTheme = AdwaitaThemeData.light().copyWith(
  primaryColor: const Color(0xFF3582e5),
  iconTheme: const IconThemeData(size: 16),
  extensions: [
    ShimmerColorTheme(
      shimmerBackgroundColor: Colors.grey[300],
      shimmerColor: Colors.grey[400],
    )
  ],
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF3582e5);
      }
      return Colors.grey[300];
    }),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF3582e5),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF3582e5),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Colors.grey[900],
    horizontalTitleGap: 0,
  ),
);
final linuxDarkTheme = AdwaitaThemeData.dark().copyWith(
  iconTheme: IconThemeData(size: 16, color: Colors.grey[50]),
  extensions: [
    ShimmerColorTheme(
      shimmerBackgroundColor: Colors.grey[800],
      shimmerColor: Colors.grey[900],
    )
  ],
  listTileTheme: ListTileThemeData(
    iconColor: Colors.grey[50],
    horizontalTitleGap: 0,
  ),
);
