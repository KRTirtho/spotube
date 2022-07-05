import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useCustomStatusBarColor(
  Color color,
  bool isCurrentRoute, {
  bool noSetBGColor = false,
}) {
  final context = useContext();
  final backgroundColor = Theme.of(context).backgroundColor;
  resetStatusbar() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: backgroundColor, // status bar color
          statusBarIconBrightness: backgroundColor.computeLuminance() > 0.179
              ? Brightness.dark
              : Brightness.light,
        ),
      );

  final statusBarColor = SystemChrome.latestStyle?.statusBarColor;

  useEffect(() {
    if (isCurrentRoute && statusBarColor != color) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor:
              noSetBGColor ? Colors.transparent : color, // status bar color
          statusBarIconBrightness: color.computeLuminance() > 0.179
              ? Brightness.dark
              : Brightness.light,
        ),
      );
    } else if (!isCurrentRoute && statusBarColor == color) {
      resetStatusbar();
    }
    return;
  }, [color, isCurrentRoute, statusBarColor]);

  useEffect(() {
    return resetStatusbar;
  }, []);
}
