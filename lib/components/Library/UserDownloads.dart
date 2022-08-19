import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserDownloads extends HookConsumerWidget {
  const UserDownloads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final downloader = ref.watch(downloaderProvider);

    final inQueue = downloader.inQueue.toList();
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[50],
                  onPrimary: Colors.red[400],
                ),
                child: const Text("Cancel All"),
                onPressed: downloader.currentlyRunning > 0
                    ? downloader.cancelAll
                    : null,
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: inQueue.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final track = inQueue[index];
            return ListTile(
              title: Text(track.name!),
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 40,
                    width: 40,
                    imageUrl: TypeConversionUtils.image_X_UrlString(
                      track.album?.images,
                    ),
                  ),
                ),
              ),
              trailing: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator.adaptive(),
              ),
              horizontalTitleGap: 5,
              subtitle: Text(
                TypeConversionUtils.artists_X_String<Artist>(
                  track.artists ?? [],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
