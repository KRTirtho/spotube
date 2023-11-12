import 'package:spotube/services/sourced_track/sourced_track.dart';

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

typedef SourceMap = Map<SourceCodecs, Map<SourceQualities, String>>;
typedef SiblingType = ({SourceInfo info, SourceMap? source});
