import 'package:spotube/models/playback/track_sources.dart';

enum SourceCodecs {
  m4a._("M4a (Best for downloaded music)"),
  weba._("WebA (Best for streamed music)\nDoesn't support audio metadata");

  final String label;
  const SourceCodecs._(this.label);
}

enum SourceQualities {
  high(2),
  medium(1),
  low(0);

  final int priority;
  const SourceQualities(this.priority);

  bool operator <(SourceQualities other) {
    return priority < other.priority;
  }

  operator >(SourceQualities other) {
    return priority > other.priority;
  }
}

typedef SiblingType<T extends TrackSourceInfo> = ({
  T info,
  List<TrackSource>? source
});
