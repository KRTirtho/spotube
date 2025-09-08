import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/tray_manager/tray_menu.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class SystemTrayManager with TrayListener {
  final Ref ref;
  final bool enabled;

  SystemTrayManager(
    this.ref, {
    required this.enabled,
  }) {
    initialize();
  }

  Future<void> initialize() async {
    if (!kIsDesktop) return;

    if (enabled) {
      await trayManager.setIcon(
        kIsWindows
            ? 'assets/branding/spotube-logo.ico'
            : kIsFlatpak
                ? 'com.github.KRTirtho.Spotube'
                : 'assets/branding/spotube-logo.png',
      );
      trayManager.addListener(this);
    } else {
      await trayManager.destroy();
    }
  }

  void dispose() {
    trayManager.removeListener(this);
  }

  @override
  onTrayIconMouseDown() {
    if (kIsWindows) {
      windowManager.show();
    } else {
      trayManager.popUpContextMenu();
    }
  }

  @override
  onTrayIconRightMouseDown() {
    if (!kIsWindows) {
      windowManager.show();
    } else {
      trayManager.popUpContextMenu();
    }
  }
}

final trayManagerProvider = Provider(
  (ref) {
    final enabled = ref.watch(
      userPreferencesProvider.select((s) => s.showSystemTrayIcon),
    );

    ref.listen(trayMenuProvider, (_, menu) {
      if (!enabled || !kIsDesktop) return;
      trayManager.setContextMenu(menu);
    });

    final manager = SystemTrayManager(
      ref,
      enabled: enabled,
    );

    ref.onDispose(manager.dispose);

    return manager;
  },
);
