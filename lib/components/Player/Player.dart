import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Player/PlayerActions.dart';
import 'package:spotube/components/Player/PlayerOverlay.dart';
import 'package:spotube/components/Player/PlayerTrackDetails.dart';
import 'package:spotube/components/Player/PlayerControls.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class Player extends HookConsumerWidget {
  Player({Key? key}) : super(key: key);

  final logger = getLogger(Player);
  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final layoutMode =
        ref.watch(userPreferencesProvider.select((s) => s.layoutMode));

    final breakpoint = useBreakpoints();

    String albumArt = useMemoized(
      () => playback.track?.album?.images?.isNotEmpty == true
          ? TypeConversionUtils.image_X_UrlString(
              playback.track?.album?.images,
              index: (playback.track?.album?.images?.length ?? 1) - 1,
              placeholder: ImagePlaceholder.albumArt,
            )
          : "assets/album-placeholder.png",
      [playback.track?.album?.images],
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
      WidgetsBinding.instance.addPostFrameCallback((time) {
        // clearing the overlay-entry as passing the already available
        // entry will result in splashing while resizing the window
        if ((layoutMode == LayoutMode.compact ||
                (breakpoint.isLessThanOrEqualTo(Breakpoints.md) &&
                    layoutMode == LayoutMode.adaptive)) &&
            entryRef.value == null &&
            playback.track != null) {
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
    }, [breakpoint, playback.track, layoutMode]);

    // returning an empty non spacious Container as the overlay will take
    // place in the global overlay stack aka [_entries]
    if (layoutMode == LayoutMode.compact ||
        (breakpoint.isLessThanOrEqualTo(Breakpoints.md) &&
            layoutMode == LayoutMode.adaptive)) {
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
            Flexible(
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
                    child: HookBuilder(builder: (context) {
                      final volume = useState(playback.volume);

                      useEffect(() {
                        if (volume.value != playback.volume) {
                          volume.value = playback.volume;
                        }
                        return null;
                      }, [playback.volume]);
                      return Slider.adaptive(
                        min: 0,
                        max: 1,
                        value: volume.value,
                        onChanged: (v) {
                          volume.value = v;
                        },
                        onChangeEnd: (value) async {
                          try {
                            // You don't really need to know why but this
                            // way it works only
                            await playback.setVolume(value);
                            await playback.setVolume(value);
                          } catch (e, stack) {
                            logger.e("onChange", e, stack);
                          }
                        },
                      );
                    }),
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
