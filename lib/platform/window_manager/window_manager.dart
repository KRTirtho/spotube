// Conditional exports for window manager functionality
export 'window_manager_native.dart'
    if (dart.library.html) 'window_manager_web.dart';