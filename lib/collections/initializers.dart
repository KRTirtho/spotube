// Conditional exports for platform initializers
export 'initializers_native.dart'
    if (dart.library.html) 'initializers_web.dart';