// Conditional exports for media controls functionality
export 'media_controls_native.dart'
    if (dart.library.html) 'media_controls_web.dart';