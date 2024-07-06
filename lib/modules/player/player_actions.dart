import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/player/sibling_tracks_sheet.dart';
import 'package:spotube/components/adaptive/adaptive_pop_sheet_list.dart';
import 'package:spotube/components/heart_button/heart_button.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/sleep_timer_provider.dart';

class PlayerActions extends HookConsumerWidget {
  final MainAxisAlignment mainAxisAlignment;
  final bool floatingQueue;
  final bool showQueue;
  final List<Widget>? extraActions;

  const PlayerActions({
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.floatingQueue = true,
    this.showQueue = true,
    this.extraActions,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(audioPlayerProvider);
    final isLocalTrack = playlist.activeTrack is LocalTrack;
    ref.watch(downloadManagerProvider);
    final downloader = ref.watch(downloadManagerProvider.notifier);
    final isInQueue = useMemoized(() {
      if (playlist.activeTrack == null) return false;
      return downloader.isActive(playlist.activeTrack!);
    }, [
      playlist.activeTrack,
      downloader,
    ]);

    final localTracks = [] /* ref.watch(localTracksProvider).value */;
    final auth = ref.watch(authenticationProvider);
    final sleepTimer = ref.watch(sleepTimerProvider);
    final sleepTimerNotifier = ref.watch(sleepTimerProvider.notifier);

    final isDownloaded = useMemoized(() {
      return localTracks.any(
            (element) =>
                element.name == playlist.activeTrack?.name &&
                element.album?.name == playlist.activeTrack?.album?.name &&
                element.artists?.asString() ==
                    playlist.activeTrack?.artists?.asString(),
          ) ==
          true;
    }, [localTracks, playlist.activeTrack]);

    final sleepTimerEntries = useMemoized(
      () => {
        context.l10n.mins(15): const Duration(minutes: 15),
        context.l10n.mins(30): const Duration(minutes: 30),
        context.l10n.hour(1): const Duration(hours: 1),
        context.l10n.hour(2): const Duration(hours: 2),
      },
      [context.l10n],
    );

    var customHoursEnabled =
        sleepTimer == null || sleepTimerEntries.values.contains(sleepTimer);
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (showQueue)
          IconButton(
            icon: const Icon(SpotubeIcons.queue),
            tooltip: context.l10n.queue,
            onPressed: playlist.activeTrack != null
                ? () {
                    Scaffold.of(context).openEndDrawer();
                  }
                : null,
          ),
        if (!isLocalTrack)
          IconButton(
            icon: const Icon(SpotubeIcons.alternativeRoute),
            tooltip: context.l10n.alternative_track_sources,
            onPressed: playlist.activeTrack != null
                ? () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.black12,
                      barrierColor: Colors.black12,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      builder: (context) {
                        return SiblingTracksSheet(floating: floatingQueue);
                      },
                    );
                  }
                : null,
          ),
        if (!kIsWeb && !isLocalTrack)
          if (isInQueue)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          else
            IconButton(
              tooltip: context.l10n.download_track,
              icon: Icon(
                isDownloaded ? SpotubeIcons.done : SpotubeIcons.download,
              ),
              onPressed: playlist.activeTrack != null
                  ? () => downloader.addToQueue(playlist.activeTrack!)
                  : null,
            ),
        if (playlist.activeTrack != null &&
            !isLocalTrack &&
            auth.asData?.value != null)
          TrackHeartButton(track: playlist.activeTrack!),
        AdaptivePopSheetList(
          offset: Offset(0, -50 * (sleepTimerEntries.values.length + 2)),
          headings: [
            Text(context.l10n.sleep_timer),
          ],
          icon: Icon(
            SpotubeIcons.timer,
            color: sleepTimer != null ? Colors.red : null,
          ),
          onSelected: (value) {
            if (value == Duration.zero) {
              sleepTimerNotifier.cancelSleepTimer();
            } else {
              sleepTimerNotifier.setSleepTimer(value);
            }
          },
          children: [
            for (final entry in sleepTimerEntries.entries)
              PopSheetEntry(
                value: entry.value,
                enabled: sleepTimer != entry.value,
                title: Text(entry.key),
              ),
            PopSheetEntry(
              title: Text(
                customHoursEnabled
                    ? context.l10n.custom_hours
                    : sleepTimer.format(abbreviated: true),
              ),
              // only enabled when there's no preset timers selected
              enabled: customHoursEnabled,
              onTap: () async {
                final currentTime = TimeOfDay.now();
                final time = await showTimePicker(
                  context: context,
                  initialTime: currentTime,
                );

                if (time != null) {
                  sleepTimerNotifier.setSleepTimer(
                    Duration(
                      hours: (time.hour - currentTime.hour).abs(),
                      minutes: (time.minute - currentTime.minute).abs(),
                    ),
                  );
                }
              },
            ),
            PopSheetEntry(
              value: Duration.zero,
              enabled: sleepTimer != Duration.zero && sleepTimer != null,
              textColor: Colors.green,
              title: Text(context.l10n.cancel),
            ),
          ],
        ),
        ...(extraActions ?? [])
      ],
    );
  }
}
