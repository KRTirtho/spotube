import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/state.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/metadata/metadata.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotube/services/audio_player/playback_state.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/platform.dart';

class MobileAudioService extends BaseAudioHandler {
  AudioSession? session;
  final Ref ref;
  final AudioPlayerNotifier audioPlayerNotifier;

  /// Media id of the synthetic "Liked Songs" browsable item exposed to
  /// Android Auto / system media browsers.
  static const String likedMediaId = 'spotube://liked';

  /// Prefix for playlist browsable items. The full id is
  /// `spotube://playlist/<playlistId>`.
  static const String playlistMediaIdPrefix = 'spotube://playlist/';

  /// Playable item that plays a whole collection. Id is
  /// `spotube://playall/<collectionId>` where collectionId is [likedMediaId]
  /// or a `spotube://playlist/<id>`.
  static const String _playAllPrefix = 'spotube://playall/';

  /// Playable item that plays a collection starting at a specific track. Id is
  /// `spotube://track/<collectionId>/<trackId>`.
  static const String _trackActionPrefix = 'spotube://track/';

  /// Browsable folder exposing the plugin's browse/home sections (e.g. the
  /// "Made for you" hub with Discover Weekly), which aren't returned by
  /// savedPlaylists.
  static const String _browseMediaId = 'spotube://browse';

  /// Browsable folder for a single browse section. Id is
  /// `spotube://section/<sectionId>`.
  static const String _sectionPrefix = 'spotube://section/';

  /// Name of the custom "shuffle" media control action.
  static const String _shuffleActionName = 'shuffle';

  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  AudioPlayerState get playlist => audioPlayerNotifier.state;

  MobileAudioService(this.ref, this.audioPlayerNotifier) {
    AudioSession.instance.then((s) {
      session = s;
      session?.configure(const AudioSessionConfiguration.music());

      bool wasPausedByBeginEvent = false;

      s.interruptionEventStream.listen((event) async {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await audioPlayer.setVolume(0.5);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              {
                wasPausedByBeginEvent = audioPlayer.isPlaying;
                await audioPlayer.pause();
                break;
              }
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              await audioPlayer.setVolume(1.0);
              break;
            case AudioInterruptionType.pause when wasPausedByBeginEvent:
            case AudioInterruptionType.unknown when wasPausedByBeginEvent:
              await audioPlayer.resume();
              wasPausedByBeginEvent = false;
              break;
            default:
              break;
          }
        }
      });

      s.becomingNoisyEventStream.listen((_) {
        audioPlayer.pause();
      });
    });
    audioPlayer.playerStateStream.listen((state) async {
      if (state == AudioPlaybackState.playing) {
        await session?.setActive(true);
      }
      playbackState.add(await _transformEvent());
    });

    audioPlayer.positionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
    audioPlayer.bufferedPositionStream.listen((pos) async {
      playbackState.add(await _transformEvent());
    });
  }

  void addItem(MediaItem item) {
    session?.setActive(true);
    mediaItem.add(item);
  }

  @override
  Future<void> play() => audioPlayer.resume();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await super.setShuffleMode(shuffleMode);

    audioPlayer.setShuffle(shuffleMode == AudioServiceShuffleMode.all);
  }

  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    if (name == _shuffleActionName) {
      final next = !audioPlayer.isShuffled;
      await setShuffleMode(
        next ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      );
      // Refresh playback state so the control's icon reflects the new state.
      playbackState.add(await _transformEvent());
      return null;
    }
    return super.customAction(name, extras);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    super.setRepeatMode(repeatMode);
    audioPlayer.setLoopMode(switch (repeatMode) {
      AudioServiceRepeatMode.all ||
      AudioServiceRepeatMode.group =>
        PlaylistMode.loop,
      AudioServiceRepeatMode.one => PlaylistMode.single,
      _ => PlaylistMode.none,
    });
  }

  @override
  Future<void> stop() async {
    await audioPlayerNotifier.stop();
  }

  @override
  Future<void> skipToNext() async {
    await audioPlayer.skipToNext();
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await audioPlayer.skipToPrevious();
    await super.skipToPrevious();
  }

  @override
  Future<void> onTaskRemoved() async {
    await audioPlayer.pause();
    if (kIsAndroid) exit(0);
  }

  // ===========================================================================
  // Media browsing (Android Auto / system media browser).
  //
  // The root level exposes a "Liked Songs" entry plus the user's saved
  // playlists (which, for most accounts, includes Spotify's auto-followed
  // mixes such as "Discover Weekly" and "Release Radar"). Each entry is
  // playable: selecting it in Android Auto triggers [playFromMediaId], which
  // resolves the tracks and starts playback through the normal pipeline.
  // ===========================================================================

  @override
  Future<List<MediaItem>> getChildren(
    String parentMediaId, [
    Map<String, dynamic>? options,
  ]) async {
    if (parentMediaId == AudioService.browsableRootId) {
      return _rootChildren();
    }
    if (parentMediaId == _browseMediaId) {
      return _browseChildren();
    }
    if (parentMediaId.startsWith(_sectionPrefix)) {
      return _sectionChildren(parentMediaId.substring(_sectionPrefix.length));
    }
    if (parentMediaId == likedMediaId ||
        parentMediaId.startsWith(playlistMediaIdPrefix)) {
      return _collectionChildren(parentMediaId);
    }
    return const [];
  }

  /// Top level: "Liked Songs" + the user's saved playlists, all browsable
  /// (tap to drill into the track list).
  Future<List<MediaItem>> _rootChildren() async {
    final items = <MediaItem>[];

    try {
      final plugin = await ref
          .read(metadataPluginProvider.future)
          .timeout(const Duration(seconds: 20));

      // Liked Songs uses the most recently liked track's cover as its art.
      // (A bundled asset / private-cache file:// URI isn't readable by the
      // Android Auto process — only http(s) URLs are.)
      Uri? likedArt;
      if (plugin != null) {
        try {
          final firstLiked = await _withAuthRetry(
            () => plugin.user.savedTracks(offset: 0, limit: 1),
          );
          likedArt = _httpArtUri(
            firstLiked.items.firstOrNull?.album.images,
            ImagePlaceholder.albumArt,
          );
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }

      items.add(
        MediaItem(
          id: likedMediaId,
          title: 'Liked Songs',
          artUri: likedArt,
          playable: false,
        ),
      );

      if (plugin == null) return items;

      // "Made for you" / Discover Weekly etc. live in the browse hub, not in
      // savedPlaylists.
      items.add(
        const MediaItem(
          id: _browseMediaId,
          title: 'Browse',
          playable: false,
        ),
      );

      final playlists = await _withAuthRetry(
        () => plugin.user.savedPlaylists(offset: 0, limit: 50),
      );
      for (final playlist in playlists.items) {
        items.add(
          MediaItem(
            id: '$playlistMediaIdPrefix${playlist.id}',
            title: playlist.name,
            artUri: _httpArtUri(
              playlist.images,
              ImagePlaceholder.collection,
            ),
            playable: false,
          ),
        );
      }
    } catch (e, stack) {
      // Likely not authenticated yet; still expose the Liked Songs entry.
      AppLogger.reportError(e, stack);
      if (items.isEmpty) {
        items.add(
          const MediaItem(
            id: likedMediaId,
            title: 'Liked Songs',
            playable: false,
          ),
        );
      }
    }

    return items;
  }

  /// Children of the "Browse" folder: the plugin's browse/home sections that
  /// contain playlists (Made for you, Your top mixes, etc.), each a browsable
  /// folder. The full playlist list (including Discover Weekly, which the
  /// section preview omits) is fetched on demand in [_sectionChildren].
  Future<List<MediaItem>> _browseChildren() async {
    try {
      final plugin = await ref
          .read(metadataPluginProvider.future)
          .timeout(const Duration(seconds: 20));
      if (plugin == null) return const [];

      final sections = await _withAuthRetry(
        () => plugin.browse.sections(offset: 0, limit: 20),
      );

      final items = <MediaItem>[];
      for (final section in sections.items) {
        // Skip sections whose preview has no playlists (e.g. artist-only rows).
        if (section.items.whereType<SpotubeSimplePlaylistObject>().isEmpty) {
          continue;
        }
        items.add(
          MediaItem(
            id: '$_sectionPrefix${section.id}',
            title: section.title,
            playable: false,
          ),
        );
      }
      return items;
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      return const [];
    }
  }

  /// Children of a browse section: its full playlist list (this is where
  /// Discover Weekly lives — it is absent from the section preview).
  Future<List<MediaItem>> _sectionChildren(String sectionId) async {
    try {
      final plugin = await ref
          .read(metadataPluginProvider.future)
          .timeout(const Duration(seconds: 20));
      if (plugin == null) return const [];

      final result = await _withAuthRetry(
        () => plugin.browse.sectionItems(sectionId, offset: 0, limit: 50),
      );

      final seen = <String>{};
      final items = <MediaItem>[];
      for (final playlist
          in result.items.whereType<SpotubeSimplePlaylistObject>()) {
        if (!seen.add(playlist.id)) continue;
        items.add(
          MediaItem(
            id: '$playlistMediaIdPrefix${playlist.id}',
            title: playlist.name,
            artUri: _httpArtUri(playlist.images, ImagePlaceholder.collection),
            playable: false,
          ),
        );
      }
      return items;
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      return const [];
    }
  }

  /// Children of a collection (Liked Songs or a playlist): a "Play all" entry
  /// followed by the track list. Tapping a track plays the collection from
  /// that track.
  Future<List<MediaItem>> _collectionChildren(String collectionId) async {
    try {
      final plugin = await ref
          .read(metadataPluginProvider.future)
          .timeout(const Duration(seconds: 20));
      if (plugin == null) return const [];

      final tracks = await _collectionTracks(plugin, collectionId);

      final items = <MediaItem>[
        MediaItem(
          id: '$_playAllPrefix$collectionId',
          title: '▶  Play all',
          playable: true,
        ),
      ];

      for (final track in tracks) {
        items.add(
          MediaItem(
            id: '$_trackActionPrefix$collectionId/${track.id}',
            title: track.name,
            artist: track.artists.asString(),
            album: track.album.name,
            duration: Duration(milliseconds: track.durationMs),
            artUri: _httpArtUri(track.album.images, ImagePlaceholder.albumArt),
            playable: true,
          ),
        );
      }

      return items;
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      return const [];
    }
  }

  /// Resolves a collection id ([likedMediaId] or `spotube://playlist/<id>`) to
  /// its tracks.
  Future<List<SpotubeFullTrackObject>> _collectionTracks(
    MetadataPlugin plugin,
    String collectionId,
  ) {
    if (collectionId == likedMediaId) {
      return _fetchAllTracks(
        (offset, limit) => plugin.user.savedTracks(offset: offset, limit: limit),
      );
    }
    if (collectionId.startsWith(playlistMediaIdPrefix)) {
      final playlistId = collectionId.substring(playlistMediaIdPrefix.length);
      return _fetchAllTracks(
        (offset, limit) =>
            plugin.playlist.tracks(playlistId, offset: offset, limit: limit),
      );
    }
    return Future.value(const []);
  }

  /// Returns an http(s) art URI for [images], or null. Media browsers run in a
  /// different process and can only load network art — never bundled-asset
  /// placeholder paths.
  Uri? _httpArtUri(
    List<SpotubeImageObject>? images,
    ImagePlaceholder placeholder,
  ) {
    final url = images.asUrlString(placeholder: placeholder);
    return url.startsWith('http') ? Uri.parse(url) : null;
  }

  @override
  Future<void> playFromMediaId(
    String mediaId, [
    Map<String, dynamic>? extras,
  ]) async {
    try {
      final plugin = await ref.read(metadataPluginProvider.future);
      if (plugin == null) return;

      // Parse the media id into a collection to play and an optional track to
      // start from.
      String collectionId;
      String? startTrackId;
      if (mediaId.startsWith(_trackActionPrefix)) {
        final rest = mediaId.substring(_trackActionPrefix.length);
        final sep = rest.lastIndexOf('/');
        if (sep < 0) return;
        collectionId = rest.substring(0, sep);
        startTrackId = rest.substring(sep + 1);
      } else if (mediaId.startsWith(_playAllPrefix)) {
        collectionId = mediaId.substring(_playAllPrefix.length);
      } else if (mediaId == likedMediaId ||
          mediaId.startsWith(playlistMediaIdPrefix)) {
        // Fallback: a collection id played directly.
        collectionId = mediaId;
      } else {
        return;
      }

      final tracks = await _collectionTracks(plugin, collectionId);
      if (tracks.isEmpty) return;

      var initialIndex = 0;
      if (startTrackId != null) {
        final idx = tracks.indexWhere((track) => track.id == startTrackId);
        if (idx >= 0) initialIndex = idx;
      }

      await audioPlayerNotifier.load(
        tracks.cast<SpotubeTrackObject>(),
        initialIndex: initialIndex,
        autoPlay: true,
      );
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
    }
  }

  /// Pages through a paginated track endpoint, accumulating up to [maxTracks]
  /// tracks (bounded so very large libraries don't stall playback start).
  Future<List<SpotubeFullTrackObject>> _fetchAllTracks(
    Future<SpotubePaginationResponseObject<SpotubeFullTrackObject>> Function(
      int offset,
      int limit,
    ) fetch, {
    int pageSize = 50,
    int maxTracks = 500,
  }) async {
    final tracks = <SpotubeFullTrackObject>[];
    var offset = 0;

    while (tracks.length < maxTracks) {
      final page = await _withAuthRetry(() => fetch(offset, pageSize));
      tracks.addAll(page.items);
      if (!page.hasMore || page.items.isEmpty) break;
      offset = page.nextOffset ?? (offset + page.items.length);
    }

    return tracks;
  }

  /// Runs [fn], retrying on failure. On a cold start the stored access token is
  /// often stale, so the first authenticated request fails with 401; the plugin
  /// refreshes the token in the background, so a retry succeeds. Each attempt is
  /// time-bounded so a hung request can't stall the browse tree.
  Future<T> _withAuthRetry<T>(
    Future<T> Function() fn, {
    int attempts = 3,
    Duration delay = const Duration(milliseconds: 700),
    Duration timeout = const Duration(seconds: 15),
  }) async {
    Object? lastError;
    StackTrace? lastStack;
    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        return await fn().timeout(timeout);
      } catch (e, stack) {
        lastError = e;
        lastStack = stack;
        if (attempt < attempts - 1) await Future.delayed(delay);
      }
    }
    Error.throwWithStackTrace(lastError!, lastStack!);
  }

  Future<PlaybackState> _transformEvent() async {
    try {
      return PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          audioPlayer.isPlaying ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
          // Explicit shuffle toggle. audio_service always advertises the
          // standard ACTION_SET_SHUFFLE_MODE, but Android Auto doesn't reliably
          // render a toggle from it, so we expose a tappable custom control.
          MediaControl.custom(
            androidIcon: audioPlayer.isShuffled == true
                ? 'drawable/ic_shuffle_on'
                : 'drawable/ic_shuffle',
            label: 'Shuffle',
            name: _shuffleActionName,
          ),
        ],
        systemActions: {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        playing: audioPlayer.isPlaying,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        shuffleMode: audioPlayer.isShuffled == true
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        repeatMode: switch (audioPlayer.loopMode) {
          PlaylistMode.loop => AudioServiceRepeatMode.all,
          PlaylistMode.single => AudioServiceRepeatMode.one,
          _ => AudioServiceRepeatMode.none,
        },
        processingState: audioPlayer.isBuffering
            ? AudioProcessingState.loading
            : AudioProcessingState.ready,
      );
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      rethrow;
    }
  }
}
