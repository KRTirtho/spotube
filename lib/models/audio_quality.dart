enum AudioQuality {
  low,
  high,
  lossless;

  String toDabMusicQuality() {
    switch (this) {
      case AudioQuality.low:
        return '12';
      case AudioQuality.high:
        return '27';
      case AudioQuality.lossless:
        return '28';
    }
  }

  String toShortString() {
    switch (this) {
      case AudioQuality.low:
        return 'Low';
      case AudioQuality.high:
        return 'High';
      case AudioQuality.lossless:
        return 'Lossless';
    }
  }
}
