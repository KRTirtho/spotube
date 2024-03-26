import 'package:flutter_displaymode/flutter_displaymode.dart';

abstract class AndroidUtils {

  /// Sets the device's display to the highest refresh rate available.
  ///
  /// This method retrieves the list of supported display modes and the currently active display mode.
  /// It then selects the display mode with the highest refresh rate that matches the current resolution.
  /// The selected display mode is set as the preferred mode using the FlutterDisplayMode plugin.
  /// After setting the new mode, it checks if the system is using the new mode.
  /// If the system is not using the new mode, it reverts back to the original mode and returns false.
  /// Otherwise, it returns true to indicate that the high refresh rate has been successfully set.
  ///
  /// Returns true if the high refresh rate is set successfully, false otherwise.
  static Future<bool> setHighRefreshRate() async {
    final List<DisplayMode> modes = await FlutterDisplayMode.supported;
    final DisplayMode activeMode = await FlutterDisplayMode.active;

    DisplayMode newMode = activeMode;
    for (final DisplayMode mode in modes) {
      if (mode.height == newMode.height &&
          mode.width == newMode.width &&
          mode.refreshRate > newMode.refreshRate) {
        newMode = mode;
      }
    }

    await FlutterDisplayMode.setPreferredMode(newMode);

    final display = await FlutterDisplayMode.active; // possibly altered by system

    if (display.refreshRate < newMode.refreshRate) {
      await FlutterDisplayMode.setPreferredMode(display);
      return false;
    }

    return true;
  }
}
