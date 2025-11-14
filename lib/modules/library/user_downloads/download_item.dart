import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/download_manager_provider.dart';

class DownloadItem extends HookConsumerWidget {
  final DownloadTask task;
  const DownloadItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, ref) {
    final downloadManager = ref.watch(downloadManagerProvider.notifier);

    return ButtonTile(
      style: ButtonVariance.ghost,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: UniversalImage(
            height: 40,
            width: 40,
            path: task.track.album.images.asUrlString(
              placeholder: ImagePlaceholder.albumArt,
            ),
          ),
        ),
      ),
      title: Text(task.track.name),
      subtitle: ArtistLink(
        artists: task.track.artists,
        mainAxisAlignment: WrapAlignment.start,
        onOverflowArtistClick: () {
          context.navigateTo(TrackRoute(trackId: task.track.id));
        },
      ),
      trailing: switch (task.status) {
        DownloadStatus.downloading => HookBuilder(builder: (context) {
            return StreamBuilder(
                stream: task.downloadedBytesStream,
                builder: (context, asyncSnapshot) {
                  final progress =
                      task.totalSizeBytes == null || task.totalSizeBytes == 0
                          ? 0
                          : (asyncSnapshot.data ?? 0) / task.totalSizeBytes!;

                  return Row(
                    children: [
                      CircularProgressIndicator(
                        value: progress.toDouble(),
                      ),
                      const SizedBox(width: 10),
                      const SizedBox(width: 10),
                      IconButton.ghost(
                          icon: const Icon(SpotubeIcons.close),
                          onPressed: () {
                            downloadManager.cancel(task.track);
                          }),
                    ],
                  );
                });
          }),
        DownloadStatus.failed || DownloadStatus.canceled => SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(
                  SpotubeIcons.error,
                  color: Colors.red[400],
                ),
                const SizedBox(width: 10),
                IconButton.ghost(
                  icon: const Icon(SpotubeIcons.refresh),
                  onPressed: () {
                    downloadManager.retry(task.track);
                  },
                ),
              ],
            ),
          ),
        DownloadStatus.completed =>
          Icon(SpotubeIcons.done, color: Colors.green[400]),
        DownloadStatus.queued => IconButton.ghost(
            icon: const Icon(SpotubeIcons.close),
            onPressed: () {
              downloadManager.cancel(task.track);
            }),
      },
    );
  }
}
