import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin deviceInfo;
  DeviceInfoService._() : deviceInfo = DeviceInfoPlugin();

  static final instance = DeviceInfoService._();

  Future<String> deviceId() async {
    final info = await deviceInfo.deviceInfo;

    return switch (info) {
      AndroidDeviceInfo() => info.id,
      IosDeviceInfo() => info.identifierForVendor ?? info.model,
      MacOsDeviceInfo() => info.systemGUID ?? info.model,
      WindowsDeviceInfo() => info.deviceId,
      LinuxDeviceInfo() => info.machineId ?? info.id,
      _ => 'Unknown',
    };
  }

  Future<String> computerName() async {
    final info = await deviceInfo.deviceInfo;

    return switch (info) {
      AndroidDeviceInfo() => info.model,
      IosDeviceInfo() => info.localizedModel,
      MacOsDeviceInfo() => info.computerName,
      WindowsDeviceInfo() => info.computerName,
      LinuxDeviceInfo() => info.name,
      _ => 'Unknown',
    };
  }
}
