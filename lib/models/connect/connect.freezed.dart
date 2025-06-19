// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connect.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebSocketLoadEventData _$WebSocketLoadEventDataFromJson(
    Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'playlist':
      return WebSocketLoadEventDataPlaylist.fromJson(json);
    case 'album':
      return WebSocketLoadEventDataAlbum.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'WebSocketLoadEventData',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$WebSocketLoadEventData {
  @Assert("tracks is List<SpotubeFullTrackObject>",
      "tracks must be a list of SpotubeFullTrackObject")
  List<SpotubeTrackObject> get tracks => throw _privateConstructorUsedError;
  Object? get collection => throw _privateConstructorUsedError;
  int? get initialIndex => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)
        playlist,
    required TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)
        album,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)?
        playlist,
    TResult? Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)?
        album,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)?
        playlist,
    TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)?
        album,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WebSocketLoadEventDataPlaylist value) playlist,
    required TResult Function(WebSocketLoadEventDataAlbum value) album,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WebSocketLoadEventDataPlaylist value)? playlist,
    TResult? Function(WebSocketLoadEventDataAlbum value)? album,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WebSocketLoadEventDataPlaylist value)? playlist,
    TResult Function(WebSocketLoadEventDataAlbum value)? album,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this WebSocketLoadEventData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebSocketLoadEventDataCopyWith<WebSocketLoadEventData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketLoadEventDataCopyWith<$Res> {
  factory $WebSocketLoadEventDataCopyWith(WebSocketLoadEventData value,
          $Res Function(WebSocketLoadEventData) then) =
      _$WebSocketLoadEventDataCopyWithImpl<$Res, WebSocketLoadEventData>;
  @useResult
  $Res call(
      {@Assert("tracks is List<SpotubeFullTrackObject>",
          "tracks must be a list of SpotubeFullTrackObject")
      List<SpotubeTrackObject> tracks,
      int? initialIndex});
}

/// @nodoc
class _$WebSocketLoadEventDataCopyWithImpl<$Res,
        $Val extends WebSocketLoadEventData>
    implements $WebSocketLoadEventDataCopyWith<$Res> {
  _$WebSocketLoadEventDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tracks = null,
    Object? initialIndex = freezed,
  }) {
    return _then(_value.copyWith(
      tracks: null == tracks
          ? _value.tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as List<SpotubeTrackObject>,
      initialIndex: freezed == initialIndex
          ? _value.initialIndex
          : initialIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebSocketLoadEventDataPlaylistImplCopyWith<$Res>
    implements $WebSocketLoadEventDataCopyWith<$Res> {
  factory _$$WebSocketLoadEventDataPlaylistImplCopyWith(
          _$WebSocketLoadEventDataPlaylistImpl value,
          $Res Function(_$WebSocketLoadEventDataPlaylistImpl) then) =
      __$$WebSocketLoadEventDataPlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Assert("tracks is List<SpotubeFullTrackObject>",
          "tracks must be a list of SpotubeFullTrackObject")
      List<SpotubeTrackObject> tracks,
      SpotubeSimplePlaylistObject? collection,
      int? initialIndex});

  $SpotubeSimplePlaylistObjectCopyWith<$Res>? get collection;
}

/// @nodoc
class __$$WebSocketLoadEventDataPlaylistImplCopyWithImpl<$Res>
    extends _$WebSocketLoadEventDataCopyWithImpl<$Res,
        _$WebSocketLoadEventDataPlaylistImpl>
    implements _$$WebSocketLoadEventDataPlaylistImplCopyWith<$Res> {
  __$$WebSocketLoadEventDataPlaylistImplCopyWithImpl(
      _$WebSocketLoadEventDataPlaylistImpl _value,
      $Res Function(_$WebSocketLoadEventDataPlaylistImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tracks = null,
    Object? collection = freezed,
    Object? initialIndex = freezed,
  }) {
    return _then(_$WebSocketLoadEventDataPlaylistImpl(
      tracks: null == tracks
          ? _value._tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as List<SpotubeTrackObject>,
      collection: freezed == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as SpotubeSimplePlaylistObject?,
      initialIndex: freezed == initialIndex
          ? _value.initialIndex
          : initialIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubeSimplePlaylistObjectCopyWith<$Res>? get collection {
    if (_value.collection == null) {
      return null;
    }

    return $SpotubeSimplePlaylistObjectCopyWith<$Res>(_value.collection!,
        (value) {
      return _then(_value.copyWith(collection: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$WebSocketLoadEventDataPlaylistImpl
    extends WebSocketLoadEventDataPlaylist {
  _$WebSocketLoadEventDataPlaylistImpl(
      {@Assert("tracks is List<SpotubeFullTrackObject>",
          "tracks must be a list of SpotubeFullTrackObject")
      required final List<SpotubeTrackObject> tracks,
      this.collection,
      this.initialIndex,
      final String? $type})
      : _tracks = tracks,
        $type = $type ?? 'playlist',
        super._();

  factory _$WebSocketLoadEventDataPlaylistImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WebSocketLoadEventDataPlaylistImplFromJson(json);

  final List<SpotubeTrackObject> _tracks;
  @override
  @Assert("tracks is List<SpotubeFullTrackObject>",
      "tracks must be a list of SpotubeFullTrackObject")
  List<SpotubeTrackObject> get tracks {
    if (_tracks is EqualUnmodifiableListView) return _tracks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tracks);
  }

  @override
  final SpotubeSimplePlaylistObject? collection;
  @override
  final int? initialIndex;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'WebSocketLoadEventData.playlist(tracks: $tracks, collection: $collection, initialIndex: $initialIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketLoadEventDataPlaylistImpl &&
            const DeepCollectionEquality().equals(other._tracks, _tracks) &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            (identical(other.initialIndex, initialIndex) ||
                other.initialIndex == initialIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_tracks), collection, initialIndex);

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketLoadEventDataPlaylistImplCopyWith<
          _$WebSocketLoadEventDataPlaylistImpl>
      get copyWith => __$$WebSocketLoadEventDataPlaylistImplCopyWithImpl<
          _$WebSocketLoadEventDataPlaylistImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)
        playlist,
    required TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)
        album,
  }) {
    return playlist(tracks, collection, initialIndex);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)?
        playlist,
    TResult? Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)?
        album,
  }) {
    return playlist?.call(tracks, collection, initialIndex);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)?
        playlist,
    TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)?
        album,
    required TResult orElse(),
  }) {
    if (playlist != null) {
      return playlist(tracks, collection, initialIndex);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WebSocketLoadEventDataPlaylist value) playlist,
    required TResult Function(WebSocketLoadEventDataAlbum value) album,
  }) {
    return playlist(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WebSocketLoadEventDataPlaylist value)? playlist,
    TResult? Function(WebSocketLoadEventDataAlbum value)? album,
  }) {
    return playlist?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WebSocketLoadEventDataPlaylist value)? playlist,
    TResult Function(WebSocketLoadEventDataAlbum value)? album,
    required TResult orElse(),
  }) {
    if (playlist != null) {
      return playlist(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketLoadEventDataPlaylistImplToJson(
      this,
    );
  }
}

abstract class WebSocketLoadEventDataPlaylist extends WebSocketLoadEventData {
  factory WebSocketLoadEventDataPlaylist(
      {@Assert("tracks is List<SpotubeFullTrackObject>",
          "tracks must be a list of SpotubeFullTrackObject")
      required final List<SpotubeTrackObject> tracks,
      final SpotubeSimplePlaylistObject? collection,
      final int? initialIndex}) = _$WebSocketLoadEventDataPlaylistImpl;
  WebSocketLoadEventDataPlaylist._() : super._();

  factory WebSocketLoadEventDataPlaylist.fromJson(Map<String, dynamic> json) =
      _$WebSocketLoadEventDataPlaylistImpl.fromJson;

  @override
  @Assert("tracks is List<SpotubeFullTrackObject>",
      "tracks must be a list of SpotubeFullTrackObject")
  List<SpotubeTrackObject> get tracks;
  @override
  SpotubeSimplePlaylistObject? get collection;
  @override
  int? get initialIndex;

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketLoadEventDataPlaylistImplCopyWith<
          _$WebSocketLoadEventDataPlaylistImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WebSocketLoadEventDataAlbumImplCopyWith<$Res>
    implements $WebSocketLoadEventDataCopyWith<$Res> {
  factory _$$WebSocketLoadEventDataAlbumImplCopyWith(
          _$WebSocketLoadEventDataAlbumImpl value,
          $Res Function(_$WebSocketLoadEventDataAlbumImpl) then) =
      __$$WebSocketLoadEventDataAlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Assert("tracks is List<SpotubeFullTrackObject>",
          "tracks must be a list of SpotubeFullTrackObject")
      List<SpotubeTrackObject> tracks,
      SpotubeSimpleAlbumObject? collection,
      int? initialIndex});

  $SpotubeSimpleAlbumObjectCopyWith<$Res>? get collection;
}

/// @nodoc
class __$$WebSocketLoadEventDataAlbumImplCopyWithImpl<$Res>
    extends _$WebSocketLoadEventDataCopyWithImpl<$Res,
        _$WebSocketLoadEventDataAlbumImpl>
    implements _$$WebSocketLoadEventDataAlbumImplCopyWith<$Res> {
  __$$WebSocketLoadEventDataAlbumImplCopyWithImpl(
      _$WebSocketLoadEventDataAlbumImpl _value,
      $Res Function(_$WebSocketLoadEventDataAlbumImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tracks = null,
    Object? collection = freezed,
    Object? initialIndex = freezed,
  }) {
    return _then(_$WebSocketLoadEventDataAlbumImpl(
      tracks: null == tracks
          ? _value._tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as List<SpotubeTrackObject>,
      collection: freezed == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as SpotubeSimpleAlbumObject?,
      initialIndex: freezed == initialIndex
          ? _value.initialIndex
          : initialIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubeSimpleAlbumObjectCopyWith<$Res>? get collection {
    if (_value.collection == null) {
      return null;
    }

    return $SpotubeSimpleAlbumObjectCopyWith<$Res>(_value.collection!, (value) {
      return _then(_value.copyWith(collection: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$WebSocketLoadEventDataAlbumImpl extends WebSocketLoadEventDataAlbum {
  _$WebSocketLoadEventDataAlbumImpl(
      {@Assert("tracks is List<SpotubeFullTrackObject>",
          "tracks must be a list of SpotubeFullTrackObject")
      required final List<SpotubeTrackObject> tracks,
      this.collection,
      this.initialIndex,
      final String? $type})
      : _tracks = tracks,
        $type = $type ?? 'album',
        super._();

  factory _$WebSocketLoadEventDataAlbumImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WebSocketLoadEventDataAlbumImplFromJson(json);

  final List<SpotubeTrackObject> _tracks;
  @override
  @Assert("tracks is List<SpotubeFullTrackObject>",
      "tracks must be a list of SpotubeFullTrackObject")
  List<SpotubeTrackObject> get tracks {
    if (_tracks is EqualUnmodifiableListView) return _tracks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tracks);
  }

  @override
  final SpotubeSimpleAlbumObject? collection;
  @override
  final int? initialIndex;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'WebSocketLoadEventData.album(tracks: $tracks, collection: $collection, initialIndex: $initialIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketLoadEventDataAlbumImpl &&
            const DeepCollectionEquality().equals(other._tracks, _tracks) &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            (identical(other.initialIndex, initialIndex) ||
                other.initialIndex == initialIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_tracks), collection, initialIndex);

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketLoadEventDataAlbumImplCopyWith<_$WebSocketLoadEventDataAlbumImpl>
      get copyWith => __$$WebSocketLoadEventDataAlbumImplCopyWithImpl<
          _$WebSocketLoadEventDataAlbumImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)
        playlist,
    required TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)
        album,
  }) {
    return album(tracks, collection, initialIndex);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)?
        playlist,
    TResult? Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)?
        album,
  }) {
    return album?.call(tracks, collection, initialIndex);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimplePlaylistObject? collection,
            int? initialIndex)?
        playlist,
    TResult Function(
            @Assert("tracks is List<SpotubeFullTrackObject>",
                "tracks must be a list of SpotubeFullTrackObject")
            List<SpotubeTrackObject> tracks,
            SpotubeSimpleAlbumObject? collection,
            int? initialIndex)?
        album,
    required TResult orElse(),
  }) {
    if (album != null) {
      return album(tracks, collection, initialIndex);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WebSocketLoadEventDataPlaylist value) playlist,
    required TResult Function(WebSocketLoadEventDataAlbum value) album,
  }) {
    return album(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WebSocketLoadEventDataPlaylist value)? playlist,
    TResult? Function(WebSocketLoadEventDataAlbum value)? album,
  }) {
    return album?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WebSocketLoadEventDataPlaylist value)? playlist,
    TResult Function(WebSocketLoadEventDataAlbum value)? album,
    required TResult orElse(),
  }) {
    if (album != null) {
      return album(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketLoadEventDataAlbumImplToJson(
      this,
    );
  }
}

abstract class WebSocketLoadEventDataAlbum extends WebSocketLoadEventData {
  factory WebSocketLoadEventDataAlbum(
      {@Assert("tracks is List<SpotubeFullTrackObject>",
          "tracks must be a list of SpotubeFullTrackObject")
      required final List<SpotubeTrackObject> tracks,
      final SpotubeSimpleAlbumObject? collection,
      final int? initialIndex}) = _$WebSocketLoadEventDataAlbumImpl;
  WebSocketLoadEventDataAlbum._() : super._();

  factory WebSocketLoadEventDataAlbum.fromJson(Map<String, dynamic> json) =
      _$WebSocketLoadEventDataAlbumImpl.fromJson;

  @override
  @Assert("tracks is List<SpotubeFullTrackObject>",
      "tracks must be a list of SpotubeFullTrackObject")
  List<SpotubeTrackObject> get tracks;
  @override
  SpotubeSimpleAlbumObject? get collection;
  @override
  int? get initialIndex;

  /// Create a copy of WebSocketLoadEventData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketLoadEventDataAlbumImplCopyWith<_$WebSocketLoadEventDataAlbumImpl>
      get copyWith => throw _privateConstructorUsedError;
}
