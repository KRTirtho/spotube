import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:spotube/hooks/playback.dart';
import 'package:spotube/models/GlobalKeyActions.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';

useHotKeys(WidgetRef ref) {
  final playback = ref.watch(playbackProvider);
  final preferences = ref.watch(userPreferencesProvider);
  List<GlobalKeyActions> _hotKeys = [];

  final onNext = useNextTrack(playback);

  final onPrevious = usePreviousTrack(playback);

  final _playOrPause = useTogglePlayPause(playback);

  useEffect(() {
    if (Platform.isIOS || Platform.isAndroid) return null;
    _hotKeys = [
      GlobalKeyActions(
        HotKey(KeyCode.space, scope: HotKeyScope.inapp),
        _playOrPause,
      ),
      if (preferences.nextTrackHotKey != null)
        GlobalKeyActions(preferences.nextTrackHotKey!, (key) => onNext()),
      if (preferences.prevTrackHotKey != null)
        GlobalKeyActions(preferences.prevTrackHotKey!, (key) => onPrevious()),
      if (preferences.playPauseHotKey != null)
        GlobalKeyActions(preferences.playPauseHotKey!, _playOrPause)
    ];
    Future.wait(
      _hotKeys.map((e) {
        return hotKeyManager.register(
          e.hotKey,
          keyDownHandler: e.onKeyDown,
        );
      }),
    );
    return () {
      Future.wait(_hotKeys.map((e) => hotKeyManager.unregister(e.hotKey)));
    };
  });
}
