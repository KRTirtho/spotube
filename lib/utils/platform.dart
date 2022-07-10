import 'dart:io';

final kIsDesktop = Platform.isLinux || Platform.isWindows || Platform.isMacOS;

final kIsMobile = Platform.isAndroid || Platform.isIOS;

final kIsFlatpak = Platform.environment["FLATPAK_ID"] != null;
