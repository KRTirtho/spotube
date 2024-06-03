import 'package:flutter/widgets.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

class CallbackWindowListener implements WindowListener {
  final VoidCallback? _onWindowClose;
  final VoidCallback? _onWindowFocus;
  final VoidCallback? _onWindowBlur;
  final VoidCallback? _onWindowMaximize;
  final VoidCallback? _onWindowUnmaximize;
  final VoidCallback? _onWindowMinimize;
  final VoidCallback? _onWindowRestore;
  final VoidCallback? _onWindowResize;
  final VoidCallback? _onWindowResized;
  final VoidCallback? _onWindowMove;
  final VoidCallback? _onWindowMoved;
  final VoidCallback? _onWindowEnterFullScreen;
  final VoidCallback? _onWindowLeaveFullScreen;
  final VoidCallback? _onWindowDocked;
  final VoidCallback? _onWindowUndocked;
  final VoidCallback? _onWindowEvent;

  const CallbackWindowListener({
    VoidCallback? onWindowClose,
    VoidCallback? onWindowFocus,
    VoidCallback? onWindowBlur,
    VoidCallback? onWindowMaximize,
    VoidCallback? onWindowUnmaximize,
    VoidCallback? onWindowMinimize,
    VoidCallback? onWindowRestore,
    VoidCallback? onWindowResize,
    VoidCallback? onWindowResized,
    VoidCallback? onWindowMove,
    VoidCallback? onWindowMoved,
    VoidCallback? onWindowEnterFullScreen,
    VoidCallback? onWindowLeaveFullScreen,
    VoidCallback? onWindowDocked,
    VoidCallback? onWindowUndocked,
    VoidCallback? onWindowEvent,
  })  : _onWindowClose = onWindowClose,
        _onWindowFocus = onWindowFocus,
        _onWindowBlur = onWindowBlur,
        _onWindowMaximize = onWindowMaximize,
        _onWindowUnmaximize = onWindowUnmaximize,
        _onWindowMinimize = onWindowMinimize,
        _onWindowRestore = onWindowRestore,
        _onWindowResize = onWindowResize,
        _onWindowResized = onWindowResized,
        _onWindowMove = onWindowMove,
        _onWindowMoved = onWindowMoved,
        _onWindowEnterFullScreen = onWindowEnterFullScreen,
        _onWindowLeaveFullScreen = onWindowLeaveFullScreen,
        _onWindowDocked = onWindowDocked,
        _onWindowUndocked = onWindowUndocked,
        _onWindowEvent = onWindowEvent;

  @override
  void onWindowBlur() {
    return _onWindowBlur?.call();
  }

  @override
  void onWindowClose() {
    return _onWindowClose?.call();
  }

  @override
  void onWindowDocked() {
    return _onWindowDocked?.call();
  }

  @override
  void onWindowEnterFullScreen() {
    return _onWindowEnterFullScreen?.call();
  }

  @override
  void onWindowEvent(String eventName) {
    return _onWindowEvent?.call();
  }

  @override
  void onWindowFocus() {
    return _onWindowFocus?.call();
  }

  @override
  void onWindowLeaveFullScreen() {
    return _onWindowLeaveFullScreen?.call();
  }

  @override
  void onWindowMaximize() {
    return _onWindowMaximize?.call();
  }

  @override
  void onWindowMinimize() {
    return _onWindowMinimize?.call();
  }

  @override
  void onWindowMove() {
    return _onWindowMove?.call();
  }

  @override
  void onWindowMoved() {
    return _onWindowMoved?.call();
  }

  @override
  void onWindowResize() {
    return _onWindowResize?.call();
  }

  @override
  void onWindowResized() {
    return _onWindowResized?.call();
  }

  @override
  void onWindowRestore() {
    return _onWindowRestore?.call();
  }

  @override
  void onWindowUndocked() {
    return _onWindowUndocked?.call();
  }

  @override
  void onWindowUnmaximize() {
    return _onWindowUnmaximize?.call();
  }
}

void useWindowListener({
  VoidCallback? onWindowClose,
  VoidCallback? onWindowFocus,
  VoidCallback? onWindowBlur,
  VoidCallback? onWindowMaximize,
  VoidCallback? onWindowUnmaximize,
  VoidCallback? onWindowMinimize,
  VoidCallback? onWindowRestore,
  VoidCallback? onWindowResize,
  VoidCallback? onWindowResized,
  VoidCallback? onWindowMove,
  VoidCallback? onWindowMoved,
  VoidCallback? onWindowEnterFullScreen,
  VoidCallback? onWindowLeaveFullScreen,
  VoidCallback? onWindowDocked,
  VoidCallback? onWindowUndocked,
  VoidCallback? onWindowEvent,
}) {
  useEffect(() {
    if (!kIsDesktop) return null;

    final listener = CallbackWindowListener(
      onWindowClose: onWindowClose,
      onWindowFocus: onWindowFocus,
      onWindowBlur: onWindowBlur,
      onWindowMaximize: onWindowMaximize,
      onWindowUnmaximize: onWindowUnmaximize,
      onWindowMinimize: onWindowMinimize,
      onWindowRestore: onWindowRestore,
      onWindowResize: onWindowResize,
      onWindowResized: onWindowResized,
      onWindowMove: onWindowMove,
      onWindowMoved: onWindowMoved,
      onWindowEnterFullScreen: onWindowEnterFullScreen,
      onWindowLeaveFullScreen: onWindowLeaveFullScreen,
      onWindowDocked: onWindowDocked,
      onWindowUndocked: onWindowUndocked,
      onWindowEvent: onWindowEvent,
    );
    windowManager.addListener(listener);
    return () {
      windowManager.removeListener(listener);
    };
  }, [
    onWindowClose,
    onWindowFocus,
    onWindowBlur,
    onWindowMaximize,
    onWindowUnmaximize,
    onWindowMinimize,
    onWindowRestore,
    onWindowResize,
    onWindowResized,
    onWindowMove,
    onWindowMoved,
    onWindowEnterFullScreen,
    onWindowLeaveFullScreen,
    onWindowDocked,
    onWindowUndocked,
    onWindowEvent,
  ]);
}
