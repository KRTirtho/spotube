import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/track/track.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/services/download_manager/download_status.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/service_utils.dart';

class DownloadItem extends HookConsumerWidget {
  final Track track;
  const DownloadItem({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context, ref) {
    final downloadManager = ref.watch(downloadManagerProvider);

    final taskStatus = useState<DownloadStatus?>(null);

    useEffect(() {
      if (track is! SourcedTrack) return null;
      final notifier = downloadManager.getStatusNotifier(track as SourcedTrack);

      taskStatus.value = notifier?.value;

      void listener() {
        taskStatus.value = notifier?.value;
      }

      notifier?.addListener(listener);

      return () {
        notifier?.removeListener(listener);
      };
    }, [track]);

    final isQueryingSourceInfo =
        taskStatus.value == null || track is! SourcedTrack;

    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: UniversalImage(
            height: 40,
            width: 40,
            path: (track.album?.images).asUrlString(
              placeholder: ImagePlaceholder.albumArt,
            ),
          ),
        ),
      ),
      title: Text(track.name ?? ''),
      subtitle: ArtistLink(
        artists: track.artists ?? <Artist>[],
        mainAxisAlignment: WrapAlignment.start,
        onOverflowArtistClick: () => ServiceUtils.pushNamed(
          context,
          TrackPage.name,
          pathParameters: {
            "id": track.id!,
          },
        ),
      ),
      trailing: isQueryingSourceInfo
          ? Text(
              context.l10n.querying_info,
              style: Theme.of(context).textTheme.labelMedium,
            )
          : switch (taskStatus.value!) {
              DownloadStatus.downloading => HookBuilder(builder: (context) {
                  final taskProgress = useListenable(useMemoized(
                    () => downloadManager
                        .getProgressNotifier(track as SourcedTrack),
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
                              downloadManager.pause(track as SourcedTrack);
                            }),
                        const SizedBox(width: 10),
                        IconButton(
                            icon: const Icon(SpotubeIcons.close),
                            onPressed: () {
                              downloadManager.cancel(track as SourcedTrack);
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
                          downloadManager.resume(track as SourcedTrack);
                        }),
                    const SizedBox(width: 10),
                    IconButton(
                        icon: const Icon(SpotubeIcons.close),
                        onPressed: () {
                          downloadManager.cancel(track as SourcedTrack);
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
                          downloadManager.retry(track as SourcedTrack);
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
                    downloadManager.removeFromQueue(track as SourcedTrack);
                  }),
            },
    );
  }
}
