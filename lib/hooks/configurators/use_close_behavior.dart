import 'dart:io';

import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/hooks/configurators/use_window_listener.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:local_notifier/local_notifier.dart';

final closeNotification = DesktopTools.createNotification(
  title: 'Spotube',
  message: 'Running in background. Minimized to System Tray',
  actions: [
    LocalNotificationAction(text: 'Close The App'),
  ],
)?..onClickAction = (value) {
    exit(0);
  };

void useCloseBehavior(WidgetRef ref) {
  useWindowListener(
    onWindowClose: () async {
      final preferences = ref.read(userPreferencesProvider);
      if (preferences.closeBehavior == CloseBehavior.minimizeToTray) {
        await DesktopTools.window.hide();
        closeNotification?.show();
      } else {
        exit(0);
      }
    },
  );
}
