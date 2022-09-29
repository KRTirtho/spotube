import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Player/PlayerControls.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';

class PlayPauseIntent extends Intent {
  final WidgetRef ref;
  const PlayPauseIntent(this.ref);
}

class PlayPauseAction extends Action<PlayPauseIntent> {
  final logger = getLogger(PlayPauseAction);

  @override
  invoke(intent) async {
    try {
      if (PlayerControls.focusNode.canRequestFocus) {
        PlayerControls.focusNode.requestFocus();
      }
      final playback = intent.ref.read(playbackProvider);
      if (playback.track == null) {
        return null;
      } else if (playback.track != null &&
          playback.currentDuration == Duration.zero &&
          await playback.player.getCurrentPosition() == Duration.zero) {
        final track = Track.fromJson(playback.track!.toJson());
        playback.track = null;
        await playback.play(track);
      } else {
        await playback.togglePlayPause();
      }
      return null;
    } catch (e, stack) {
      logger.e("useTogglePlayPause", e, stack);
      return null;
    }
  }
}

class OpenSettingsIntent extends Intent {
  final GoRouter router;
  const OpenSettingsIntent(this.router);
}

class OpenSettingsAction extends Action<OpenSettingsIntent> {
  @override
  invoke(intent) async {
    intent.router.push("/settings");
    FocusManager.instance.primaryFocus?.unfocus();
    return null;
  }
}

class SeekIntent extends Intent {
  final WidgetRef ref;
  final bool forward;
  const SeekIntent(this.ref, this.forward);
}

class SeekAction extends Action<SeekIntent> {
  @override
  invoke(intent) async {
    final playback = intent.ref.read(playbackProvider);
    if ((playback.playlist == null && playback.track == null) ||
        playback.status == PlaybackStatus.loading) {
      DirectionalFocusAction().invoke(
        DirectionalFocusIntent(
          intent.forward ? TraversalDirection.right : TraversalDirection.left,
        ),
      );
      return null;
    }
    final position =
        (await playback.player.getCurrentPosition() ?? Duration.zero).inSeconds;
    await playback.seekPosition(
      Duration(
        seconds: intent.forward ? position + 5 : position - 5,
      ),
    );
    return null;
  }
}
