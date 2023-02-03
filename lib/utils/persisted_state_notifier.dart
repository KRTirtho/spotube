import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

abstract class PersistedStateNotifier<T> extends StateNotifier<T> {
  final String cacheKey;

  PersistedStateNotifier(super.state, this.cacheKey) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openLazyBox("spotube_cache");
    final json = await box.get(cacheKey);

    if (json != null) {
      state = await fromJson(castNestedJson(json));
    }
  }

  Map<String, dynamic> castNestedJson(Map map) {
    return Map.castFrom<dynamic, dynamic, String, dynamic>(
      map.map((key, value) {
        if (value is Map) {
          return MapEntry(
            key,
            castNestedJson(value),
          );
        } else if (value is Iterable) {
          return MapEntry(
            key,
            value.map((e) {
              if (e is Map) return castNestedJson(e);
              return e;
            }).toList(),
          );
        }
        return MapEntry(key, value);
      }),
    );
  }

  void save() async {
    final box = await Hive.openLazyBox("spotube_cache");
    box.put(cacheKey, toJson());
  }

  FutureOr<T> fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  @override
  set state(T value) {
    if (state == value) return;
    super.state = value;
    save();
  }
}
