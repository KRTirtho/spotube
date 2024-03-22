import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart' hide Offset;
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/lyrics/zoom_controls.dart';
import 'package:spotube/components/shared/shimmers/shimmer_lyrics.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_auto_scroll_controller.dart';
import 'package:spotube/components/lyrics/use_synced_lyrics.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:stroke_text/stroke_text.dart';

final _delay = StateProvider<int>((ref) => 0);

class SyncedLyrics extends HookConsumerWidget {
  final PaletteColor palette;
  final bool? isModal;
  final int defaultTextZoom;

  const SyncedLyrics({
    required this.palette,
    this.isModal,
    this.defaultTextZoom = 100,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);

    final mediaQuery = MediaQuery.of(context);
    final controller = useAutoScrollController();

    final delay = ref.watch(_delay);

    final timedLyricsQuery =
        useQueries.lyrics.spotifySynced(ref, playlist.activeTrack);

    final lyricValue = timedLyricsQuery.data;

    final isUnSyncLyric = useMemoized(
      () => lyricValue?.lyrics.every((l) => l.time == Duration.zero),
      [lyricValue],
    );

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
    final textZoomLevel = useState<int>(defaultTextZoom);

    final textTheme = Theme.of(context).textTheme;

    ref.listen(
      ProxyPlaylistNotifier.provider.select((s) => s.activeTrack),
      (previous, next) {
        controller.scrollToIndex(0);
        ref.read(_delay.notifier).state = 0;
      },
    );

    final headlineTextStyle = (mediaQuery.mdAndUp
            ? textTheme.displaySmall
            : textTheme.headlineMedium?.copyWith(fontSize: 25))
        ?.copyWith(color: palette.titleTextColor);

    final bodyTextTheme = textTheme.bodyLarge?.copyWith(
      color: palette.bodyTextColor,
    );
    return Stack(
      children: [
        Column(
          children: [
            if (isModal != true)
              Center(
                child: Text(
                  playlist.activeTrack?.name ?? "Not Playing",
                  style: headlineTextStyle,
                ),
              ),
            if (isModal != true)
              Center(
                child: Text(
                  TypeConversionUtils.artists_X_String<Artist>(
                      playlist.activeTrack?.artists ?? []),
                  style: mediaQuery.mdAndUp
                      ? textTheme.headlineSmall
                      : textTheme.titleLarge,
                ),
              ),
            if (lyricValue != null &&
                lyricValue.lyrics.isNotEmpty &&
                isUnSyncLyric == false)
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
                          ? Container(
                              padding: index == lyricValue.lyrics.length - 1
                                  ? EdgeInsets.only(
                                      bottom: mediaQuery.size.height / 2,
                                    )
                                  : null,
                            )
                          : Center(
                              child: Padding(
                                padding: index == lyricValue.lyrics.length - 1
                                    ? const EdgeInsets.all(8.0).copyWith(
                                        bottom: 100,
                                      )
                                    : const EdgeInsets.all(8.0),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: isActive
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    fontSize: (isActive ? 28 : 26) *
                                        (textZoomLevel.value / 100),
                                  ),
                                  textAlign: TextAlign.center,
                                  child: InkWell(
                                    onTap: () async {
                                      final duration =
                                          await audioPlayer.duration ??
                                              Duration.zero;
                                      final time = Duration(
                                        seconds:
                                            lyricSlice.time.inSeconds - delay,
                                      );
                                      if (time > duration || time.isNegative) {
                                        return;
                                      }
                                      audioPlayer.seek(time);
                                    },
                                    child: Builder(builder: (context) {
                                      return StrokeText(
                                        text: lyricSlice.text,
                                        textStyle:
                                            DefaultTextStyle.of(context).style,
                                        textColor: isActive
                                            ? Colors.white
                                            : palette.bodyTextColor,
                                        strokeColor: isActive
                                            ? Colors.black
                                            : Colors.transparent,
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            if (playlist.activeTrack != null &&
                (timedLyricsQuery.isLoading || timedLyricsQuery.isRefreshing))
              const Expanded(
                child: ShimmerLyrics(),
              )
            else if (playlist.activeTrack != null &&
                (timedLyricsQuery.hasError)) ...[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Text(
                  context.l10n.no_lyrics_available,
                  style: bodyTextTheme,
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(26),
              const Icon(SpotubeIcons.noLyrics, size: 60),
            ] else if (isUnSyncLyric == true)
              Expanded(
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: bodyTextTheme,
                      children: [
                        const TextSpan(
                          text:
                              "Synced lyrics are not available for this song. Please use the",
                        ),
                        TextSpan(
                          text: " Plain Lyrics ",
                          style: textTheme.bodyLarge?.copyWith(
                            color: palette.bodyTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: "tab instead."),
                      ],
                    ),
                  ),
                ),
              ),
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
