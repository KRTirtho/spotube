import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';

PackageInfo usePackageInfo<PageKeyType, ItemType>({
  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  String appName = 'Unknown',

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  String packageName = 'Unknown',

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  String version = 'Unknown',

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  String buildNumber = 'Unknown',

  /// The build signature. Empty string on iOS, signing key signature (hex) on Android.
  String buildSignature = '',
  List<Object?>? keys,
}) {
  return use(
    _PackageInfoHook(
      appName: appName,
      buildNumber: buildNumber,
      packageName: packageName,
      version: version,
      buildSignature: buildSignature,
      keys: keys,
    ),
  );
}

class _PackageInfoHook<PageKeyType, ItemType> extends Hook<PackageInfo> {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String buildSignature;

  const _PackageInfoHook({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    this.buildSignature = '',
    super.keys,
  });

  @override
  HookState<PackageInfo, Hook<PackageInfo>> createState() =>
      _PackageInfoHookState<PageKeyType, ItemType>();
}

class _PackageInfoHookState<PageKeyType, ItemType>
    extends HookState<PackageInfo, _PackageInfoHook<PageKeyType, ItemType>> {
  late PackageInfo info = PackageInfo(
    appName: hook.appName,
    buildNumber: hook.buildNumber,
    packageName: hook.packageName,
    version: hook.version,
  );

  @override
  void initHook() {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        info = packageInfo;
      });
    });
    super.initHook();
  }

  @override
  PackageInfo build(BuildContext context) => info;

  @override
  String get debugLabel => 'usePagingController';
}
