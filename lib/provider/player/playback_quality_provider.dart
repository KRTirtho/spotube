import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/audio_quality.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

class PlaybackQualityState {
  final AudioQuality selectedQuality;
  final double? bitrate;

  PlaybackQualityState({
    required this.selectedQuality,
    this.bitrate,
  });

  PlaybackQualityState copyWith({
    AudioQuality? selectedQuality,
    double? bitrate,
  }) {
    return PlaybackQualityState(
      selectedQuality: selectedQuality ?? this.selectedQuality,
      bitrate: bitrate ?? this.bitrate,
    );
  }

  String toShortString() {
    if (bitrate != null) {
      return '${(bitrate! / 1000).round()} kbps';
    }
    return selectedQuality.toShortString();
  }
}

class PlaybackQualityNotifier extends StateNotifier<PlaybackQualityState> {
  final Ref ref;

  PlaybackQualityNotifier(this.ref)
      : super(
          PlaybackQualityState(
            selectedQuality:
                ref.read(userPreferencesProvider).audioQuality,
          ),
        ) {
    ref.listen(userPreferencesProvider.select((s) => s.audioQuality),
        (previous, next) {
      state = state.copyWith(selectedQuality: next);
    });

    audioPlayer.audioBitrateStream.listen((bitrate) {
      state = state.copyWith(bitrate: bitrate);
    });
  }
}

final playbackQualityProvider =
    StateNotifierProvider<PlaybackQualityNotifier, PlaybackQualityState>(
  (ref) => PlaybackQualityNotifier(ref),
);
