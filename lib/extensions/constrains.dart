import 'package:flutter/widgets.dart';

extension ContainerBreakpoints on BoxConstraints {
  bool get isSm => biggest.width <= 640;
  bool get isMd => biggest.width > 640 && biggest.width <= 768;
  bool get isLg => biggest.width > 768 && biggest.width <= 1024;
  bool get isXl => biggest.width > 1024 && biggest.width <= 1280;
  bool get is2Xl => biggest.width > 1280;

  bool get mdAndUp => isMd || isLg || isXl || is2Xl;
  bool get lgAndUp => isLg || isXl || is2Xl;
  bool get xlAndUp => isXl || is2Xl;
}

extension ScreenBreakpoints on MediaQueryData {
  bool get isSm => size.width <= 640;
  bool get isMd => size.width > 640 && size.width <= 768;
  bool get isLg => size.width > 768 && size.width <= 1024;
  bool get isXl => size.width > 1024 && size.width <= 1280;
  bool get is2Xl => size.width > 1280;

  bool get mdAndUp => isMd || isLg || isXl || is2Xl;
  bool get lgAndUp => isLg || isXl || is2Xl;
  bool get xlAndUp => isXl || is2Xl;
}
