import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';

class SpotifyTheme {
  static ThemeData materialTheme(BuildContext context) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SpotifyColors.background,
      backgroundColor: SpotifyColors.background,
      cardColor: SpotifyColors.surface,
      dividerColor: SpotifyColors.separator,
      primaryColor: SpotifyColors.spotifyGreen,
      indicatorColor: SpotifyColors.spotifyGreen,
      focusColor: SpotifyColors.spotifyGreen,
      hoverColor: SpotifyColors.hover,
      highlightColor: SpotifyColors.hover.withValues(alpha: 0.1),
      splashColor: Colors.transparent,
      canvasColor: SpotifyColors.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: const IconThemeData(
        color: SpotifyColors.primaryText,
        size: 20,
      ),
      primaryIconTheme: const IconThemeData(
        color: SpotifyColors.primaryText,
      ),
      dividerTheme: const DividerThemeData(
        color: SpotifyColors.separator,
        space: 1,
        thickness: 1,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        selectedTileColor: SpotifyColors.hover,
        selectedColor: SpotifyColors.primaryText,
        unselectedColor: SpotifyColors.secondaryText,
        iconColor: SpotifyColors.secondaryText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SpotifyColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: SpotifyColors.hover),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: SpotifyColors.hover),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: SpotifyColors.spotifyGreen),
        ),
        hintStyle: textTheme.bodySmall?.copyWith(
          color: SpotifyColors.disabledText,
        ),
      ),
    );
  }

  static ShadcnThemeData shadcnTheme() {
    return const ShadcnThemeData(
      radius: 0.125,
      iconTheme: IconThemeProperties(),
      colorScheme: LegacyColorSchemes.darkSlate(),
      surfaceOpacity: 0,
      surfaceBlur: 0,
    );
  }
}
