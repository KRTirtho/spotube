import 'dart:io';

import 'package:flutter/foundation.dart';

final kIsDesktop = kIsLinux || kIsWindows || kIsMacOS;

final kIsMobile = kIsAndroid || kIsIOS;

final kIsFlatpak = kIsWeb ? false : Platform.environment["FLATPAK_ID"] != null;

final kIsMacOS = kIsWeb ? false : Platform.isMacOS;
final kIsLinux = kIsWeb ? false : Platform.isLinux;
final kIsAndroid = kIsWeb ? false : Platform.isAndroid;
final kIsIOS = kIsWeb ? false : Platform.isIOS;
final kIsWindows = kIsWeb ? false : Platform.isWindows;
