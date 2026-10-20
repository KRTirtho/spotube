import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotube/theme/spotify_colors.dart';

class SpotifyTypography {
  static const double _letterSpacing = -0.04;

  static TextTheme buildTextTheme(BuildContext context) {
    final base = GoogleFonts.poppinsTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: SpotifyColors.primaryText,
        letterSpacing: _letterSpacing,
      ),
      displayMedium: base.displayMedium!.copyWith(
        fontWeight: FontWeight.w700,
        color: SpotifyColors.primaryText,
        letterSpacing: _letterSpacing,
      ),
      displaySmall: base.displaySmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: SpotifyColors.primaryText,
        letterSpacing: _letterSpacing,
      ),
      headlineLarge: base.headlineLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: SpotifyColors.primaryText,
        letterSpacing: _letterSpacing,
      ),
      headlineMedium: base.headlineMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: SpotifyColors.primaryText,
        letterSpacing: _letterSpacing,
      ),
      headlineSmall: base.headlineSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: SpotifyColors.primaryText,
        letterSpacing: _letterSpacing,
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: SpotifyColors.primaryText,
        fontSize: 16,
        letterSpacing: _letterSpacing,
      ),
      titleMedium: base.titleMedium!.copyWith(
        fontWeight: FontWeight.w700,
        color: SpotifyColors.primaryText,
        fontSize: 14,
        letterSpacing: _letterSpacing,
      ),
      titleSmall: base.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: SpotifyColors.primaryText,
        fontSize: 14,
        letterSpacing: _letterSpacing,
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        fontWeight: FontWeight.w400,
        color: SpotifyColors.primaryText,
        fontSize: 16,
        letterSpacing: _letterSpacing,
      ),
      bodyMedium: base.bodyMedium!.copyWith(
        fontWeight: FontWeight.w400,
        color: SpotifyColors.primaryText,
        fontSize: 14,
        letterSpacing: _letterSpacing,
      ),
      bodySmall: base.bodySmall!.copyWith(
        fontWeight: FontWeight.w400,
        color: SpotifyColors.secondaryText,
        fontSize: 13,
        letterSpacing: _letterSpacing,
      ),
      labelLarge: base.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: SpotifyColors.primaryText,
        fontSize: 12,
        letterSpacing: 0.16,
      ),
      labelMedium: base.labelMedium!.copyWith(
        fontWeight: FontWeight.w500,
        color: SpotifyColors.secondaryText,
        fontSize: 11,
        letterSpacing: 0.16,
      ),
      labelSmall: base.labelSmall!.copyWith(
        fontWeight: FontWeight.w500,
        color: SpotifyColors.disabledText,
        fontSize: 11,
        letterSpacing: 0.16,
      ),
    );
  }

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
}
