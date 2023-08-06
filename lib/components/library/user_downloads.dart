import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/services/download_manager/download_manager.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserDownloads extends HookConsumerWidget {
  const UserDownloads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(downloadManagerProvider);
    final downloadManager = ref.watch(downloadManagerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  context.l10n
                      .currently_downloading(downloadManager.$downloadCount),
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[400],
                ),
                onPressed: downloadManager.$downloadCount == 0
                    ? null
                    : downloadManager.cancelAll,
                child: Text(context.l10n.cancel_all),
              ),
            ],
          ),
        ),
        Expanded(
          child: SafeArea(
            child: ListView.builder(
              itemCount: downloadManager.$downloadCount,
              itemBuilder: (context, index) {
                final track = downloadManager.$history.elementAt(index);
                return HookBuilder(builder: (context) {
                  final taskStatus = useListenable(
                    useMemoized(
                      () => downloadManager.getStatusNotifier(track),
                      [track],
                    ),
                  );

                  return ListTile(
                    title: Text(track.name ?? ''),
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
                    trailing: taskStatus == null
                        ? null
                        : switch (taskStatus.value) {
                            DownloadStatus.downloading =>
                              HookBuilder(builder: (context) {
                                final taskProgress = useListenable(useMemoized(
                                  () => downloadManager
                                      .getProgressNotifier(track),
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
                                            downloadManager.pause(track);
                                          }),
                                      const SizedBox(width: 10),
                                      IconButton(
                                          icon: const Icon(SpotubeIcons.close),
                                          onPressed: () {
                                            downloadManager.cancel(track);
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
                                        downloadManager.resume(track);
                                      }),
                                  const SizedBox(width: 10),
                                  IconButton(
                                      icon: const Icon(SpotubeIcons.close),
                                      onPressed: () {
                                        downloadManager.cancel(track);
                                      })
                                ],
                              ),
                            DownloadStatus.failed ||
                            DownloadStatus.canceled =>
                              SizedBox(
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
                                        downloadManager.retry(track);
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
                                  downloadManager.removeFromQueue(track);
                                }),
                          },
                    subtitle: TypeConversionUtils.artists_X_ClickableArtists(
                      track.artists ?? <Artist>[],
                      mainAxisAlignment: WrapAlignment.start,
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
