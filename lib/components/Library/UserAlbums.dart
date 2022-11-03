import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerPlaybuttonCard.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserAlbums extends HookConsumerWidget {
  const UserAlbums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final albumsQuery = useQuery(
      job: currentUserAlbumsQueryJob,
      externalData: ref.watch(spotifyProvider),
    );

    if (albumsQuery.isLoading || !albumsQuery.hasData) {
      return const Center(child: ShimmerPlaybuttonCard(count: 7));
    }

    return SingleChildScrollView(
      child: Material(
        type: MaterialType.transparency,
        textStyle: PlatformTheme.of(context).textTheme!.body!,
        color: PlatformTheme.of(context).scaffoldBackgroundColor,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 20, // gap between adjacent chips
            runSpacing: 20, // gap between lines
            alignment: WrapAlignment.center,
            children: albumsQuery.data!
                .map((album) =>
                    AlbumCard(TypeConversionUtils.simpleAlbum_X_Album(album)))
                .toList(),
          ),
        ),
      ),
    );
  }
}
