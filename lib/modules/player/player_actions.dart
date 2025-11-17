import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/modules/player/sibling_tracks_sheet.dart';
import 'package:spotube/components/adaptive/adaptive_pop_sheet_list.dart';
import 'package:spotube/components/heart_button/heart_button.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/local_tracks/local_tracks_provider.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
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
    final isLocalTrack = playlist.activeTrack is SpotubeLocalTrackObject;
    ref.watch(downloadManagerProvider);
    final downloader = ref.watch(downloadManagerProvider.notifier);
    final isInQueue = useMemoized(() {
      if (playlist.activeTrack is! SpotubeFullTrackObject) return false;
      final downloadTask =
          downloader.getTaskByTrackId(playlist.activeTrack!.id);
      return const [
        DownloadStatus.queued,
        DownloadStatus.downloading,
      ].contains(downloadTask?.status);
    }, [
      playlist.activeTrack,
      downloader,
    ]);

    final localTracks = ref.watch(localTracksProvider).value;
    final authenticated = ref.watch(metadataPluginAuthenticatedProvider);
    final sleepTimer = ref.watch(sleepTimerProvider);
    final sleepTimerNotifier = ref.watch(sleepTimerProvider.notifier);

    final isDownloaded = useMemoized(() {
      return localTracks?.values.expand((e) => e).any(
                (element) =>
                    element.name == playlist.activeTrack?.name &&
                    element.album.name == playlist.activeTrack?.album.name &&
                    element.artists.asString() ==
                        playlist.activeTrack?.artists.asString(),
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
          Tooltip(
            tooltip: TooltipContainer(child: Text(context.l10n.queue)).call,
            child: IconButton.ghost(
              icon: const Icon(SpotubeIcons.queue),
              enabled: playlist.activeTrack != null,
              onPressed: () {
                openDrawer(
                  context: context,
                  position: OverlayPosition.right,
                  transformBackdrop: false,
                  draggable: false,
                  surfaceBlur: context.theme.surfaceBlur,
                  surfaceOpacity: 0.7,
                  builder: (context) {
                    return Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Consumer(
                        builder: (context, ref, _) {
                          final playlist = ref.watch(audioPlayerProvider);
                          final playlistNotifier =
                              ref.read(audioPlayerProvider.notifier);

                          return PlayerQueue.fromAudioPlayerNotifier(
                            floating: true,
                            playlist: playlist,
                            notifier: playlistNotifier,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        if (!isLocalTrack)
          Tooltip(
            tooltip: TooltipContainer(
              child: Text(context.l10n.alternative_track_sources),
            ).call,
            child: IconButton.ghost(
              enabled: playlist.activeTrack != null,
              icon: const Icon(SpotubeIcons.alternativeRoute),
              onPressed: () {
                final screenSize = MediaQuery.sizeOf(context);
                if (screenSize.mdAndUp) {
                  showPopover(
                    alignment: Alignment.bottomCenter,
                    context: context,
                    builder: (context) {
                      return SurfaceCard(
                        padding: EdgeInsets.zero,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 600,
                            maxWidth: 500,
                          ),
                          child: SiblingTracksSheet(floating: floatingQueue),
                        ),
                      );
                    },
                  );
                } else {
                  context.pushRoute(const PlayerTrackSourcesRoute());
                }
              },
            ),
          ),
        if (!kIsWeb && !isLocalTrack)
          if (isInQueue)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                size: 2,
              ),
            )
          else
            Tooltip(
              tooltip:
                  TooltipContainer(child: Text(context.l10n.download_track))
                      .call,
              child: IconButton.ghost(
                icon: Icon(
                  isDownloaded ? SpotubeIcons.done : SpotubeIcons.download,
                ),
                onPressed: playlist.activeTrack != null
                    ? () => downloader.addToQueue(
                        playlist.activeTrack! as SpotubeFullTrackObject)
                    : null,
              ),
            ),
        if (playlist.activeTrack != null &&
            !isLocalTrack &&
            authenticated.asData?.value == true)
          TrackHeartButton(track: playlist.activeTrack!),
        AdaptivePopSheetList<Duration>(
          tooltip: context.l10n.sleep_timer,
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
          items: (context) => [
            for (final entry in sleepTimerEntries.entries)
              AdaptiveMenuButton(
                value: entry.value,
                enabled: sleepTimer != entry.value,
                child: Text(entry.key),
              ),
            AdaptiveMenuButton(
              enabled: customHoursEnabled,
              onPressed: (context) async {
                final currentTime = TimeOfDay.now();
                final time = await showDialog<TimeOfDay?>(
                  context: context,
                  builder: (context) => HookBuilder(builder: (context) {
                    final timeRef = useRef<TimeOfDay?>(null);
                    return AlertDialog(
                      trailing: IconButton.ghost(
                        size: ButtonSize.xSmall,
                        icon: const Icon(SpotubeIcons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      title: Text(
                        ShadcnLocalizations.of(context).placeholderTimePicker,
                      ),
                      content: TimePickerDialog(
                        use24HourFormat: false,
                        initialValue: TimeOfDay.fromDateTime(
                          DateTime.now().add(sleepTimer ?? Duration.zero),
                        ),
                        onChanged: (value) => timeRef.value = value,
                      ),
                      actions: [
                        Button.primary(
                          onPressed: () {
                            Navigator.of(context).pop(timeRef.value);
                          },
                          child: Text(context.l10n.save),
                        ),
                      ],
                    );
                  }),
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
              child: Text(
                customHoursEnabled
                    ? context.l10n.custom_hours
                    : sleepTimer.format(abbreviated: true),
              ),
            ),
            AdaptiveMenuButton(
              value: Duration.zero,
              enabled: sleepTimer != Duration.zero && sleepTimer != null,
              child: Text(
                context.l10n.cancel,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        ...(extraActions ?? [])
      ],
    );
  }
}
