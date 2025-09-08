import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spotube/hooks/utils/use_async_effect.dart';
import 'package:spotube/provider/local_tracks/local_tracks_provider.dart';
import 'package:spotube/utils/platform.dart';

void useGetStoragePermissions(WidgetRef ref) {
  final context = useContext();

  useAsyncEffect(
    () async {
      if (kIsAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;

        final hasNoStoragePerm = androidInfo.version.sdkInt < 33 &&
            !await Permission.storage.isGranted &&
            !await Permission.storage.isLimited;

        final hasNoAudioPerm = androidInfo.version.sdkInt >= 33 &&
            !await Permission.audio.isGranted &&
            !await Permission.audio.isLimited;

        if (hasNoStoragePerm) {
          await Permission.storage.request();
          if (context.mounted) ref.invalidate(localTracksProvider);
        }
        if (hasNoAudioPerm) {
          await Permission.audio.request();
          if (context.mounted) ref.invalidate(localTracksProvider);
        }
      }

      if (kIsIOS) {
        final hasStoragePerm = await Permission.storage.isGranted ||
            await Permission.storage.isLimited;

        if (!hasStoragePerm) {
          await Permission.storage.request();
          if (context.mounted) ref.invalidate(localTracksProvider);
        }
      }
    },
    null,
    [],
  );
}
