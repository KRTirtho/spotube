import 'package:spotube/models/playback/track_sources.dart';

enum SourceCodecs {
  m4a._("M4a (Best for downloaded music)"),
  weba._("WebA (Best for streamed music)\nDoesn't support audio metadata"),
  mp3._("MP3 (Widely supported audio format)"),
  flac._("FLAC (Lossless, best quality)\nLarge file size");

  final String label;
  const SourceCodecs._(this.label);
}

enum SourceQualities {
  uncompressed(3),
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
