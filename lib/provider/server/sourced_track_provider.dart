import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/audio_source/quality_presets.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

class SourcedTrackNotifier
    extends FamilyAsyncNotifier<SourcedTrack, SpotubeFullTrackObject> {
  @override
  FutureOr<SourcedTrack> build(query) {
    ref.watch(audioSourcePluginProvider);
    ref.watch(audioSourcePresetsProvider);

    return SourcedTrack.fetchFromTrack(query: query, ref: ref);
  }

  Future<SourcedTrack> refreshStreamingUrl() async {
    return await update((prev) async {
      return await prev.refreshStream();
    });
  }

  Future<SourcedTrack> copyWithSibling() async {
    return await update((prev) async {
      return prev.copyWithSibling();
    });
  }

  Future<SourcedTrack> swapWithSibling(
    SpotubeAudioSourceMatchObject sibling,
  ) async {
    return await update((prev) async {
      return await prev.swapWithSibling(sibling) ?? prev;
    });
  }

  Future<SourcedTrack> swapWithNextSibling() async {
    return await update((prev) async {
      return await prev.swapWithSibling(prev.siblings.first) as SourcedTrack;
    });
  }
}

final sourcedTrackProvider = AsyncNotifierProviderFamily<SourcedTrackNotifier,
    SourcedTrack, SpotubeFullTrackObject>(
  () => SourcedTrackNotifier(),
);
