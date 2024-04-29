// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaybackHistoryItem _$PlaybackHistoryItemFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'playlist':
      return PlaybackHistoryPlaylist.fromJson(json);
    case 'album':
      return PlaybackHistoryAlbum.fromJson(json);
    case 'track':
      return PlaybackHistoryTrack.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'PlaybackHistoryItem',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$PlaybackHistoryItem {
  DateTime get date => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime date, PlaylistSimple playlist) playlist,
    required TResult Function(DateTime date, AlbumSimple album) album,
    required TResult Function(DateTime date, Track track) track,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult? Function(DateTime date, AlbumSimple album)? album,
    TResult? Function(DateTime date, Track track)? track,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult Function(DateTime date, AlbumSimple album)? album,
    TResult Function(DateTime date, Track track)? track,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlaybackHistoryPlaylist value) playlist,
    required TResult Function(PlaybackHistoryAlbum value) album,
    required TResult Function(PlaybackHistoryTrack value) track,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlaybackHistoryPlaylist value)? playlist,
    TResult? Function(PlaybackHistoryAlbum value)? album,
    TResult? Function(PlaybackHistoryTrack value)? track,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlaybackHistoryPlaylist value)? playlist,
    TResult Function(PlaybackHistoryAlbum value)? album,
    TResult Function(PlaybackHistoryTrack value)? track,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaybackHistoryItemCopyWith<PlaybackHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaybackHistoryItemCopyWith<$Res> {
  factory $PlaybackHistoryItemCopyWith(
          PlaybackHistoryItem value, $Res Function(PlaybackHistoryItem) then) =
      _$PlaybackHistoryItemCopyWithImpl<$Res, PlaybackHistoryItem>;
  @useResult
  $Res call({DateTime date});
}

/// @nodoc
class _$PlaybackHistoryItemCopyWithImpl<$Res, $Val extends PlaybackHistoryItem>
    implements $PlaybackHistoryItemCopyWith<$Res> {
  _$PlaybackHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaybackHistoryPlaylistImplCopyWith<$Res>
    implements $PlaybackHistoryItemCopyWith<$Res> {
  factory _$$PlaybackHistoryPlaylistImplCopyWith(
          _$PlaybackHistoryPlaylistImpl value,
          $Res Function(_$PlaybackHistoryPlaylistImpl) then) =
      __$$PlaybackHistoryPlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, PlaylistSimple playlist});
}

/// @nodoc
class __$$PlaybackHistoryPlaylistImplCopyWithImpl<$Res>
    extends _$PlaybackHistoryItemCopyWithImpl<$Res,
        _$PlaybackHistoryPlaylistImpl>
    implements _$$PlaybackHistoryPlaylistImplCopyWith<$Res> {
  __$$PlaybackHistoryPlaylistImplCopyWithImpl(
      _$PlaybackHistoryPlaylistImpl _value,
      $Res Function(_$PlaybackHistoryPlaylistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? playlist = null,
  }) {
    return _then(_$PlaybackHistoryPlaylistImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      playlist: null == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as PlaylistSimple,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaybackHistoryPlaylistImpl implements PlaybackHistoryPlaylist {
  _$PlaybackHistoryPlaylistImpl(
      {required this.date, required this.playlist, final String? $type})
      : $type = $type ?? 'playlist';

  factory _$PlaybackHistoryPlaylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaybackHistoryPlaylistImplFromJson(json);

  @override
  final DateTime date;
  @override
  final PlaylistSimple playlist;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PlaybackHistoryItem.playlist(date: $date, playlist: $playlist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaybackHistoryPlaylistImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.playlist, playlist) ||
                other.playlist == playlist));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, playlist);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaybackHistoryPlaylistImplCopyWith<_$PlaybackHistoryPlaylistImpl>
      get copyWith => __$$PlaybackHistoryPlaylistImplCopyWithImpl<
          _$PlaybackHistoryPlaylistImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime date, PlaylistSimple playlist) playlist,
    required TResult Function(DateTime date, AlbumSimple album) album,
    required TResult Function(DateTime date, Track track) track,
  }) {
    return playlist(date, this.playlist);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult? Function(DateTime date, AlbumSimple album)? album,
    TResult? Function(DateTime date, Track track)? track,
  }) {
    return playlist?.call(date, this.playlist);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult Function(DateTime date, AlbumSimple album)? album,
    TResult Function(DateTime date, Track track)? track,
    required TResult orElse(),
  }) {
    if (playlist != null) {
      return playlist(date, this.playlist);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlaybackHistoryPlaylist value) playlist,
    required TResult Function(PlaybackHistoryAlbum value) album,
    required TResult Function(PlaybackHistoryTrack value) track,
  }) {
    return playlist(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlaybackHistoryPlaylist value)? playlist,
    TResult? Function(PlaybackHistoryAlbum value)? album,
    TResult? Function(PlaybackHistoryTrack value)? track,
  }) {
    return playlist?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlaybackHistoryPlaylist value)? playlist,
    TResult Function(PlaybackHistoryAlbum value)? album,
    TResult Function(PlaybackHistoryTrack value)? track,
    required TResult orElse(),
  }) {
    if (playlist != null) {
      return playlist(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaybackHistoryPlaylistImplToJson(
      this,
    );
  }
}

abstract class PlaybackHistoryPlaylist implements PlaybackHistoryItem {
  factory PlaybackHistoryPlaylist(
      {required final DateTime date,
      required final PlaylistSimple playlist}) = _$PlaybackHistoryPlaylistImpl;

  factory PlaybackHistoryPlaylist.fromJson(Map<String, dynamic> json) =
      _$PlaybackHistoryPlaylistImpl.fromJson;

  @override
  DateTime get date;
  PlaylistSimple get playlist;
  @override
  @JsonKey(ignore: true)
  _$$PlaybackHistoryPlaylistImplCopyWith<_$PlaybackHistoryPlaylistImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlaybackHistoryAlbumImplCopyWith<$Res>
    implements $PlaybackHistoryItemCopyWith<$Res> {
  factory _$$PlaybackHistoryAlbumImplCopyWith(_$PlaybackHistoryAlbumImpl value,
          $Res Function(_$PlaybackHistoryAlbumImpl) then) =
      __$$PlaybackHistoryAlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, AlbumSimple album});
}

/// @nodoc
class __$$PlaybackHistoryAlbumImplCopyWithImpl<$Res>
    extends _$PlaybackHistoryItemCopyWithImpl<$Res, _$PlaybackHistoryAlbumImpl>
    implements _$$PlaybackHistoryAlbumImplCopyWith<$Res> {
  __$$PlaybackHistoryAlbumImplCopyWithImpl(_$PlaybackHistoryAlbumImpl _value,
      $Res Function(_$PlaybackHistoryAlbumImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? album = null,
  }) {
    return _then(_$PlaybackHistoryAlbumImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as AlbumSimple,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaybackHistoryAlbumImpl implements PlaybackHistoryAlbum {
  _$PlaybackHistoryAlbumImpl(
      {required this.date, required this.album, final String? $type})
      : $type = $type ?? 'album';

  factory _$PlaybackHistoryAlbumImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaybackHistoryAlbumImplFromJson(json);

  @override
  final DateTime date;
  @override
  final AlbumSimple album;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PlaybackHistoryItem.album(date: $date, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaybackHistoryAlbumImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.album, album) || other.album == album));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, album);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaybackHistoryAlbumImplCopyWith<_$PlaybackHistoryAlbumImpl>
      get copyWith =>
          __$$PlaybackHistoryAlbumImplCopyWithImpl<_$PlaybackHistoryAlbumImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime date, PlaylistSimple playlist) playlist,
    required TResult Function(DateTime date, AlbumSimple album) album,
    required TResult Function(DateTime date, Track track) track,
  }) {
    return album(date, this.album);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult? Function(DateTime date, AlbumSimple album)? album,
    TResult? Function(DateTime date, Track track)? track,
  }) {
    return album?.call(date, this.album);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult Function(DateTime date, AlbumSimple album)? album,
    TResult Function(DateTime date, Track track)? track,
    required TResult orElse(),
  }) {
    if (album != null) {
      return album(date, this.album);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlaybackHistoryPlaylist value) playlist,
    required TResult Function(PlaybackHistoryAlbum value) album,
    required TResult Function(PlaybackHistoryTrack value) track,
  }) {
    return album(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlaybackHistoryPlaylist value)? playlist,
    TResult? Function(PlaybackHistoryAlbum value)? album,
    TResult? Function(PlaybackHistoryTrack value)? track,
  }) {
    return album?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlaybackHistoryPlaylist value)? playlist,
    TResult Function(PlaybackHistoryAlbum value)? album,
    TResult Function(PlaybackHistoryTrack value)? track,
    required TResult orElse(),
  }) {
    if (album != null) {
      return album(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaybackHistoryAlbumImplToJson(
      this,
    );
  }
}

abstract class PlaybackHistoryAlbum implements PlaybackHistoryItem {
  factory PlaybackHistoryAlbum(
      {required final DateTime date,
      required final AlbumSimple album}) = _$PlaybackHistoryAlbumImpl;

  factory PlaybackHistoryAlbum.fromJson(Map<String, dynamic> json) =
      _$PlaybackHistoryAlbumImpl.fromJson;

  @override
  DateTime get date;
  AlbumSimple get album;
  @override
  @JsonKey(ignore: true)
  _$$PlaybackHistoryAlbumImplCopyWith<_$PlaybackHistoryAlbumImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlaybackHistoryTrackImplCopyWith<$Res>
    implements $PlaybackHistoryItemCopyWith<$Res> {
  factory _$$PlaybackHistoryTrackImplCopyWith(_$PlaybackHistoryTrackImpl value,
          $Res Function(_$PlaybackHistoryTrackImpl) then) =
      __$$PlaybackHistoryTrackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, Track track});
}

/// @nodoc
class __$$PlaybackHistoryTrackImplCopyWithImpl<$Res>
    extends _$PlaybackHistoryItemCopyWithImpl<$Res, _$PlaybackHistoryTrackImpl>
    implements _$$PlaybackHistoryTrackImplCopyWith<$Res> {
  __$$PlaybackHistoryTrackImplCopyWithImpl(_$PlaybackHistoryTrackImpl _value,
      $Res Function(_$PlaybackHistoryTrackImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? track = null,
  }) {
    return _then(_$PlaybackHistoryTrackImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      track: null == track
          ? _value.track
          : track // ignore: cast_nullable_to_non_nullable
              as Track,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaybackHistoryTrackImpl implements PlaybackHistoryTrack {
  _$PlaybackHistoryTrackImpl(
      {required this.date, required this.track, final String? $type})
      : $type = $type ?? 'track';

  factory _$PlaybackHistoryTrackImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaybackHistoryTrackImplFromJson(json);

  @override
  final DateTime date;
  @override
  final Track track;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PlaybackHistoryItem.track(date: $date, track: $track)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaybackHistoryTrackImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.track, track) || other.track == track));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, track);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaybackHistoryTrackImplCopyWith<_$PlaybackHistoryTrackImpl>
      get copyWith =>
          __$$PlaybackHistoryTrackImplCopyWithImpl<_$PlaybackHistoryTrackImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime date, PlaylistSimple playlist) playlist,
    required TResult Function(DateTime date, AlbumSimple album) album,
    required TResult Function(DateTime date, Track track) track,
  }) {
    return track(date, this.track);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult? Function(DateTime date, AlbumSimple album)? album,
    TResult? Function(DateTime date, Track track)? track,
  }) {
    return track?.call(date, this.track);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime date, PlaylistSimple playlist)? playlist,
    TResult Function(DateTime date, AlbumSimple album)? album,
    TResult Function(DateTime date, Track track)? track,
    required TResult orElse(),
  }) {
    if (track != null) {
      return track(date, this.track);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlaybackHistoryPlaylist value) playlist,
    required TResult Function(PlaybackHistoryAlbum value) album,
    required TResult Function(PlaybackHistoryTrack value) track,
  }) {
    return track(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlaybackHistoryPlaylist value)? playlist,
    TResult? Function(PlaybackHistoryAlbum value)? album,
    TResult? Function(PlaybackHistoryTrack value)? track,
  }) {
    return track?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlaybackHistoryPlaylist value)? playlist,
    TResult Function(PlaybackHistoryAlbum value)? album,
    TResult Function(PlaybackHistoryTrack value)? track,
    required TResult orElse(),
  }) {
    if (track != null) {
      return track(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaybackHistoryTrackImplToJson(
      this,
    );
  }
}

abstract class PlaybackHistoryTrack implements PlaybackHistoryItem {
  factory PlaybackHistoryTrack(
      {required final DateTime date,
      required final Track track}) = _$PlaybackHistoryTrackImpl;

  factory PlaybackHistoryTrack.fromJson(Map<String, dynamic> json) =
      _$PlaybackHistoryTrackImpl.fromJson;

  @override
  DateTime get date;
  Track get track;
  @override
  @JsonKey(ignore: true)
  _$$PlaybackHistoryTrackImplCopyWith<_$PlaybackHistoryTrackImpl>
      get copyWith => throw _privateConstructorUsedError;
}
