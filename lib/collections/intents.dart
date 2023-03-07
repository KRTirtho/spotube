import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotube/components/player/player_controls.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/audio_player.dart';
import 'package:spotube/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

class PlayPauseIntent extends Intent {
  final WidgetRef ref;
  const PlayPauseIntent(this.ref);
}

class PlayPauseAction extends Action<PlayPauseIntent> {
  final logger = getLogger(PlayPauseAction);

  @override
  invoke(intent) async {
    if (PlayerControls.focusNode.canRequestFocus) {
      PlayerControls.focusNode.requestFocus();
    }
    final playlist = intent.ref.read(PlaylistQueueNotifier.provider);
    final playlistNotifier = intent.ref.read(PlaylistQueueNotifier.notifier);
    if (playlist == null) {
      return null;
    } else if (!PlaylistQueueNotifier.isPlaying) {
      await playlistNotifier.play();
    } else {
      await playlistNotifier.pause();
    }
    return null;
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
    final playlist = intent.ref.read(PlaylistQueueNotifier.provider);
    final playlistNotifier = intent.ref.read(PlaylistQueueNotifier.notifier);
    if (playlist == null || playlist.isLoading) {
      DirectionalFocusAction().invoke(
        DirectionalFocusIntent(
          intent.forward ? TraversalDirection.right : TraversalDirection.left,
        ),
      );
      return null;
    }
    final position =
        (await audioPlayer.getCurrentPosition() ?? Duration.zero).inSeconds;
    await playlistNotifier.seek(
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
      windowManager.close();
    } else {
      SystemNavigator.pop();
    }
    return null;
  }
}
