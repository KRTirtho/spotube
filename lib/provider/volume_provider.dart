import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';

class VolumeProvider extends PersistedStateNotifier<double> {
  VolumeProvider() : super(1, 'volume');

  Future<void> setVolume(double volume) async {
    state = volume;
    await audioPlayer.setVolume(volume);
  }

  @override
  FutureOr<void> onInit() async {
    await audioPlayer.setVolume(state);
  }

  @override
  FutureOr<double> fromJson(Map<String, dynamic> json) {
    return json['volume'] as double? ?? 0.0;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'volume': state};
  }
}

final volumeProvider =
    StateNotifierProvider<VolumeProvider, double>((ref) => VolumeProvider());
