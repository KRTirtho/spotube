import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/services/sourced_track/enums.dart';

part 'user_preferences_state.g.dart';

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

@JsonSerializable()
final class UserPreferences {
  @JsonKey(
    defaultValue: SourceQualities.high,
    unknownEnumValue: SourceQualities.high,
  )
  final SourceQualities audioQuality;

  @JsonKey(defaultValue: true)
  final bool albumColorSync;

  @JsonKey(defaultValue: false)
  final bool amoledDarkTheme;

  @JsonKey(defaultValue: true)
  final bool checkUpdate;

  @JsonKey(defaultValue: false)
  final bool normalizeAudio;

  @JsonKey(defaultValue: true)
  final bool showSystemTrayIcon;

  @JsonKey(defaultValue: true)
  final bool skipNonMusic;

  @JsonKey(defaultValue: false)
  final bool systemTitleBar;

  @JsonKey(
    defaultValue: CloseBehavior.minimizeToTray,
    unknownEnumValue: CloseBehavior.minimizeToTray,
  )
  final CloseBehavior closeBehavior;

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

  static SpotubeColor _defaultAccentColorScheme() =>
      const SpotubeColor(0xFF2196F3, name: "Blue");

  @JsonKey(
    defaultValue: UserPreferences._defaultAccentColorScheme,
    fromJson: UserPreferences._accentColorSchemeFromJson,
    toJson: UserPreferences._accentColorSchemeToJson,
    readValue: UserPreferences._accentColorSchemeReadValue,
  )
  final SpotubeColor accentColorScheme;

  @JsonKey(
    defaultValue: LayoutMode.adaptive,
    unknownEnumValue: LayoutMode.adaptive,
  )
  final LayoutMode layoutMode;

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

  static Locale _defaultLocaleValue() => const Locale("system", "system");

  @JsonKey(
    defaultValue: UserPreferences._defaultLocaleValue,
    toJson: UserPreferences._localeToJson,
    fromJson: UserPreferences._localeFromJson,
    readValue: UserPreferences._localeReadValue,
  )
  final Locale locale;

  @JsonKey(
    defaultValue: Market.US,
    unknownEnumValue: Market.US,
  )
  final Market recommendationMarket;

  @JsonKey(
    defaultValue: SearchMode.youtube,
    unknownEnumValue: SearchMode.youtube,
  )
  final SearchMode searchMode;

  @JsonKey(defaultValue: "")
  final String downloadLocation;

  @JsonKey(defaultValue: "https://pipedapi.kavin.rocks")
  final String pipedInstance;

  @JsonKey(
    defaultValue: ThemeMode.system,
    unknownEnumValue: ThemeMode.system,
  )
  final ThemeMode themeMode;

  @JsonKey(
    defaultValue: AudioSource.youtube,
    unknownEnumValue: AudioSource.youtube,
  )
  final AudioSource audioSource;

  @JsonKey(
    defaultValue: SourceCodecs.weba,
    unknownEnumValue: SourceCodecs.weba,
  )
  final SourceCodecs streamMusicCodec;

  @JsonKey(
    defaultValue: SourceCodecs.m4a,
    unknownEnumValue: SourceCodecs.m4a,
  )
  final SourceCodecs downloadMusicCodec;

  @JsonKey(defaultValue: true)
  final bool discordPresence;

  UserPreferences({
    required this.audioQuality,
    required this.albumColorSync,
    required this.amoledDarkTheme,
    required this.checkUpdate,
    required this.normalizeAudio,
    required this.showSystemTrayIcon,
    required this.skipNonMusic,
    required this.systemTitleBar,
    required this.closeBehavior,
    required this.accentColorScheme,
    required this.layoutMode,
    required this.locale,
    required this.recommendationMarket,
    required this.searchMode,
    required this.downloadLocation,
    required this.pipedInstance,
    required this.themeMode,
    required this.audioSource,
    required this.streamMusicCodec,
    required this.downloadMusicCodec,
    required this.discordPresence,
  });

  factory UserPreferences.withDefaults() {
    return UserPreferences.fromJson({});
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return _$UserPreferencesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserPreferencesToJson(this);
  }

  UserPreferences copyWith({
    ThemeMode? themeMode,
    SpotubeColor? accentColorScheme,
    bool? albumColorSync,
    bool? checkUpdate,
    SourceQualities? audioQuality,
    String? downloadLocation,
    LayoutMode? layoutMode,
    CloseBehavior? closeBehavior,
    bool? showSystemTrayIcon,
    Locale? locale,
    String? pipedInstance,
    SearchMode? searchMode,
    bool? skipNonMusic,
    AudioSource? audioSource,
    Market? recommendationMarket,
    bool? saveTrackLyrics,
    bool? amoledDarkTheme,
    bool? normalizeAudio,
    SourceCodecs? downloadMusicCodec,
    SourceCodecs? streamMusicCodec,
    bool? systemTitleBar,
    bool? discordPresence,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      accentColorScheme: accentColorScheme ?? this.accentColorScheme,
      albumColorSync: albumColorSync ?? this.albumColorSync,
      checkUpdate: checkUpdate ?? this.checkUpdate,
      audioQuality: audioQuality ?? this.audioQuality,
      downloadLocation: downloadLocation ?? this.downloadLocation,
      layoutMode: layoutMode ?? this.layoutMode,
      closeBehavior: closeBehavior ?? this.closeBehavior,
      showSystemTrayIcon: showSystemTrayIcon ?? this.showSystemTrayIcon,
      locale: locale ?? this.locale,
      pipedInstance: pipedInstance ?? this.pipedInstance,
      searchMode: searchMode ?? this.searchMode,
      skipNonMusic: skipNonMusic ?? this.skipNonMusic,
      audioSource: audioSource ?? this.audioSource,
      recommendationMarket: recommendationMarket ?? this.recommendationMarket,
      amoledDarkTheme: amoledDarkTheme ?? this.amoledDarkTheme,
      downloadMusicCodec: downloadMusicCodec ?? this.downloadMusicCodec,
      normalizeAudio: normalizeAudio ?? this.normalizeAudio,
      streamMusicCodec: streamMusicCodec ?? this.streamMusicCodec,
      systemTitleBar: systemTitleBar ?? this.systemTitleBar,
      discordPresence: discordPresence ?? this.discordPresence,
    );
  }
}
