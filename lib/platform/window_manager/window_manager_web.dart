// Web stub implementation - window manager not available on web

class WindowManager {
  static WindowManager get instance => WindowManager._();
  WindowManager._();
  
  Future<void> ensureInitialized() async {}
  Future<void> waitUntilReadyToShow() async {}
  Future<void> setTitle(String title) async {}
  Future<void> setTitleBarStyle(dynamic style, {dynamic windowButtonVisibility}) async {}
  Future<void> setSkipTaskbar(bool skip) async {}
  Future<void> setMinimumSize(dynamic size) async {}
  Future<void> center() async {}
  Future<void> show() async {}
  Future<void> hide() async {}
  Future<void> close() async {}
  Future<bool> isFocused() async => false;
  Future<bool> isVisible() async => false;
  Future<bool> isMinimized() async => false;
  Future<bool> isMaximized() async => false;
  Future<void> minimize() async {}
  Future<void> maximize() async {}
  Future<void> unmaximize() async {}
  Future<void> focus() async {}
  Future<void> blur() async {}
  Future<void> setAlwaysOnTop(bool flag) async {}
  Future<void> setSize(dynamic size) async {}
  Future<void> setPosition(dynamic position) async {}
  Future<dynamic> getSize() async => null;
  Future<dynamic> getPosition() async => null;
}

WindowManager get windowManager => WindowManager.instance;

class WindowListener {}

enum TitleBarStyle { normal, hidden }

class Size {
  final double width;
  final double height;
  const Size(this.width, this.height);
}

class Offset {
  final double dx;
  final double dy;
  const Offset(this.dx, this.dy);
}