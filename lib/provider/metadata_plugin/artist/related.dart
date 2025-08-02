import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/utils/family_paginated.dart';

class MetadataPluginArtistRelatedArtistsNotifier
    extends FamilyPaginatedAsyncNotifier<SpotubeFullArtistObject, String> {
  @override
  Future<SpotubePaginationResponseObject<SpotubeFullArtistObject>> fetch(
    int offset,
    int limit,
  ) async {
    return await (await metadataPlugin).artist.related(
          arg,
          limit: limit,
          offset: offset,
        );
  }

  @override
  build(arg) async {
    ref.watch(metadataPluginProvider);
    return await fetch(0, 20);
  }
}

final metadataPluginArtistRelatedArtistsProvider = AsyncNotifierProviderFamily<
    MetadataPluginArtistRelatedArtistsNotifier,
    SpotubePaginationResponseObject<SpotubeFullArtistObject>,
    String>(
  () => MetadataPluginArtistRelatedArtistsNotifier(),
);
