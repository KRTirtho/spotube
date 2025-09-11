import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/provider/metadata_plugin/utils/family_paginated.dart';

class MetadataPluginSearchPlaylistsNotifier
    extends AutoDisposeFamilyPaginatedAsyncNotifier<SpotubeSimplePlaylistObject,
        String> {
  MetadataPluginSearchPlaylistsNotifier() : super();

  @override
  fetch(offset, limit) async {
    if (arg.isEmpty) {
      return SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>(
        limit: limit,
        nextOffset: null,
        total: 0,
        items: [],
        hasMore: false,
      );
    }

    final res = await (await metadataPlugin).search.playlists(
          arg,
          offset: offset,
          limit: limit,
        );

    return res;
  }

  @override
  build(arg) async {
    ref.cacheFor();

    ref.watch(metadataPluginProvider);
    return await fetch(0, 20);
  }
}

final metadataPluginSearchPlaylistsProvider =
    AutoDisposeAsyncNotifierProviderFamily<
        MetadataPluginSearchPlaylistsNotifier,
        SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>,
        String>(
  () => MetadataPluginSearchPlaylistsNotifier(),
);
