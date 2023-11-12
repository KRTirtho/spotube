import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/models/source_match.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/services/youtube/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

final pipedProvider = Provider<PipedClient>(
  (ref) {
    final instance =
        ref.watch(userPreferencesProvider.select((s) => s.pipedInstance));
    return PipedClient(instance: instance);
  },
);

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
        throw TrackNotFoundException(track);
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
        sourceInfo: SourceInfo(
          id: manifest.id,
          artist: manifest.uploader,
          pageUrl: "https://www.youtube.com/watch?v=${manifest.id}",
          thumbnail: manifest.thumbnailUrl,
          title: manifest.title,
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

    return {
      SourceCodecs.mp4: {
        SourceQualities.high: m4a.first.url.toString(),
        SourceQualities.medium:
            (m4a.elementAtOrNull(m4a.length ~/ 2) ?? m4a[1]).url.toString(),
        SourceQualities.low: m4a.last.url.toString(),
      },
      SourceCodecs.weba: {
        SourceQualities.high: weba.first.url.toString(),
        SourceQualities.medium:
            (weba.elementAtOrNull(weba.length ~/ 2) ?? weba[1]).url.toString(),
        SourceQualities.low: weba.last.url.toString(),
      }
    };
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
      info: SourceInfo(
        id: item.id,
        artist: item.channelName,
        pageUrl: "https://www.youtube.com/watch?v=${item.id}",
        thumbnail: item.thumbnailUrl,
        title: item.title,
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

    final isYouTubeMusic = preference.searchMode == SearchMode.youtubeMusic;

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
            .map(
              (result) => YoutubeVideoInfo.fromSearchItemStream(
                result as PipedSearchItemStream,
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
  Future<SourcedTrack> swapWithSibling(SourceInfo sibling) async {
    if (sibling.id == sourceInfo.id ||
        siblings.none((s) => s.id == sibling.id)) {
      throw Exception("Invalid sibling");
    }

    final newSourceInfo = siblings.firstWhere((s) => s.id == sibling.id);
    final newSiblings = siblings.where((s) => s.id != sibling.id).toList()
      ..insert(0, sourceInfo);

    final pipedClient = ref.read(pipedProvider);

    final manifest = await pipedClient.streams(newSourceInfo.id);

    return PipedSourcedTrack(
      ref: ref,
      siblings: newSiblings,
      source: toSourceMap(manifest),
      sourceInfo: newSourceInfo,
      track: this,
    );
  }
}
