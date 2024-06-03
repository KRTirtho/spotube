import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/services/sourced_track/enums.dart';

part 'user_preferences_state.g.dart';
part 'user_preferences_state.freezed.dart';

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
