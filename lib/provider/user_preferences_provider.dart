import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/platform.dart';
import 'package:path/path.dart' as path;

enum LayoutMode {
  compact,
  extended,
  adaptive,
}

enum AudioQuality {
  high,
  low,
}

enum CloseBehavior {
  minimizeToTray,
  close,
}

enum YoutubeApiType {
  youtube,
  piped;

  String get label => name[0].toUpperCase() + name.substring(1);
}

enum MusicCodec {
  m4a._("M4a (Best for downloaded music)"),
  weba._("WebA (Best for streamed music)\nDoesn't support audio metadata");

  final String label;
  const MusicCodec._(this.label);
}

class UserPreferences {
  final AudioQuality audioQuality;
  final bool albumColorSync;
  final bool amoledDarkTheme;
  final bool checkUpdate;
  final bool normalizeAudio;
  final bool showSystemTrayIcon;
  final bool skipNonMusic;
  final bool systemTitleBar;
  final CloseBehavior closeBehavior;
  final SpotubeColor accentColorScheme;
  final LayoutMode layoutMode;
  final Locale locale;
  final Market recommendationMarket;
  final SearchMode searchMode;
  String downloadLocation;
  final String pipedInstance;
  final ThemeMode themeMode;
  final YoutubeApiType youtubeApiType;
  final MusicCodec streamMusicCodec;
  final MusicCodec downloadMusicCodec;

  UserPreferences({
    required AudioQuality? audioQuality,
    required bool? albumColorSync,
    required bool? amoledDarkTheme,
    required bool? checkUpdate,
    required bool? normalizeAudio,
    required bool? showSystemTrayIcon,
    required bool? skipNonMusic,
    required bool? systemTitleBar,
    required CloseBehavior? closeBehavior,
    required SpotubeColor? accentColorScheme,
    required LayoutMode? layoutMode,
    required Locale? locale,
    required Market? recommendationMarket,
    required SearchMode? searchMode,
    required String? downloadLocation,
    required String? pipedInstance,
    required ThemeMode? themeMode,
    required YoutubeApiType? youtubeApiType,
    required MusicCodec? streamMusicCodec,
    required MusicCodec? downloadMusicCodec,
  })  : accentColorScheme =
            accentColorScheme ?? const SpotubeColor(0xFF2196F3, name: "Blue"),
        albumColorSync = albumColorSync ?? true,
        amoledDarkTheme = amoledDarkTheme ?? false,
        audioQuality = audioQuality ?? AudioQuality.high,
        checkUpdate = checkUpdate ?? true,
        closeBehavior = closeBehavior ?? CloseBehavior.close,
        downloadLocation = downloadLocation ?? "",
        downloadMusicCodec = downloadMusicCodec ?? MusicCodec.m4a,
        layoutMode = layoutMode ?? LayoutMode.adaptive,
        locale = locale ?? const Locale("system", "system"),
        normalizeAudio = normalizeAudio ?? true,
        pipedInstance = pipedInstance ?? "https://pipedapi.kavin.rocks",
        recommendationMarket = recommendationMarket ?? Market.US,
        searchMode = searchMode ?? SearchMode.youtube,
        showSystemTrayIcon = showSystemTrayIcon ?? true,
        skipNonMusic = skipNonMusic ?? true,
        streamMusicCodec = streamMusicCodec ?? MusicCodec.weba,
        systemTitleBar = systemTitleBar ?? false,
        themeMode = themeMode ?? ThemeMode.system,
        youtubeApiType = youtubeApiType ?? YoutubeApiType.youtube {
    if (downloadLocation == null) {
      _getDefaultDownloadDirectory().then(
        (value) => this.downloadLocation = value,
      );
    }
  }

  factory UserPreferences.withDefaults() {
    return UserPreferences(
      audioQuality: null,
      albumColorSync: null,
      amoledDarkTheme: null,
      checkUpdate: null,
      normalizeAudio: null,
      showSystemTrayIcon: null,
      skipNonMusic: null,
      systemTitleBar: null,
      closeBehavior: null,
      accentColorScheme: null,
      layoutMode: null,
      locale: null,
      recommendationMarket: null,
      searchMode: null,
      downloadLocation: null,
      pipedInstance: null,
      themeMode: null,
      youtubeApiType: null,
      streamMusicCodec: null,
      downloadMusicCodec: null,
    );
  }

  static Future<String> _getDefaultDownloadDirectory() async {
    if (kIsAndroid) return "/storage/emulated/0/Download/Spotube";

    if (kIsMacOS) {
      return path.join((await getLibraryDirectory()).path, "Caches");
    }

    return getDownloadsDirectory().then((dir) {
      return path.join(dir!.path, "Spotube");
    });
  }

  static Future<UserPreferences> fromJson(Map<String, dynamic> json) async {
    final localeMap =
        json["locale"] != null ? jsonDecode(json["locale"]) : null;

    final systemTitleBar = json["systemTitleBar"] ?? false;
    if (DesktopTools.platform.isDesktop) {
      await DesktopTools.window.setTitleBarStyle(
        systemTitleBar ? TitleBarStyle.normal : TitleBarStyle.hidden,
      );
    }

    final normalizeAudio = json["normalizeAudio"] ?? true;
    audioPlayer.setAudioNormalization(normalizeAudio);

    return UserPreferences(
      accentColorScheme: json["accentColorScheme"] == null
          ? null
          : SpotubeColor.fromString(json["accentColorScheme"]),
      albumColorSync: json["albumColorSync"],
      amoledDarkTheme: json["amoledDarkTheme"],
      audioQuality: AudioQuality.values[json["audioQuality"]],
      checkUpdate: json["checkUpdate"],
      closeBehavior: CloseBehavior.values[json["closeBehavior"]],
      downloadLocation:
          json["downloadLocation"] ?? await _getDefaultDownloadDirectory(),
      downloadMusicCodec: MusicCodec.values[json["downloadMusicCodec"]],
      layoutMode: LayoutMode.values[json["layoutMode"]],
      locale:
          localeMap == null ? null : Locale(localeMap?["lc"], localeMap?["cc"]),
      normalizeAudio: json["normalizeAudio"],
      pipedInstance: json["pipedInstance"],
      recommendationMarket: Market.values[json["recommendationMarket"]],
      searchMode: SearchMode.values[json["searchMode"]],
      showSystemTrayIcon: json["showSystemTrayIcon"],
      skipNonMusic: json["skipNonMusic"],
      streamMusicCodec: MusicCodec.values[json["streamMusicCodec"]],
      systemTitleBar: json["systemTitleBar"],
      themeMode: ThemeMode.values[json["themeMode"]],
      youtubeApiType: YoutubeApiType.values[json["youtubeApiType"]],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "recommendationMarket": recommendationMarket.index,
      "themeMode": themeMode.index,
      "accentColorScheme": accentColorScheme.toString(),
      "albumColorSync": albumColorSync,
      "checkUpdate": checkUpdate,
      "audioQuality": audioQuality.index,
      "downloadLocation": downloadLocation,
      "layoutMode": layoutMode.index,
      "closeBehavior": closeBehavior.index,
      "showSystemTrayIcon": showSystemTrayIcon,
      "locale":
          jsonEncode({"lc": locale.languageCode, "cc": locale.countryCode}),
      "pipedInstance": pipedInstance,
      "searchMode": searchMode.index,
      "skipNonMusic": skipNonMusic,
      "youtubeApiType": youtubeApiType.index,
      'systemTitleBar': systemTitleBar,
      "amoledDarkTheme": amoledDarkTheme,
      "normalizeAudio": normalizeAudio,
      "streamMusicCodec": streamMusicCodec.index,
      "downloadMusicCodec": downloadMusicCodec.index,
    };
  }

  UserPreferences copyWith({
    ThemeMode? themeMode,
    SpotubeColor? accentColorScheme,
    bool? albumColorSync,
    bool? checkUpdate,
    AudioQuality? audioQuality,
    String? downloadLocation,
    LayoutMode? layoutMode,
    CloseBehavior? closeBehavior,
    bool? showSystemTrayIcon,
    Locale? locale,
    String? pipedInstance,
    SearchMode? searchMode,
    bool? skipNonMusic,
    YoutubeApiType? youtubeApiType,
    Market? recommendationMarket,
    bool? saveTrackLyrics,
    bool? amoledDarkTheme,
    bool? normalizeAudio,
    MusicCodec? downloadMusicCodec,
    MusicCodec? streamMusicCodec,
    bool? systemTitleBar,
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
      youtubeApiType: youtubeApiType ?? this.youtubeApiType,
      recommendationMarket: recommendationMarket ?? this.recommendationMarket,
      amoledDarkTheme: amoledDarkTheme ?? this.amoledDarkTheme,
      downloadMusicCodec: downloadMusicCodec ?? this.downloadMusicCodec,
      normalizeAudio: normalizeAudio ?? this.normalizeAudio,
      streamMusicCodec: streamMusicCodec ?? this.streamMusicCodec,
      systemTitleBar: systemTitleBar ?? this.systemTitleBar,
    );
  }
}

class UserPreferencesNotifier extends PersistedStateNotifier<UserPreferences> {
  final Ref ref;

  UserPreferencesNotifier(this.ref)
      : super(UserPreferences.withDefaults(), "preferences");

  void reset() {
    state = UserPreferences.withDefaults();
  }

  void setStreamMusicCodec(MusicCodec codec) {
    state = state.copyWith(streamMusicCodec: codec);
  }

  void setDownloadMusicCodec(MusicCodec codec) {
    state = state.copyWith(downloadMusicCodec: codec);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setRecommendationMarket(Market country) {
    state = state.copyWith(recommendationMarket: country);
  }

  void setAccentColorScheme(SpotubeColor color) {
    state = state.copyWith(accentColorScheme: color);
  }

  void setAlbumColorSync(bool sync) {
    state = state.copyWith(albumColorSync: sync);

    if (!sync) {
      ref.read(paletteProvider.notifier).state = null;
    } else {
      ref.read(ProxyPlaylistNotifier.notifier).updatePalette();
    }
  }

  void setCheckUpdate(bool check) {
    state = state.copyWith(checkUpdate: check);
  }

  void setAudioQuality(AudioQuality quality) {
    state = state.copyWith(audioQuality: quality);
  }

  void setDownloadLocation(String downloadDir) {
    if (downloadDir.isEmpty) return;
    state = state.copyWith(downloadLocation: downloadDir);
  }

  void setLayoutMode(LayoutMode mode) {
    state = state.copyWith(layoutMode: mode);
  }

  void setCloseBehavior(CloseBehavior behavior) {
    state = state.copyWith(closeBehavior: behavior);
  }

  void setShowSystemTrayIcon(bool show) {
    state = state.copyWith(showSystemTrayIcon: show);
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }

  void setPipedInstance(String instance) {
    state = state.copyWith(pipedInstance: instance);
  }

  void setSearchMode(SearchMode mode) {
    state = state.copyWith(searchMode: mode);
  }

  void setSkipNonMusic(bool skip) {
    state = state.copyWith(skipNonMusic: skip);
  }

  void setYoutubeApiType(YoutubeApiType type) {
    state = state.copyWith(youtubeApiType: type);
  }

  void setSystemTitleBar(bool isSystemTitleBar) {
    state = state.copyWith(systemTitleBar: isSystemTitleBar);
    if (DesktopTools.platform.isDesktop) {
      DesktopTools.window.setTitleBarStyle(
        isSystemTitleBar ? TitleBarStyle.normal : TitleBarStyle.hidden,
      );
    }
  }

  void setAmoledDarkTheme(bool isAmoled) {
    state = state.copyWith(amoledDarkTheme: isAmoled);
  }

  void setNormalizeAudio(bool normalize) {
    state = state.copyWith(normalizeAudio: normalize);
    audioPlayer.setAudioNormalization(normalize);
  }

  @override
  FutureOr<UserPreferences> fromJson(Map<String, dynamic> json) {
    return UserPreferences.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return state.toJson();
  }
}

final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>(
  (ref) => UserPreferencesNotifier(ref),
);
