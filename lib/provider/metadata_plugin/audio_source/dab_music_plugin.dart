import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/audio_source.dart';
import 'package:spotube/provider/metadata_plugin/audio_source/dab_music_audio_source.dart';

void main() {
  final plugin = SpotubePlugin(
    name: 'DAB Music Audio Source',
    author: 'jules-for-spotube',
    version: '1.0.0',
    description: 'Adds DAB Music as an audio source for Spotube.',
    audioSources: [
      DabMusicAudioSource(),
    ],
  );

  plugin.run();
}
