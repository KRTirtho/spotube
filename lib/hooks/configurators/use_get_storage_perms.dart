import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/hooks/utils/use_async_effect.dart';

void useGetStoragePermissions(WidgetRef ref) {
  final isMounted = useIsMounted();

  useAsyncEffect(
    () async {
      if (!DesktopTools.platform.isMobile) return;

      final androidInfo = await DeviceInfoPlugin().androidInfo;

      final hasNoStoragePerm = androidInfo.version.sdkInt < 33 &&
          !await Permission.storage.isGranted &&
          !await Permission.storage.isLimited;

      final hasNoAudioPerm = androidInfo.version.sdkInt >= 33 &&
          !await Permission.audio.isGranted &&
          !await Permission.audio.isLimited;

      if (hasNoStoragePerm) {
        await Permission.storage.request();
        if (isMounted()) ref.refresh(localTracksProvider);
      }
      if (hasNoAudioPerm) {
        await Permission.audio.request();
        if (isMounted()) ref.refresh(localTracksProvider);
      }
    },
    null,
    [],
  );
}
