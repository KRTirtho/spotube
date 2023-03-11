import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/lyrics/zoom_controls.dart';
import 'package:spotube/components/shared/shimmers/shimmer_lyrics.dart';
import 'package:spotube/hooks/use_auto_scroll_controller.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/hooks/use_synced_lyrics.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/type_conversion_utils.dart';

final _delay = StateProvider<int>((ref) => 0);

class SyncedLyrics extends HookConsumerWidget {
  final PaletteColor palette;
  final bool? isModal;

  const SyncedLyrics({
    required this.palette,
    this.isModal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(PlaylistQueueNotifier.provider);

    final breakpoint = useBreakpoints();
    final controller = useAutoScrollController();

    final delay = ref.watch(_delay);

    final timedLyricsQuery =
        useQueries.lyrics.spotifySynced(ref, playlist?.activeTrack);

    final lyricValue = timedLyricsQuery.data;

    final lyricsMap = useMemoized(
      () =>
          lyricValue?.lyrics
              .map((lyric) => {lyric.time.inSeconds: lyric.text})
              .reduce((accumulator, lyricSlice) =>
                  {...accumulator, ...lyricSlice}) ??
          {},
      [lyricValue],
    );
    final currentTime = useSyncedLyrics(ref, lyricsMap, delay);
    final textZoomLevel = useState<int>(100);

    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      controller.scrollToIndex(0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(_delay.notifier).state = 0;
      });
      return null;
    }, [playlist?.activeTrack]);

    final headlineTextStyle = (breakpoint >= Breakpoints.md
            ? textTheme.displaySmall
            : textTheme.headlineMedium?.copyWith(fontSize: 25))
        ?.copyWith(color: palette.titleTextColor);

    return Stack(
      children: [
        Column(
          children: [
            if (isModal != true)
              Center(
                child: Text(
                  playlist?.activeTrack.name ?? "Not Playing",
                  style: headlineTextStyle,
                ),
              ),
            if (isModal != true)
              Center(
                child: Text(
                  TypeConversionUtils.artists_X_String<Artist>(
                      playlist?.activeTrack.artists ?? []),
                  style: breakpoint >= Breakpoints.md
                      ? textTheme.headlineSmall
                      : textTheme.titleLarge,
                ),
              ),
            if (lyricValue != null && lyricValue.lyrics.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: lyricValue.lyrics.length,
                  itemBuilder: (context, index) {
                    final lyricSlice = lyricValue.lyrics[index];
                    final isActive = lyricSlice.time.inSeconds == currentTime;

                    if (isActive) {
                      controller.scrollToIndex(
                        index,
                        preferPosition: AutoScrollPosition.middle,
                      );
                    }
                    return AutoScrollTag(
                      key: ValueKey(index),
                      index: index,
                      controller: controller,
                      child: lyricSlice.text.isEmpty
                          ? Container()
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : palette.bodyTextColor,
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: (isActive ? 30 : 26) *
                                        (textZoomLevel.value / 100),
                                  ),
                                  child: Text(
                                    lyricSlice.text,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            if (playlist?.activeTrack != null &&
                (lyricValue == null || lyricValue.lyrics.isEmpty == true))
              const Expanded(child: ShimmerLyrics()),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Builder(builder: (context) {
            final actions = [
              ZoomControls(
                value: delay,
                onChanged: (value) => ref.read(_delay.notifier).state = value,
                interval: 1,
                unit: "s",
                increaseIcon: const Icon(SpotubeIcons.add),
                decreaseIcon: const Icon(SpotubeIcons.remove),
                direction: isModal == true ? Axis.horizontal : Axis.vertical,
              ),
              ZoomControls(
                value: textZoomLevel.value,
                onChanged: (value) => textZoomLevel.value = value,
                min: 50,
                max: 200,
              ),
            ];

            return isModal == true
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: actions,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: actions,
                  );
          }),
        ),
      ],
    );
  }
}
