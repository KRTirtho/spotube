import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistedStateNotifier<T> extends StateNotifier<T> {
  get cacheKey => state.runtimeType.toString();

  SharedPreferences? localStorage;

  PersistedStateNotifier(super.state) : super() {
    SharedPreferences.getInstance().then(
      (localStorage) {
        this.localStorage = localStorage;
        final rawState = localStorage.getString(cacheKey);

        if (rawState != null) {
          state = fromJson(jsonDecode(rawState));
        }
      },
    );
  }

  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  @override
  set state(T value) {
    if (state == value) return;
    super.state = value;
    if (localStorage == null) {
      SharedPreferences.getInstance().then(
        (localStorage) {
          this.localStorage = localStorage;
          localStorage.setString(
            cacheKey,
            jsonEncode(toJson()),
          );
        },
      );
    } else {
      localStorage?.setString(
        cacheKey,
        jsonEncode(toJson()),
      );
    }
  }
}
