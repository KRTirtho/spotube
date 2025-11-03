import 'package:riverpod/riverpod.dart';
import 'package:spotube/provider/metadata_plugin/audio_source/quality_presets.dart';

final audioSourceQualityLabelProvider = Provider<String>((ref) {
  final sourceQuality = ref.watch(audioSourcePresetsProvider);
  final sourceContainer =
      sourceQuality.presets[sourceQuality.selectedStreamingContainerIndex];
  final quality =
      sourceContainer.qualities[sourceQuality.selectedStreamingQualityIndex];

  return "${sourceContainer.name} • ${quality.toString()}";
});
