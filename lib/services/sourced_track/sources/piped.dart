import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/source_match.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/source_map.dart';
import 'package:spotube/services/sourced_track/models/video_info.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

final pipedProvider = Provider<PipedClient>(
  (ref) {
    final instance =
        ref.watch(userPreferencesProvider.select((s) => s.pipedInstance));
    return PipedClient(instance: instance);
  },
);

class PipedSourceInfo extends SourceInfo {
  PipedSourceInfo({
    required super.id,
    required super.title,
    required super.artist,
    required super.thumbnail,
    required super.pageUrl,
    required super.duration,
    required super.artistUrl,
    required super.album,
  });
}

class PipedSourcedTrack extends SourcedTrack {
  PipedSourcedTrack({
    required super.ref,
    required super.source,
    required super.siblings,
    required super.sourceInfo,
    required super.track,
  });

  static Future<SourcedTrack> fetchFromTrack({
    required Track track,
    required Ref ref,
  }) async {
    final cachedSource = await SourceMatch.box.get(track.id);
    final preferences = ref.read(userPreferencesProvider);
    final pipedClient = ref.read(pipedProvider);

    if (cachedSource == null) {
      final siblings = await fetchSiblings(ref: ref, track: track);
      if (siblings.isEmpty) {
        throw TrackNotFoundError(track);
      }

      await SourceMatch.box.put(
        track.id!,
        SourceMatch(
          id: track.id!,
          sourceType: preferences.searchMode == SearchMode.youtube
              ? SourceType.youtube
              : SourceType.youtubeMusic,
          createdAt: DateTime.now(),
          sourceId: siblings.first.info.id,
        ),
      );

      return PipedSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        source: siblings.first.source as SourceMap,
        sourceInfo: siblings.first.info,
        track: track,
      );
    } else {
      final manifest = await pipedClient.streams(cachedSource.sourceId);

      return PipedSourcedTrack(
        ref: ref,
        siblings: [],
        source: toSourceMap(manifest),
        sourceInfo: PipedSourceInfo(
          id: manifest.id,
          artist: manifest.uploader,
          artistUrl: manifest.uploaderUrl,
          pageUrl: "https://www.youtube.com/watch?v=${manifest.id}",
          thumbnail: manifest.thumbnailUrl,
          title: manifest.title,
          duration: manifest.duration,
          album: null,
        ),
        track: track,
      );
    }
  }

  static SourceMap toSourceMap(PipedStreamResponse manifest) {
    final m4a = manifest.audioStreams
        .where((audio) => audio.format == PipedAudioStreamFormat.m4a)
        .sorted((a, b) => a.bitrate.compareTo(b.bitrate));

    final weba = manifest.audioStreams
        .where((audio) => audio.format == PipedAudioStreamFormat.webm)
        .sorted((a, b) => a.bitrate.compareTo(b.bitrate));

    return SourceMap(
      m4a: SourceQualityMap(
        high: m4a.first.url.toString(),
        medium: (m4a.elementAtOrNull(m4a.length ~/ 2) ?? m4a[1]).url.toString(),
        low: m4a.last.url.toString(),
      ),
      weba: SourceQualityMap(
        high: weba.first.url.toString(),
        medium:
            (weba.elementAtOrNull(weba.length ~/ 2) ?? weba[1]).url.toString(),
        low: weba.last.url.toString(),
      ),
    );
  }

  static Future<SiblingType> toSiblingType(
    int index,
    YoutubeVideoInfo item,
    PipedClient pipedClient,
  ) async {
    SourceMap? sourceMap;
    if (index == 0) {
      final manifest = await pipedClient.streams(item.id);
      sourceMap = toSourceMap(manifest);
    }

    final SiblingType sibling = (
      info: PipedSourceInfo(
        id: item.id,
        artist: item.channelName,
        artistUrl: "https://www.youtube.com/${item.channelId}",
        pageUrl: "https://www.youtube.com/watch?v=${item.id}",
        thumbnail: item.thumbnailUrl,
        title: item.title,
        duration: item.duration,
        album: null,
      ),
      source: sourceMap,
    );

    return sibling;
  }

  static Future<List<SiblingType>> fetchSiblings({
    required Track track,
    required Ref ref,
  }) async {
    final pipedClient = ref.read(pipedProvider);
    final preference = ref.read(userPreferencesProvider);

    final query = SourcedTrack.getSearchTerm(track);

    final PipedSearchResult(items: searchResults) = await pipedClient.search(
      query,
      preference.searchMode == SearchMode.youtube
          ? PipedFilter.video
          : PipedFilter.musicSongs,
    );

    // when falling back to piped API make sure to use the YouTube mode
    final isYouTubeMusic = preference.audioSource != AudioSource.piped
        ? false
        : preference.searchMode == SearchMode.youtubeMusic;

    if (isYouTubeMusic) {
      final artists = (track.artists ?? [])
          .map((ar) => ar.name)
          .toList()
          .whereNotNull()
          .toList();

      return await Future.wait(
        searchResults
            .map(
              (result) => YoutubeVideoInfo.fromSearchItemStream(
                result as PipedSearchItemStream,
                preference.searchMode,
              ),
            )
            .sorted((a, b) => b.views.compareTo(a.views))
            .where(
              (item) => artists.any(
                (artist) =>
                    artist.toLowerCase() == item.channelName.toLowerCase(),
              ),
            )
            .mapIndexed((i, r) => toSiblingType(i, r, pipedClient)),
      );
    }

    if (ServiceUtils.onlyContainsEnglish(query)) {
      return await Future.wait(
        searchResults
            .whereType<PipedSearchItemStream>()
            .map(
              (result) => YoutubeVideoInfo.fromSearchItemStream(
                result,
                preference.searchMode,
              ),
            )
            .mapIndexed((i, r) => toSiblingType(i, r, pipedClient)),
      );
    }

    final rankedSiblings = YoutubeSourcedTrack.rankResults(
      searchResults
          .map(
            (result) => YoutubeVideoInfo.fromSearchItemStream(
              result as PipedSearchItemStream,
              preference.searchMode,
            ),
          )
          .toList(),
      track,
    );

    return await Future.wait(
      rankedSiblings.mapIndexed((i, r) => toSiblingType(i, r, pipedClient)),
    );
  }

  @override
  Future<SourcedTrack> copyWithSibling() async {
    if (siblings.isNotEmpty) {
      return this;
    }
    final fetchedSiblings = await fetchSiblings(ref: ref, track: this);

    return PipedSourcedTrack(
      ref: ref,
      siblings: fetchedSiblings
          .where((s) => s.info.id != sourceInfo.id)
          .map((s) => s.info)
          .toList(),
      source: source,
      sourceInfo: sourceInfo,
      track: this,
    );
  }

  @override
  Future<SourcedTrack?> swapWithSibling(SourceInfo sibling) async {
    if (sibling.id == sourceInfo.id) {
      return null;
    }

    // a sibling source that was fetched from the search results
    final isStepSibling = siblings.none((s) => s.id == sibling.id);

    final newSourceInfo = isStepSibling
        ? sibling
        : siblings.firstWhere((s) => s.id == sibling.id);
    final newSiblings = siblings.where((s) => s.id != sibling.id).toList()
      ..insert(0, sourceInfo);

    final pipedClient = ref.read(pipedProvider);

    final manifest = await pipedClient.streams(newSourceInfo.id);

    await SourceMatch.box.put(
      id!,
      SourceMatch(
        id: id!,
        sourceType: SourceType.jiosaavn,
        createdAt: DateTime.now(),
        sourceId: newSourceInfo.id,
      ),
    );

    return PipedSourcedTrack(
      ref: ref,
      siblings: newSiblings,
      source: toSourceMap(manifest),
      sourceInfo: newSourceInfo,
      track: this,
    );
  }
}
