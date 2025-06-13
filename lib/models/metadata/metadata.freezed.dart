// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpotubeAlbumObject _$SpotubeAlbumObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeAlbumObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeAlbumObject {
  String get uid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  SpotubeArtistObject get artist => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  String get releaseDate => throw _privateConstructorUsedError;
  String get externalUrl => throw _privateConstructorUsedError;
  SpotubeAlbumType get type => throw _privateConstructorUsedError;

  /// Serializes this SpotubeAlbumObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeAlbumObjectCopyWith<SpotubeAlbumObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeAlbumObjectCopyWith<$Res> {
  factory $SpotubeAlbumObjectCopyWith(
          SpotubeAlbumObject value, $Res Function(SpotubeAlbumObject) then) =
      _$SpotubeAlbumObjectCopyWithImpl<$Res, SpotubeAlbumObject>;
  @useResult
  $Res call(
      {String uid,
      String title,
      SpotubeArtistObject artist,
      List<SpotubeImageObject> images,
      String releaseDate,
      String externalUrl,
      SpotubeAlbumType type});

  $SpotubeArtistObjectCopyWith<$Res> get artist;
}

/// @nodoc
class _$SpotubeAlbumObjectCopyWithImpl<$Res, $Val extends SpotubeAlbumObject>
    implements $SpotubeAlbumObjectCopyWith<$Res> {
  _$SpotubeAlbumObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? title = null,
    Object? artist = null,
    Object? images = null,
    Object? releaseDate = null,
    Object? externalUrl = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as SpotubeArtistObject,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumType,
    ) as $Val);
  }

  /// Create a copy of SpotubeAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubeArtistObjectCopyWith<$Res> get artist {
    return $SpotubeArtistObjectCopyWith<$Res>(_value.artist, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpotubeAlbumObjectImplCopyWith<$Res>
    implements $SpotubeAlbumObjectCopyWith<$Res> {
  factory _$$SpotubeAlbumObjectImplCopyWith(_$SpotubeAlbumObjectImpl value,
          $Res Function(_$SpotubeAlbumObjectImpl) then) =
      __$$SpotubeAlbumObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String title,
      SpotubeArtistObject artist,
      List<SpotubeImageObject> images,
      String releaseDate,
      String externalUrl,
      SpotubeAlbumType type});

  @override
  $SpotubeArtistObjectCopyWith<$Res> get artist;
}

/// @nodoc
class __$$SpotubeAlbumObjectImplCopyWithImpl<$Res>
    extends _$SpotubeAlbumObjectCopyWithImpl<$Res, _$SpotubeAlbumObjectImpl>
    implements _$$SpotubeAlbumObjectImplCopyWith<$Res> {
  __$$SpotubeAlbumObjectImplCopyWithImpl(_$SpotubeAlbumObjectImpl _value,
      $Res Function(_$SpotubeAlbumObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? title = null,
    Object? artist = null,
    Object? images = null,
    Object? releaseDate = null,
    Object? externalUrl = null,
    Object? type = null,
  }) {
    return _then(_$SpotubeAlbumObjectImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as SpotubeArtistObject,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeAlbumObjectImpl implements _SpotubeAlbumObject {
  _$SpotubeAlbumObjectImpl(
      {required this.uid,
      required this.title,
      required this.artist,
      final List<SpotubeImageObject> images = const [],
      required this.releaseDate,
      required this.externalUrl,
      required this.type})
      : _images = images;

  factory _$SpotubeAlbumObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeAlbumObjectImplFromJson(json);

  @override
  final String uid;
  @override
  final String title;
  @override
  final SpotubeArtistObject artist;
  final List<SpotubeImageObject> _images;
  @override
  @JsonKey()
  List<SpotubeImageObject> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String releaseDate;
  @override
  final String externalUrl;
  @override
  final SpotubeAlbumType type;

  @override
  String toString() {
    return 'SpotubeAlbumObject(uid: $uid, title: $title, artist: $artist, images: $images, releaseDate: $releaseDate, externalUrl: $externalUrl, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeAlbumObjectImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      title,
      artist,
      const DeepCollectionEquality().hash(_images),
      releaseDate,
      externalUrl,
      type);

  /// Create a copy of SpotubeAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeAlbumObjectImplCopyWith<_$SpotubeAlbumObjectImpl> get copyWith =>
      __$$SpotubeAlbumObjectImplCopyWithImpl<_$SpotubeAlbumObjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeAlbumObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeAlbumObject implements SpotubeAlbumObject {
  factory _SpotubeAlbumObject(
      {required final String uid,
      required final String title,
      required final SpotubeArtistObject artist,
      final List<SpotubeImageObject> images,
      required final String releaseDate,
      required final String externalUrl,
      required final SpotubeAlbumType type}) = _$SpotubeAlbumObjectImpl;

  factory _SpotubeAlbumObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeAlbumObjectImpl.fromJson;

  @override
  String get uid;
  @override
  String get title;
  @override
  SpotubeArtistObject get artist;
  @override
  List<SpotubeImageObject> get images;
  @override
  String get releaseDate;
  @override
  String get externalUrl;
  @override
  SpotubeAlbumType get type;

  /// Create a copy of SpotubeAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeAlbumObjectImplCopyWith<_$SpotubeAlbumObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotubeArtistObject _$SpotubeArtistObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeArtistObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeArtistObject {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  String get externalUrl => throw _privateConstructorUsedError;

  /// Serializes this SpotubeArtistObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeArtistObjectCopyWith<SpotubeArtistObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeArtistObjectCopyWith<$Res> {
  factory $SpotubeArtistObjectCopyWith(
          SpotubeArtistObject value, $Res Function(SpotubeArtistObject) then) =
      _$SpotubeArtistObjectCopyWithImpl<$Res, SpotubeArtistObject>;
  @useResult
  $Res call(
      {String uid,
      String name,
      List<SpotubeImageObject> images,
      String externalUrl});
}

/// @nodoc
class _$SpotubeArtistObjectCopyWithImpl<$Res, $Val extends SpotubeArtistObject>
    implements $SpotubeArtistObjectCopyWith<$Res> {
  _$SpotubeArtistObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? images = null,
    Object? externalUrl = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeArtistObjectImplCopyWith<$Res>
    implements $SpotubeArtistObjectCopyWith<$Res> {
  factory _$$SpotubeArtistObjectImplCopyWith(_$SpotubeArtistObjectImpl value,
          $Res Function(_$SpotubeArtistObjectImpl) then) =
      __$$SpotubeArtistObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      List<SpotubeImageObject> images,
      String externalUrl});
}

/// @nodoc
class __$$SpotubeArtistObjectImplCopyWithImpl<$Res>
    extends _$SpotubeArtistObjectCopyWithImpl<$Res, _$SpotubeArtistObjectImpl>
    implements _$$SpotubeArtistObjectImplCopyWith<$Res> {
  __$$SpotubeArtistObjectImplCopyWithImpl(_$SpotubeArtistObjectImpl _value,
      $Res Function(_$SpotubeArtistObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? images = null,
    Object? externalUrl = null,
  }) {
    return _then(_$SpotubeArtistObjectImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeArtistObjectImpl implements _SpotubeArtistObject {
  _$SpotubeArtistObjectImpl(
      {required this.uid,
      required this.name,
      final List<SpotubeImageObject> images = const [],
      required this.externalUrl})
      : _images = images;

  factory _$SpotubeArtistObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeArtistObjectImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  final List<SpotubeImageObject> _images;
  @override
  @JsonKey()
  List<SpotubeImageObject> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String externalUrl;

  @override
  String toString() {
    return 'SpotubeArtistObject(uid: $uid, name: $name, images: $images, externalUrl: $externalUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeArtistObjectImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, name,
      const DeepCollectionEquality().hash(_images), externalUrl);

  /// Create a copy of SpotubeArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeArtistObjectImplCopyWith<_$SpotubeArtistObjectImpl> get copyWith =>
      __$$SpotubeArtistObjectImplCopyWithImpl<_$SpotubeArtistObjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeArtistObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeArtistObject implements SpotubeArtistObject {
  factory _SpotubeArtistObject(
      {required final String uid,
      required final String name,
      final List<SpotubeImageObject> images,
      required final String externalUrl}) = _$SpotubeArtistObjectImpl;

  factory _SpotubeArtistObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeArtistObjectImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  List<SpotubeImageObject> get images;
  @override
  String get externalUrl;

  /// Create a copy of SpotubeArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeArtistObjectImplCopyWith<_$SpotubeArtistObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotubeFeedObject _$SpotubeFeedObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeFeedObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeFeedObject {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get externalUrl => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;

  /// Serializes this SpotubeFeedObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeFeedObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeFeedObjectCopyWith<SpotubeFeedObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeFeedObjectCopyWith<$Res> {
  factory $SpotubeFeedObjectCopyWith(
          SpotubeFeedObject value, $Res Function(SpotubeFeedObject) then) =
      _$SpotubeFeedObjectCopyWithImpl<$Res, SpotubeFeedObject>;
  @useResult
  $Res call(
      {String uid,
      String name,
      String externalUrl,
      List<SpotubeImageObject> images});
}

/// @nodoc
class _$SpotubeFeedObjectCopyWithImpl<$Res, $Val extends SpotubeFeedObject>
    implements $SpotubeFeedObjectCopyWith<$Res> {
  _$SpotubeFeedObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeFeedObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? externalUrl = null,
    Object? images = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeFeedObjectImplCopyWith<$Res>
    implements $SpotubeFeedObjectCopyWith<$Res> {
  factory _$$SpotubeFeedObjectImplCopyWith(_$SpotubeFeedObjectImpl value,
          $Res Function(_$SpotubeFeedObjectImpl) then) =
      __$$SpotubeFeedObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String externalUrl,
      List<SpotubeImageObject> images});
}

/// @nodoc
class __$$SpotubeFeedObjectImplCopyWithImpl<$Res>
    extends _$SpotubeFeedObjectCopyWithImpl<$Res, _$SpotubeFeedObjectImpl>
    implements _$$SpotubeFeedObjectImplCopyWith<$Res> {
  __$$SpotubeFeedObjectImplCopyWithImpl(_$SpotubeFeedObjectImpl _value,
      $Res Function(_$SpotubeFeedObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeFeedObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? externalUrl = null,
    Object? images = null,
  }) {
    return _then(_$SpotubeFeedObjectImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeFeedObjectImpl implements _SpotubeFeedObject {
  _$SpotubeFeedObjectImpl(
      {required this.uid,
      required this.name,
      required this.externalUrl,
      final List<SpotubeImageObject> images = const []})
      : _images = images;

  factory _$SpotubeFeedObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeFeedObjectImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String externalUrl;
  final List<SpotubeImageObject> _images;
  @override
  @JsonKey()
  List<SpotubeImageObject> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'SpotubeFeedObject(uid: $uid, name: $name, externalUrl: $externalUrl, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeFeedObjectImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, name, externalUrl,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of SpotubeFeedObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeFeedObjectImplCopyWith<_$SpotubeFeedObjectImpl> get copyWith =>
      __$$SpotubeFeedObjectImplCopyWithImpl<_$SpotubeFeedObjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeFeedObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeFeedObject implements SpotubeFeedObject {
  factory _SpotubeFeedObject(
      {required final String uid,
      required final String name,
      required final String externalUrl,
      final List<SpotubeImageObject> images}) = _$SpotubeFeedObjectImpl;

  factory _SpotubeFeedObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeFeedObjectImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String get externalUrl;
  @override
  List<SpotubeImageObject> get images;

  /// Create a copy of SpotubeFeedObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeFeedObjectImplCopyWith<_$SpotubeFeedObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotubeImageObject _$SpotubeImageObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeImageObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeImageObject {
  String get url => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;

  /// Serializes this SpotubeImageObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeImageObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeImageObjectCopyWith<SpotubeImageObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeImageObjectCopyWith<$Res> {
  factory $SpotubeImageObjectCopyWith(
          SpotubeImageObject value, $Res Function(SpotubeImageObject) then) =
      _$SpotubeImageObjectCopyWithImpl<$Res, SpotubeImageObject>;
  @useResult
  $Res call({String url, int width, int height});
}

/// @nodoc
class _$SpotubeImageObjectCopyWithImpl<$Res, $Val extends SpotubeImageObject>
    implements $SpotubeImageObjectCopyWith<$Res> {
  _$SpotubeImageObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeImageObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeImageObjectImplCopyWith<$Res>
    implements $SpotubeImageObjectCopyWith<$Res> {
  factory _$$SpotubeImageObjectImplCopyWith(_$SpotubeImageObjectImpl value,
          $Res Function(_$SpotubeImageObjectImpl) then) =
      __$$SpotubeImageObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, int width, int height});
}

/// @nodoc
class __$$SpotubeImageObjectImplCopyWithImpl<$Res>
    extends _$SpotubeImageObjectCopyWithImpl<$Res, _$SpotubeImageObjectImpl>
    implements _$$SpotubeImageObjectImplCopyWith<$Res> {
  __$$SpotubeImageObjectImplCopyWithImpl(_$SpotubeImageObjectImpl _value,
      $Res Function(_$SpotubeImageObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeImageObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$SpotubeImageObjectImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeImageObjectImpl implements _SpotubeImageObject {
  _$SpotubeImageObjectImpl(
      {required this.url, required this.width, required this.height});

  factory _$SpotubeImageObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeImageObjectImplFromJson(json);

  @override
  final String url;
  @override
  final int width;
  @override
  final int height;

  @override
  String toString() {
    return 'SpotubeImageObject(url: $url, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeImageObjectImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, width, height);

  /// Create a copy of SpotubeImageObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeImageObjectImplCopyWith<_$SpotubeImageObjectImpl> get copyWith =>
      __$$SpotubeImageObjectImplCopyWithImpl<_$SpotubeImageObjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeImageObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeImageObject implements SpotubeImageObject {
  factory _SpotubeImageObject(
      {required final String url,
      required final int width,
      required final int height}) = _$SpotubeImageObjectImpl;

  factory _SpotubeImageObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeImageObjectImpl.fromJson;

  @override
  String get url;
  @override
  int get width;
  @override
  int get height;

  /// Create a copy of SpotubeImageObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeImageObjectImplCopyWith<_$SpotubeImageObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotubePaginationResponseObject<T> _$SpotubePaginationResponseObjectFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _SpotubePaginationResponseObject<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$SpotubePaginationResponseObject<T> {
  int get total => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;
  String get limit => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  List<T> get items => throw _privateConstructorUsedError;

  /// Serializes this SpotubePaginationResponseObject to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of SpotubePaginationResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubePaginationResponseObjectCopyWith<T,
          SpotubePaginationResponseObject<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubePaginationResponseObjectCopyWith<T, $Res> {
  factory $SpotubePaginationResponseObjectCopyWith(
          SpotubePaginationResponseObject<T> value,
          $Res Function(SpotubePaginationResponseObject<T>) then) =
      _$SpotubePaginationResponseObjectCopyWithImpl<T, $Res,
          SpotubePaginationResponseObject<T>>;
  @useResult
  $Res call(
      {int total,
      String? nextCursor,
      String limit,
      bool hasMore,
      List<T> items});
}

/// @nodoc
class _$SpotubePaginationResponseObjectCopyWithImpl<T, $Res,
        $Val extends SpotubePaginationResponseObject<T>>
    implements $SpotubePaginationResponseObjectCopyWith<T, $Res> {
  _$SpotubePaginationResponseObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubePaginationResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? nextCursor = freezed,
    Object? limit = null,
    Object? hasMore = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as String,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubePaginationResponseObjectImplCopyWith<T, $Res>
    implements $SpotubePaginationResponseObjectCopyWith<T, $Res> {
  factory _$$SpotubePaginationResponseObjectImplCopyWith(
          _$SpotubePaginationResponseObjectImpl<T> value,
          $Res Function(_$SpotubePaginationResponseObjectImpl<T>) then) =
      __$$SpotubePaginationResponseObjectImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {int total,
      String? nextCursor,
      String limit,
      bool hasMore,
      List<T> items});
}

/// @nodoc
class __$$SpotubePaginationResponseObjectImplCopyWithImpl<T, $Res>
    extends _$SpotubePaginationResponseObjectCopyWithImpl<T, $Res,
        _$SpotubePaginationResponseObjectImpl<T>>
    implements _$$SpotubePaginationResponseObjectImplCopyWith<T, $Res> {
  __$$SpotubePaginationResponseObjectImplCopyWithImpl(
      _$SpotubePaginationResponseObjectImpl<T> _value,
      $Res Function(_$SpotubePaginationResponseObjectImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of SpotubePaginationResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? nextCursor = freezed,
    Object? limit = null,
    Object? hasMore = null,
    Object? items = null,
  }) {
    return _then(_$SpotubePaginationResponseObjectImpl<T>(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as String,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$SpotubePaginationResponseObjectImpl<T>
    implements _SpotubePaginationResponseObject<T> {
  _$SpotubePaginationResponseObjectImpl(
      {required this.total,
      required this.nextCursor,
      required this.limit,
      required this.hasMore,
      required final List<T> items})
      : _items = items;

  factory _$SpotubePaginationResponseObjectImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$SpotubePaginationResponseObjectImplFromJson(json, fromJsonT);

  @override
  final int total;
  @override
  final String? nextCursor;
  @override
  final String limit;
  @override
  final bool hasMore;
  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'SpotubePaginationResponseObject<$T>(total: $total, nextCursor: $nextCursor, limit: $limit, hasMore: $hasMore, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubePaginationResponseObjectImpl<T> &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, nextCursor, limit,
      hasMore, const DeepCollectionEquality().hash(_items));

  /// Create a copy of SpotubePaginationResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubePaginationResponseObjectImplCopyWith<T,
          _$SpotubePaginationResponseObjectImpl<T>>
      get copyWith => __$$SpotubePaginationResponseObjectImplCopyWithImpl<T,
          _$SpotubePaginationResponseObjectImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$SpotubePaginationResponseObjectImplToJson<T>(this, toJsonT);
  }
}

abstract class _SpotubePaginationResponseObject<T>
    implements SpotubePaginationResponseObject<T> {
  factory _SpotubePaginationResponseObject(
      {required final int total,
      required final String? nextCursor,
      required final String limit,
      required final bool hasMore,
      required final List<T> items}) = _$SpotubePaginationResponseObjectImpl<T>;

  factory _SpotubePaginationResponseObject.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$SpotubePaginationResponseObjectImpl<T>.fromJson;

  @override
  int get total;
  @override
  String? get nextCursor;
  @override
  String get limit;
  @override
  bool get hasMore;
  @override
  List<T> get items;

  /// Create a copy of SpotubePaginationResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubePaginationResponseObjectImplCopyWith<T,
          _$SpotubePaginationResponseObjectImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubePlaylistObject _$SpotubePlaylistObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubePlaylistObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubePlaylistObject {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get externalUrl => throw _privateConstructorUsedError;
  SpotubeUserObject get owner => throw _privateConstructorUsedError;
  List<SpotubeUserObject> get collaborators =>
      throw _privateConstructorUsedError;

  /// Serializes this SpotubePlaylistObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubePlaylistObjectCopyWith<SpotubePlaylistObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubePlaylistObjectCopyWith<$Res> {
  factory $SpotubePlaylistObjectCopyWith(SpotubePlaylistObject value,
          $Res Function(SpotubePlaylistObject) then) =
      _$SpotubePlaylistObjectCopyWithImpl<$Res, SpotubePlaylistObject>;
  @useResult
  $Res call(
      {String uid,
      String name,
      List<SpotubeImageObject> images,
      String description,
      String externalUrl,
      SpotubeUserObject owner,
      List<SpotubeUserObject> collaborators});

  $SpotubeUserObjectCopyWith<$Res> get owner;
}

/// @nodoc
class _$SpotubePlaylistObjectCopyWithImpl<$Res,
        $Val extends SpotubePlaylistObject>
    implements $SpotubePlaylistObjectCopyWith<$Res> {
  _$SpotubePlaylistObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? images = null,
    Object? description = null,
    Object? externalUrl = null,
    Object? owner = null,
    Object? collaborators = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpotubeUserObject,
      collaborators: null == collaborators
          ? _value.collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<SpotubeUserObject>,
    ) as $Val);
  }

  /// Create a copy of SpotubePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubeUserObjectCopyWith<$Res> get owner {
    return $SpotubeUserObjectCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpotubePlaylistObjectImplCopyWith<$Res>
    implements $SpotubePlaylistObjectCopyWith<$Res> {
  factory _$$SpotubePlaylistObjectImplCopyWith(
          _$SpotubePlaylistObjectImpl value,
          $Res Function(_$SpotubePlaylistObjectImpl) then) =
      __$$SpotubePlaylistObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      List<SpotubeImageObject> images,
      String description,
      String externalUrl,
      SpotubeUserObject owner,
      List<SpotubeUserObject> collaborators});

  @override
  $SpotubeUserObjectCopyWith<$Res> get owner;
}

/// @nodoc
class __$$SpotubePlaylistObjectImplCopyWithImpl<$Res>
    extends _$SpotubePlaylistObjectCopyWithImpl<$Res,
        _$SpotubePlaylistObjectImpl>
    implements _$$SpotubePlaylistObjectImplCopyWith<$Res> {
  __$$SpotubePlaylistObjectImplCopyWithImpl(_$SpotubePlaylistObjectImpl _value,
      $Res Function(_$SpotubePlaylistObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? images = null,
    Object? description = null,
    Object? externalUrl = null,
    Object? owner = null,
    Object? collaborators = null,
  }) {
    return _then(_$SpotubePlaylistObjectImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpotubeUserObject,
      collaborators: null == collaborators
          ? _value._collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<SpotubeUserObject>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubePlaylistObjectImpl implements _SpotubePlaylistObject {
  _$SpotubePlaylistObjectImpl(
      {required this.uid,
      required this.name,
      final List<SpotubeImageObject> images = const [],
      required this.description,
      required this.externalUrl,
      required this.owner,
      final List<SpotubeUserObject> collaborators = const []})
      : _images = images,
        _collaborators = collaborators;

  factory _$SpotubePlaylistObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubePlaylistObjectImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  final List<SpotubeImageObject> _images;
  @override
  @JsonKey()
  List<SpotubeImageObject> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String description;
  @override
  final String externalUrl;
  @override
  final SpotubeUserObject owner;
  final List<SpotubeUserObject> _collaborators;
  @override
  @JsonKey()
  List<SpotubeUserObject> get collaborators {
    if (_collaborators is EqualUnmodifiableListView) return _collaborators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collaborators);
  }

  @override
  String toString() {
    return 'SpotubePlaylistObject(uid: $uid, name: $name, images: $images, description: $description, externalUrl: $externalUrl, owner: $owner, collaborators: $collaborators)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubePlaylistObjectImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality()
                .equals(other._collaborators, _collaborators));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      name,
      const DeepCollectionEquality().hash(_images),
      description,
      externalUrl,
      owner,
      const DeepCollectionEquality().hash(_collaborators));

  /// Create a copy of SpotubePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubePlaylistObjectImplCopyWith<_$SpotubePlaylistObjectImpl>
      get copyWith => __$$SpotubePlaylistObjectImplCopyWithImpl<
          _$SpotubePlaylistObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubePlaylistObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubePlaylistObject implements SpotubePlaylistObject {
  factory _SpotubePlaylistObject(
          {required final String uid,
          required final String name,
          final List<SpotubeImageObject> images,
          required final String description,
          required final String externalUrl,
          required final SpotubeUserObject owner,
          final List<SpotubeUserObject> collaborators}) =
      _$SpotubePlaylistObjectImpl;

  factory _SpotubePlaylistObject.fromJson(Map<String, dynamic> json) =
      _$SpotubePlaylistObjectImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  List<SpotubeImageObject> get images;
  @override
  String get description;
  @override
  String get externalUrl;
  @override
  SpotubeUserObject get owner;
  @override
  List<SpotubeUserObject> get collaborators;

  /// Create a copy of SpotubePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubePlaylistObjectImplCopyWith<_$SpotubePlaylistObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeSearchResponseObject _$SpotubeSearchResponseObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeSearchResponseObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeSearchResponseObject {
  @JsonKey(fromJson: _paginationTracksFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubeTrackObject>? get tracks =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: _paginationAlbumsFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubeAlbumObject>? get albums =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: _paginationArtistsFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubeArtistObject>? get artists =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: _paginationPlaylistsFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubePlaylistObject>? get playlists =>
      throw _privateConstructorUsedError;

  /// Serializes this SpotubeSearchResponseObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeSearchResponseObjectCopyWith<SpotubeSearchResponseObject>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeSearchResponseObjectCopyWith<$Res> {
  factory $SpotubeSearchResponseObjectCopyWith(
          SpotubeSearchResponseObject value,
          $Res Function(SpotubeSearchResponseObject) then) =
      _$SpotubeSearchResponseObjectCopyWithImpl<$Res,
          SpotubeSearchResponseObject>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _paginationTracksFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubeTrackObject>? tracks,
      @JsonKey(fromJson: _paginationAlbumsFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubeAlbumObject>? albums,
      @JsonKey(fromJson: _paginationArtistsFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubeArtistObject>? artists,
      @JsonKey(
          fromJson: _paginationPlaylistsFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubePlaylistObject>? playlists});

  $SpotubePaginationResponseObjectCopyWith<SpotubeTrackObject, $Res>?
      get tracks;
  $SpotubePaginationResponseObjectCopyWith<SpotubeAlbumObject, $Res>?
      get albums;
  $SpotubePaginationResponseObjectCopyWith<SpotubeArtistObject, $Res>?
      get artists;
  $SpotubePaginationResponseObjectCopyWith<SpotubePlaylistObject, $Res>?
      get playlists;
}

/// @nodoc
class _$SpotubeSearchResponseObjectCopyWithImpl<$Res,
        $Val extends SpotubeSearchResponseObject>
    implements $SpotubeSearchResponseObjectCopyWith<$Res> {
  _$SpotubeSearchResponseObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tracks = freezed,
    Object? albums = freezed,
    Object? artists = freezed,
    Object? playlists = freezed,
  }) {
    return _then(_value.copyWith(
      tracks: freezed == tracks
          ? _value.tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubeTrackObject>?,
      albums: freezed == albums
          ? _value.albums
          : albums // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubeAlbumObject>?,
      artists: freezed == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubeArtistObject>?,
      playlists: freezed == playlists
          ? _value.playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubePlaylistObject>?,
    ) as $Val);
  }

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubePaginationResponseObjectCopyWith<SpotubeTrackObject, $Res>?
      get tracks {
    if (_value.tracks == null) {
      return null;
    }

    return $SpotubePaginationResponseObjectCopyWith<SpotubeTrackObject, $Res>(
        _value.tracks!, (value) {
      return _then(_value.copyWith(tracks: value) as $Val);
    });
  }

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubePaginationResponseObjectCopyWith<SpotubeAlbumObject, $Res>?
      get albums {
    if (_value.albums == null) {
      return null;
    }

    return $SpotubePaginationResponseObjectCopyWith<SpotubeAlbumObject, $Res>(
        _value.albums!, (value) {
      return _then(_value.copyWith(albums: value) as $Val);
    });
  }

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubePaginationResponseObjectCopyWith<SpotubeArtistObject, $Res>?
      get artists {
    if (_value.artists == null) {
      return null;
    }

    return $SpotubePaginationResponseObjectCopyWith<SpotubeArtistObject, $Res>(
        _value.artists!, (value) {
      return _then(_value.copyWith(artists: value) as $Val);
    });
  }

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubePaginationResponseObjectCopyWith<SpotubePlaylistObject, $Res>?
      get playlists {
    if (_value.playlists == null) {
      return null;
    }

    return $SpotubePaginationResponseObjectCopyWith<SpotubePlaylistObject,
        $Res>(_value.playlists!, (value) {
      return _then(_value.copyWith(playlists: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpotubeSearchResponseObjectImplCopyWith<$Res>
    implements $SpotubeSearchResponseObjectCopyWith<$Res> {
  factory _$$SpotubeSearchResponseObjectImplCopyWith(
          _$SpotubeSearchResponseObjectImpl value,
          $Res Function(_$SpotubeSearchResponseObjectImpl) then) =
      __$$SpotubeSearchResponseObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _paginationTracksFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubeTrackObject>? tracks,
      @JsonKey(fromJson: _paginationAlbumsFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubeAlbumObject>? albums,
      @JsonKey(fromJson: _paginationArtistsFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubeArtistObject>? artists,
      @JsonKey(
          fromJson: _paginationPlaylistsFromJson, toJson: _paginationToJson)
      SpotubePaginationResponseObject<SpotubePlaylistObject>? playlists});

  @override
  $SpotubePaginationResponseObjectCopyWith<SpotubeTrackObject, $Res>?
      get tracks;
  @override
  $SpotubePaginationResponseObjectCopyWith<SpotubeAlbumObject, $Res>?
      get albums;
  @override
  $SpotubePaginationResponseObjectCopyWith<SpotubeArtistObject, $Res>?
      get artists;
  @override
  $SpotubePaginationResponseObjectCopyWith<SpotubePlaylistObject, $Res>?
      get playlists;
}

/// @nodoc
class __$$SpotubeSearchResponseObjectImplCopyWithImpl<$Res>
    extends _$SpotubeSearchResponseObjectCopyWithImpl<$Res,
        _$SpotubeSearchResponseObjectImpl>
    implements _$$SpotubeSearchResponseObjectImplCopyWith<$Res> {
  __$$SpotubeSearchResponseObjectImplCopyWithImpl(
      _$SpotubeSearchResponseObjectImpl _value,
      $Res Function(_$SpotubeSearchResponseObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tracks = freezed,
    Object? albums = freezed,
    Object? artists = freezed,
    Object? playlists = freezed,
  }) {
    return _then(_$SpotubeSearchResponseObjectImpl(
      tracks: freezed == tracks
          ? _value.tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubeTrackObject>?,
      albums: freezed == albums
          ? _value.albums
          : albums // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubeAlbumObject>?,
      artists: freezed == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubeArtistObject>?,
      playlists: freezed == playlists
          ? _value.playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as SpotubePaginationResponseObject<SpotubePlaylistObject>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeSearchResponseObjectImpl
    implements _SpotubeSearchResponseObject {
  _$SpotubeSearchResponseObjectImpl(
      {@JsonKey(fromJson: _paginationTracksFromJson, toJson: _paginationToJson)
      this.tracks,
      @JsonKey(fromJson: _paginationAlbumsFromJson, toJson: _paginationToJson)
      this.albums,
      @JsonKey(fromJson: _paginationArtistsFromJson, toJson: _paginationToJson)
      this.artists,
      @JsonKey(
          fromJson: _paginationPlaylistsFromJson, toJson: _paginationToJson)
      this.playlists});

  factory _$SpotubeSearchResponseObjectImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeSearchResponseObjectImplFromJson(json);

  @override
  @JsonKey(fromJson: _paginationTracksFromJson, toJson: _paginationToJson)
  final SpotubePaginationResponseObject<SpotubeTrackObject>? tracks;
  @override
  @JsonKey(fromJson: _paginationAlbumsFromJson, toJson: _paginationToJson)
  final SpotubePaginationResponseObject<SpotubeAlbumObject>? albums;
  @override
  @JsonKey(fromJson: _paginationArtistsFromJson, toJson: _paginationToJson)
  final SpotubePaginationResponseObject<SpotubeArtistObject>? artists;
  @override
  @JsonKey(fromJson: _paginationPlaylistsFromJson, toJson: _paginationToJson)
  final SpotubePaginationResponseObject<SpotubePlaylistObject>? playlists;

  @override
  String toString() {
    return 'SpotubeSearchResponseObject(tracks: $tracks, albums: $albums, artists: $artists, playlists: $playlists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeSearchResponseObjectImpl &&
            (identical(other.tracks, tracks) || other.tracks == tracks) &&
            (identical(other.albums, albums) || other.albums == albums) &&
            (identical(other.artists, artists) || other.artists == artists) &&
            (identical(other.playlists, playlists) ||
                other.playlists == playlists));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tracks, albums, artists, playlists);

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeSearchResponseObjectImplCopyWith<_$SpotubeSearchResponseObjectImpl>
      get copyWith => __$$SpotubeSearchResponseObjectImplCopyWithImpl<
          _$SpotubeSearchResponseObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeSearchResponseObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeSearchResponseObject
    implements SpotubeSearchResponseObject {
  factory _SpotubeSearchResponseObject(
      {@JsonKey(fromJson: _paginationTracksFromJson, toJson: _paginationToJson)
      final SpotubePaginationResponseObject<SpotubeTrackObject>? tracks,
      @JsonKey(fromJson: _paginationAlbumsFromJson, toJson: _paginationToJson)
      final SpotubePaginationResponseObject<SpotubeAlbumObject>? albums,
      @JsonKey(fromJson: _paginationArtistsFromJson, toJson: _paginationToJson)
      final SpotubePaginationResponseObject<SpotubeArtistObject>? artists,
      @JsonKey(
          fromJson: _paginationPlaylistsFromJson, toJson: _paginationToJson)
      final SpotubePaginationResponseObject<SpotubePlaylistObject>?
          playlists}) = _$SpotubeSearchResponseObjectImpl;

  factory _SpotubeSearchResponseObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeSearchResponseObjectImpl.fromJson;

  @override
  @JsonKey(fromJson: _paginationTracksFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubeTrackObject>? get tracks;
  @override
  @JsonKey(fromJson: _paginationAlbumsFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubeAlbumObject>? get albums;
  @override
  @JsonKey(fromJson: _paginationArtistsFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubeArtistObject>? get artists;
  @override
  @JsonKey(fromJson: _paginationPlaylistsFromJson, toJson: _paginationToJson)
  SpotubePaginationResponseObject<SpotubePlaylistObject>? get playlists;

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeSearchResponseObjectImplCopyWith<_$SpotubeSearchResponseObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeTrackObject _$SpotubeTrackObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeTrackObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeTrackObject {
  String get uid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<SpotubeArtistObject> get artists => throw _privateConstructorUsedError;
  SpotubeAlbumObject get album => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  String get isrc => throw _privateConstructorUsedError;
  String get externalUrl => throw _privateConstructorUsedError;

  /// Serializes this SpotubeTrackObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeTrackObjectCopyWith<SpotubeTrackObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeTrackObjectCopyWith<$Res> {
  factory $SpotubeTrackObjectCopyWith(
          SpotubeTrackObject value, $Res Function(SpotubeTrackObject) then) =
      _$SpotubeTrackObjectCopyWithImpl<$Res, SpotubeTrackObject>;
  @useResult
  $Res call(
      {String uid,
      String title,
      List<SpotubeArtistObject> artists,
      SpotubeAlbumObject album,
      int durationMs,
      String isrc,
      String externalUrl});

  $SpotubeAlbumObjectCopyWith<$Res> get album;
}

/// @nodoc
class _$SpotubeTrackObjectCopyWithImpl<$Res, $Val extends SpotubeTrackObject>
    implements $SpotubeTrackObjectCopyWith<$Res> {
  _$SpotubeTrackObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? title = null,
    Object? artists = null,
    Object? album = null,
    Object? durationMs = null,
    Object? isrc = null,
    Object? externalUrl = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeArtistObject>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumObject,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      isrc: null == isrc
          ? _value.isrc
          : isrc // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubeAlbumObjectCopyWith<$Res> get album {
    return $SpotubeAlbumObjectCopyWith<$Res>(_value.album, (value) {
      return _then(_value.copyWith(album: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpotubeTrackObjectImplCopyWith<$Res>
    implements $SpotubeTrackObjectCopyWith<$Res> {
  factory _$$SpotubeTrackObjectImplCopyWith(_$SpotubeTrackObjectImpl value,
          $Res Function(_$SpotubeTrackObjectImpl) then) =
      __$$SpotubeTrackObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String title,
      List<SpotubeArtistObject> artists,
      SpotubeAlbumObject album,
      int durationMs,
      String isrc,
      String externalUrl});

  @override
  $SpotubeAlbumObjectCopyWith<$Res> get album;
}

/// @nodoc
class __$$SpotubeTrackObjectImplCopyWithImpl<$Res>
    extends _$SpotubeTrackObjectCopyWithImpl<$Res, _$SpotubeTrackObjectImpl>
    implements _$$SpotubeTrackObjectImplCopyWith<$Res> {
  __$$SpotubeTrackObjectImplCopyWithImpl(_$SpotubeTrackObjectImpl _value,
      $Res Function(_$SpotubeTrackObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? title = null,
    Object? artists = null,
    Object? album = null,
    Object? durationMs = null,
    Object? isrc = null,
    Object? externalUrl = null,
  }) {
    return _then(_$SpotubeTrackObjectImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeArtistObject>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumObject,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      isrc: null == isrc
          ? _value.isrc
          : isrc // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeTrackObjectImpl implements _SpotubeTrackObject {
  _$SpotubeTrackObjectImpl(
      {required this.uid,
      required this.title,
      final List<SpotubeArtistObject> artists = const [],
      required this.album,
      required this.durationMs,
      required this.isrc,
      required this.externalUrl})
      : _artists = artists;

  factory _$SpotubeTrackObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeTrackObjectImplFromJson(json);

  @override
  final String uid;
  @override
  final String title;
  final List<SpotubeArtistObject> _artists;
  @override
  @JsonKey()
  List<SpotubeArtistObject> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  @override
  final SpotubeAlbumObject album;
  @override
  final int durationMs;
  @override
  final String isrc;
  @override
  final String externalUrl;

  @override
  String toString() {
    return 'SpotubeTrackObject(uid: $uid, title: $title, artists: $artists, album: $album, durationMs: $durationMs, isrc: $isrc, externalUrl: $externalUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeTrackObjectImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.isrc, isrc) || other.isrc == isrc) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      title,
      const DeepCollectionEquality().hash(_artists),
      album,
      durationMs,
      isrc,
      externalUrl);

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeTrackObjectImplCopyWith<_$SpotubeTrackObjectImpl> get copyWith =>
      __$$SpotubeTrackObjectImplCopyWithImpl<_$SpotubeTrackObjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeTrackObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeTrackObject implements SpotubeTrackObject {
  factory _SpotubeTrackObject(
      {required final String uid,
      required final String title,
      final List<SpotubeArtistObject> artists,
      required final SpotubeAlbumObject album,
      required final int durationMs,
      required final String isrc,
      required final String externalUrl}) = _$SpotubeTrackObjectImpl;

  factory _SpotubeTrackObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeTrackObjectImpl.fromJson;

  @override
  String get uid;
  @override
  String get title;
  @override
  List<SpotubeArtistObject> get artists;
  @override
  SpotubeAlbumObject get album;
  @override
  int get durationMs;
  @override
  String get isrc;
  @override
  String get externalUrl;

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeTrackObjectImplCopyWith<_$SpotubeTrackObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotubeUserObject _$SpotubeUserObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeUserObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeUserObject {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get avatars => throw _privateConstructorUsedError;
  String get externalUrl => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;

  /// Serializes this SpotubeUserObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeUserObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeUserObjectCopyWith<SpotubeUserObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeUserObjectCopyWith<$Res> {
  factory $SpotubeUserObjectCopyWith(
          SpotubeUserObject value, $Res Function(SpotubeUserObject) then) =
      _$SpotubeUserObjectCopyWithImpl<$Res, SpotubeUserObject>;
  @useResult
  $Res call(
      {String uid,
      String name,
      List<SpotubeImageObject> avatars,
      String externalUrl,
      String displayName});
}

/// @nodoc
class _$SpotubeUserObjectCopyWithImpl<$Res, $Val extends SpotubeUserObject>
    implements $SpotubeUserObjectCopyWith<$Res> {
  _$SpotubeUserObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeUserObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? avatars = null,
    Object? externalUrl = null,
    Object? displayName = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatars: null == avatars
          ? _value.avatars
          : avatars // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeUserObjectImplCopyWith<$Res>
    implements $SpotubeUserObjectCopyWith<$Res> {
  factory _$$SpotubeUserObjectImplCopyWith(_$SpotubeUserObjectImpl value,
          $Res Function(_$SpotubeUserObjectImpl) then) =
      __$$SpotubeUserObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      List<SpotubeImageObject> avatars,
      String externalUrl,
      String displayName});
}

/// @nodoc
class __$$SpotubeUserObjectImplCopyWithImpl<$Res>
    extends _$SpotubeUserObjectCopyWithImpl<$Res, _$SpotubeUserObjectImpl>
    implements _$$SpotubeUserObjectImplCopyWith<$Res> {
  __$$SpotubeUserObjectImplCopyWithImpl(_$SpotubeUserObjectImpl _value,
      $Res Function(_$SpotubeUserObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeUserObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? avatars = null,
    Object? externalUrl = null,
    Object? displayName = null,
  }) {
    return _then(_$SpotubeUserObjectImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatars: null == avatars
          ? _value._avatars
          : avatars // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      externalUrl: null == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeUserObjectImpl implements _SpotubeUserObject {
  _$SpotubeUserObjectImpl(
      {required this.uid,
      required this.name,
      final List<SpotubeImageObject> avatars = const [],
      required this.externalUrl,
      required this.displayName})
      : _avatars = avatars;

  factory _$SpotubeUserObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeUserObjectImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  final List<SpotubeImageObject> _avatars;
  @override
  @JsonKey()
  List<SpotubeImageObject> get avatars {
    if (_avatars is EqualUnmodifiableListView) return _avatars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avatars);
  }

  @override
  final String externalUrl;
  @override
  final String displayName;

  @override
  String toString() {
    return 'SpotubeUserObject(uid: $uid, name: $name, avatars: $avatars, externalUrl: $externalUrl, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeUserObjectImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._avatars, _avatars) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, name,
      const DeepCollectionEquality().hash(_avatars), externalUrl, displayName);

  /// Create a copy of SpotubeUserObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeUserObjectImplCopyWith<_$SpotubeUserObjectImpl> get copyWith =>
      __$$SpotubeUserObjectImplCopyWithImpl<_$SpotubeUserObjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeUserObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeUserObject implements SpotubeUserObject {
  factory _SpotubeUserObject(
      {required final String uid,
      required final String name,
      final List<SpotubeImageObject> avatars,
      required final String externalUrl,
      required final String displayName}) = _$SpotubeUserObjectImpl;

  factory _SpotubeUserObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeUserObjectImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  List<SpotubeImageObject> get avatars;
  @override
  String get externalUrl;
  @override
  String get displayName;

  /// Create a copy of SpotubeUserObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeUserObjectImplCopyWith<_$SpotubeUserObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PluginConfiguration _$PluginConfigurationFromJson(Map<String, dynamic> json) {
  return _PluginConfiguration.fromJson(json);
}

/// @nodoc
mixin _$PluginConfiguration {
  PluginType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get entryPoint => throw _privateConstructorUsedError;
  List<PluginApis> get apis => throw _privateConstructorUsedError;
  List<PluginAbilities> get abilities => throw _privateConstructorUsedError;

  /// Serializes this PluginConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PluginConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PluginConfigurationCopyWith<PluginConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PluginConfigurationCopyWith<$Res> {
  factory $PluginConfigurationCopyWith(
          PluginConfiguration value, $Res Function(PluginConfiguration) then) =
      _$PluginConfigurationCopyWithImpl<$Res, PluginConfiguration>;
  @useResult
  $Res call(
      {PluginType type,
      String name,
      String description,
      String version,
      String author,
      String entryPoint,
      List<PluginApis> apis,
      List<PluginAbilities> abilities});
}

/// @nodoc
class _$PluginConfigurationCopyWithImpl<$Res, $Val extends PluginConfiguration>
    implements $PluginConfigurationCopyWith<$Res> {
  _$PluginConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PluginConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? version = null,
    Object? author = null,
    Object? entryPoint = null,
    Object? apis = null,
    Object? abilities = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PluginType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      entryPoint: null == entryPoint
          ? _value.entryPoint
          : entryPoint // ignore: cast_nullable_to_non_nullable
              as String,
      apis: null == apis
          ? _value.apis
          : apis // ignore: cast_nullable_to_non_nullable
              as List<PluginApis>,
      abilities: null == abilities
          ? _value.abilities
          : abilities // ignore: cast_nullable_to_non_nullable
              as List<PluginAbilities>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PluginConfigurationImplCopyWith<$Res>
    implements $PluginConfigurationCopyWith<$Res> {
  factory _$$PluginConfigurationImplCopyWith(_$PluginConfigurationImpl value,
          $Res Function(_$PluginConfigurationImpl) then) =
      __$$PluginConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PluginType type,
      String name,
      String description,
      String version,
      String author,
      String entryPoint,
      List<PluginApis> apis,
      List<PluginAbilities> abilities});
}

/// @nodoc
class __$$PluginConfigurationImplCopyWithImpl<$Res>
    extends _$PluginConfigurationCopyWithImpl<$Res, _$PluginConfigurationImpl>
    implements _$$PluginConfigurationImplCopyWith<$Res> {
  __$$PluginConfigurationImplCopyWithImpl(_$PluginConfigurationImpl _value,
      $Res Function(_$PluginConfigurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PluginConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? version = null,
    Object? author = null,
    Object? entryPoint = null,
    Object? apis = null,
    Object? abilities = null,
  }) {
    return _then(_$PluginConfigurationImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PluginType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      entryPoint: null == entryPoint
          ? _value.entryPoint
          : entryPoint // ignore: cast_nullable_to_non_nullable
              as String,
      apis: null == apis
          ? _value._apis
          : apis // ignore: cast_nullable_to_non_nullable
              as List<PluginApis>,
      abilities: null == abilities
          ? _value._abilities
          : abilities // ignore: cast_nullable_to_non_nullable
              as List<PluginAbilities>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PluginConfigurationImpl extends _PluginConfiguration {
  _$PluginConfigurationImpl(
      {required this.type,
      required this.name,
      required this.description,
      required this.version,
      required this.author,
      required this.entryPoint,
      final List<PluginApis> apis = const [],
      final List<PluginAbilities> abilities = const []})
      : _apis = apis,
        _abilities = abilities,
        super._();

  factory _$PluginConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PluginConfigurationImplFromJson(json);

  @override
  final PluginType type;
  @override
  final String name;
  @override
  final String description;
  @override
  final String version;
  @override
  final String author;
  @override
  final String entryPoint;
  final List<PluginApis> _apis;
  @override
  @JsonKey()
  List<PluginApis> get apis {
    if (_apis is EqualUnmodifiableListView) return _apis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_apis);
  }

  final List<PluginAbilities> _abilities;
  @override
  @JsonKey()
  List<PluginAbilities> get abilities {
    if (_abilities is EqualUnmodifiableListView) return _abilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_abilities);
  }

  @override
  String toString() {
    return 'PluginConfiguration(type: $type, name: $name, description: $description, version: $version, author: $author, entryPoint: $entryPoint, apis: $apis, abilities: $abilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PluginConfigurationImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.entryPoint, entryPoint) ||
                other.entryPoint == entryPoint) &&
            const DeepCollectionEquality().equals(other._apis, _apis) &&
            const DeepCollectionEquality()
                .equals(other._abilities, _abilities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      name,
      description,
      version,
      author,
      entryPoint,
      const DeepCollectionEquality().hash(_apis),
      const DeepCollectionEquality().hash(_abilities));

  /// Create a copy of PluginConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PluginConfigurationImplCopyWith<_$PluginConfigurationImpl> get copyWith =>
      __$$PluginConfigurationImplCopyWithImpl<_$PluginConfigurationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PluginConfigurationImplToJson(
      this,
    );
  }
}

abstract class _PluginConfiguration extends PluginConfiguration {
  factory _PluginConfiguration(
      {required final PluginType type,
      required final String name,
      required final String description,
      required final String version,
      required final String author,
      required final String entryPoint,
      final List<PluginApis> apis,
      final List<PluginAbilities> abilities}) = _$PluginConfigurationImpl;
  _PluginConfiguration._() : super._();

  factory _PluginConfiguration.fromJson(Map<String, dynamic> json) =
      _$PluginConfigurationImpl.fromJson;

  @override
  PluginType get type;
  @override
  String get name;
  @override
  String get description;
  @override
  String get version;
  @override
  String get author;
  @override
  String get entryPoint;
  @override
  List<PluginApis> get apis;
  @override
  List<PluginAbilities> get abilities;

  /// Create a copy of PluginConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PluginConfigurationImplCopyWith<_$PluginConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
