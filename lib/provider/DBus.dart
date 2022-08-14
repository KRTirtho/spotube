import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/utils/platform.dart';

final Provider<DBusClient?> dbusClientProvider = Provider<DBusClient?>((ref) {
  if (kIsLinux) {
    return DBusClient.session();
  }
  return null;
});

final dbus = DBusClient.session();
