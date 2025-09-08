import 'package:shadcn_flutter/shadcn_flutter.dart';

extension CopyWithButtonVarianceExtension on ButtonVariance {
  ButtonVariance copyWith({
    ButtonStateProperty<EdgeInsets>? padding,
    ButtonStateProperty<Decoration>? decoration,
    ButtonStateProperty<MouseCursor>? mouseCursor,
    ButtonStateProperty<IconThemeData>? iconTheme,
    ButtonStateProperty<EdgeInsets>? margin,
    ButtonStateProperty<TextStyle>? textStyle,
  }) {
    return ButtonVariance(
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      iconTheme: iconTheme ?? this.iconTheme,
      margin: margin ?? this.margin,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
