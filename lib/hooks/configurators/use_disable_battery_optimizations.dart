import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:spotube/hooks/utils/use_async_effect.dart';
import 'package:spotube/services/kv_store/kv_store.dart';

void useDisableBatteryOptimizations() {
  useAsyncEffect(() async {
    if (!DesktopTools.platform.isAndroid ||
        KVStoreService.askedForBatteryOptimization) return;

    await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();

    await DisableBatteryOptimization
        .showDisableManufacturerBatteryOptimizationSettings(
      "Your device has additional battery optimization",
      "Follow the steps and disable the optimizations to allow smooth functioning of this app",
    );

    await KVStoreService.setAskedForBatteryOptimization(true);
  }, null, []);
}
