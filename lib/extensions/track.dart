import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/album_simple.dart';
import 'package:spotube/extensions/artist_simple.dart';

extension TrackJson on Track {
  Map<String, dynamic> toJson() {
    return TrackJson.trackToJson(this);
  }

  static Map<String, dynamic> trackToJson(Track track) {
    return {
      "album": track.album?.toJson(),
      "artists": track.artists?.map((artist) => artist.toJson()).toList(),
      "available_markets": track.availableMarkets?.map((e) => e.name).toList(),
      "disc_number": track.discNumber,
      "duration_ms": track.durationMs,
      "explicit": track.explicit,
      // "external_ids"track.: externalIds,
      // "external_urls"track.: externalUrls,
      "href": track.href,
      "id": track.id,
      "is_playable": track.isPlayable,
      // "linked_from"track.: linkedFrom,
      "name": track.name,
      "popularity": track.popularity,
      "preview_rrl": track.previewUrl,
      "track_number": track.trackNumber,
      "type": track.type,
      "uri": track.uri,
    };
  }
}
