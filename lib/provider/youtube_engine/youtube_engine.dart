import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/youtube_engine/youtube_explode_engine.dart';
import 'package:spotube/services/youtube_engine/yt_dlp_engine.dart';

final youtubeEngineProvider = Provider((ref) {
  final engineMode = ref.watch(
    userPreferencesProvider.select((value) => value.youtubeClientEngine),
  );

  if (engineMode == YoutubeClientEngine.newPipe) {
    throw UnimplementedError();
  } else if (engineMode == YoutubeClientEngine.ytDlp &&
      YtDlpEngine.isAvailableForPlatform) {
    return YtDlpEngine();
  } else {
    return YouTubeExplodeEngine();
  }
});
