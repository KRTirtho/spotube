import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<DBusClient?> dbusClientProvider = Provider<DBusClient?>((ref) {
  if (Platform.isLinux) {
    return DBusClient.session();
  }
});
