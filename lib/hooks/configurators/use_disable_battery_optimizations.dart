import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/hooks/utils/use_async_effect.dart';

bool _asked = false;
void useDisableBatteryOptimizations() {
  useAsyncEffect(() async {
    if (!DesktopTools.platform.isAndroid || _asked) return;
    final localStorage = await SharedPreferences.getInstance();

    final rawIsBatteryOptimizationDisabled =
        localStorage.getBool("isBatteryOptimizationDisabled");
    final isBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    if (rawIsBatteryOptimizationDisabled != false &&
        isBatteryOptimizationDisabled == false) {
      final hasDisabled = await DisableBatteryOptimization
          .showDisableBatteryOptimizationSettings();

      localStorage.setBool(
        "isBatteryOptimizationDisabled",
        hasDisabled == true,
      );
    }

    final rawIsManBatteryOptimizationDisabled =
        localStorage.getBool("isManufacturerBatteryOptimizationDisabled");
    final isManBatteryOptimizationDisabled = await DisableBatteryOptimization
        .isManufacturerBatteryOptimizationDisabled;

    if (rawIsManBatteryOptimizationDisabled != false &&
        isManBatteryOptimizationDisabled == false) {
      final hasDisabled = await DisableBatteryOptimization
          .showDisableManufacturerBatteryOptimizationSettings(
        "Your device has additional battery optimization",
        "Follow the steps and disable the optimizations to allow smooth functioning of this app",
      );

      localStorage.setBool(
        "isManufacturerBatteryOptimizationDisabled",
        hasDisabled == true,
      );
    }
    _asked = true;
  }, null, []);
}
