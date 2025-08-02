import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/youtube_engine/youtube_engine.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/services/song_link/song_link.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/exceptions.dart';
import 'package:spotube/services/sourced_track/models/video_info.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final officialMusicRegex = RegExp(
  r"official\s(video|audio|music\svideo|lyric\svideo|visualizer)",
  caseSensitive: false,
);

class YoutubeSourcedTrack extends SourcedTrack {
  YoutubeSourcedTrack({
    required super.source,
    required super.siblings,
    required super.info,
    required super.query,
    required super.sources,
    required super.ref,
  });

  static Future<YoutubeSourcedTrack> fetchFromTrack({
    required TrackSourceQuery query,
    required Ref ref,
  }) async {
    final audioSource = ref.read(userPreferencesProvider).audioSource;
    final database = ref.read(databaseProvider);
    final cachedSource = await (database.select(database.sourceMatchTable)
          ..where((s) => s.trackId.equals(query.id))
          ..limit(1)
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .get()
        .then((s) => s.firstOrNull);

    if (cachedSource == null || cachedSource.sourceType != SourceType.youtube) {
      final siblings = await fetchSiblings(ref: ref, query: query);
      if (siblings.isEmpty) {
        throw TrackNotFoundError(query);
      }

      await database.into(database.sourceMatchTable).insert(
            SourceMatchTableCompanion.insert(
              trackId: query.id,
              sourceId: siblings.first.info.id,
              sourceType: const Value(SourceType.youtube),
            ),
          );

      return YoutubeSourcedTrack(
        ref: ref,
        siblings: siblings.map((s) => s.info).skip(1).toList(),
        info: siblings.first.info,
        source: audioSource,
        sources: siblings.first.source ?? [],
        query: query,
      );
    }
    final (item, manifest) = await ref
        .read(youtubeEngineProvider)
        .getVideoWithStreamInfo(cachedSource.sourceId);

    final sourcedTrack = YoutubeSourcedTrack(
      ref: ref,
      siblings: [],
      sources: toTrackSources(manifest),
      info: TrackSourceInfo(
        id: item.id.value,
        artists: item.author,
        pageUrl: item.url,
        thumbnail: item.thumbnails.highResUrl,
        title: item.title,
        durationMs: item.duration?.inMilliseconds ?? 0,
      ),
      query: query,
      source: audioSource,
    );

    AppLogger.log.i("${query.title}: ${sourcedTrack.url}");

    return sourcedTrack;
  }

  static List<TrackSource> toTrackSources(StreamManifest manifest) {
    return manifest.audioOnly.map((streamInfo) {
      return TrackSource(
        url: streamInfo.url.toString(),
        quality: switch (streamInfo.qualityLabel) {
          "medium" => SourceQualities.medium,
          "high" => SourceQualities.high,
          "low" => SourceQualities.low,
          _ => SourceQualities.high,
        },
        codec: streamInfo.codec.mimeType == "audio/webm"
            ? SourceCodecs.weba
            : SourceCodecs.m4a,
        bitrate: streamInfo.bitrate.bitsPerSecond.toString(),
      );
    }).toList();
  }

  static Future<SiblingType> toSiblingType(
    int index,
    YoutubeVideoInfo item,
    dynamic ref,
  ) async {
    assert(ref is WidgetRef || ref is Ref, "Invalid ref type");
    List<TrackSource>? sourceMap;
    if (index == 0) {
      final manifest =
          await ref.read(youtubeEngineProvider).getStreamManifest(item.id);
      sourceMap = toTrackSources(manifest);
    }

    final SiblingType sibling = (
      info: TrackSourceInfo(
        id: item.id,
        artists: item.channelName,
        pageUrl: "https://www.youtube.com/watch?v=${item.id}",
        thumbnail: item.thumbnailUrl,
        title: item.title,
        durationMs: item.duration.inMilliseconds,
      ),
      source: sourceMap,
    );

    return sibling;
  }

  static List<YoutubeVideoInfo> rankResults(
      List<YoutubeVideoInfo> results, TrackSourceQuery track) {
    return results
        .sorted((a, b) => b.views.compareTo(a.views))
        .map((sibling) {
          int score = 0;

          for (final artist in track.artists) {
            final isSameChannelArtist =
                sibling.channelName.toLowerCase() == artist.toLowerCase();
            final channelContainsArtist = sibling.channelName
                .toLowerCase()
                .contains(artist.toLowerCase());

            if (isSameChannelArtist || channelContainsArtist) {
              score += 1;
            }

            final titleContainsArtist =
                sibling.title.toLowerCase().contains(artist.toLowerCase());

            if (titleContainsArtist) {
              score += 1;
            }
          }

          final titleContainsTrackName =
              sibling.title.toLowerCase().contains(track.title.toLowerCase());

          final hasOfficialFlag =
              officialMusicRegex.hasMatch(sibling.title.toLowerCase());

          if (titleContainsTrackName) {
            score += 3;
          }

          if (hasOfficialFlag) {
            score += 1;
          }

          if (hasOfficialFlag && titleContainsTrackName) {
            score += 2;
          }

          return (sibling: sibling, score: score);
        })
        .sorted((a, b) => b.score.compareTo(a.score))
        .map((e) => e.sibling)
        .toList();
  }

  static Future<List<YoutubeVideoInfo>> fetchFromIsrc({
    required TrackSourceQuery track,
    required Ref ref,
  }) async {
    final isrcResults = <YoutubeVideoInfo>[];
    final isrc = track.isrc;
    if (isrc.isNotEmpty) {
      final searchedVideos =
          await ref.read(youtubeEngineProvider).searchVideos(isrc.toString());
      if (searchedVideos.isNotEmpty) {
        isrcResults.addAll(searchedVideos
            .map<YoutubeVideoInfo>(YoutubeVideoInfo.fromVideo)
            .map((YoutubeVideoInfo videoInfo) {
              final ytWords = videoInfo.title
                  .toLowerCase()
                  .replaceAll(RegExp(r'[^\p{L}\p{N}\p{Z}]+', unicode: true), '')
                  .split(RegExp(r'\p{Z}+', unicode: true))
                  .where((item) => item.isNotEmpty);
              final spWords = track.title
                  .toLowerCase()
                  .replaceAll(RegExp(r'[^\p{L}\p{N}\p{Z}]+', unicode: true), '')
                  .split(RegExp(r'\p{Z}+', unicode: true))
                  .where((item) => item.isNotEmpty);
              // Single word and duration match with 3 second tolerance
              if (ytWords.any((word) => spWords.contains(word)) &&
                  (videoInfo.duration -
                              Duration(milliseconds: track.durationMs))
                          .abs()
                          .inMilliseconds <=
                      3000) {
                return videoInfo;
              }
              return null;
            })
            .whereType<YoutubeVideoInfo>()
            .toList());
      }
    }
    return isrcResults;
  }

  static Future<List<SiblingType>> fetchSiblings({
    required TrackSourceQuery query,
    required Ref ref,
  }) async {
    final videoResults = <YoutubeVideoInfo>[];

    if (query is! SourcedTrack) {
      final isrcResults = await fetchFromIsrc(
        track: query,
        ref: ref,
      );

      videoResults.addAll(isrcResults);

      if (isrcResults.isEmpty) {
        final links = await SongLinkService.links(query.id);
        final ytLink = links.firstWhereOrNull(
          (link) => link.platform == "youtube",
        );
        if (ytLink?.url != null) {
          try {
            videoResults.add(
              YoutubeVideoInfo.fromVideo(await ref
                  .read(youtubeEngineProvider)
                  .getVideo(Uri.parse(ytLink!.url!).queryParameters["v"]!)),
            );
          } on VideoUnplayableException catch (e, stack) {
            // Ignore this error and continue with the search
            AppLogger.reportError(e, stack);
          }
        }
      }
    }

    final searchQuery = SourcedTrack.getSearchTerm(query);

    final searchResults =
        await ref.read(youtubeEngineProvider).searchVideos(searchQuery);

    if (ServiceUtils.onlyContainsEnglish(searchQuery)) {
      videoResults
          .addAll(searchResults.map(YoutubeVideoInfo.fromVideo).toList());
    } else {
      videoResults.addAll(rankResults(
        searchResults.map(YoutubeVideoInfo.fromVideo).toList(),
        query,
      ));
    }

    final seenIds = <String>{};
    int index = 0;
    return await Future.wait(
      videoResults.map((videoResult) async {
        // Deduplicate results
        if (!seenIds.contains(videoResult.id)) {
          seenIds.add(videoResult.id);
          return await toSiblingType(index++, videoResult, ref);
        }
        return null;
      }),
    ).then((s) => s.whereType<SiblingType>().toList());
  }

  @override
  Future<YoutubeSourcedTrack?> swapWithSibling(TrackSourceInfo sibling) async {
    if (sibling.id == info.id) {
      return null;
    }

    // a sibling source that was fetched from the search results
    final isStepSibling = siblings.none((s) => s.id == sibling.id);

    final newSourceInfo = isStepSibling
        ? sibling
        : siblings.firstWhere((s) => s.id == sibling.id);
    final newSiblings = siblings.where((s) => s.id != sibling.id).toList()
      ..insert(0, info);

    final manifest = await ref
        .read(youtubeEngineProvider)
        .getStreamManifest(newSourceInfo.id);

    final database = ref.read(databaseProvider);

    await database.into(database.sourceMatchTable).insert(
          SourceMatchTableCompanion.insert(
            trackId: query.id,
            sourceId: newSourceInfo.id,
            sourceType: const Value(SourceType.youtube),
            // Because we're sorting by createdAt in the query
            // we have to update it to indicate priority
            createdAt: Value(DateTime.now()),
          ),
          mode: InsertMode.replace,
        );

    return YoutubeSourcedTrack(
      ref: ref,
      source: source,
      siblings: newSiblings,
      sources: toTrackSources(manifest),
      info: info,
      query: query,
    );
  }

  @override
  Future<YoutubeSourcedTrack> copyWithSibling() async {
    if (siblings.isNotEmpty) {
      return this;
    }
    final fetchedSiblings = await fetchSiblings(ref: ref, query: query);

    return YoutubeSourcedTrack(
      ref: ref,
      siblings: fetchedSiblings
          .where((s) => s.info.id != info.id)
          .map((s) => s.info)
          .toList(),
      source: source,
      sources: sources,
      info: info,
      query: query,
    );
  }

  @override
  Future<SourcedTrack> refreshStream() async {
    final manifest =
        await ref.read(youtubeEngineProvider).getStreamManifest(info.id);

    final sourcedTrack = YoutubeSourcedTrack(
      ref: ref,
      siblings: siblings,
      source: source,
      sources: toTrackSources(manifest),
      info: info,
      query: query,
    );

    AppLogger.log.i("Refreshing ${query.title}: ${sourcedTrack.url}");

    return sourcedTrack;
  }
}
