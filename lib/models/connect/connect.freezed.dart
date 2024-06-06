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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WebSocketLoadEventData _$WebSocketLoadEventDataFromJson(
    Map<String, dynamic> json) {
  return _WebSocketLoadEventData.fromJson(json);
}

/// @nodoc
mixin _$WebSocketLoadEventData {
  @JsonKey(name: 'tracks', toJson: _tracksJson)
  List<Track> get tracks => throw _privateConstructorUsedError;
  String? get collectionId => throw _privateConstructorUsedError;
  int? get initialIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      {@JsonKey(name: 'tracks', toJson: _tracksJson) List<Track> tracks,
      String? collectionId,
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tracks = null,
    Object? collectionId = freezed,
    Object? initialIndex = freezed,
  }) {
    return _then(_value.copyWith(
      tracks: null == tracks
          ? _value.tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as List<Track>,
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      initialIndex: freezed == initialIndex
          ? _value.initialIndex
          : initialIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebSocketLoadEventDataImplCopyWith<$Res>
    implements $WebSocketLoadEventDataCopyWith<$Res> {
  factory _$$WebSocketLoadEventDataImplCopyWith(
          _$WebSocketLoadEventDataImpl value,
          $Res Function(_$WebSocketLoadEventDataImpl) then) =
      __$$WebSocketLoadEventDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'tracks', toJson: _tracksJson) List<Track> tracks,
      String? collectionId,
      int? initialIndex});
}

/// @nodoc
class __$$WebSocketLoadEventDataImplCopyWithImpl<$Res>
    extends _$WebSocketLoadEventDataCopyWithImpl<$Res,
        _$WebSocketLoadEventDataImpl>
    implements _$$WebSocketLoadEventDataImplCopyWith<$Res> {
  __$$WebSocketLoadEventDataImplCopyWithImpl(
      _$WebSocketLoadEventDataImpl _value,
      $Res Function(_$WebSocketLoadEventDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tracks = null,
    Object? collectionId = freezed,
    Object? initialIndex = freezed,
  }) {
    return _then(_$WebSocketLoadEventDataImpl(
      tracks: null == tracks
          ? _value._tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as List<Track>,
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      initialIndex: freezed == initialIndex
          ? _value.initialIndex
          : initialIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebSocketLoadEventDataImpl implements _WebSocketLoadEventData {
  _$WebSocketLoadEventDataImpl(
      {@JsonKey(name: 'tracks', toJson: _tracksJson)
      required final List<Track> tracks,
      this.collectionId,
      this.initialIndex})
      : _tracks = tracks;

  factory _$WebSocketLoadEventDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebSocketLoadEventDataImplFromJson(json);

  final List<Track> _tracks;
  @override
  @JsonKey(name: 'tracks', toJson: _tracksJson)
  List<Track> get tracks {
    if (_tracks is EqualUnmodifiableListView) return _tracks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tracks);
  }

  @override
  final String? collectionId;
  @override
  final int? initialIndex;

  @override
  String toString() {
    return 'WebSocketLoadEventData(tracks: $tracks, collectionId: $collectionId, initialIndex: $initialIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketLoadEventDataImpl &&
            const DeepCollectionEquality().equals(other._tracks, _tracks) &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.initialIndex, initialIndex) ||
                other.initialIndex == initialIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_tracks), collectionId, initialIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketLoadEventDataImplCopyWith<_$WebSocketLoadEventDataImpl>
      get copyWith => __$$WebSocketLoadEventDataImplCopyWithImpl<
          _$WebSocketLoadEventDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketLoadEventDataImplToJson(
      this,
    );
  }
}

abstract class _WebSocketLoadEventData implements WebSocketLoadEventData {
  factory _WebSocketLoadEventData(
      {@JsonKey(name: 'tracks', toJson: _tracksJson)
      required final List<Track> tracks,
      final String? collectionId,
      final int? initialIndex}) = _$WebSocketLoadEventDataImpl;

  factory _WebSocketLoadEventData.fromJson(Map<String, dynamic> json) =
      _$WebSocketLoadEventDataImpl.fromJson;

  @override
  @JsonKey(name: 'tracks', toJson: _tracksJson)
  List<Track> get tracks;
  @override
  String? get collectionId;
  @override
  int? get initialIndex;
  @override
  @JsonKey(ignore: true)
  _$$WebSocketLoadEventDataImplCopyWith<_$WebSocketLoadEventDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
