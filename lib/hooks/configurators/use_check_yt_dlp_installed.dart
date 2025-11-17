import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/settings/youtube_engine_not_installed_dialog.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:spotube/services/youtube_engine/yt_dlp_engine.dart';

void useCheckYtDlpInstalled(WidgetRef ref) {
  final context = useContext();

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final youtubeEngine = ref.read(
        userPreferencesProvider.select(
          (value) => value.youtubeClientEngine,
        ),
      );

      final customPath =
          KVStoreService.getYoutubeEnginePath(YoutubeClientEngine.ytDlp);

      if (youtubeEngine == YoutubeClientEngine.ytDlp &&
          !await YtDlpEngine.isInstalled() &&
          (customPath == null || !await File(customPath).exists()) &&
          context.mounted) {
        await showDialog(
          context: context,
          builder: (context) =>
              YouTubeEngineNotInstalledDialog(engine: youtubeEngine),
        );
      }
    });

    return null;
  }, []);
}
