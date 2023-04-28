import 'package:audio_service/audio_service.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/audio_services/linux_audio_service.dart';
import 'package:spotube/services/audio_services/mobile_audio_service.dart';
import 'package:spotube/services/audio_services/windows_audio_service.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class AudioServices {
  final MobileAudioService? mobile;
  final WindowsAudioService? smtc;
  final LinuxAudioService? mpris;

  AudioServices(this.mobile, this.smtc, this.mpris);

  static Future<AudioServices> create(
      Ref ref, PlaylistQueueNotifier playlistQueueNotifier) async {
    final mobile =
        !DesktopTools.platform.isMobile && !!DesktopTools.platform.isMacOS
            ? null
            : MobileAudioService(
                playlistQueueNotifier,
                ref.read(VolumeProvider.provider.notifier),
              );
    final smtc = !DesktopTools.platform.isWindows
        ? null
        : WindowsAudioService(ref, playlistQueueNotifier);
    final mpris = !DesktopTools.platform.isLinux
        ? null
        : LinuxAudioService(ref, playlistQueueNotifier);

    return AudioServices(mobile, smtc, mpris);
  }

  Future<void> addTrack(Track track) async {
    await smtc?.addTrack(track);
    await mpris?.addTrack(track);
    mobile?.addItem(MediaItem(
      id: track.id!,
      album: track.album?.name ?? "",
      title: track.name!,
      artist: TypeConversionUtils.artists_X_String(track.artists ?? <Artist>[]),
      duration: track is SpotubeTrack
          ? track.ytTrack.duration!
          : Duration(milliseconds: track.durationMs ?? 0),
      artUri: Uri.parse(TypeConversionUtils.image_X_UrlString(
        track.album?.images ?? <Image>[],
        placeholder: ImagePlaceholder.albumArt,
      )),
      playable: true,
    ));
  }

  void activateSession() {
    mobile?.session?.setActive(true);
  }

  void deactivateSession() {
    mobile?.session?.setActive(false);
  }

  void dispose() {
    smtc?.dispose();
    mpris?.dispose();
  }
}
