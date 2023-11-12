import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/source_map.dart';

enum SourceCodecs {
  mp4,
  weba,
  m4a,
}

enum SourceQualities {
  high,
  medium,
  low,
}

typedef SiblingType = ({SourceInfo info, SourceMap? source});
