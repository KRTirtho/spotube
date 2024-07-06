import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/modules/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/services/sourced_track/enums.dart';

part 'adapters.g.dart';
part 'adapters.freezed.dart';

@HiveType(typeId: 2)
class SkipSegment {
  @HiveField(0)
  final int start;
  @HiveField(1)
  final int end;
  SkipSegment(this.start, this.end);

  static String version = 'v1';
  static final boxName = "oss.krtirtho.spotube.skip_segments.$version";
  static LazyBox get box => Hive.lazyBox(boxName);

  SkipSegment.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        end = json['end'];

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };
}

@JsonEnum()
@HiveType(typeId: 5)
enum SourceType {
  @HiveField(0)
  youtube._("YouTube"),

  @HiveField(1)
  youtubeMusic._("YouTube Music"),

  @HiveField(2)
  jiosaavn._("JioSaavn");

  final String label;

  const SourceType._(this.label);
}

@JsonSerializable()
@HiveType(typeId: 6)
class SourceMatch {
  @HiveField(0)
  String id;

  @HiveField(1)
  String sourceId;

  @HiveField(2)
  SourceType sourceType;

  @HiveField(3)
  DateTime createdAt;

  SourceMatch({
    required this.id,
    required this.sourceId,
    required this.sourceType,
    required this.createdAt,
  });

  factory SourceMatch.fromJson(Map<String, dynamic> json) =>
      _$SourceMatchFromJson(json);

  Map<String, dynamic> toJson() => _$SourceMatchToJson(this);

  static String version = 'v1';
  static final boxName = "oss.krtirtho.spotube.source_matches.$version";

  static LazyBox<SourceMatch> get box => Hive.lazyBox<SourceMatch>(boxName);
}

@JsonSerializable()
class AuthenticationCredentials {
  String cookie;
  String accessToken;
  DateTime expiration;

  AuthenticationCredentials({
    required this.cookie,
    required this.accessToken,
    required this.expiration,
  });

  factory AuthenticationCredentials.fromJson(Map<String, dynamic> json) {
    return AuthenticationCredentials(
      cookie: json['cookie'] as String,
      accessToken: json['accessToken'] as String,
      expiration: DateTime.parse(json['expiration'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cookie': cookie,
      'accessToken': accessToken,
      'expiration': expiration.toIso8601String(),
    };
  }
}

@JsonEnum()
enum LayoutMode {
  compact,
  extended,
  adaptive,
}

@JsonEnum()
enum CloseBehavior {
  minimizeToTray,
  close,
}

@JsonEnum()
enum AudioSource {
  youtube,
  piped,
  jiosaavn;

  String get label => name[0].toUpperCase() + name.substring(1);
}

@JsonEnum()
enum MusicCodec {
  m4a._("M4a (Best for downloaded music)"),
  weba._("WebA (Best for streamed music)\nDoesn't support audio metadata");

  final String label;
  const MusicCodec._(this.label);
}

@JsonEnum()
enum SearchMode {
  youtube._("YouTube"),
  youtubeMusic._("YouTube Music");

  final String label;

  const SearchMode._(this.label);

  factory SearchMode.fromString(String key) {
    return SearchMode.values.firstWhere((e) => e.name == key);
  }
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(SourceQualities.high) SourceQualities audioQuality,
    @Default(true) bool albumColorSync,
    @Default(false) bool amoledDarkTheme,
    @Default(true) bool checkUpdate,
    @Default(false) bool normalizeAudio,
    @Default(false) bool showSystemTrayIcon,
    @Default(false) bool skipNonMusic,
    @Default(false) bool systemTitleBar,
    @Default(CloseBehavior.close) CloseBehavior closeBehavior,
    @Default(SpotubeColor(0xFF2196F3, name: "Blue"))
    @JsonKey(
      fromJson: UserPreferences._accentColorSchemeFromJson,
      toJson: UserPreferences._accentColorSchemeToJson,
      readValue: UserPreferences._accentColorSchemeReadValue,
    )
    SpotubeColor accentColorScheme,
    @Default(LayoutMode.adaptive) LayoutMode layoutMode,
    @Default(Locale("system", "system"))
    @JsonKey(
      fromJson: UserPreferences._localeFromJson,
      toJson: UserPreferences._localeToJson,
      readValue: UserPreferences._localeReadValue,
    )
    Locale locale,
    @Default(Market.US) Market recommendationMarket,
    @Default(SearchMode.youtube) SearchMode searchMode,
    @Default("") String downloadLocation,
    @Default([]) List<String> localLibraryLocation,
    @Default("https://pipedapi.kavin.rocks") String pipedInstance,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(AudioSource.youtube) AudioSource audioSource,
    @Default(SourceCodecs.weba) SourceCodecs streamMusicCodec,
    @Default(SourceCodecs.m4a) SourceCodecs downloadMusicCodec,
    @Default(true) bool discordPresence,
    @Default(true) bool endlessPlayback,
    @Default(false) bool enableConnect,
  }) = _UserPreferences;
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  factory UserPreferences.withDefaults() => UserPreferences.fromJson({});

  static SpotubeColor _accentColorSchemeFromJson(Map<String, dynamic> json) {
    return SpotubeColor.fromString(json["color"]);
  }

  static Map<String, dynamic>? _accentColorSchemeReadValue(
      Map<dynamic, dynamic> json, String key) {
    if (json[key] is String) {
      return {"color": json[key]};
    }

    return json[key] as Map<String, dynamic>?;
  }

  static Map<String, dynamic> _accentColorSchemeToJson(SpotubeColor color) {
    return {"color": color.toString()};
  }

  static Locale _localeFromJson(Map<String, dynamic> json) {
    return Locale(json["languageCode"], json["countryCode"]);
  }

  static Map<String, dynamic> _localeToJson(Locale locale) {
    return {
      "languageCode": locale.languageCode,
      "countryCode": locale.countryCode,
    };
  }

  static Map<String, dynamic>? _localeReadValue(
      Map<dynamic, dynamic> json, String key) {
    if (json[key] is String) {
      final map = jsonDecode(json[key]);
      return {
        "languageCode": map["lc"],
        "countryCode": map["cc"],
      };
    }

    return json[key] as Map<String, dynamic>?;
  }
}

enum BlacklistedType {
  artist,
  track;

  static BlacklistedType fromName(String name) =>
      BlacklistedType.values.firstWhere((e) => e.name == name);
}

class BlacklistedElement {
  final String id;
  final String name;
  final BlacklistedType type;

  BlacklistedElement.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = BlacklistedType.fromName(json['type']);

  Map<String, dynamic> toJson() => {'id': id, 'type': type.name, 'name': name};
}

@freezed
class PlaybackHistoryItem with _$PlaybackHistoryItem {
  factory PlaybackHistoryItem.playlist({
    required DateTime date,
    required PlaylistSimple playlist,
  }) = PlaybackHistoryPlaylist;

  factory PlaybackHistoryItem.album({
    required DateTime date,
    required AlbumSimple album,
  }) = PlaybackHistoryAlbum;

  factory PlaybackHistoryItem.track({
    required DateTime date,
    required Track track,
  }) = PlaybackHistoryTrack;

  factory PlaybackHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$PlaybackHistoryItemFromJson(json);
}

class PlaybackHistoryState {
  final List<PlaybackHistoryItem> items;
  const PlaybackHistoryState({this.items = const []});

  factory PlaybackHistoryState.fromJson(Map<String, dynamic> json) {
    return PlaybackHistoryState(
      items: json["items"]
              ?.map(
                (json) => PlaybackHistoryItem.fromJson(json),
              )
              .toList()
              .cast<PlaybackHistoryItem>() ??
          <PlaybackHistoryItem>[],
    );
  }
}

class ScrobblerState {
  final String username;
  final String passwordHash;

  ScrobblerState({
    required this.username,
    required this.passwordHash,
  });

  factory ScrobblerState.fromJson(Map<String, dynamic> json) {
    return ScrobblerState(
      username: json["username"],
      passwordHash: json["passwordHash"],
    );
  }
}
