import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistedChangeNotifier extends ChangeNotifier {
  late SharedPreferences _localStorage;
  PersistedChangeNotifier() {
    SharedPreferences.getInstance().then((value) => _localStorage = value).then(
      (_) async {
        final persistedMap = (await toMap())
            .entries
            .toList()
            .fold<Map<String, dynamic>>({}, (acc, entry) {
          if (entry.value != null) {
            if (entry.value is bool) {
              acc[entry.key] = _localStorage.getBool(entry.key) ?? false;
            } else if (entry.value is int) {
              acc[entry.key] = _localStorage.getInt(entry.key) ?? -1;
            } else if (entry.value is double) {
              acc[entry.key] = _localStorage.getDouble(entry.key) ?? -1.0;
            } else if (entry.value is String) {
              acc[entry.key] = _localStorage.getString(entry.key) ?? "";
            }
          } else {
            acc[entry.key] = _localStorage.get(entry.key);
          }
          return acc;
        });
        await loadFromLocal(persistedMap);
        notifyListeners();
      },
    );
  }

  FutureOr<void> loadFromLocal(Map<String, dynamic> map);

  FutureOr<Map<String, dynamic>> toMap();

  Future<void> updatePersistence() async {
    for (final entry in (await toMap()).entries) {
      if (entry.value is bool) {
        await _localStorage.setBool(entry.key, entry.value);
      } else if (entry.value is int) {
        await _localStorage.setInt(entry.key, entry.value);
      } else if (entry.value is double) {
        await _localStorage.setDouble(entry.key, entry.value);
      } else if (entry.value is String) {
        await _localStorage.setString(entry.key, entry.value);
      }
    }
  }
}
