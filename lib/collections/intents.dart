import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/modules/player/player_controls.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/pages/library/library.dart';
import 'package:spotube/pages/lyrics/lyrics.dart';
import 'package:spotube/pages/search/search.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/utils/platform.dart';

class PlayPauseIntent extends Intent {
  final WidgetRef ref;
  const PlayPauseIntent(this.ref);
}

class PlayPauseAction extends Action<PlayPauseIntent> {
  @override
  invoke(intent) async {
    if (PlayerControls.focusNode.canRequestFocus) {
      PlayerControls.focusNode.requestFocus();
    }

    if (!audioPlayer.isPlaying) {
      await audioPlayer.resume();
    } else {
      await audioPlayer.pause();
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
    final router = intent.ref.read(routerProvider);
    switch (intent.tab) {
      case HomeTabs.browse:
        router.goNamed(HomePage.name);
        break;
      case HomeTabs.search:
        router.goNamed(SearchPage.name);
        break;
      case HomeTabs.library:
        router.goNamed(LibraryPage.name);
        break;
      case HomeTabs.lyrics:
        router.goNamed(LyricsPage.name);
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
    final isFetchingActiveTrack = intent.ref.read(queryingTrackInfoProvider);
    if (isFetchingActiveTrack) {
      DirectionalFocusAction().invoke(
        DirectionalFocusIntent(
          intent.forward ? TraversalDirection.right : TraversalDirection.left,
        ),
      );
      return null;
    }
    final position = audioPlayer.position.inSeconds;
    await audioPlayer.seek(
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
      exit(0);
    } else {
      SystemNavigator.pop();
    }
    return null;
  }
}
