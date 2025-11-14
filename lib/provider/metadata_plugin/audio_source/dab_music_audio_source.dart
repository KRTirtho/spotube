import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/audio_quality.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/audio_source.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/dab_music/dab_music_api.dart';

class DabMusicAudioSource extends AudioSource {
  final DabMusicApi _api = DabMusicApi();
  final Ref? ref;

  DabMusicAudioSource([this.ref]);

  @override
  String get name => 'DAB Music';

  @override
  Future<List<SpotubeTrackObject>> search(String query) {
    return _api.search(query);
  }

  @override
  Future<String> getStreamUrl(SpotubeTrackObject track) {
    final quality = ref?.read(userPreferencesProvider).audioQuality ?? AudioQuality.high;
    return _api.getStreamUrl(track.id, quality: quality);
  }
}
