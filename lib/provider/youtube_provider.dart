import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/youtube/youtube.dart';

final youtubeProvider = Provider<YoutubeEndpoints>((ref) {
  final preferences = ref.watch(userPreferencesProvider);
  return YoutubeEndpoints(preferences);
});

// this provider overrides the API provider to use piped.video for downloading
final downloadYoutubeProvider = Provider<YoutubeEndpoints>((ref) {
  final preferences = ref.watch(userPreferencesProvider);
  return YoutubeEndpoints(
    preferences.copyWith(
      youtubeApiType: YoutubeApiType.piped,
    ),
  );
});
