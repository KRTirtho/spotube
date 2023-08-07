import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/services/download_manager/download_status.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class DownloadItem extends HookConsumerWidget {
  final Track track;
  const DownloadItem({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final downloadManager = ref.watch(downloadManagerProvider);

    final taskStatus = useState<DownloadStatus?>(null);

    useEffect(() {
      if (track is! SpotubeTrack) return null;
      final notifier = downloadManager.getStatusNotifier(track as SpotubeTrack);

      taskStatus.value = notifier?.value;
      listener() {
        taskStatus.value = notifier?.value;
      }

      downloadManager
          .getStatusNotifier(track as SpotubeTrack)
          ?.addListener(listener);

      return () {
        downloadManager
            .getStatusNotifier(track as SpotubeTrack)
            ?.removeListener(listener);
      };
    }, [track]);

    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: UniversalImage(
            height: 40,
            width: 40,
            path: TypeConversionUtils.image_X_UrlString(
              track.album?.images,
              placeholder: ImagePlaceholder.albumArt,
            ),
          ),
        ),
      ),
      title: Text(track.name ?? ''),
      subtitle: TypeConversionUtils.artists_X_ClickableArtists(
        track.artists ?? <Artist>[],
        mainAxisAlignment: WrapAlignment.start,
      ),
      trailing: taskStatus.value == null || track is! SpotubeTrack
          ? Text(
              context.l10n.querying_info,
              style: Theme.of(context).textTheme.labelMedium,
            )
          : switch (taskStatus.value!) {
              DownloadStatus.downloading => HookBuilder(builder: (context) {
                  final taskProgress = useListenable(useMemoized(
                    () => downloadManager
                        .getProgressNotifier(track as SpotubeTrack),
                    [track],
                  ));
                  return SizedBox(
                    width: 140,
                    child: Row(
                      children: [
                        CircularProgressIndicator(
                          value: taskProgress?.value ?? 0,
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                            icon: const Icon(SpotubeIcons.pause),
                            onPressed: () {
                              downloadManager.pause(track as SpotubeTrack);
                            }),
                        const SizedBox(width: 10),
                        IconButton(
                            icon: const Icon(SpotubeIcons.close),
                            onPressed: () {
                              downloadManager.cancel(track as SpotubeTrack);
                            }),
                      ],
                    ),
                  );
                }),
              DownloadStatus.paused => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(SpotubeIcons.play),
                        onPressed: () {
                          downloadManager.resume(track as SpotubeTrack);
                        }),
                    const SizedBox(width: 10),
                    IconButton(
                        icon: const Icon(SpotubeIcons.close),
                        onPressed: () {
                          downloadManager.cancel(track as SpotubeTrack);
                        })
                  ],
                ),
              DownloadStatus.failed || DownloadStatus.canceled => SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Icon(
                        SpotubeIcons.error,
                        color: Colors.red[400],
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(SpotubeIcons.refresh),
                        onPressed: () {
                          downloadManager.retry(track as SpotubeTrack);
                        },
                      ),
                    ],
                  ),
                ),
              DownloadStatus.completed =>
                Icon(SpotubeIcons.done, color: Colors.green[400]),
              DownloadStatus.queued => IconButton(
                  icon: const Icon(SpotubeIcons.close),
                  onPressed: () {
                    downloadManager.removeFromQueue(track as SpotubeTrack);
                  }),
            },
    );
  }
}
