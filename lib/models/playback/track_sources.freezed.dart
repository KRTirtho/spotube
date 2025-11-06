// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_sources.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrackSourceQuery _$TrackSourceQueryFromJson(Map<String, dynamic> json) {
  return _TrackSourceQuery.fromJson(json);
}

/// @nodoc
mixin _$TrackSourceQuery {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get artists => throw _privateConstructorUsedError;
  String get album => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  String get isrc => throw _privateConstructorUsedError;
  bool get explicit => throw _privateConstructorUsedError;

  /// Serializes this TrackSourceQuery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackSourceQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackSourceQueryCopyWith<TrackSourceQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackSourceQueryCopyWith<$Res> {
  factory $TrackSourceQueryCopyWith(
          TrackSourceQuery value, $Res Function(TrackSourceQuery) then) =
      _$TrackSourceQueryCopyWithImpl<$Res, TrackSourceQuery>;
  @useResult
  $Res call(
      {String id,
      String title,
      List<String> artists,
      String album,
      int durationMs,
      String isrc,
      bool explicit});
}

/// @nodoc
class _$TrackSourceQueryCopyWithImpl<$Res, $Val extends TrackSourceQuery>
    implements $TrackSourceQueryCopyWith<$Res> {
  _$TrackSourceQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackSourceQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artists = null,
    Object? album = null,
    Object? durationMs = null,
    Object? isrc = null,
    Object? explicit = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<String>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      isrc: null == isrc
          ? _value.isrc
          : isrc // ignore: cast_nullable_to_non_nullable
              as String,
      explicit: null == explicit
          ? _value.explicit
          : explicit // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrackSourceQueryImplCopyWith<$Res>
    implements $TrackSourceQueryCopyWith<$Res> {
  factory _$$TrackSourceQueryImplCopyWith(_$TrackSourceQueryImpl value,
          $Res Function(_$TrackSourceQueryImpl) then) =
      __$$TrackSourceQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      List<String> artists,
      String album,
      int durationMs,
      String isrc,
      bool explicit});
}

/// @nodoc
class __$$TrackSourceQueryImplCopyWithImpl<$Res>
    extends _$TrackSourceQueryCopyWithImpl<$Res, _$TrackSourceQueryImpl>
    implements _$$TrackSourceQueryImplCopyWith<$Res> {
  __$$TrackSourceQueryImplCopyWithImpl(_$TrackSourceQueryImpl _value,
      $Res Function(_$TrackSourceQueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrackSourceQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artists = null,
    Object? album = null,
    Object? durationMs = null,
    Object? isrc = null,
    Object? explicit = null,
  }) {
    return _then(_$TrackSourceQueryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<String>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      isrc: null == isrc
          ? _value.isrc
          : isrc // ignore: cast_nullable_to_non_nullable
              as String,
      explicit: null == explicit
          ? _value.explicit
          : explicit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackSourceQueryImpl extends _TrackSourceQuery {
  _$TrackSourceQueryImpl(
      {required this.id,
      required this.title,
      required final List<String> artists,
      required this.album,
      required this.durationMs,
      required this.isrc,
      required this.explicit})
      : _artists = artists,
        super._();

  factory _$TrackSourceQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackSourceQueryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<String> _artists;
  @override
  List<String> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  @override
  final String album;
  @override
  final int durationMs;
  @override
  final String isrc;
  @override
  final bool explicit;

  @override
  String toString() {
    return 'TrackSourceQuery(id: $id, title: $title, artists: $artists, album: $album, durationMs: $durationMs, isrc: $isrc, explicit: $explicit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackSourceQueryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.isrc, isrc) || other.isrc == isrc) &&
            (identical(other.explicit, explicit) ||
                other.explicit == explicit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(_artists),
      album,
      durationMs,
      isrc,
      explicit);

  /// Create a copy of TrackSourceQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackSourceQueryImplCopyWith<_$TrackSourceQueryImpl> get copyWith =>
      __$$TrackSourceQueryImplCopyWithImpl<_$TrackSourceQueryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackSourceQueryImplToJson(
      this,
    );
  }
}

abstract class _TrackSourceQuery extends TrackSourceQuery {
  factory _TrackSourceQuery(
      {required final String id,
      required final String title,
      required final List<String> artists,
      required final String album,
      required final int durationMs,
      required final String isrc,
      required final bool explicit}) = _$TrackSourceQueryImpl;
  _TrackSourceQuery._() : super._();

  factory _TrackSourceQuery.fromJson(Map<String, dynamic> json) =
      _$TrackSourceQueryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<String> get artists;
  @override
  String get album;
  @override
  int get durationMs;
  @override
  String get isrc;
  @override
  bool get explicit;

  /// Create a copy of TrackSourceQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackSourceQueryImplCopyWith<_$TrackSourceQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrackSourceInfo _$TrackSourceInfoFromJson(Map<String, dynamic> json) {
  return _TrackSourceInfo.fromJson(json);
}

/// @nodoc
mixin _$TrackSourceInfo {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get artists => throw _privateConstructorUsedError;
  String get thumbnail => throw _privateConstructorUsedError;
  String get pageUrl => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;

  /// Serializes this TrackSourceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackSourceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackSourceInfoCopyWith<TrackSourceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackSourceInfoCopyWith<$Res> {
  factory $TrackSourceInfoCopyWith(
          TrackSourceInfo value, $Res Function(TrackSourceInfo) then) =
      _$TrackSourceInfoCopyWithImpl<$Res, TrackSourceInfo>;
  @useResult
  $Res call(
      {String id,
      String title,
      String artists,
      String thumbnail,
      String pageUrl,
      int durationMs});
}

/// @nodoc
class _$TrackSourceInfoCopyWithImpl<$Res, $Val extends TrackSourceInfo>
    implements $TrackSourceInfoCopyWith<$Res> {
  _$TrackSourceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackSourceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artists = null,
    Object? thumbnail = null,
    Object? pageUrl = null,
    Object? durationMs = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      pageUrl: null == pageUrl
          ? _value.pageUrl
          : pageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrackSourceInfoImplCopyWith<$Res>
    implements $TrackSourceInfoCopyWith<$Res> {
  factory _$$TrackSourceInfoImplCopyWith(_$TrackSourceInfoImpl value,
          $Res Function(_$TrackSourceInfoImpl) then) =
      __$$TrackSourceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String artists,
      String thumbnail,
      String pageUrl,
      int durationMs});
}

/// @nodoc
class __$$TrackSourceInfoImplCopyWithImpl<$Res>
    extends _$TrackSourceInfoCopyWithImpl<$Res, _$TrackSourceInfoImpl>
    implements _$$TrackSourceInfoImplCopyWith<$Res> {
  __$$TrackSourceInfoImplCopyWithImpl(
      _$TrackSourceInfoImpl _value, $Res Function(_$TrackSourceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrackSourceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artists = null,
    Object? thumbnail = null,
    Object? pageUrl = null,
    Object? durationMs = null,
  }) {
    return _then(_$TrackSourceInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      pageUrl: null == pageUrl
          ? _value.pageUrl
          : pageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackSourceInfoImpl implements _TrackSourceInfo {
  _$TrackSourceInfoImpl(
      {required this.id,
      required this.title,
      required this.artists,
      required this.thumbnail,
      required this.pageUrl,
      required this.durationMs});

  factory _$TrackSourceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackSourceInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String artists;
  @override
  final String thumbnail;
  @override
  final String pageUrl;
  @override
  final int durationMs;

  @override
  String toString() {
    return 'TrackSourceInfo(id: $id, title: $title, artists: $artists, thumbnail: $thumbnail, pageUrl: $pageUrl, durationMs: $durationMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackSourceInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artists, artists) || other.artists == artists) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.pageUrl, pageUrl) || other.pageUrl == pageUrl) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, artists, thumbnail, pageUrl, durationMs);

  /// Create a copy of TrackSourceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackSourceInfoImplCopyWith<_$TrackSourceInfoImpl> get copyWith =>
      __$$TrackSourceInfoImplCopyWithImpl<_$TrackSourceInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackSourceInfoImplToJson(
      this,
    );
  }
}

abstract class _TrackSourceInfo implements TrackSourceInfo {
  factory _TrackSourceInfo(
      {required final String id,
      required final String title,
      required final String artists,
      required final String thumbnail,
      required final String pageUrl,
      required final int durationMs}) = _$TrackSourceInfoImpl;

  factory _TrackSourceInfo.fromJson(Map<String, dynamic> json) =
      _$TrackSourceInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get artists;
  @override
  String get thumbnail;
  @override
  String get pageUrl;
  @override
  int get durationMs;

  /// Create a copy of TrackSourceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackSourceInfoImplCopyWith<_$TrackSourceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrackSource _$TrackSourceFromJson(Map<String, dynamic> json) {
  return _TrackSource.fromJson(json);
}

/// @nodoc
mixin _$TrackSource {
  String get url => throw _privateConstructorUsedError;
  SourceQualities get quality => throw _privateConstructorUsedError;
  SourceCodecs get codec => throw _privateConstructorUsedError;
  String get bitrate => throw _privateConstructorUsedError;

  /// Serializes this TrackSource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackSourceCopyWith<TrackSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackSourceCopyWith<$Res> {
  factory $TrackSourceCopyWith(
          TrackSource value, $Res Function(TrackSource) then) =
      _$TrackSourceCopyWithImpl<$Res, TrackSource>;
  @useResult
  $Res call(
      {String url,
      SourceQualities quality,
      SourceCodecs codec,
      String bitrate});
}

/// @nodoc
class _$TrackSourceCopyWithImpl<$Res, $Val extends TrackSource>
    implements $TrackSourceCopyWith<$Res> {
  _$TrackSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? quality = null,
    Object? codec = null,
    Object? bitrate = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as SourceQualities,
      codec: null == codec
          ? _value.codec
          : codec // ignore: cast_nullable_to_non_nullable
              as SourceCodecs,
      bitrate: null == bitrate
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrackSourceImplCopyWith<$Res>
    implements $TrackSourceCopyWith<$Res> {
  factory _$$TrackSourceImplCopyWith(
          _$TrackSourceImpl value, $Res Function(_$TrackSourceImpl) then) =
      __$$TrackSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      SourceQualities quality,
      SourceCodecs codec,
      String bitrate});
}

/// @nodoc
class __$$TrackSourceImplCopyWithImpl<$Res>
    extends _$TrackSourceCopyWithImpl<$Res, _$TrackSourceImpl>
    implements _$$TrackSourceImplCopyWith<$Res> {
  __$$TrackSourceImplCopyWithImpl(
      _$TrackSourceImpl _value, $Res Function(_$TrackSourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrackSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? quality = null,
    Object? codec = null,
    Object? bitrate = null,
  }) {
    return _then(_$TrackSourceImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as SourceQualities,
      codec: null == codec
          ? _value.codec
          : codec // ignore: cast_nullable_to_non_nullable
              as SourceCodecs,
      bitrate: null == bitrate
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackSourceImpl implements _TrackSource {
  _$TrackSourceImpl(
      {required this.url,
      required this.quality,
      required this.codec,
      required this.bitrate});

  factory _$TrackSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackSourceImplFromJson(json);

  @override
  final String url;
  @override
  final SourceQualities quality;
  @override
  final SourceCodecs codec;
  @override
  final String bitrate;

  @override
  String toString() {
    return 'TrackSource(url: $url, quality: $quality, codec: $codec, bitrate: $bitrate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackSourceImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.codec, codec) || other.codec == codec) &&
            (identical(other.bitrate, bitrate) || other.bitrate == bitrate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, quality, codec, bitrate);

  /// Create a copy of TrackSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackSourceImplCopyWith<_$TrackSourceImpl> get copyWith =>
      __$$TrackSourceImplCopyWithImpl<_$TrackSourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackSourceImplToJson(
      this,
    );
  }
}

abstract class _TrackSource implements TrackSource {
  factory _TrackSource(
      {required final String url,
      required final SourceQualities quality,
      required final SourceCodecs codec,
      required final String bitrate}) = _$TrackSourceImpl;

  factory _TrackSource.fromJson(Map<String, dynamic> json) =
      _$TrackSourceImpl.fromJson;

  @override
  String get url;
  @override
  SourceQualities get quality;
  @override
  SourceCodecs get codec;
  @override
  String get bitrate;

  /// Create a copy of TrackSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackSourceImplCopyWith<_$TrackSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
