import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/utils/family_paginated.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';

class MetadataPluginPlaylistTracksNotifier
    extends AutoDisposeFamilyPaginatedAsyncNotifier<SpotubeFullTrackObject,
        String> {
  MetadataPluginPlaylistTracksNotifier() : super();

  @override
  fetch(offset, limit) async {
    final tracks = await (await metadataPlugin).playlist.tracks(
          arg,
          offset: offset,
          limit: limit,
        );

    return tracks;
  }

  @override
  build(arg) async {
    ref.cacheFor();

    ref.watch(metadataPluginProvider);
    return await fetch(0, 20);
  }
}

final metadataPluginPlaylistTracksProvider =
    AutoDisposeAsyncNotifierProviderFamily<MetadataPluginPlaylistTracksNotifier,
        SpotubePaginationResponseObject<SpotubeFullTrackObject>, String>(
  () => MetadataPluginPlaylistTracksNotifier(),
);
