import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbusClientProvider = Provider((ref) {
  return DBusClient.session();
});
