import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/metadata/endpoints/error.dart';

final metadataPluginSearchAllProvider =
    FutureProvider.autoDispose.family<SpotubeSearchResponseObject, String>(
  (ref, query) async {
    final metadataPlugin = await ref.watch(metadataPluginProvider.future);

    if (metadataPlugin == null) {
      throw MetadataPluginException.noDefaultPlugin(
        "No default metadata plugin found",
      );
    }

    return metadataPlugin.search.all(query);
  },
);
