// Conditional exports for tray manager functionality
export 'tray_manager_native.dart'
    if (dart.library.html) 'tray_manager_web.dart';