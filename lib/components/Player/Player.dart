import 'dart:async';
import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Player/PlayerActions.dart';
import 'package:spotube/components/Player/PlayerOverlay.dart';
import 'package:spotube/components/Player/PlayerTrackDetails.dart';
import 'package:spotube/components/Player/PlayerControls.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';

class Player extends HookConsumerWidget {
  Player({Key? key}) : super(key: key);

  final logger = createLogger(Player);
  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);

    final _volume = useState(0.0);

    final breakpoint = useBreakpoints();

    final AudioPlayer player = playback.player;

    final Future<SharedPreferences> future =
        useMemoized(SharedPreferences.getInstance);
    final AsyncSnapshot<SharedPreferences?> localStorage =
        useFuture(future, initialData: null);

    useEffect(() {
      /// warm up the audio player before playing actual audio
      /// It's for resolving unresolved issue related to just_audio's
      /// [disposeAllPlayers] method which is throwing
      /// [UnimplementedException] in the [PlatformInterface]
      /// implementation
      if (Platform.isAndroid || Platform.isIOS) {
        playback.audioSession
            ?.setActive(true)
            .then((_) => player.setAsset("assets/warmer.mp3"))
            .catchError((e) {
          logger.e("useEffect", e, StackTrace.current);
        });
      } else {
        player.setAsset("assets/warmer.mp3");
      }
      return null;
    }, []);

    useEffect(() {
      if (localStorage.hasData) {
        _volume.value = localStorage.data?.getDouble(LocalStorageKeys.volume) ??
            player.volume;
      }
      return null;
    }, [localStorage.data]);

    String albumArt = useMemoized(
      () => imageToUrlString(
        playback.currentTrack?.album?.images,
        index: (playback.currentTrack?.album?.images?.length ?? 1) - 1,
      ),
      [playback.currentTrack?.album?.images],
    );

    final entryRef = useRef<OverlayEntry?>(null);

    void disposeOverlay() {
      try {
        entryRef.value?.remove();
        entryRef.value = null;
      } catch (e, stack) {
        if (e is! AssertionError) {
          logger.e("useEffect.cleanup", e, stack);
        }
      }
    }

    useEffect(() {
      // I can't believe useEffect doesn't run Post Frame aka
      // after rendering/painting the UI
      // `My disappointment is immeasurable and my day is ruined` XD
      WidgetsBinding.instance?.addPostFrameCallback((time) {
        // clearing the overlay-entry as passing the already available
        // entry will result in splashing while resizing the window
        if (breakpoint.isLessThanOrEqualTo(Breakpoints.md) &&
            entryRef.value == null &&
            playback.currentTrack != null) {
          entryRef.value = OverlayEntry(
            opaque: false,
            builder: (context) => PlayerOverlay(albumArt: albumArt),
          );
          try {
            Overlay.of(context)?.insert(entryRef.value!);
          } catch (e) {
            if (e is AssertionError &&
                e.message ==
                    'The specified entry is already present in the Overlay.') {
              disposeOverlay();
              Overlay.of(context)?.insert(entryRef.value!);
            }
          }
        } else {
          disposeOverlay();
        }
      });
      return () {
        disposeOverlay();
      };
    }, [breakpoint, playback.currentTrack]);

    // returning an empty non spacious Container as the overlay will take
    // place in the global overlay stack aka [_entries]
    if (breakpoint.isLessThanOrEqualTo(Breakpoints.md)) {
      return Container();
    }

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: PlayerTrackDetails(albumArt: albumArt)),
            // controls
            Expanded(
              flex: 3,
              child: PlayerControls(),
            ),
            // add to saved tracks
            Expanded(
              flex: 1,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  Container(
                    height: 20,
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Slider.adaptive(
                      value: _volume.value,
                      onChanged: (value) async {
                        try {
                          await player.setVolume(value).then((_) {
                            _volume.value = value;
                            localStorage.data?.setDouble(
                              LocalStorageKeys.volume,
                              value,
                            );
                          });
                        } catch (e, stack) {
                          logger.e("onChange", e, stack);
                        }
                      },
                    ),
                  ),
                  PlayerActions()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
