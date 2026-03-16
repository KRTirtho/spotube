part of '../metadata.dart';

class MetadataPluginLyricsEndpoint {
  final Hetu hetu;

  MetadataPluginLyricsEndpoint(this.hetu);

  HTInstance get hetuMetadataLyrics =>
      (hetu.fetch("metadataPlugin") as HTInstance).memberGet("lyrics")
          as HTInstance;

  Future<List<SubtitleSimple>> search({
    required String trackName,
    required String artistName,
    String? albumName,
    Duration? duration,
  }) async {
    final result = await hetuMetadataLyrics.invoke(
      "search",
      positionalArgs: [
        {
          'trackName': trackName,
          'artistName': artistName,
          'albumName': albumName,
          'duration': duration?.inSeconds,
        }
      ],
    );

    if (result == null) return [];

    final list = result as List;
    return list.map((item) => SubtitleSimple.fromJson(item)).toList();
  }

  Future<SubtitleSimple?> getById(String id) async {
    final result = await hetuMetadataLyrics.invoke(
      "getById",
      positionalArgs: [id],
    );

    if (result == null) return null;

    return SubtitleSimple.fromJson(result);
  }

  Future<bool> isAvailable() async {
    final result = await hetuMetadataLyrics.invoke("isAvailable");
    return result as bool? ?? false;
  }
}
