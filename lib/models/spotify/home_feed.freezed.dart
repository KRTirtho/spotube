// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpotifySectionPlaylist _$SpotifySectionPlaylistFromJson(
    Map<String, dynamic> json) {
  return _SpotifySectionPlaylist.fromJson(json);
}

/// @nodoc
mixin _$SpotifySectionPlaylist {
  String get description => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  List<SpotifySectionItemImage> get images =>
      throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  /// Serializes this SpotifySectionPlaylist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifySectionPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifySectionPlaylistCopyWith<SpotifySectionPlaylist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifySectionPlaylistCopyWith<$Res> {
  factory $SpotifySectionPlaylistCopyWith(SpotifySectionPlaylist value,
          $Res Function(SpotifySectionPlaylist) then) =
      _$SpotifySectionPlaylistCopyWithImpl<$Res, SpotifySectionPlaylist>;
  @useResult
  $Res call(
      {String description,
      String format,
      List<SpotifySectionItemImage> images,
      String name,
      String owner,
      String uri});
}

/// @nodoc
class _$SpotifySectionPlaylistCopyWithImpl<$Res,
        $Val extends SpotifySectionPlaylist>
    implements $SpotifySectionPlaylistCopyWith<$Res> {
  _$SpotifySectionPlaylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifySectionPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? format = null,
    Object? images = null,
    Object? name = null,
    Object? owner = null,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionItemImage>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifySectionPlaylistImplCopyWith<$Res>
    implements $SpotifySectionPlaylistCopyWith<$Res> {
  factory _$$SpotifySectionPlaylistImplCopyWith(
          _$SpotifySectionPlaylistImpl value,
          $Res Function(_$SpotifySectionPlaylistImpl) then) =
      __$$SpotifySectionPlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String description,
      String format,
      List<SpotifySectionItemImage> images,
      String name,
      String owner,
      String uri});
}

/// @nodoc
class __$$SpotifySectionPlaylistImplCopyWithImpl<$Res>
    extends _$SpotifySectionPlaylistCopyWithImpl<$Res,
        _$SpotifySectionPlaylistImpl>
    implements _$$SpotifySectionPlaylistImplCopyWith<$Res> {
  __$$SpotifySectionPlaylistImplCopyWithImpl(
      _$SpotifySectionPlaylistImpl _value,
      $Res Function(_$SpotifySectionPlaylistImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifySectionPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? format = null,
    Object? images = null,
    Object? name = null,
    Object? owner = null,
    Object? uri = null,
  }) {
    return _then(_$SpotifySectionPlaylistImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionItemImage>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifySectionPlaylistImpl extends _SpotifySectionPlaylist {
  const _$SpotifySectionPlaylistImpl(
      {required this.description,
      required this.format,
      required final List<SpotifySectionItemImage> images,
      required this.name,
      required this.owner,
      required this.uri})
      : _images = images,
        super._();

  factory _$SpotifySectionPlaylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifySectionPlaylistImplFromJson(json);

  @override
  final String description;
  @override
  final String format;
  final List<SpotifySectionItemImage> _images;
  @override
  List<SpotifySectionItemImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String name;
  @override
  final String owner;
  @override
  final String uri;

  @override
  String toString() {
    return 'SpotifySectionPlaylist(description: $description, format: $format, images: $images, name: $name, owner: $owner, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifySectionPlaylistImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.format, format) || other.format == format) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, description, format,
      const DeepCollectionEquality().hash(_images), name, owner, uri);

  /// Create a copy of SpotifySectionPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifySectionPlaylistImplCopyWith<_$SpotifySectionPlaylistImpl>
      get copyWith => __$$SpotifySectionPlaylistImplCopyWithImpl<
          _$SpotifySectionPlaylistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifySectionPlaylistImplToJson(
      this,
    );
  }
}

abstract class _SpotifySectionPlaylist extends SpotifySectionPlaylist {
  const factory _SpotifySectionPlaylist(
      {required final String description,
      required final String format,
      required final List<SpotifySectionItemImage> images,
      required final String name,
      required final String owner,
      required final String uri}) = _$SpotifySectionPlaylistImpl;
  const _SpotifySectionPlaylist._() : super._();

  factory _SpotifySectionPlaylist.fromJson(Map<String, dynamic> json) =
      _$SpotifySectionPlaylistImpl.fromJson;

  @override
  String get description;
  @override
  String get format;
  @override
  List<SpotifySectionItemImage> get images;
  @override
  String get name;
  @override
  String get owner;
  @override
  String get uri;

  /// Create a copy of SpotifySectionPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifySectionPlaylistImplCopyWith<_$SpotifySectionPlaylistImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotifySectionArtist _$SpotifySectionArtistFromJson(Map<String, dynamic> json) {
  return _SpotifySectionArtist.fromJson(json);
}

/// @nodoc
mixin _$SpotifySectionArtist {
  String get name => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;
  List<SpotifySectionItemImage> get images =>
      throw _privateConstructorUsedError;

  /// Serializes this SpotifySectionArtist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifySectionArtist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifySectionArtistCopyWith<SpotifySectionArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifySectionArtistCopyWith<$Res> {
  factory $SpotifySectionArtistCopyWith(SpotifySectionArtist value,
          $Res Function(SpotifySectionArtist) then) =
      _$SpotifySectionArtistCopyWithImpl<$Res, SpotifySectionArtist>;
  @useResult
  $Res call({String name, String uri, List<SpotifySectionItemImage> images});
}

/// @nodoc
class _$SpotifySectionArtistCopyWithImpl<$Res,
        $Val extends SpotifySectionArtist>
    implements $SpotifySectionArtistCopyWith<$Res> {
  _$SpotifySectionArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifySectionArtist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uri = null,
    Object? images = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionItemImage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifySectionArtistImplCopyWith<$Res>
    implements $SpotifySectionArtistCopyWith<$Res> {
  factory _$$SpotifySectionArtistImplCopyWith(_$SpotifySectionArtistImpl value,
          $Res Function(_$SpotifySectionArtistImpl) then) =
      __$$SpotifySectionArtistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String uri, List<SpotifySectionItemImage> images});
}

/// @nodoc
class __$$SpotifySectionArtistImplCopyWithImpl<$Res>
    extends _$SpotifySectionArtistCopyWithImpl<$Res, _$SpotifySectionArtistImpl>
    implements _$$SpotifySectionArtistImplCopyWith<$Res> {
  __$$SpotifySectionArtistImplCopyWithImpl(_$SpotifySectionArtistImpl _value,
      $Res Function(_$SpotifySectionArtistImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifySectionArtist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uri = null,
    Object? images = null,
  }) {
    return _then(_$SpotifySectionArtistImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionItemImage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifySectionArtistImpl extends _SpotifySectionArtist {
  const _$SpotifySectionArtistImpl(
      {required this.name,
      required this.uri,
      required final List<SpotifySectionItemImage> images})
      : _images = images,
        super._();

  factory _$SpotifySectionArtistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifySectionArtistImplFromJson(json);

  @override
  final String name;
  @override
  final String uri;
  final List<SpotifySectionItemImage> _images;
  @override
  List<SpotifySectionItemImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'SpotifySectionArtist(name: $name, uri: $uri, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifySectionArtistImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, uri, const DeepCollectionEquality().hash(_images));

  /// Create a copy of SpotifySectionArtist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifySectionArtistImplCopyWith<_$SpotifySectionArtistImpl>
      get copyWith =>
          __$$SpotifySectionArtistImplCopyWithImpl<_$SpotifySectionArtistImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifySectionArtistImplToJson(
      this,
    );
  }
}

abstract class _SpotifySectionArtist extends SpotifySectionArtist {
  const factory _SpotifySectionArtist(
          {required final String name,
          required final String uri,
          required final List<SpotifySectionItemImage> images}) =
      _$SpotifySectionArtistImpl;
  const _SpotifySectionArtist._() : super._();

  factory _SpotifySectionArtist.fromJson(Map<String, dynamic> json) =
      _$SpotifySectionArtistImpl.fromJson;

  @override
  String get name;
  @override
  String get uri;
  @override
  List<SpotifySectionItemImage> get images;

  /// Create a copy of SpotifySectionArtist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifySectionArtistImplCopyWith<_$SpotifySectionArtistImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotifySectionAlbum _$SpotifySectionAlbumFromJson(Map<String, dynamic> json) {
  return _SpotifySectionAlbum.fromJson(json);
}

/// @nodoc
mixin _$SpotifySectionAlbum {
  List<SpotifySectionAlbumArtist> get artists =>
      throw _privateConstructorUsedError;
  List<SpotifySectionItemImage> get images =>
      throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  /// Serializes this SpotifySectionAlbum to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifySectionAlbum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifySectionAlbumCopyWith<SpotifySectionAlbum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifySectionAlbumCopyWith<$Res> {
  factory $SpotifySectionAlbumCopyWith(
          SpotifySectionAlbum value, $Res Function(SpotifySectionAlbum) then) =
      _$SpotifySectionAlbumCopyWithImpl<$Res, SpotifySectionAlbum>;
  @useResult
  $Res call(
      {List<SpotifySectionAlbumArtist> artists,
      List<SpotifySectionItemImage> images,
      String name,
      String uri});
}

/// @nodoc
class _$SpotifySectionAlbumCopyWithImpl<$Res, $Val extends SpotifySectionAlbum>
    implements $SpotifySectionAlbumCopyWith<$Res> {
  _$SpotifySectionAlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifySectionAlbum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? artists = null,
    Object? images = null,
    Object? name = null,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionAlbumArtist>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionItemImage>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifySectionAlbumImplCopyWith<$Res>
    implements $SpotifySectionAlbumCopyWith<$Res> {
  factory _$$SpotifySectionAlbumImplCopyWith(_$SpotifySectionAlbumImpl value,
          $Res Function(_$SpotifySectionAlbumImpl) then) =
      __$$SpotifySectionAlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SpotifySectionAlbumArtist> artists,
      List<SpotifySectionItemImage> images,
      String name,
      String uri});
}

/// @nodoc
class __$$SpotifySectionAlbumImplCopyWithImpl<$Res>
    extends _$SpotifySectionAlbumCopyWithImpl<$Res, _$SpotifySectionAlbumImpl>
    implements _$$SpotifySectionAlbumImplCopyWith<$Res> {
  __$$SpotifySectionAlbumImplCopyWithImpl(_$SpotifySectionAlbumImpl _value,
      $Res Function(_$SpotifySectionAlbumImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifySectionAlbum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? artists = null,
    Object? images = null,
    Object? name = null,
    Object? uri = null,
  }) {
    return _then(_$SpotifySectionAlbumImpl(
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionAlbumArtist>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifySectionItemImage>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifySectionAlbumImpl extends _SpotifySectionAlbum {
  const _$SpotifySectionAlbumImpl(
      {required final List<SpotifySectionAlbumArtist> artists,
      required final List<SpotifySectionItemImage> images,
      required this.name,
      required this.uri})
      : _artists = artists,
        _images = images,
        super._();

  factory _$SpotifySectionAlbumImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifySectionAlbumImplFromJson(json);

  final List<SpotifySectionAlbumArtist> _artists;
  @override
  List<SpotifySectionAlbumArtist> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  final List<SpotifySectionItemImage> _images;
  @override
  List<SpotifySectionItemImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String name;
  @override
  final String uri;

  @override
  String toString() {
    return 'SpotifySectionAlbum(artists: $artists, images: $images, name: $name, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifySectionAlbumImpl &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_artists),
      const DeepCollectionEquality().hash(_images),
      name,
      uri);

  /// Create a copy of SpotifySectionAlbum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifySectionAlbumImplCopyWith<_$SpotifySectionAlbumImpl> get copyWith =>
      __$$SpotifySectionAlbumImplCopyWithImpl<_$SpotifySectionAlbumImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifySectionAlbumImplToJson(
      this,
    );
  }
}

abstract class _SpotifySectionAlbum extends SpotifySectionAlbum {
  const factory _SpotifySectionAlbum(
      {required final List<SpotifySectionAlbumArtist> artists,
      required final List<SpotifySectionItemImage> images,
      required final String name,
      required final String uri}) = _$SpotifySectionAlbumImpl;
  const _SpotifySectionAlbum._() : super._();

  factory _SpotifySectionAlbum.fromJson(Map<String, dynamic> json) =
      _$SpotifySectionAlbumImpl.fromJson;

  @override
  List<SpotifySectionAlbumArtist> get artists;
  @override
  List<SpotifySectionItemImage> get images;
  @override
  String get name;
  @override
  String get uri;

  /// Create a copy of SpotifySectionAlbum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifySectionAlbumImplCopyWith<_$SpotifySectionAlbumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpotifySectionAlbumArtist _$SpotifySectionAlbumArtistFromJson(
    Map<String, dynamic> json) {
  return _SpotifySectionAlbumArtist.fromJson(json);
}

/// @nodoc
mixin _$SpotifySectionAlbumArtist {
  String get name => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  /// Serializes this SpotifySectionAlbumArtist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifySectionAlbumArtist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifySectionAlbumArtistCopyWith<SpotifySectionAlbumArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifySectionAlbumArtistCopyWith<$Res> {
  factory $SpotifySectionAlbumArtistCopyWith(SpotifySectionAlbumArtist value,
          $Res Function(SpotifySectionAlbumArtist) then) =
      _$SpotifySectionAlbumArtistCopyWithImpl<$Res, SpotifySectionAlbumArtist>;
  @useResult
  $Res call({String name, String uri});
}

/// @nodoc
class _$SpotifySectionAlbumArtistCopyWithImpl<$Res,
        $Val extends SpotifySectionAlbumArtist>
    implements $SpotifySectionAlbumArtistCopyWith<$Res> {
  _$SpotifySectionAlbumArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifySectionAlbumArtist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifySectionAlbumArtistImplCopyWith<$Res>
    implements $SpotifySectionAlbumArtistCopyWith<$Res> {
  factory _$$SpotifySectionAlbumArtistImplCopyWith(
          _$SpotifySectionAlbumArtistImpl value,
          $Res Function(_$SpotifySectionAlbumArtistImpl) then) =
      __$$SpotifySectionAlbumArtistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String uri});
}

/// @nodoc
class __$$SpotifySectionAlbumArtistImplCopyWithImpl<$Res>
    extends _$SpotifySectionAlbumArtistCopyWithImpl<$Res,
        _$SpotifySectionAlbumArtistImpl>
    implements _$$SpotifySectionAlbumArtistImplCopyWith<$Res> {
  __$$SpotifySectionAlbumArtistImplCopyWithImpl(
      _$SpotifySectionAlbumArtistImpl _value,
      $Res Function(_$SpotifySectionAlbumArtistImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifySectionAlbumArtist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uri = null,
  }) {
    return _then(_$SpotifySectionAlbumArtistImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifySectionAlbumArtistImpl extends _SpotifySectionAlbumArtist {
  const _$SpotifySectionAlbumArtistImpl({required this.name, required this.uri})
      : super._();

  factory _$SpotifySectionAlbumArtistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifySectionAlbumArtistImplFromJson(json);

  @override
  final String name;
  @override
  final String uri;

  @override
  String toString() {
    return 'SpotifySectionAlbumArtist(name: $name, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifySectionAlbumArtistImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, uri);

  /// Create a copy of SpotifySectionAlbumArtist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifySectionAlbumArtistImplCopyWith<_$SpotifySectionAlbumArtistImpl>
      get copyWith => __$$SpotifySectionAlbumArtistImplCopyWithImpl<
          _$SpotifySectionAlbumArtistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifySectionAlbumArtistImplToJson(
      this,
    );
  }
}

abstract class _SpotifySectionAlbumArtist extends SpotifySectionAlbumArtist {
  const factory _SpotifySectionAlbumArtist(
      {required final String name,
      required final String uri}) = _$SpotifySectionAlbumArtistImpl;
  const _SpotifySectionAlbumArtist._() : super._();

  factory _SpotifySectionAlbumArtist.fromJson(Map<String, dynamic> json) =
      _$SpotifySectionAlbumArtistImpl.fromJson;

  @override
  String get name;
  @override
  String get uri;

  /// Create a copy of SpotifySectionAlbumArtist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifySectionAlbumArtistImplCopyWith<_$SpotifySectionAlbumArtistImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotifySectionItemImage _$SpotifySectionItemImageFromJson(
    Map<String, dynamic> json) {
  return _SpotifySectionItemImage.fromJson(json);
}

/// @nodoc
mixin _$SpotifySectionItemImage {
  num? get height => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  num? get width => throw _privateConstructorUsedError;

  /// Serializes this SpotifySectionItemImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifySectionItemImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifySectionItemImageCopyWith<SpotifySectionItemImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifySectionItemImageCopyWith<$Res> {
  factory $SpotifySectionItemImageCopyWith(SpotifySectionItemImage value,
          $Res Function(SpotifySectionItemImage) then) =
      _$SpotifySectionItemImageCopyWithImpl<$Res, SpotifySectionItemImage>;
  @useResult
  $Res call({num? height, String url, num? width});
}

/// @nodoc
class _$SpotifySectionItemImageCopyWithImpl<$Res,
        $Val extends SpotifySectionItemImage>
    implements $SpotifySectionItemImageCopyWith<$Res> {
  _$SpotifySectionItemImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifySectionItemImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = freezed,
    Object? url = null,
    Object? width = freezed,
  }) {
    return _then(_value.copyWith(
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as num?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as num?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifySectionItemImageImplCopyWith<$Res>
    implements $SpotifySectionItemImageCopyWith<$Res> {
  factory _$$SpotifySectionItemImageImplCopyWith(
          _$SpotifySectionItemImageImpl value,
          $Res Function(_$SpotifySectionItemImageImpl) then) =
      __$$SpotifySectionItemImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num? height, String url, num? width});
}

/// @nodoc
class __$$SpotifySectionItemImageImplCopyWithImpl<$Res>
    extends _$SpotifySectionItemImageCopyWithImpl<$Res,
        _$SpotifySectionItemImageImpl>
    implements _$$SpotifySectionItemImageImplCopyWith<$Res> {
  __$$SpotifySectionItemImageImplCopyWithImpl(
      _$SpotifySectionItemImageImpl _value,
      $Res Function(_$SpotifySectionItemImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifySectionItemImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = freezed,
    Object? url = null,
    Object? width = freezed,
  }) {
    return _then(_$SpotifySectionItemImageImpl(
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as num?,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifySectionItemImageImpl extends _SpotifySectionItemImage {
  const _$SpotifySectionItemImageImpl(
      {required this.height, required this.url, required this.width})
      : super._();

  factory _$SpotifySectionItemImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifySectionItemImageImplFromJson(json);

  @override
  final num? height;
  @override
  final String url;
  @override
  final num? width;

  @override
  String toString() {
    return 'SpotifySectionItemImage(height: $height, url: $url, width: $width)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifySectionItemImageImpl &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, height, url, width);

  /// Create a copy of SpotifySectionItemImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifySectionItemImageImplCopyWith<_$SpotifySectionItemImageImpl>
      get copyWith => __$$SpotifySectionItemImageImplCopyWithImpl<
          _$SpotifySectionItemImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifySectionItemImageImplToJson(
      this,
    );
  }
}

abstract class _SpotifySectionItemImage extends SpotifySectionItemImage {
  const factory _SpotifySectionItemImage(
      {required final num? height,
      required final String url,
      required final num? width}) = _$SpotifySectionItemImageImpl;
  const _SpotifySectionItemImage._() : super._();

  factory _SpotifySectionItemImage.fromJson(Map<String, dynamic> json) =
      _$SpotifySectionItemImageImpl.fromJson;

  @override
  num? get height;
  @override
  String get url;
  @override
  num? get width;

  /// Create a copy of SpotifySectionItemImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifySectionItemImageImplCopyWith<_$SpotifySectionItemImageImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotifyHomeFeedSectionItem _$SpotifyHomeFeedSectionItemFromJson(
    Map<String, dynamic> json) {
  return _SpotifyHomeFeedSectionItem.fromJson(json);
}

/// @nodoc
mixin _$SpotifyHomeFeedSectionItem {
  String get typename => throw _privateConstructorUsedError;
  SpotifySectionPlaylist? get playlist => throw _privateConstructorUsedError;
  SpotifySectionArtist? get artist => throw _privateConstructorUsedError;
  SpotifySectionAlbum? get album => throw _privateConstructorUsedError;

  /// Serializes this SpotifyHomeFeedSectionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifyHomeFeedSectionItemCopyWith<SpotifyHomeFeedSectionItem>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyHomeFeedSectionItemCopyWith<$Res> {
  factory $SpotifyHomeFeedSectionItemCopyWith(SpotifyHomeFeedSectionItem value,
          $Res Function(SpotifyHomeFeedSectionItem) then) =
      _$SpotifyHomeFeedSectionItemCopyWithImpl<$Res,
          SpotifyHomeFeedSectionItem>;
  @useResult
  $Res call(
      {String typename,
      SpotifySectionPlaylist? playlist,
      SpotifySectionArtist? artist,
      SpotifySectionAlbum? album});

  $SpotifySectionPlaylistCopyWith<$Res>? get playlist;
  $SpotifySectionArtistCopyWith<$Res>? get artist;
  $SpotifySectionAlbumCopyWith<$Res>? get album;
}

/// @nodoc
class _$SpotifyHomeFeedSectionItemCopyWithImpl<$Res,
        $Val extends SpotifyHomeFeedSectionItem>
    implements $SpotifyHomeFeedSectionItemCopyWith<$Res> {
  _$SpotifyHomeFeedSectionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typename = null,
    Object? playlist = freezed,
    Object? artist = freezed,
    Object? album = freezed,
  }) {
    return _then(_value.copyWith(
      typename: null == typename
          ? _value.typename
          : typename // ignore: cast_nullable_to_non_nullable
              as String,
      playlist: freezed == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as SpotifySectionPlaylist?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as SpotifySectionArtist?,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotifySectionAlbum?,
    ) as $Val);
  }

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotifySectionPlaylistCopyWith<$Res>? get playlist {
    if (_value.playlist == null) {
      return null;
    }

    return $SpotifySectionPlaylistCopyWith<$Res>(_value.playlist!, (value) {
      return _then(_value.copyWith(playlist: value) as $Val);
    });
  }

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotifySectionArtistCopyWith<$Res>? get artist {
    if (_value.artist == null) {
      return null;
    }

    return $SpotifySectionArtistCopyWith<$Res>(_value.artist!, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotifySectionAlbumCopyWith<$Res>? get album {
    if (_value.album == null) {
      return null;
    }

    return $SpotifySectionAlbumCopyWith<$Res>(_value.album!, (value) {
      return _then(_value.copyWith(album: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpotifyHomeFeedSectionItemImplCopyWith<$Res>
    implements $SpotifyHomeFeedSectionItemCopyWith<$Res> {
  factory _$$SpotifyHomeFeedSectionItemImplCopyWith(
          _$SpotifyHomeFeedSectionItemImpl value,
          $Res Function(_$SpotifyHomeFeedSectionItemImpl) then) =
      __$$SpotifyHomeFeedSectionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String typename,
      SpotifySectionPlaylist? playlist,
      SpotifySectionArtist? artist,
      SpotifySectionAlbum? album});

  @override
  $SpotifySectionPlaylistCopyWith<$Res>? get playlist;
  @override
  $SpotifySectionArtistCopyWith<$Res>? get artist;
  @override
  $SpotifySectionAlbumCopyWith<$Res>? get album;
}

/// @nodoc
class __$$SpotifyHomeFeedSectionItemImplCopyWithImpl<$Res>
    extends _$SpotifyHomeFeedSectionItemCopyWithImpl<$Res,
        _$SpotifyHomeFeedSectionItemImpl>
    implements _$$SpotifyHomeFeedSectionItemImplCopyWith<$Res> {
  __$$SpotifyHomeFeedSectionItemImplCopyWithImpl(
      _$SpotifyHomeFeedSectionItemImpl _value,
      $Res Function(_$SpotifyHomeFeedSectionItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typename = null,
    Object? playlist = freezed,
    Object? artist = freezed,
    Object? album = freezed,
  }) {
    return _then(_$SpotifyHomeFeedSectionItemImpl(
      typename: null == typename
          ? _value.typename
          : typename // ignore: cast_nullable_to_non_nullable
              as String,
      playlist: freezed == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as SpotifySectionPlaylist?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as SpotifySectionArtist?,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotifySectionAlbum?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyHomeFeedSectionItemImpl implements _SpotifyHomeFeedSectionItem {
  _$SpotifyHomeFeedSectionItemImpl(
      {required this.typename, this.playlist, this.artist, this.album});

  factory _$SpotifyHomeFeedSectionItemImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotifyHomeFeedSectionItemImplFromJson(json);

  @override
  final String typename;
  @override
  final SpotifySectionPlaylist? playlist;
  @override
  final SpotifySectionArtist? artist;
  @override
  final SpotifySectionAlbum? album;

  @override
  String toString() {
    return 'SpotifyHomeFeedSectionItem(typename: $typename, playlist: $playlist, artist: $artist, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyHomeFeedSectionItemImpl &&
            (identical(other.typename, typename) ||
                other.typename == typename) &&
            (identical(other.playlist, playlist) ||
                other.playlist == playlist) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.album, album) || other.album == album));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, typename, playlist, artist, album);

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyHomeFeedSectionItemImplCopyWith<_$SpotifyHomeFeedSectionItemImpl>
      get copyWith => __$$SpotifyHomeFeedSectionItemImplCopyWithImpl<
          _$SpotifyHomeFeedSectionItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyHomeFeedSectionItemImplToJson(
      this,
    );
  }
}

abstract class _SpotifyHomeFeedSectionItem
    implements SpotifyHomeFeedSectionItem {
  factory _SpotifyHomeFeedSectionItem(
      {required final String typename,
      final SpotifySectionPlaylist? playlist,
      final SpotifySectionArtist? artist,
      final SpotifySectionAlbum? album}) = _$SpotifyHomeFeedSectionItemImpl;

  factory _SpotifyHomeFeedSectionItem.fromJson(Map<String, dynamic> json) =
      _$SpotifyHomeFeedSectionItemImpl.fromJson;

  @override
  String get typename;
  @override
  SpotifySectionPlaylist? get playlist;
  @override
  SpotifySectionArtist? get artist;
  @override
  SpotifySectionAlbum? get album;

  /// Create a copy of SpotifyHomeFeedSectionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifyHomeFeedSectionItemImplCopyWith<_$SpotifyHomeFeedSectionItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotifyHomeFeedSection _$SpotifyHomeFeedSectionFromJson(
    Map<String, dynamic> json) {
  return _SpotifyHomeFeedSection.fromJson(json);
}

/// @nodoc
mixin _$SpotifyHomeFeedSection {
  String get typename => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;
  List<SpotifyHomeFeedSectionItem> get items =>
      throw _privateConstructorUsedError;

  /// Serializes this SpotifyHomeFeedSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifyHomeFeedSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifyHomeFeedSectionCopyWith<SpotifyHomeFeedSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyHomeFeedSectionCopyWith<$Res> {
  factory $SpotifyHomeFeedSectionCopyWith(SpotifyHomeFeedSection value,
          $Res Function(SpotifyHomeFeedSection) then) =
      _$SpotifyHomeFeedSectionCopyWithImpl<$Res, SpotifyHomeFeedSection>;
  @useResult
  $Res call(
      {String typename,
      String? title,
      String uri,
      List<SpotifyHomeFeedSectionItem> items});
}

/// @nodoc
class _$SpotifyHomeFeedSectionCopyWithImpl<$Res,
        $Val extends SpotifyHomeFeedSection>
    implements $SpotifyHomeFeedSectionCopyWith<$Res> {
  _$SpotifyHomeFeedSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifyHomeFeedSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typename = null,
    Object? title = freezed,
    Object? uri = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      typename: null == typename
          ? _value.typename
          : typename // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SpotifyHomeFeedSectionItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyHomeFeedSectionImplCopyWith<$Res>
    implements $SpotifyHomeFeedSectionCopyWith<$Res> {
  factory _$$SpotifyHomeFeedSectionImplCopyWith(
          _$SpotifyHomeFeedSectionImpl value,
          $Res Function(_$SpotifyHomeFeedSectionImpl) then) =
      __$$SpotifyHomeFeedSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String typename,
      String? title,
      String uri,
      List<SpotifyHomeFeedSectionItem> items});
}

/// @nodoc
class __$$SpotifyHomeFeedSectionImplCopyWithImpl<$Res>
    extends _$SpotifyHomeFeedSectionCopyWithImpl<$Res,
        _$SpotifyHomeFeedSectionImpl>
    implements _$$SpotifyHomeFeedSectionImplCopyWith<$Res> {
  __$$SpotifyHomeFeedSectionImplCopyWithImpl(
      _$SpotifyHomeFeedSectionImpl _value,
      $Res Function(_$SpotifyHomeFeedSectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifyHomeFeedSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typename = null,
    Object? title = freezed,
    Object? uri = null,
    Object? items = null,
  }) {
    return _then(_$SpotifyHomeFeedSectionImpl(
      typename: null == typename
          ? _value.typename
          : typename // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SpotifyHomeFeedSectionItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyHomeFeedSectionImpl implements _SpotifyHomeFeedSection {
  _$SpotifyHomeFeedSectionImpl(
      {required this.typename,
      this.title,
      required this.uri,
      required final List<SpotifyHomeFeedSectionItem> items})
      : _items = items;

  factory _$SpotifyHomeFeedSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyHomeFeedSectionImplFromJson(json);

  @override
  final String typename;
  @override
  final String? title;
  @override
  final String uri;
  final List<SpotifyHomeFeedSectionItem> _items;
  @override
  List<SpotifyHomeFeedSectionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'SpotifyHomeFeedSection(typename: $typename, title: $title, uri: $uri, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyHomeFeedSectionImpl &&
            (identical(other.typename, typename) ||
                other.typename == typename) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, typename, title, uri,
      const DeepCollectionEquality().hash(_items));

  /// Create a copy of SpotifyHomeFeedSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyHomeFeedSectionImplCopyWith<_$SpotifyHomeFeedSectionImpl>
      get copyWith => __$$SpotifyHomeFeedSectionImplCopyWithImpl<
          _$SpotifyHomeFeedSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyHomeFeedSectionImplToJson(
      this,
    );
  }
}

abstract class _SpotifyHomeFeedSection implements SpotifyHomeFeedSection {
  factory _SpotifyHomeFeedSection(
          {required final String typename,
          final String? title,
          required final String uri,
          required final List<SpotifyHomeFeedSectionItem> items}) =
      _$SpotifyHomeFeedSectionImpl;

  factory _SpotifyHomeFeedSection.fromJson(Map<String, dynamic> json) =
      _$SpotifyHomeFeedSectionImpl.fromJson;

  @override
  String get typename;
  @override
  String? get title;
  @override
  String get uri;
  @override
  List<SpotifyHomeFeedSectionItem> get items;

  /// Create a copy of SpotifyHomeFeedSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifyHomeFeedSectionImplCopyWith<_$SpotifyHomeFeedSectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotifyHomeFeed _$SpotifyHomeFeedFromJson(Map<String, dynamic> json) {
  return _SpotifyHomeFeed.fromJson(json);
}

/// @nodoc
mixin _$SpotifyHomeFeed {
  String get greeting => throw _privateConstructorUsedError;
  List<SpotifyHomeFeedSection> get sections =>
      throw _privateConstructorUsedError;

  /// Serializes this SpotifyHomeFeed to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotifyHomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotifyHomeFeedCopyWith<SpotifyHomeFeed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyHomeFeedCopyWith<$Res> {
  factory $SpotifyHomeFeedCopyWith(
          SpotifyHomeFeed value, $Res Function(SpotifyHomeFeed) then) =
      _$SpotifyHomeFeedCopyWithImpl<$Res, SpotifyHomeFeed>;
  @useResult
  $Res call({String greeting, List<SpotifyHomeFeedSection> sections});
}

/// @nodoc
class _$SpotifyHomeFeedCopyWithImpl<$Res, $Val extends SpotifyHomeFeed>
    implements $SpotifyHomeFeedCopyWith<$Res> {
  _$SpotifyHomeFeedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotifyHomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? greeting = null,
    Object? sections = null,
  }) {
    return _then(_value.copyWith(
      greeting: null == greeting
          ? _value.greeting
          : greeting // ignore: cast_nullable_to_non_nullable
              as String,
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<SpotifyHomeFeedSection>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotifyHomeFeedImplCopyWith<$Res>
    implements $SpotifyHomeFeedCopyWith<$Res> {
  factory _$$SpotifyHomeFeedImplCopyWith(_$SpotifyHomeFeedImpl value,
          $Res Function(_$SpotifyHomeFeedImpl) then) =
      __$$SpotifyHomeFeedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String greeting, List<SpotifyHomeFeedSection> sections});
}

/// @nodoc
class __$$SpotifyHomeFeedImplCopyWithImpl<$Res>
    extends _$SpotifyHomeFeedCopyWithImpl<$Res, _$SpotifyHomeFeedImpl>
    implements _$$SpotifyHomeFeedImplCopyWith<$Res> {
  __$$SpotifyHomeFeedImplCopyWithImpl(
      _$SpotifyHomeFeedImpl _value, $Res Function(_$SpotifyHomeFeedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotifyHomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? greeting = null,
    Object? sections = null,
  }) {
    return _then(_$SpotifyHomeFeedImpl(
      greeting: null == greeting
          ? _value.greeting
          : greeting // ignore: cast_nullable_to_non_nullable
              as String,
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<SpotifyHomeFeedSection>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotifyHomeFeedImpl implements _SpotifyHomeFeed {
  _$SpotifyHomeFeedImpl(
      {required this.greeting,
      required final List<SpotifyHomeFeedSection> sections})
      : _sections = sections;

  factory _$SpotifyHomeFeedImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotifyHomeFeedImplFromJson(json);

  @override
  final String greeting;
  final List<SpotifyHomeFeedSection> _sections;
  @override
  List<SpotifyHomeFeedSection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  String toString() {
    return 'SpotifyHomeFeed(greeting: $greeting, sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotifyHomeFeedImpl &&
            (identical(other.greeting, greeting) ||
                other.greeting == greeting) &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, greeting, const DeepCollectionEquality().hash(_sections));

  /// Create a copy of SpotifyHomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotifyHomeFeedImplCopyWith<_$SpotifyHomeFeedImpl> get copyWith =>
      __$$SpotifyHomeFeedImplCopyWithImpl<_$SpotifyHomeFeedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotifyHomeFeedImplToJson(
      this,
    );
  }
}

abstract class _SpotifyHomeFeed implements SpotifyHomeFeed {
  factory _SpotifyHomeFeed(
          {required final String greeting,
          required final List<SpotifyHomeFeedSection> sections}) =
      _$SpotifyHomeFeedImpl;

  factory _SpotifyHomeFeed.fromJson(Map<String, dynamic> json) =
      _$SpotifyHomeFeedImpl.fromJson;

  @override
  String get greeting;
  @override
  List<SpotifyHomeFeedSection> get sections;

  /// Create a copy of SpotifyHomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotifyHomeFeedImplCopyWith<_$SpotifyHomeFeedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
