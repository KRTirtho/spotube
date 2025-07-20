import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';

class MetadataPluginAlbumReleasesNotifier
    extends PaginatedAsyncNotifier<SpotubeSimpleAlbumObject> {
  @override
  Future<SpotubePaginationResponseObject<SpotubeSimpleAlbumObject>> fetch(
    int offset,
    int limit,
  ) async {
    return await (await metadataPlugin)
        .album
        .releases(limit: limit, offset: offset);
  }

  @override
  build() async {
    ref.watch(metadataPluginAuthenticatedProvider);
    return await fetch(0, 20);
  }
}

final metadataPluginAlbumReleasesProvider = AsyncNotifierProvider<
    MetadataPluginAlbumReleasesNotifier,
    SpotubePaginationResponseObject<SpotubeSimpleAlbumObject>>(
  () => MetadataPluginAlbumReleasesNotifier(),
);
