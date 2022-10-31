import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserDownloads extends HookConsumerWidget {
  const UserDownloads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final downloader = ref.watch(downloaderProvider);

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
                  "Currently downloading (${downloader.currentlyRunning})",
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              const SizedBox(width: 10),
              PlatformFilledButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[400],
                ),
                onPressed: downloader.currentlyRunning > 0
                    ? downloader.cancelAll
                    : null,
                child: const Text("Cancel All"),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: downloader.inQueue.length,
            itemBuilder: (context, index) {
              final track = downloader.inQueue.elementAt(index);
              return PlatformListTile(
                title: Text(track.name!),
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
                trailing: const SizedBox(
                  width: 30,
                  height: 30,
                  child: PlatformCircularProgressIndicator(),
                ),
                subtitle: Text(
                  TypeConversionUtils.artists_X_String(
                    track.artists ?? <Artist>[],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
