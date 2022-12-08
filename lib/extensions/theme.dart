import 'package:flutter/material.dart';

class ShimmerColorTheme extends ThemeExtension<ShimmerColorTheme> {
  final Color? shimmerColor;
  final Color? shimmerBackgroundColor;

  ShimmerColorTheme({
    this.shimmerBackgroundColor,
    this.shimmerColor,
  });

  @override
  ThemeExtension<ShimmerColorTheme> copyWith(
      {Color? shimmerColor, Color? shimmerBackgroundColor}) {
    return ShimmerColorTheme(
      shimmerBackgroundColor:
          shimmerBackgroundColor ?? this.shimmerBackgroundColor,
      shimmerColor: shimmerColor ?? this.shimmerColor,
    );
  }

  @override
  ThemeExtension<ShimmerColorTheme> lerp(
      ThemeExtension<ShimmerColorTheme>? other, double t) {
    if (other is! ShimmerColorTheme) {
      return this;
    }
    return ShimmerColorTheme(
      shimmerBackgroundColor:
          Color.lerp(shimmerBackgroundColor, other.shimmerBackgroundColor, t),
      shimmerColor: Color.lerp(shimmerColor, other.shimmerColor, t),
    );
  }
}
