import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_player/loop_mode.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

final dbus = DBusClient.session();

class _MprisMediaPlayer2 extends DBusObject {
  /// Creates a new object to expose on [path].
  _MprisMediaPlayer2() : super(DBusObjectPath('/org/mpris/MediaPlayer2')) {
    dbus.registerObject(this);
  }

  void dispose() {
    dbus.unregisterObject(this);
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanQuit
  Future<DBusMethodResponse> getCanQuit() async {
    return DBusMethodSuccessResponse([const DBusBoolean(true)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Fullscreen
  Future<DBusMethodResponse> getFullscreen() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Fullscreen
  Future<DBusMethodResponse> setFullscreen(bool value) async {
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanSetFullscreen
  Future<DBusMethodResponse> getCanSetFullscreen() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.CanRaise
  Future<DBusMethodResponse> getCanRaise() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.HasTrackList
  Future<DBusMethodResponse> getHasTrackList() async {
    return DBusMethodSuccessResponse([const DBusBoolean(false)]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Identity
  Future<DBusMethodResponse> getIdentity() async {
    return DBusMethodSuccessResponse([const DBusString("Spotube")]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.DesktopEntry
  Future<DBusMethodResponse> getDesktopEntry() async {
    return DBusMethodSuccessResponse(
      [const DBusString("/usr/share/application/spotube")],
    );
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedUriSchemes
  Future<DBusMethodResponse> getSupportedUriSchemes() async {
    return DBusMethodSuccessResponse([
      DBusArray.string(["http"])
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.SupportedMimeTypes
  Future<DBusMethodResponse> getSupportedMimeTypes() async {
    return DBusMethodSuccessResponse([
      DBusArray.string(["audio/mpeg"])
    ]);
  }

  /// Implementation of org.mpris.MediaPlayer2.Raise()
  Future<DBusMethodResponse> doRaise() async {
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Quit()
  Future<DBusMethodResponse> doQuit() async {
    exit(0);
  }

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface('org.mpris.MediaPlayer2', methods: [
        DBusIntrospectMethod('Raise'),
        DBusIntrospectMethod('Quit')
      ], properties: [
        DBusIntrospectProperty('CanQuit', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Fullscreen', DBusSignature('b'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('CanSetFullscreen', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanRaise', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('HasTrackList', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Identity', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('DesktopEntry', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedUriSchemes', DBusSignature('as'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedMimeTypes', DBusSignature('as'),
            access: DBusPropertyAccess.read)
      ])
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    if (methodCall.interface == 'org.mpris.MediaPlayer2') {
      if (methodCall.name == 'Raise') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doRaise();
      } else if (methodCall.name == 'Quit') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return doQuit();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else {
      return DBusMethodErrorResponse.unknownInterface();
    }
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return getCanQuit();
      } else if (name == 'Fullscreen') {
        return getFullscreen();
      } else if (name == 'CanSetFullscreen') {
        return getCanSetFullscreen();
      } else if (name == 'CanRaise') {
        return getCanRaise();
      } else if (name == 'HasTrackList') {
        return getHasTrackList();
      } else if (name == 'Identity') {
        return getIdentity();
      } else if (name == 'DesktopEntry') {
        return getDesktopEntry();
      } else if (name == 'SupportedUriSchemes') {
        return getSupportedUriSchemes();
      } else if (name == 'SupportedMimeTypes') {
        return getSupportedMimeTypes();
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
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Fullscreen') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return setFullscreen((value as DBusBoolean).value);
      } else if (name == 'CanSetFullscreen') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanRaise') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'HasTrackList') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Identity') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'DesktopEntry') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedUriSchemes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedMimeTypes') {
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
    if (interface == 'org.mpris.MediaPlayer2') {
      properties['CanQuit'] = (await getCanQuit()).returnValues[0];
      properties['Fullscreen'] = (await getFullscreen()).returnValues[0];
      properties['CanSetFullscreen'] =
          (await getCanSetFullscreen()).returnValues[0];
      properties['CanRaise'] = (await getCanRaise()).returnValues[0];
      properties['HasTrackList'] = (await getHasTrackList()).returnValues[0];
      properties['Identity'] = (await getIdentity()).returnValues[0];
      properties['DesktopEntry'] = (await getDesktopEntry()).returnValues[0];
      properties['SupportedUriSchemes'] =
          (await getSupportedUriSchemes()).returnValues[0];
      properties['SupportedMimeTypes'] =
          (await getSupportedMimeTypes()).returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}

class _MprisMediaPlayer2Player extends DBusObject {
  final Ref ref;
  final ProxyPlaylistNotifier playlistNotifier;

  /// Creates a new object to expose on [path].
  _MprisMediaPlayer2Player(this.ref, this.playlistNotifier)
      : super(DBusObjectPath("/org/mpris/MediaPlayer2")) {
    (() async {
      final nameStatus =
          await dbus.requestName("org.mpris.MediaPlayer2.spotube");
      if (nameStatus == DBusRequestNameReply.exists) {
        await dbus.requestName("org.mpris.MediaPlayer2.spotube.instance$pid");
      }
      await dbus.registerObject(this);
    }());
  }

  ProxyPlaylist get playlist => playlistNotifier.playlist;

  void dispose() {
    dbus.unregisterObject(this);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.PlaybackStatus
  Future<DBusMethodResponse> getPlaybackStatus() async {
    final status = audioPlayer.isPlaying
        ? "Playing"
        : playlist.active == null
            ? "Stopped"
            : "Paused";
    return DBusMethodSuccessResponse([DBusString(status)]);
  }

  // TODO: Implement Track Loop

  /// Gets value of property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> getLoopStatus() async {
    final loopMode = switch (await audioPlayer.loopMode) {
      PlaybackLoopMode.all => "Playlist",
      PlaybackLoopMode.one => "Track",
      PlaybackLoopMode.none => "None",
    };

    return DBusMethodSuccessResponse([DBusString(loopMode)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.LoopStatus
  Future<DBusMethodResponse> setLoopStatus(String value) async {
    // playlistNotifier.setIsLoop(value == "Track");
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> getRate() async {
    return DBusMethodSuccessResponse([const DBusDouble(1)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Rate
  Future<DBusMethodResponse> setRate(double value) async {
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> getShuffle() async {
    return DBusMethodSuccessResponse(
        [DBusBoolean(await audioPlayer.isShuffled)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Shuffle
  Future<DBusMethodResponse> setShuffle(bool value) async {
    audioPlayer.setShuffle(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Metadata
  Future<DBusMethodResponse> getMetadata() async {
    if (playlist.activeTrack == null || playlist.isFetching) {
      return DBusMethodSuccessResponse([DBusDict.stringVariant({})]);
    }
    final id = playlist.activeTrack!.id;

    return DBusMethodSuccessResponse([
      DBusDict.stringVariant({
        "mpris:trackid": DBusString("${path.value}/Track/$id"),
        "mpris:length": DBusInt32(
          (await audioPlayer.duration)?.inMicroseconds ?? 0,
        ),
        "mpris:artUrl": DBusString(
          TypeConversionUtils.image_X_UrlString(
            playlist.activeTrack?.album?.images,
            placeholder: ImagePlaceholder.albumArt,
          ),
        ),
        "xesam:album": DBusString(playlist.activeTrack!.album!.name!),
        "xesam:artist": DBusArray.string(
          playlist.activeTrack!.artists!.map((artist) => artist.name!),
        ),
        "xesam:title": DBusString(playlist.activeTrack!.name!),
        "xesam:url": DBusString(
          playlist.activeTrack is SourcedTrack
              ? (playlist.activeTrack as SourcedTrack).url
              : playlist.activeTrack!.previewUrl ?? "",
        ),
        "xesam:genre": const DBusString("Unknown"),
      }),
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> getVolume() async {
    return DBusMethodSuccessResponse([DBusDouble(audioPlayer.volume)]);
  }

  /// Sets property org.mpris.MediaPlayer2.Player.Volume
  Future<DBusMethodResponse> setVolume(double value) async {
    await audioPlayer.setVolume(value);
    return DBusMethodSuccessResponse();
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.Position
  Future<DBusMethodResponse> getPosition() async {
    return DBusMethodSuccessResponse([
      DBusInt64((await audioPlayer.position)?.inMicroseconds ?? 0),
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
        (playlist.tracks.length) > 1,
      )
    ]);
  }

  /// Gets value of property org.mpris.MediaPlayer2.Player.CanGoPrevious
  Future<DBusMethodResponse> getCanGoPrevious() async {
    return DBusMethodSuccessResponse([
      DBusBoolean(
        (playlist.tracks.length) > 1,
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
    await playlistNotifier.next();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Previous()
  Future<DBusMethodResponse> doPrevious() async {
    await playlistNotifier.previous();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Pause()
  Future<DBusMethodResponse> doPause() async {
    await audioPlayer.pause();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.PlayPause()
  Future<DBusMethodResponse> doPlayPause() async {
    audioPlayer.isPlaying
        ? await audioPlayer.pause()
        : await audioPlayer.resume();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Stop()
  Future<DBusMethodResponse> doStop() async {
    playlistNotifier.stop();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Play()
  Future<DBusMethodResponse> doPlay() async {
    await audioPlayer.resume();
    return DBusMethodSuccessResponse();
  }

  /// Implementation of org.mpris.MediaPlayer2.Player.Seek()
  Future<DBusMethodResponse> doSeek(int offset) async {
    await audioPlayer.seek(Duration(microseconds: offset));
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
  Future<void> emitSeeked(int position) async {
    await emitSignal(
      'org.mpris.MediaPlayer2.Player',
      'Seeked',
      [DBusInt64(position)],
    );
  }

  Future<void> updateProperties() async {
    return emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "PlaybackStatus": (await getPlaybackStatus()).returnValues.first,
        "LoopStatus": (await getLoopStatus()).returnValues.first,
        "Rate": (await getRate()).returnValues.first,
        "Shuffle": (await getShuffle()).returnValues.first,
        "Metadata": (await getMetadata()).returnValues.first,
        "Volume": (await getVolume()).returnValues.first,
        "Position": (await getPosition()).returnValues.first,
        "MinimumRate": (await getMinimumRate()).returnValues.first,
        "MaximumRate": (await getMaximumRate()).returnValues.first,
        "CanGoNext": (await getCanGoNext()).returnValues.first,
        "CanGoPrevious": (await getCanGoPrevious()).returnValues.first,
        "CanPlay": (await getCanPlay()).returnValues.first,
        "CanPause": (await getCanPause()).returnValues.first,
        "CanSeek": (await getCanSeek()).returnValues.first,
        "CanControl": (await getCanControl()).returnValues.first,
      },
    );
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

class LinuxAudioService {
  _MprisMediaPlayer2 mp2;
  _MprisMediaPlayer2Player player;

  LinuxAudioService(Ref ref, ProxyPlaylistNotifier playlistNotifier)
      : mp2 = _MprisMediaPlayer2(),
        player = _MprisMediaPlayer2Player(ref, playlistNotifier);

  void dispose() {
    mp2.dispose();
    player.dispose();
  }
}
