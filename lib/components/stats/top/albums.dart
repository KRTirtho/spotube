import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/links/artist_link.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/album/album.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/utils/service_utils.dart';

class TopAlbums extends HookConsumerWidget {
  const TopAlbums({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final albums =
        ref.watch(playbackHistoryTopProvider.select((value) => value.albums));

    return SliverList.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return ListTile(
          horizontalTitleGap: 8,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: UniversalImage(
              path: (album.album.images).asUrlString(
                placeholder: ImagePlaceholder.albumArt,
              ),
              width: 40,
              height: 40,
            ),
          ),
          title: Text(album.album.name!),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${album.album.albumType?.formatted} • "),
              Flexible(
                child: ArtistLink(
                  artists: album.album.artists!,
                  mainAxisAlignment: WrapAlignment.start,
                ),
              ),
            ],
          ),
          trailing: Text(
            "${compactNumberFormatter.format(album.count)} plays",
          ),
          onTap: () {
            ServiceUtils.pushNamed(
              context,
              AlbumPage.name,
              pathParameters: {
                "id": album.album.id!,
              },
              extra: album.album,
            );
          },
        );
      },
    );
  }
}
