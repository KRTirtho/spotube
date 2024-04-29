import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/artist/artist.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/utils/service_utils.dart';

class TopArtists extends HookConsumerWidget {
  const TopArtists({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final artists =
        ref.watch(playbackHistoryTopProvider.select((value) => value.artists));

    return SliverList.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ListTile(
          title: Text(artist.artist.name!),
          horizontalTitleGap: 8,
          leading: CircleAvatar(
            backgroundImage: UniversalImage.imageProvider(
              (artist.artist.images).asUrlString(
                placeholder: ImagePlaceholder.artist,
              ),
            ),
          ),
          trailing: Text(
            "${compactNumberFormatter.format(artist.count)} plays",
          ),
          onTap: () {
            ServiceUtils.pushNamed(
              context,
              ArtistPage.name,
              pathParameters: {
                "id": artist.artist.id!,
              },
            );
          },
        );
      },
    );
  }
}
