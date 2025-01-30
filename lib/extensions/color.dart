import 'package:shadcn_flutter/shadcn_flutter.dart';

extension ColorAlterer on Color {
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  bool isLight() {
    final luminance = computeLuminance();
    return luminance > 0.5;
  }

  bool isDark() {
    final luminance = computeLuminance();
    return luminance <= 0.5;
  }
}
