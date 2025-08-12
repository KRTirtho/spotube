// Conditional exports for window manager tools
export 'wm_tools_native.dart'
    if (dart.library.html) 'wm_tools_web.dart';