import 'package:flutter/material.dart';

ThemeData theme(Color seed, Brightness brightness, bool isAmoled) {
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    shadow: Colors.black12,
    background: isAmoled ? Colors.black : null,
    surface: isAmoled ? Colors.black : null,
    brightness: brightness,
  );

  const borderRadius = BorderRadius.all(Radius.circular(15));
  const roundedRectangleBorder = RoundedRectangleBorder(borderRadius: borderRadius);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    listTileTheme: ListTileThemeData(
      horizontalTitleGap: 5,
      iconColor: scheme.onSurface,
    ),
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: borderRadius,
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
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: borderRadius,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: roundedRectangleBorder,
      color: scheme.surface,
      elevation: 4,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: roundedRectangleBorder,
      backgroundColor: scheme.onSurface,
      contentTextStyle: TextStyle(color: scheme.surface),
    ),
    sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
    searchBarTheme: SearchBarThemeData(
      textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 15)),
      constraints: const BoxConstraints(maxWidth: double.infinity),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(8)),
      backgroundColor: MaterialStatePropertyAll(
        Color.lerp(
          scheme.surfaceVariant,
          scheme.surface,
          brightness == Brightness.light ? .9 : .7,
        ),
      ),
      elevation: const MaterialStatePropertyAll(0),
      shape: MaterialStatePropertyAll(roundedRectangleBorder),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thickness: MaterialStatePropertyAll(14),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}