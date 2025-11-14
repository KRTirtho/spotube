import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';

final metadataPluginTrackProvider =
    FutureProvider.family<SpotubeFullTrackObject, String>((ref, trackId) async {
  final metadataPlugin = await ref.watch(metadataPluginProvider.future);

  if (metadataPlugin == null) {
    throw MetadataPluginException.noDefaultMetadataPlugin();
  }

  return metadataPlugin.track.getTrack(trackId);
});
