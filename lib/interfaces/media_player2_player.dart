// This file was generated using the following command and may be overwritten.
// dart-dbus generate-object defs/org.mpris.MediaPlayer2.Player.xml

import 'package:audioplayers/audioplayers.dart';
import 'package:dbus/dbus.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Playback.dart';

class Player_Interface extends DBusObject {
  final AudioPlayer player;
  final Playback playback;

  /// Creates a new object to expose on [path].
  Player_Interface({
    required this.player,
    required this.playback,
  }) : super(DBusObjectPath("/org/mpris/MediaPlayer2"));

  /// Gets value of property org.mpris.MediaPlayer2.Player.PlaybackStatus
  Future<DBusMethodResponse> getPlaybackStatus() async {
    final status = player.state == PlayerState.playing
        ? "Playing"
        : playback.currentPlaylist == null
            ? "Stopped"
            : "Paused";
    return DBusMethodSuccessResponse([DBusString(status)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> getLoopStatus() async {
    return DBusMethodSuccessResponse([const DBusString("Playlist")]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> setLoopStatus(String value) async {
    return DBusMethodErrorResponse.failed(
        'Set org.mpris.MediaPlayer2.Player.LoopStatus not implemented');
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    return DBusMethodSuccessResponse([DBusDouble(1)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double value) async {
    player.setPlaybackRate(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> getShuffle() async {
    return DBusMethodSuccessResponse([DBusBoolean(playback.shuffled)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> setShuffle(bool value) async {
    if (value) {
      playback.shuffle();
    } else {
      playback.unshuffle();
    }
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Metadata
  Future<DBusMethodResponse> getMetadata() async {
    try {
      if (playback.currentTrack == null) {
        return DBusMethodSuccessResponse([DBusDict.stringVariant({})]);
      }
      final id = (playback.currentPlaylist != null
              ? playback.currentPlaylist!.tracks.indexWhere(
                  (track) => playback.currentTrack!.id == track.id!,
                )
              : 0)
          .abs();

      return DBusMethodSuccessResponse([
        DBusDict.stringVariant({
          "mpris:trackid": DBusString("${path.value}/Track/$id"),
          "mpris:length": DBusInt32(playback.duration?.inMicroseconds ?? 0),
          "mpris:artUrl": DBusString(
              imageToUrlString(playback.currentTrack?.album?.images)),
          "xesam:album": DBusString(playback.currentTrack!.album!.name!),
          "xesam:artist": DBusArray.string(
            playback.currentTrack!.artists!.map((artist) => artist.name!),
          ),
          "xesam:title": DBusString(playback.currentTrack!.name!),
          "xesam:url": DBusString(
            playback.currentTrack is SpotubeTrack
                ? (playback.currentTrack as SpotubeTrack).ytUri
                : playback.currentTrack!.previewUrl!,
          ),
          "xesam:genre": const DBusString("Unknown"),
        }),
      ]);
    } catch (e) {
      print("[DBUS ERROR] $e");
      rethrow;
    }
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    return DBusMethodSuccessResponse([DBusDouble(playback.volume)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> setVolume(double value) async {
    playback.setVolume(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Position
  Future<DBusMethodResponse> getPosition() async {
    return DBusMethodSuccessResponse([
      DBusInt64((await player.getDuration())?.inMicroseconds ?? 0),
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MinimumRate
  Future<DBusMethodResponse> getMinimumRate() async {
    return DBusMethodSuccessResponse([const DBusDouble(1)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.MaximumRate
  Future<DBusMethodResponse> getMaximumRate() async {
    return DBusMethodSuccessResponse([const DBusDouble(1)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoNext
  Future<DBusMethodResponse> getCanGoNext() async {
    return DBusMethodSuccessResponse([
      DBusBoolean(
        playback.currentPlaylist?.tracks.isNotEmpty == true,
      )
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoPrevious
  Future<DBusMethodResponse> getCanGoPrevious() async {
    return DBusMethodSuccessResponse([
      DBusBoolean(
        playback.currentPlaylist?.tracks.isNotEmpty == true,
      )
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPlay
  Future<DBusMethodResponse> getCanPlay() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanPause
  Future<DBusMethodResponse> getCanPause() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanSeek
  Future<DBusMethodResponse> getCanSeek() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanControl
  Future<DBusMethodResponse> getCanControl() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Next()
  Future<DBusMethodResponse> doNext() async {
    playback.movePlaylistPositionBy(1);
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Previous()
  Future<DBusMethodResponse> doPrevious() async {
    playback.movePlaylistPositionBy(-1);
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    player.pause();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    player.state == PlayerState.playing ? player.pause() : player.resume();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    await player.pause();
    await player.seek(Duration.zero);
    playback.reset();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Play()
  Future<DBusMethodResponse> doPlay() async {
    player.resume();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Seek()
  Future<DBusMethodResponse> doSeek(int offset) async {
    player.seek(Duration(microseconds: offset));
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.SetPosition()
  Future<DBusMethodResponse> doSetPosition(String TrackId, int Position) async {
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.OpenUri()
  Future<DBusMethodResponse> doOpenUri(String Uri) async {
    return DBusMethodSuccessResponse();
  }

  /// Emits signal org.mpris.MediaPlayer2.Player.Seeked
  Future<void> emitSeeked(int Position) async {
    await emitSignal(
        'org.mpris.MediaPlayer2.Player', 'Seeked', [DBusInt64(Position)]);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface('org.mpris.MediaPlayer2.Player', methods: [
        DBusIntrospectMethod('Next'),
        DBusIntrospectMethod('Previous'),
        DBusIntrospectMethod('Pause'),
        DBusIntrospectMethod('PlayPause'),
        DBusIntrospectMethod('Stop'),
        DBusIntrospectMethod('Play'),
        DBusIntrospectMethod('Seek', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Offset')
        ]),
        DBusIntrospectMethod('SetPosition', args: [
          DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_,
              name: 'TrackId'),
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Position')
        ]),
        DBusIntrospectMethod('OpenUri', args: [
          DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_,
              name: 'Uri')
        ])
      ], signals: [
        DBusIntrospectSignal('Seeked', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.out,
              name: 'Position')
        ])
      ], properties: [
        DBusIntrospectProperty('PlaybackStatus', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('LoopStatus', DBusSignature('s'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Rate', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Shuffle', DBusSignature('b'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Metadata', DBusSignature('a{sv}'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Volume', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Position', DBusSignature('x'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MinimumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MaximumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoNext', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoPrevious', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPlay', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPause', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanSeek', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanControl', DBusSignature('b'),
            access: DBusPropertyAccess.read)
      ])
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      if (methodCall.name == 'Next') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doNext();
      } else if (methodCall.name == 'Previous') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPrevious();
      } else if (methodCall.name == 'Pause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPause();
      } else if (methodCall.name == 'PlayPause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlayPause();
      } else if (methodCall.name == 'Stop') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doStop();
      } else if (methodCall.name == 'Play') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doPlay();
      } else if (methodCall.name == 'Seek') {
        if (methodCall.signature != DBusSignature('x')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSeek((methodCall.values[0] as DBusInt64).value);
      } else if (methodCall.name == 'SetPosition') {
        if (methodCall.signature != DBusSignature('ox')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doSetPosition((methodCall.values[0] as DBusObjectPath).value,
            (methodCall.values[1] as DBusInt64).value);
      } else if (methodCall.name == 'OpenUri') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doOpenUri((methodCall.values[0] as DBusString).value);
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return getPlaybackStatus();
      } else if (name == 'LoopStatus') {
        return getLoopStatus();
      } else if (name == 'Rate') {
        return getRate();
      } else if (name == 'Shuffle') {
        return getShuffle();
      } else if (name == 'Metadata') {
        return getMetadata();
      } else if (name == 'Volume') {
        return getVolume();
      } else if (name == 'Position') {
        return getPosition();
      } else if (name == 'MinimumRate') {
        return getMinimumRate();
      } else if (name == 'MaximumRate') {
        return getMaximumRate();
      } else if (name == 'CanGoNext') {
        return getCanGoNext();
      } else if (name == 'CanGoPrevious') {
        return getCanGoPrevious();
      } else if (name == 'CanPlay') {
        return getCanPlay();
      } else if (name == 'CanPause') {
        return getCanPause();
      } else if (name == 'CanSeek') {
        return getCanSeek();
      } else if (name == 'CanControl') {
        return getCanControl();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(
      String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'LoopStatus') {
        if (value.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setLoopStatus((value as DBusString).value);
      } else if (name == 'Rate') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setRate((value as DBusDouble).value);
      } else if (name == 'Shuffle') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setShuffle((value as DBusBoolean).value);
      } else if (name == 'Metadata') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Volume') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setVolume((value as DBusDouble).value);
      } else if (name == 'Position') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MinimumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MaximumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoNext') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoPrevious') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPlay') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPause') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanSeek') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanControl') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    var properties = <String, DBusValue>{};
    if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties['PlaybackStatus'] =
          (await getPlaybackStatus()).returnValues[0];
      properties['LoopStatus'] = (await getLoopStatus()).returnValues[0];
      properties['Rate'] = (await getRate()).returnValues[0];
      properties['Shuffle'] = (await getShuffle()).returnValues[0];
      properties['Metadata'] = (await getMetadata()).returnValues[0];
      properties['Volume'] = (await getVolume()).returnValues[0];
      properties['Position'] = (await getPosition()).returnValues[0];
      properties['MinimumRate'] = (await getMinimumRate()).returnValues[0];
      properties['MaximumRate'] = (await getMaximumRate()).returnValues[0];
      properties['CanGoNext'] = (await getCanGoNext()).returnValues[0];
      properties['CanGoPrevious'] = (await getCanGoPrevious()).returnValues[0];
      properties['CanPlay'] = (await getCanPlay()).returnValues[0];
      properties['CanPause'] = (await getCanPause()).returnValues[0];
      properties['CanSeek'] = (await getCanSeek()).returnValues[0];
      properties['CanControl'] = (await getCanControl()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}
