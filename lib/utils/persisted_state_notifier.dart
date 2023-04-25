import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:spotube/utils/primitive_utils.dart';

const secureStorage = FlutterSecureStorage();

abstract class PersistedStateNotifier<T> extends StateNotifier<T> {
  final String cacheKey;
  final bool encrypted;

  FutureOr<void> onInit() {}

  PersistedStateNotifier(
    super.state,
    this.cacheKey, {
    this.encrypted = false,
  }) {
    _load().then((_) => onInit());
  }

  Future<void> _load() async {
    final LazyBox box;

    if (encrypted) {
      String? boxName =
          await secureStorage.read(key: "oss.krtirtho.spotube.box_name");

      if (boxName == null) {
        await secureStorage.write(
          key: "oss.krtirtho.spotube.box_name",
          value: ".spotube-${PrimitiveUtils.uuid.v4()}",
        );
        boxName =
            await secureStorage.read(key: "oss.krtirtho.spotube.box_name");
      } else {
        boxName = ".spotube-$boxName";
      }

      final rawKey =
          await secureStorage.read(key: "oss.krtirtho.spotube.$boxName");

      Uint8List? encryptionKey =
          rawKey == null ? null : base64Url.decode(rawKey);

      if (encryptionKey == null) {
        await secureStorage.write(
          key: "oss.krtirtho.spotube.$boxName",
          value: base64UrlEncode(Hive.generateSecureKey()),
        );
        encryptionKey = base64Url.decode(
          (await secureStorage.read(key: "oss.krtirtho.spotube.$boxName"))!,
        );
      }

      box = await Hive.openLazyBox(
        boxName!,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    } else {
      box = await Hive.openLazyBox("spotube_cache");
    }

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
