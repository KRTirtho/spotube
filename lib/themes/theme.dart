import 'package:flutter/material.dart';

ThemeData theme(Color seed, Brightness brightness, bool isAmoled) {
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    shadow: Colors.black12,
    surface: isAmoled ? Colors.black : null,
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    listTileTheme: ListTileThemeData(
      horizontalTitleGap: 5,
      iconColor: scheme.onSurface,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      elevation: 0,
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
      iconTheme: WidgetStatePropertyAll(
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
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: scheme.surface,
      elevation: 4,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(color: scheme.onSurface),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: scheme.onSurface,
      contentTextStyle: TextStyle(color: scheme.surface),
    ),
    sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
    searchBarTheme: SearchBarThemeData(
      textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 15)),
      constraints: const BoxConstraints(maxWidth: double.infinity),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
      backgroundColor: WidgetStatePropertyAll(
        Color.lerp(
          scheme.surfaceContainerHighest,
          scheme.surface,
          brightness == Brightness.light ? .9 : .7,
        ),
      ),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thickness: WidgetStatePropertyAll(14),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
