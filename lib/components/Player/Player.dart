import 'dart:async';

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
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';

class Player extends HookConsumerWidget {
  const Player({Key? key}) : super(key: key);
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
      player.setAsset("assets/warmer.mp3");
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

    disposeOverlay() {
      try {
        entryRef.value?.remove();
        entryRef.value = null;
      } catch (e, stack) {
        if (e is! AssertionError) {
          print("[Player.useEffect.cleanup] $e");
          print(stack);
        }
      }
    }

    useEffect(() {
      // clearing the overlay-entry as passing the already available
      // entry will result in splashing while resizing the window
      if (entryRef.value != null) disposeOverlay();
      if (breakpoint.isLessThanOrEqualTo(Breakpoints.md)) {
        entryRef.value = OverlayEntry(
          opaque: false,
          builder: (context) => PlayerOverlay(albumArt: albumArt),
        );
        // I can't believe useEffect doesn't run Post Frame aka
        // after rendering/painting the UI
        // `My disappointment is immeasurable and my day is ruined` XD
        WidgetsBinding.instance?.addPostFrameCallback((time) {
          Overlay.of(context)?.insert(entryRef.value!);
        });
      }
      return () {
        disposeOverlay();
      };
    }, [breakpoint]);

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
            const Expanded(
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
                          print("[VolumeSlider.onChange()] $e");
                          print(stack);
                        }
                      },
                    ),
                  ),
                  const PlayerActions()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
