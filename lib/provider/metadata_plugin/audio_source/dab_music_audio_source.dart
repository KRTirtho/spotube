import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/audio_source.dart';
import 'package:spotube/services/dab_music/dab_music_api.dart';

class DabMusicAudioSource extends AudioSource {
  final DabMusicApi _api = DabMusicApi();

  @override
  String get name => 'DAB Music';

  @override
  Future<List<SpotubeTrackObject>> search(String query) {
    return _api.search(query);
  }

  @override
  Future<String> getStreamUrl(SpotubeTrackObject track) {
    return _api.getStreamUrl(track.id);
  }
}
