import 'package:flutter_js/flutter_js.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PluginLocalStorageApi {
  final JavascriptRuntime runtime;
  final SharedPreferences sharedPreferences;

  final String pluginName;

  PluginLocalStorageApi({
    required this.runtime,
    required this.sharedPreferences,
    required this.pluginName,
  }) {
    runtime.onMessage("LocalStorage.getItem", (args) {
      final key = args[0];
      final value = getItem(key);
      runtime.evaluate(
        """
        eventEmitter.emit('LocalStorage.getItem', ${value != null ? "'$value'" : "null"});
        """,
      );
    });

    runtime.onMessage("LocalStorage.setItem", (args) {
      final map = args[0] as Map<String, dynamic>;
      setItem(map["key"], map["value"]);
    });

    runtime.onMessage("LocalStorage.removeItem", (args) {
      final map = args[0];
      removeItem(map["key"]);
    });

    runtime.onMessage("LocalStorage.clear", (args) {
      clear();
    });
  }

  void setItem(String key, String value) async {
    await sharedPreferences.setString("plugin.$pluginName.$key", value);
  }

  String? getItem(String key) {
    return sharedPreferences.getString("plugin.$pluginName.$key");
  }

  void removeItem(String key) async {
    await sharedPreferences.remove("plugin.$pluginName.$key");
  }

  void clear() async {
    final keys = sharedPreferences.getKeys();
    for (String key in keys) {
      if (key.startsWith("plugin.$pluginName.")) {
        await sharedPreferences.remove(key);
      }
    }
  }
}
