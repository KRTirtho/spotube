import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';
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
                      .currently_downloading(downloadManager.totalDownloads),
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
                onPressed: downloadManager.totalDownloads == 0
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
              itemCount: downloadManager.totalDownloads,
              itemBuilder: (context, index) {
                final track = downloadManager.items.elementAt(index);
                return HookBuilder(builder: (context) {
                  final task = useStream(
                    downloadManager.activeDownloadProgress.stream
                        .where((element) => element.task.taskId == track.id),
                  );
                  final failedTaskStream = useStream(
                    downloadManager.failedDownloads.stream
                        .where((element) => element.taskId == track.id),
                  );
                  final taskItSelf = useFuture(
                    FileDownloader().database.recordForId(track.id!),
                  );

                  final hasFailed = failedTaskStream.hasData ||
                      taskItSelf.data?.status == TaskStatus.failed;

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
                    horizontalTitleGap: 10,
                    trailing: SizedBox(
                      width: 30,
                      height: 30,
                      child: downloadManager.activeItem?.id == track.id
                          ? CircularProgressIndicator(
                              value: task.data?.progress ?? 0,
                            )
                          : hasFailed
                              ? Icon(SpotubeIcons.error, color: Colors.red[400])
                              : IconButton(
                                  icon: const Icon(SpotubeIcons.close),
                                  onPressed: () {
                                    downloadManager.cancel(track);
                                  }),
                    ),
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
