import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/provider/palette_provider.dart';
import 'package:spotube/provider/proxy_playlist/player_listeners.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/sourced_track/enums.dart';

import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/platform.dart';
import 'package:path/path.dart' as path;
import 'package:window_manager/window_manager.dart';

class UserPreferencesNotifier extends PersistedStateNotifier<UserPreferences> {
  final Ref ref;

  UserPreferencesNotifier(this.ref)
      : super(UserPreferences.withDefaults(), "preferences");

  void reset() {
    state = UserPreferences.withDefaults();
  }

  void setStreamMusicCodec(SourceCodecs codec) {
    state = state.copyWith(streamMusicCodec: codec);
  }

  void setDownloadMusicCodec(SourceCodecs codec) {
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
      ref.read(proxyPlaylistProvider.notifier).updatePalette();
    }
  }

  void setCheckUpdate(bool check) {
    state = state.copyWith(checkUpdate: check);
  }

  void setAudioQuality(SourceQualities quality) {
    state = state.copyWith(audioQuality: quality);
  }

  void setDownloadLocation(String downloadDir) {
    if (downloadDir.isEmpty) return;
    state = state.copyWith(downloadLocation: downloadDir);
  }

  void setLocalLibraryLocation(List<String> localLibraryDirs) {
    //if (localLibraryDir.isEmpty) return;
    state = state.copyWith(localLibraryLocation: localLibraryDirs);
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

  void setAudioSource(AudioSource type) {
    state = state.copyWith(audioSource: type);
  }

  void setSystemTitleBar(bool isSystemTitleBar) {
    state = state.copyWith(systemTitleBar: isSystemTitleBar);
    if (kIsDesktop) {
      windowManager.setTitleBarStyle(
        isSystemTitleBar ? TitleBarStyle.normal : TitleBarStyle.hidden,
      );
    }
  }

  void setDiscordPresence(bool discordPresence) {
    state = state.copyWith(discordPresence: discordPresence);
  }

  void setAmoledDarkTheme(bool isAmoled) {
    state = state.copyWith(amoledDarkTheme: isAmoled);
  }

  void setNormalizeAudio(bool normalize) {
    state = state.copyWith(normalizeAudio: normalize);
    audioPlayer.setAudioNormalization(normalize);
  }

  void setEndlessPlayback(bool endless) {
    state = state.copyWith(endlessPlayback: endless);
  }

  void setEnableConnect(bool enable) {
    state = state.copyWith(enableConnect: enable);
  }

  Future<String> _getDefaultDownloadDirectory() async {
    if (kIsAndroid) return "/storage/emulated/0/Download/Spotube";

    if (kIsMacOS) {
      return path.join((await getLibraryDirectory()).path, "Caches");
    }

    return getDownloadsDirectory().then((dir) {
      return path.join(dir!.path, "Spotube");
    });
  }

  @override
  FutureOr<void> onInit() async {
    if (state.downloadLocation.isEmpty) {
      state = state.copyWith(
        downloadLocation: await _getDefaultDownloadDirectory(),
      );
    }

    if (kIsDesktop) {
      await windowManager.setTitleBarStyle(
        state.systemTitleBar ? TitleBarStyle.normal : TitleBarStyle.hidden,
      );
    }

    await audioPlayer.setAudioNormalization(state.normalizeAudio);
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
