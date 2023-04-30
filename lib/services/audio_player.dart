import 'package:audioplayers/audioplayers.dart';

final audioPlayer = (() {
  AudioPlayer.global.setAudioContext(
    const AudioContext(
      android: AudioContextAndroid(
        audioFocus: AndroidAudioFocus.gain,
        audioMode: AndroidAudioMode.inCall,
        contentType: AndroidContentType.music,
        stayAwake: true,
        usageType: AndroidUsageType.media,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: [
          AVAudioSessionOptions.allowBluetooth,
          AVAudioSessionOptions.allowBluetoothA2DP,
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ),
    ),
  );
  return AudioPlayer();
})();
