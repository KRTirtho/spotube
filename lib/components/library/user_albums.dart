import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/type_conversion_utils.dart';

class UserAlbums extends HookConsumerWidget {
  const UserAlbums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    if (auth.isAnonymous) {
      return const AnonymousFallback();
    }
    final albumsQuery = useQuery(
      job: Queries.album.ofMine,
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
