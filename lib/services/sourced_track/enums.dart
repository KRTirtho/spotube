import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/source_map.dart';

enum SourceCodecs {
  m4a._("M4a (Best for downloaded music)"),
  weba._("WebA (Best for streamed music)\nDoesn't support audio metadata");

  final String label;

  const SourceCodecs._(this.label);
}

enum SourceQualities {
  high,
  medium,
  low,
}

typedef SiblingType<T extends SourceInfo> = ({T info, SourceMap? source});
