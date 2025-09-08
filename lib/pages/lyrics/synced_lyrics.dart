import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/lyrics/zoom_controls.dart';
import 'package:spotube/components/shimmers/shimmer_lyrics.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_auto_scroll_controller.dart';
import 'package:spotube/modules/lyrics/use_synced_lyrics.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/lyrics/synced.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';

class SyncedLyrics extends HookConsumerWidget {
  final PaletteColor palette;
  final bool? isModal;
  final int defaultTextZoom;

  const SyncedLyrics({
    required this.palette,
    this.isModal,
    this.defaultTextZoom = 100,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    final playlist = ref.watch(audioPlayerProvider);

    final controller = useAutoScrollController();

    final delay = ref.watch(syncedLyricsDelayProvider);

    final timedLyricsQuery =
        ref.watch(syncedLyricsProvider(playlist.activeTrack));

    final lyricValue = timedLyricsQuery.asData?.value;

    final lyricsState = ref.watch(
      syncedLyricsMapProvider(playlist.activeTrack),
    );
    final currentTime =
        useSyncedLyrics(ref, lyricsState.asData?.value.lyricsMap ?? {}, delay);
    final textZoomLevel = useState<int>(defaultTextZoom);

    final typography = Theme.of(context).typography;

    ref.listen(
      audioPlayerProvider.select((s) => s.activeTrack),
      (previous, next) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        ref.read(syncedLyricsDelayProvider.notifier).state = 0;
      },
    );

    final headlineTextStyle = (mediaQuery.mdAndUp
            ? typography.h3
            : typography.h4.copyWith(fontSize: 25))
        .copyWith(
      color: palette.titleTextColor,
    );

    final bodyTextTheme = typography.large.copyWith(
      color: palette.bodyTextColor,
    );

    useEffect(() {
      StreamSubscription? subscription;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        subscription = audioPlayer.positionStream.listen((event) {
          try {
            if (event > Duration.zero || !controller.hasClients) return;
            controller.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } catch (e, stack) {
            AppLogger.reportError(e, stack);
          }
        });
      });

      return subscription?.cancel;
    }, [controller]);

    return Stack(
      children: [
        CustomScrollView(
          controller: controller,
          slivers: [
            if (isModal != true)
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  playlist.activeTrack?.name ?? context.l10n.not_playing,
                  style: headlineTextStyle,
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Text(
                    playlist.activeTrack?.artists.asString() ?? "",
                    style:
                        mediaQuery.mdAndUp ? typography.h4 : typography.x2Large,
                  ),
                ),
              ),
            if (lyricValue != null &&
                lyricValue.lyrics.isNotEmpty &&
                lyricsState.asData?.value.static != true)
              SliverList.builder(
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
                                    bottom: mediaQuery.height / 2,
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
                                  color: isActive
                                      ? theme.colorScheme.foreground
                                      : theme.colorScheme.mutedForeground,
                                  fontWeight: isActive
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                  fontSize: (isActive ? 28 : 26) *
                                      (textZoomLevel.value / 100),
                                ),
                                textAlign: TextAlign.center,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final time = Duration(
                                        seconds:
                                            lyricSlice.time.inSeconds - delay,
                                      );
                                      if (time > audioPlayer.duration ||
                                          time.isNegative) {
                                        return;
                                      }
                                      audioPlayer.seek(time);
                                    },
                                    child: Text(lyricSlice.text),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
            if (playlist.activeTrack != null &&
                (timedLyricsQuery.isLoading || timedLyricsQuery.isRefreshing))
              const SliverToBoxAdapter(child: ShimmerLyrics())
            else if (playlist.activeTrack != null &&
                (timedLyricsQuery.hasError)) ...[
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    context.l10n.no_lyrics_available,
                    style: bodyTextTheme,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SliverGap(26),
              const SliverToBoxAdapter(
                child: Icon(SpotubeIcons.noLyrics, size: 60),
              ),
            ] else if (lyricsState.asData?.value.static == true)
              SliverFillRemaining(
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: bodyTextTheme,
                      children: [
                        TextSpan(
                          text: context.l10n.synced_lyrics_not_available,
                        ),
                        TextSpan(
                          text: " ${context.l10n.plain_lyrics} ",
                          style: typography.large.copyWith(
                            color: palette.bodyTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: context.l10n.tab_instead),
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
                onChanged: (value) =>
                    ref.read(syncedLyricsDelayProvider.notifier).state = value,
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
