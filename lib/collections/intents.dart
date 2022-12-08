import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/player/player_controls.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/utils/platform.dart';

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
        if (playback.track!.ytUri.startsWith("http")) {
          final track = Track.fromJson(playback.track!.toJson());
          playback.track = null;
          await playback.play(track);
        } else {
          final track = playback.track;
          playback.track = null;
          await playback.play(track!);
        }
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

class NavigationIntent extends Intent {
  final GoRouter router;
  final String path;
  const NavigationIntent(this.router, this.path);
}

class NavigationAction extends Action<NavigationIntent> {
  @override
  invoke(intent) {
    intent.router.go(intent.path);
    return null;
  }
}

enum HomeTabs {
  browse,
  search,
  library,
  lyrics,
}

class HomeTabIntent extends Intent {
  final WidgetRef ref;
  final HomeTabs tab;
  const HomeTabIntent(this.ref, {required this.tab});
}

class HomeTabAction extends Action<HomeTabIntent> {
  @override
  invoke(intent) {
    switch (intent.tab) {
      case HomeTabs.browse:
        router.go("/");
        break;
      case HomeTabs.search:
        router.go("/search");
        break;
      case HomeTabs.library:
        router.go("/library");
        break;
      case HomeTabs.lyrics:
        router.go("/lyrics");
        break;
    }
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

class CloseAppIntent extends Intent {}

class CloseAppAction extends Action<CloseAppIntent> {
  @override
  invoke(intent) {
    if (kIsDesktop) {
      appWindow.close();
    } else {
      SystemNavigator.pop();
    }
    return null;
  }
}
