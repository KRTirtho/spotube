import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

class TrackSourcesNotifier
    extends FamilyAsyncNotifier<SourcedTrack, TrackSourceQuery> {
  @override
  FutureOr<SourcedTrack> build(query) {
    ref.watch(userPreferencesProvider.select((p) => p.audioQuality));
    ref.watch(userPreferencesProvider.select((p) => p.audioSource));
    ref.watch(userPreferencesProvider.select((p) => p.streamMusicCodec));
    ref.watch(userPreferencesProvider.select((p) => p.downloadMusicCodec));

    return SourcedTrack.fetchFromQuery(query: query, ref: ref);
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

  Future<SourcedTrack> swapWithSibling(TrackSourceInfo sibling) async {
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

final trackSourcesProvider = AsyncNotifierProviderFamily<TrackSourcesNotifier,
    SourcedTrack, TrackSourceQuery>(
  () => TrackSourcesNotifier(),
);
