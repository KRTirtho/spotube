import 'package:flutter/widgets.dart';

extension ContainerBreakpoints on BoxConstraints {
  bool get isXs => biggest.width <= 480;
  bool get isSm => biggest.width > 480 && biggest.width <= 640;
  bool get isMd => biggest.width > 640 && biggest.width <= 820;
  bool get isLg => biggest.width > 820 && biggest.width <= 1024;
  bool get isXl => biggest.width > 1024 && biggest.width <= 1280;
  bool get is2Xl => biggest.width > 1280;

  bool get smAndUp => isSm || isMd || isLg || isXl || is2Xl;
  bool get mdAndUp => isMd || isLg || isXl || is2Xl;
  bool get lgAndUp => isLg || isXl || is2Xl;
  bool get xlAndUp => isXl || is2Xl;

  bool get smAndDown => isXs || isSm;
  bool get mdAndDown => isXs || isSm || isMd;
  bool get lgAndDown => isXs || isSm || isMd || isLg;
  bool get xlAndDown => isXs || isSm || isMd || isLg || isXl;
}

extension ScreenBreakpoints on MediaQueryData {
  bool get isXs => size.width <= 480;
  bool get isSm => size.width > 480 && size.width <= 640;
  bool get isMd => size.width > 640 && size.width <= 820;
  bool get isLg => size.width > 820 && size.width <= 1024;
  bool get isXl => size.width > 1024 && size.width <= 1280;
  bool get is2Xl => size.width > 1280;

  bool get smAndUp => isSm || isMd || isLg || isXl || is2Xl;
  bool get mdAndUp => isMd || isLg || isXl || is2Xl;
  bool get lgAndUp => isLg || isXl || is2Xl;
  bool get xlAndUp => isXl || is2Xl;

  bool get smAndDown => isXs || isSm;
  bool get mdAndDown => isXs || isSm || isMd;
  bool get lgAndDown => isXs || isSm || isMd || isLg;
  bool get xlAndDown => isXs || isSm || isMd || isLg || isXl;
}
