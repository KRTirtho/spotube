import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/services/metadata/endpoints/error.dart';

final metadataPluginAlbumProvider =
    FutureProvider.autoDispose.family<SpotubeFullAlbumObject, String>(
  (ref, id) async {
    ref.cacheFor();

    final metadataPlugin = await ref.watch(metadataPluginProvider.future);

    if (metadataPlugin == null) {
      throw MetadataPluginException.noDefaultPlugin(
        "No metadata plugin is not set",
      );
    }

    return metadataPlugin.album.getAlbum(id);
  },
);
