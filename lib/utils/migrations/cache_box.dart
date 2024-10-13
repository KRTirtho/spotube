import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/provider/spotify/utils/json_cast.dart';
import 'package:spotube/services/kv_store/encrypted_kv_store.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/primitive_utils.dart';

const kKeyBoxName = "spotube_box_name";
const kNoEncryptionWarningShownKey = "showedNoEncryptionWarning";
const kIsUsingEncryption = "isUsingEncryption";
String getBoxKey(String boxName) => "spotube_box_$boxName";

class PersistenceCacheBox<T> {
  static late LazyBox _box;
  static late LazyBox _encryptedBox;

  final String cacheKey;
  final bool encrypted;

  final T Function(Map<String, dynamic>) fromJson;

  PersistenceCacheBox(
    this.cacheKey, {
    required this.fromJson,
    this.encrypted = false,
  });

  static Future<String?> read(String key) async {
    final localStorage = await SharedPreferences.getInstance();
    if (kIsMacOS || kIsIOS || (kIsLinux && !kIsFlatpak)) {
      return localStorage.getString(key);
    }

    try {
      await localStorage.setBool(kIsUsingEncryption, true);
      return await EncryptedKvStoreService.storage.read(key: key);
    } catch (e) {
      await localStorage.setBool(kIsUsingEncryption, false);
      return localStorage.getString(key);
    }
  }

  static Future<void> write(String key, String value) async {
    final localStorage = await SharedPreferences.getInstance();
    if (kIsMacOS || kIsIOS || (kIsLinux && !kIsFlatpak)) {
      await localStorage.setString(key, value);
      return;
    }

    try {
      await localStorage.setBool(kIsUsingEncryption, true);
      await EncryptedKvStoreService.storage.write(key: key, value: value);
    } catch (e) {
      await localStorage.setBool(kIsUsingEncryption, false);
      await localStorage.setString(key, value);
    }
  }

  static Future<void> initializeBoxes({required String? path}) async {
    String? boxName = await read(kKeyBoxName);

    if (boxName == null) {
      boxName = "spotube-${PrimitiveUtils.uuid.v4()}";
      await write(kKeyBoxName, boxName);
    }

    String? encryptionKey = await read(getBoxKey(boxName));

    if (encryptionKey == null) {
      encryptionKey = base64Url.encode(Hive.generateSecureKey());
      await write(getBoxKey(boxName), encryptionKey);
    }

    _encryptedBox = await Hive.openLazyBox(
      boxName,
      encryptionCipher: HiveAesCipher(base64Url.decode(encryptionKey)),
    );

    _box = await Hive.openLazyBox(
      "spotube_cache",
      path: path,
    );
  }

  LazyBox get box => encrypted ? _encryptedBox : _box;

  Future<T?> getData() async {
    final json = await box.get(cacheKey);

    if (json != null ||
        (json is Map && json.entries.isNotEmpty) ||
        (json is List && json.isNotEmpty)) {
      return fromJson(castNestedJson(json));
    }

    return null;
  }
}
