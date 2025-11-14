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

SpotubeAudioSourceContainerPreset _$SpotubeAudioSourceContainerPresetFromJson(
    Map<String, dynamic> json) {
  switch (json['type']) {
    case 'lossy':
      return SpotubeAudioSourceContainerPresetLossy.fromJson(json);
    case 'lossless':
      return SpotubeAudioSourceContainerPresetLossless.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'type',
          'SpotubeAudioSourceContainerPreset',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$SpotubeAudioSourceContainerPreset {
  SpotubeMediaCompressionType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<Object> get qualities => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)
        lossy,
    required TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)
        lossless,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)?
        lossy,
    TResult? Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)?
        lossless,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)?
        lossy,
    TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)?
        lossless,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpotubeAudioSourceContainerPresetLossy value)
        lossy,
    required TResult Function(SpotubeAudioSourceContainerPresetLossless value)
        lossless,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpotubeAudioSourceContainerPresetLossy value)? lossy,
    TResult? Function(SpotubeAudioSourceContainerPresetLossless value)?
        lossless,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpotubeAudioSourceContainerPresetLossy value)? lossy,
    TResult Function(SpotubeAudioSourceContainerPresetLossless value)? lossless,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SpotubeAudioSourceContainerPreset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeAudioSourceContainerPresetCopyWith<SpotubeAudioSourceContainerPreset>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeAudioSourceContainerPresetCopyWith<$Res> {
  factory $SpotubeAudioSourceContainerPresetCopyWith(
          SpotubeAudioSourceContainerPreset value,
          $Res Function(SpotubeAudioSourceContainerPreset) then) =
      _$SpotubeAudioSourceContainerPresetCopyWithImpl<$Res,
          SpotubeAudioSourceContainerPreset>;
  @useResult
  $Res call({SpotubeMediaCompressionType type, String name});
}

/// @nodoc
class _$SpotubeAudioSourceContainerPresetCopyWithImpl<$Res,
        $Val extends SpotubeAudioSourceContainerPreset>
    implements $SpotubeAudioSourceContainerPresetCopyWith<$Res> {
  _$SpotubeAudioSourceContainerPresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SpotubeMediaCompressionType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeAudioSourceContainerPresetLossyImplCopyWith<$Res>
    implements $SpotubeAudioSourceContainerPresetCopyWith<$Res> {
  factory _$$SpotubeAudioSourceContainerPresetLossyImplCopyWith(
          _$SpotubeAudioSourceContainerPresetLossyImpl value,
          $Res Function(_$SpotubeAudioSourceContainerPresetLossyImpl) then) =
      __$$SpotubeAudioSourceContainerPresetLossyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SpotubeMediaCompressionType type,
      String name,
      List<SpotubeAudioLossyContainerQuality> qualities});
}

/// @nodoc
class __$$SpotubeAudioSourceContainerPresetLossyImplCopyWithImpl<$Res>
    extends _$SpotubeAudioSourceContainerPresetCopyWithImpl<$Res,
        _$SpotubeAudioSourceContainerPresetLossyImpl>
    implements _$$SpotubeAudioSourceContainerPresetLossyImplCopyWith<$Res> {
  __$$SpotubeAudioSourceContainerPresetLossyImplCopyWithImpl(
      _$SpotubeAudioSourceContainerPresetLossyImpl _value,
      $Res Function(_$SpotubeAudioSourceContainerPresetLossyImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? qualities = null,
  }) {
    return _then(_$SpotubeAudioSourceContainerPresetLossyImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SpotubeMediaCompressionType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      qualities: null == qualities
          ? _value._qualities
          : qualities // ignore: cast_nullable_to_non_nullable
              as List<SpotubeAudioLossyContainerQuality>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeAudioSourceContainerPresetLossyImpl
    extends SpotubeAudioSourceContainerPresetLossy {
  _$SpotubeAudioSourceContainerPresetLossyImpl(
      {required this.type,
      required this.name,
      required final List<SpotubeAudioLossyContainerQuality> qualities})
      : _qualities = qualities,
        super._();

  factory _$SpotubeAudioSourceContainerPresetLossyImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeAudioSourceContainerPresetLossyImplFromJson(json);

  @override
  final SpotubeMediaCompressionType type;
  @override
  final String name;
  final List<SpotubeAudioLossyContainerQuality> _qualities;
  @override
  List<SpotubeAudioLossyContainerQuality> get qualities {
    if (_qualities is EqualUnmodifiableListView) return _qualities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_qualities);
  }

  @override
  String toString() {
    return 'SpotubeAudioSourceContainerPreset.lossy(type: $type, name: $name, qualities: $qualities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeAudioSourceContainerPresetLossyImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._qualities, _qualities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, name, const DeepCollectionEquality().hash(_qualities));

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeAudioSourceContainerPresetLossyImplCopyWith<
          _$SpotubeAudioSourceContainerPresetLossyImpl>
      get copyWith =>
          __$$SpotubeAudioSourceContainerPresetLossyImplCopyWithImpl<
              _$SpotubeAudioSourceContainerPresetLossyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)
        lossy,
    required TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)
        lossless,
  }) {
    return lossy(type, name, qualities);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)?
        lossy,
    TResult? Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)?
        lossless,
  }) {
    return lossy?.call(type, name, qualities);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)?
        lossy,
    TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)?
        lossless,
    required TResult orElse(),
  }) {
    if (lossy != null) {
      return lossy(type, name, qualities);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpotubeAudioSourceContainerPresetLossy value)
        lossy,
    required TResult Function(SpotubeAudioSourceContainerPresetLossless value)
        lossless,
  }) {
    return lossy(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpotubeAudioSourceContainerPresetLossy value)? lossy,
    TResult? Function(SpotubeAudioSourceContainerPresetLossless value)?
        lossless,
  }) {
    return lossy?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpotubeAudioSourceContainerPresetLossy value)? lossy,
    TResult Function(SpotubeAudioSourceContainerPresetLossless value)? lossless,
    required TResult orElse(),
  }) {
    if (lossy != null) {
      return lossy(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeAudioSourceContainerPresetLossyImplToJson(
      this,
    );
  }
}

abstract class SpotubeAudioSourceContainerPresetLossy
    extends SpotubeAudioSourceContainerPreset {
  factory SpotubeAudioSourceContainerPresetLossy(
          {required final SpotubeMediaCompressionType type,
          required final String name,
          required final List<SpotubeAudioLossyContainerQuality> qualities}) =
      _$SpotubeAudioSourceContainerPresetLossyImpl;
  SpotubeAudioSourceContainerPresetLossy._() : super._();

  factory SpotubeAudioSourceContainerPresetLossy.fromJson(
          Map<String, dynamic> json) =
      _$SpotubeAudioSourceContainerPresetLossyImpl.fromJson;

  @override
  SpotubeMediaCompressionType get type;
  @override
  String get name;
  @override
  List<SpotubeAudioLossyContainerQuality> get qualities;

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeAudioSourceContainerPresetLossyImplCopyWith<
          _$SpotubeAudioSourceContainerPresetLossyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpotubeAudioSourceContainerPresetLosslessImplCopyWith<$Res>
    implements $SpotubeAudioSourceContainerPresetCopyWith<$Res> {
  factory _$$SpotubeAudioSourceContainerPresetLosslessImplCopyWith(
          _$SpotubeAudioSourceContainerPresetLosslessImpl value,
          $Res Function(_$SpotubeAudioSourceContainerPresetLosslessImpl) then) =
      __$$SpotubeAudioSourceContainerPresetLosslessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SpotubeMediaCompressionType type,
      String name,
      List<SpotubeAudioLosslessContainerQuality> qualities});
}

/// @nodoc
class __$$SpotubeAudioSourceContainerPresetLosslessImplCopyWithImpl<$Res>
    extends _$SpotubeAudioSourceContainerPresetCopyWithImpl<$Res,
        _$SpotubeAudioSourceContainerPresetLosslessImpl>
    implements _$$SpotubeAudioSourceContainerPresetLosslessImplCopyWith<$Res> {
  __$$SpotubeAudioSourceContainerPresetLosslessImplCopyWithImpl(
      _$SpotubeAudioSourceContainerPresetLosslessImpl _value,
      $Res Function(_$SpotubeAudioSourceContainerPresetLosslessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? qualities = null,
  }) {
    return _then(_$SpotubeAudioSourceContainerPresetLosslessImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SpotubeMediaCompressionType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      qualities: null == qualities
          ? _value._qualities
          : qualities // ignore: cast_nullable_to_non_nullable
              as List<SpotubeAudioLosslessContainerQuality>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeAudioSourceContainerPresetLosslessImpl
    extends SpotubeAudioSourceContainerPresetLossless {
  _$SpotubeAudioSourceContainerPresetLosslessImpl(
      {required this.type,
      required this.name,
      required final List<SpotubeAudioLosslessContainerQuality> qualities})
      : _qualities = qualities,
        super._();

  factory _$SpotubeAudioSourceContainerPresetLosslessImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeAudioSourceContainerPresetLosslessImplFromJson(json);

  @override
  final SpotubeMediaCompressionType type;
  @override
  final String name;
  final List<SpotubeAudioLosslessContainerQuality> _qualities;
  @override
  List<SpotubeAudioLosslessContainerQuality> get qualities {
    if (_qualities is EqualUnmodifiableListView) return _qualities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_qualities);
  }

  @override
  String toString() {
    return 'SpotubeAudioSourceContainerPreset.lossless(type: $type, name: $name, qualities: $qualities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeAudioSourceContainerPresetLosslessImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._qualities, _qualities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, name, const DeepCollectionEquality().hash(_qualities));

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeAudioSourceContainerPresetLosslessImplCopyWith<
          _$SpotubeAudioSourceContainerPresetLosslessImpl>
      get copyWith =>
          __$$SpotubeAudioSourceContainerPresetLosslessImplCopyWithImpl<
                  _$SpotubeAudioSourceContainerPresetLosslessImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)
        lossy,
    required TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)
        lossless,
  }) {
    return lossless(type, name, qualities);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)?
        lossy,
    TResult? Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)?
        lossless,
  }) {
    return lossless?.call(type, name, qualities);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLossyContainerQuality> qualities)?
        lossy,
    TResult Function(SpotubeMediaCompressionType type, String name,
            List<SpotubeAudioLosslessContainerQuality> qualities)?
        lossless,
    required TResult orElse(),
  }) {
    if (lossless != null) {
      return lossless(type, name, qualities);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpotubeAudioSourceContainerPresetLossy value)
        lossy,
    required TResult Function(SpotubeAudioSourceContainerPresetLossless value)
        lossless,
  }) {
    return lossless(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpotubeAudioSourceContainerPresetLossy value)? lossy,
    TResult? Function(SpotubeAudioSourceContainerPresetLossless value)?
        lossless,
  }) {
    return lossless?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpotubeAudioSourceContainerPresetLossy value)? lossy,
    TResult Function(SpotubeAudioSourceContainerPresetLossless value)? lossless,
    required TResult orElse(),
  }) {
    if (lossless != null) {
      return lossless(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeAudioSourceContainerPresetLosslessImplToJson(
      this,
    );
  }
}

abstract class SpotubeAudioSourceContainerPresetLossless
    extends SpotubeAudioSourceContainerPreset {
  factory SpotubeAudioSourceContainerPresetLossless(
      {required final SpotubeMediaCompressionType type,
      required final String name,
      required final List<SpotubeAudioLosslessContainerQuality>
          qualities}) = _$SpotubeAudioSourceContainerPresetLosslessImpl;
  SpotubeAudioSourceContainerPresetLossless._() : super._();

  factory SpotubeAudioSourceContainerPresetLossless.fromJson(
          Map<String, dynamic> json) =
      _$SpotubeAudioSourceContainerPresetLosslessImpl.fromJson;

  @override
  SpotubeMediaCompressionType get type;
  @override
  String get name;
  @override
  List<SpotubeAudioLosslessContainerQuality> get qualities;

  /// Create a copy of SpotubeAudioSourceContainerPreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeAudioSourceContainerPresetLosslessImplCopyWith<
          _$SpotubeAudioSourceContainerPresetLosslessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeAudioLossyContainerQuality _$SpotubeAudioLossyContainerQualityFromJson(
    Map<String, dynamic> json) {
  return _SpotubeAudioLossyContainerQuality.fromJson(json);
}

/// @nodoc
mixin _$SpotubeAudioLossyContainerQuality {
  int get bitrate => throw _privateConstructorUsedError;

  /// Serializes this SpotubeAudioLossyContainerQuality to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeAudioLossyContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeAudioLossyContainerQualityCopyWith<SpotubeAudioLossyContainerQuality>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeAudioLossyContainerQualityCopyWith<$Res> {
  factory $SpotubeAudioLossyContainerQualityCopyWith(
          SpotubeAudioLossyContainerQuality value,
          $Res Function(SpotubeAudioLossyContainerQuality) then) =
      _$SpotubeAudioLossyContainerQualityCopyWithImpl<$Res,
          SpotubeAudioLossyContainerQuality>;
  @useResult
  $Res call({int bitrate});
}

/// @nodoc
class _$SpotubeAudioLossyContainerQualityCopyWithImpl<$Res,
        $Val extends SpotubeAudioLossyContainerQuality>
    implements $SpotubeAudioLossyContainerQualityCopyWith<$Res> {
  _$SpotubeAudioLossyContainerQualityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeAudioLossyContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bitrate = null,
  }) {
    return _then(_value.copyWith(
      bitrate: null == bitrate
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeAudioLossyContainerQualityImplCopyWith<$Res>
    implements $SpotubeAudioLossyContainerQualityCopyWith<$Res> {
  factory _$$SpotubeAudioLossyContainerQualityImplCopyWith(
          _$SpotubeAudioLossyContainerQualityImpl value,
          $Res Function(_$SpotubeAudioLossyContainerQualityImpl) then) =
      __$$SpotubeAudioLossyContainerQualityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int bitrate});
}

/// @nodoc
class __$$SpotubeAudioLossyContainerQualityImplCopyWithImpl<$Res>
    extends _$SpotubeAudioLossyContainerQualityCopyWithImpl<$Res,
        _$SpotubeAudioLossyContainerQualityImpl>
    implements _$$SpotubeAudioLossyContainerQualityImplCopyWith<$Res> {
  __$$SpotubeAudioLossyContainerQualityImplCopyWithImpl(
      _$SpotubeAudioLossyContainerQualityImpl _value,
      $Res Function(_$SpotubeAudioLossyContainerQualityImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeAudioLossyContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bitrate = null,
  }) {
    return _then(_$SpotubeAudioLossyContainerQualityImpl(
      bitrate: null == bitrate
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeAudioLossyContainerQualityImpl
    extends _SpotubeAudioLossyContainerQuality {
  _$SpotubeAudioLossyContainerQualityImpl({required this.bitrate}) : super._();

  factory _$SpotubeAudioLossyContainerQualityImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeAudioLossyContainerQualityImplFromJson(json);

  @override
  final int bitrate;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeAudioLossyContainerQualityImpl &&
            (identical(other.bitrate, bitrate) || other.bitrate == bitrate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bitrate);

  /// Create a copy of SpotubeAudioLossyContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeAudioLossyContainerQualityImplCopyWith<
          _$SpotubeAudioLossyContainerQualityImpl>
      get copyWith => __$$SpotubeAudioLossyContainerQualityImplCopyWithImpl<
          _$SpotubeAudioLossyContainerQualityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeAudioLossyContainerQualityImplToJson(
      this,
    );
  }
}

abstract class _SpotubeAudioLossyContainerQuality
    extends SpotubeAudioLossyContainerQuality {
  factory _SpotubeAudioLossyContainerQuality({required final int bitrate}) =
      _$SpotubeAudioLossyContainerQualityImpl;
  _SpotubeAudioLossyContainerQuality._() : super._();

  factory _SpotubeAudioLossyContainerQuality.fromJson(
          Map<String, dynamic> json) =
      _$SpotubeAudioLossyContainerQualityImpl.fromJson;

  @override
  int get bitrate;

  /// Create a copy of SpotubeAudioLossyContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeAudioLossyContainerQualityImplCopyWith<
          _$SpotubeAudioLossyContainerQualityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeAudioLosslessContainerQuality
    _$SpotubeAudioLosslessContainerQualityFromJson(Map<String, dynamic> json) {
  return _SpotubeAudioLosslessContainerQuality.fromJson(json);
}

/// @nodoc
mixin _$SpotubeAudioLosslessContainerQuality {
  int get bitDepth => throw _privateConstructorUsedError; // bit
  int get sampleRate => throw _privateConstructorUsedError;

  /// Serializes this SpotubeAudioLosslessContainerQuality to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeAudioLosslessContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeAudioLosslessContainerQualityCopyWith<
          SpotubeAudioLosslessContainerQuality>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeAudioLosslessContainerQualityCopyWith<$Res> {
  factory $SpotubeAudioLosslessContainerQualityCopyWith(
          SpotubeAudioLosslessContainerQuality value,
          $Res Function(SpotubeAudioLosslessContainerQuality) then) =
      _$SpotubeAudioLosslessContainerQualityCopyWithImpl<$Res,
          SpotubeAudioLosslessContainerQuality>;
  @useResult
  $Res call({int bitDepth, int sampleRate});
}

/// @nodoc
class _$SpotubeAudioLosslessContainerQualityCopyWithImpl<$Res,
        $Val extends SpotubeAudioLosslessContainerQuality>
    implements $SpotubeAudioLosslessContainerQualityCopyWith<$Res> {
  _$SpotubeAudioLosslessContainerQualityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeAudioLosslessContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bitDepth = null,
    Object? sampleRate = null,
  }) {
    return _then(_value.copyWith(
      bitDepth: null == bitDepth
          ? _value.bitDepth
          : bitDepth // ignore: cast_nullable_to_non_nullable
              as int,
      sampleRate: null == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeAudioLosslessContainerQualityImplCopyWith<$Res>
    implements $SpotubeAudioLosslessContainerQualityCopyWith<$Res> {
  factory _$$SpotubeAudioLosslessContainerQualityImplCopyWith(
          _$SpotubeAudioLosslessContainerQualityImpl value,
          $Res Function(_$SpotubeAudioLosslessContainerQualityImpl) then) =
      __$$SpotubeAudioLosslessContainerQualityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int bitDepth, int sampleRate});
}

/// @nodoc
class __$$SpotubeAudioLosslessContainerQualityImplCopyWithImpl<$Res>
    extends _$SpotubeAudioLosslessContainerQualityCopyWithImpl<$Res,
        _$SpotubeAudioLosslessContainerQualityImpl>
    implements _$$SpotubeAudioLosslessContainerQualityImplCopyWith<$Res> {
  __$$SpotubeAudioLosslessContainerQualityImplCopyWithImpl(
      _$SpotubeAudioLosslessContainerQualityImpl _value,
      $Res Function(_$SpotubeAudioLosslessContainerQualityImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeAudioLosslessContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bitDepth = null,
    Object? sampleRate = null,
  }) {
    return _then(_$SpotubeAudioLosslessContainerQualityImpl(
      bitDepth: null == bitDepth
          ? _value.bitDepth
          : bitDepth // ignore: cast_nullable_to_non_nullable
              as int,
      sampleRate: null == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeAudioLosslessContainerQualityImpl
    extends _SpotubeAudioLosslessContainerQuality {
  _$SpotubeAudioLosslessContainerQualityImpl(
      {required this.bitDepth, required this.sampleRate})
      : super._();

  factory _$SpotubeAudioLosslessContainerQualityImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeAudioLosslessContainerQualityImplFromJson(json);

  @override
  final int bitDepth;
// bit
  @override
  final int sampleRate;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeAudioLosslessContainerQualityImpl &&
            (identical(other.bitDepth, bitDepth) ||
                other.bitDepth == bitDepth) &&
            (identical(other.sampleRate, sampleRate) ||
                other.sampleRate == sampleRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bitDepth, sampleRate);

  /// Create a copy of SpotubeAudioLosslessContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeAudioLosslessContainerQualityImplCopyWith<
          _$SpotubeAudioLosslessContainerQualityImpl>
      get copyWith => __$$SpotubeAudioLosslessContainerQualityImplCopyWithImpl<
          _$SpotubeAudioLosslessContainerQualityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeAudioLosslessContainerQualityImplToJson(
      this,
    );
  }
}

abstract class _SpotubeAudioLosslessContainerQuality
    extends SpotubeAudioLosslessContainerQuality {
  factory _SpotubeAudioLosslessContainerQuality(
          {required final int bitDepth, required final int sampleRate}) =
      _$SpotubeAudioLosslessContainerQualityImpl;
  _SpotubeAudioLosslessContainerQuality._() : super._();

  factory _SpotubeAudioLosslessContainerQuality.fromJson(
          Map<String, dynamic> json) =
      _$SpotubeAudioLosslessContainerQualityImpl.fromJson;

  @override
  int get bitDepth; // bit
  @override
  int get sampleRate;

  /// Create a copy of SpotubeAudioLosslessContainerQuality
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeAudioLosslessContainerQualityImplCopyWith<
          _$SpotubeAudioLosslessContainerQualityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeAudioSourceMatchObject _$SpotubeAudioSourceMatchObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeAudioSourceMatchObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeAudioSourceMatchObject {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get artists => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;

  /// Serializes this SpotubeAudioSourceMatchObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeAudioSourceMatchObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeAudioSourceMatchObjectCopyWith<SpotubeAudioSourceMatchObject>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeAudioSourceMatchObjectCopyWith<$Res> {
  factory $SpotubeAudioSourceMatchObjectCopyWith(
          SpotubeAudioSourceMatchObject value,
          $Res Function(SpotubeAudioSourceMatchObject) then) =
      _$SpotubeAudioSourceMatchObjectCopyWithImpl<$Res,
          SpotubeAudioSourceMatchObject>;
  @useResult
  $Res call(
      {String id,
      String title,
      List<String> artists,
      Duration duration,
      String? thumbnail,
      String externalUri});
}

/// @nodoc
class _$SpotubeAudioSourceMatchObjectCopyWithImpl<$Res,
        $Val extends SpotubeAudioSourceMatchObject>
    implements $SpotubeAudioSourceMatchObjectCopyWith<$Res> {
  _$SpotubeAudioSourceMatchObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeAudioSourceMatchObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artists = null,
    Object? duration = null,
    Object? thumbnail = freezed,
    Object? externalUri = null,
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
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeAudioSourceMatchObjectImplCopyWith<$Res>
    implements $SpotubeAudioSourceMatchObjectCopyWith<$Res> {
  factory _$$SpotubeAudioSourceMatchObjectImplCopyWith(
          _$SpotubeAudioSourceMatchObjectImpl value,
          $Res Function(_$SpotubeAudioSourceMatchObjectImpl) then) =
      __$$SpotubeAudioSourceMatchObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      List<String> artists,
      Duration duration,
      String? thumbnail,
      String externalUri});
}

/// @nodoc
class __$$SpotubeAudioSourceMatchObjectImplCopyWithImpl<$Res>
    extends _$SpotubeAudioSourceMatchObjectCopyWithImpl<$Res,
        _$SpotubeAudioSourceMatchObjectImpl>
    implements _$$SpotubeAudioSourceMatchObjectImplCopyWith<$Res> {
  __$$SpotubeAudioSourceMatchObjectImplCopyWithImpl(
      _$SpotubeAudioSourceMatchObjectImpl _value,
      $Res Function(_$SpotubeAudioSourceMatchObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeAudioSourceMatchObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? artists = null,
    Object? duration = null,
    Object? thumbnail = freezed,
    Object? externalUri = null,
  }) {
    return _then(_$SpotubeAudioSourceMatchObjectImpl(
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
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeAudioSourceMatchObjectImpl
    implements _SpotubeAudioSourceMatchObject {
  _$SpotubeAudioSourceMatchObjectImpl(
      {required this.id,
      required this.title,
      required final List<String> artists,
      required this.duration,
      this.thumbnail,
      required this.externalUri})
      : _artists = artists;

  factory _$SpotubeAudioSourceMatchObjectImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeAudioSourceMatchObjectImplFromJson(json);

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
  final Duration duration;
  @override
  final String? thumbnail;
  @override
  final String externalUri;

  @override
  String toString() {
    return 'SpotubeAudioSourceMatchObject(id: $id, title: $title, artists: $artists, duration: $duration, thumbnail: $thumbnail, externalUri: $externalUri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeAudioSourceMatchObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(_artists),
      duration,
      thumbnail,
      externalUri);

  /// Create a copy of SpotubeAudioSourceMatchObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeAudioSourceMatchObjectImplCopyWith<
          _$SpotubeAudioSourceMatchObjectImpl>
      get copyWith => __$$SpotubeAudioSourceMatchObjectImplCopyWithImpl<
          _$SpotubeAudioSourceMatchObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeAudioSourceMatchObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeAudioSourceMatchObject
    implements SpotubeAudioSourceMatchObject {
  factory _SpotubeAudioSourceMatchObject(
      {required final String id,
      required final String title,
      required final List<String> artists,
      required final Duration duration,
      final String? thumbnail,
      required final String externalUri}) = _$SpotubeAudioSourceMatchObjectImpl;

  factory _SpotubeAudioSourceMatchObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeAudioSourceMatchObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<String> get artists;
  @override
  Duration get duration;
  @override
  String? get thumbnail;
  @override
  String get externalUri;

  /// Create a copy of SpotubeAudioSourceMatchObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeAudioSourceMatchObjectImplCopyWith<
          _$SpotubeAudioSourceMatchObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeAudioSourceStreamObject _$SpotubeAudioSourceStreamObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeAudioSourceStreamObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeAudioSourceStreamObject {
  String get url => throw _privateConstructorUsedError;
  String get container => throw _privateConstructorUsedError;
  SpotubeMediaCompressionType get type => throw _privateConstructorUsedError;
  String? get codec => throw _privateConstructorUsedError;
  double? get bitrate => throw _privateConstructorUsedError;
  int? get bitDepth => throw _privateConstructorUsedError;
  double? get sampleRate => throw _privateConstructorUsedError;

  /// Serializes this SpotubeAudioSourceStreamObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeAudioSourceStreamObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeAudioSourceStreamObjectCopyWith<SpotubeAudioSourceStreamObject>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeAudioSourceStreamObjectCopyWith<$Res> {
  factory $SpotubeAudioSourceStreamObjectCopyWith(
          SpotubeAudioSourceStreamObject value,
          $Res Function(SpotubeAudioSourceStreamObject) then) =
      _$SpotubeAudioSourceStreamObjectCopyWithImpl<$Res,
          SpotubeAudioSourceStreamObject>;
  @useResult
  $Res call(
      {String url,
      String container,
      SpotubeMediaCompressionType type,
      String? codec,
      double? bitrate,
      int? bitDepth,
      double? sampleRate});
}

/// @nodoc
class _$SpotubeAudioSourceStreamObjectCopyWithImpl<$Res,
        $Val extends SpotubeAudioSourceStreamObject>
    implements $SpotubeAudioSourceStreamObjectCopyWith<$Res> {
  _$SpotubeAudioSourceStreamObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeAudioSourceStreamObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? container = null,
    Object? type = null,
    Object? codec = freezed,
    Object? bitrate = freezed,
    Object? bitDepth = freezed,
    Object? sampleRate = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      container: null == container
          ? _value.container
          : container // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SpotubeMediaCompressionType,
      codec: freezed == codec
          ? _value.codec
          : codec // ignore: cast_nullable_to_non_nullable
              as String?,
      bitrate: freezed == bitrate
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as double?,
      bitDepth: freezed == bitDepth
          ? _value.bitDepth
          : bitDepth // ignore: cast_nullable_to_non_nullable
              as int?,
      sampleRate: freezed == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeAudioSourceStreamObjectImplCopyWith<$Res>
    implements $SpotubeAudioSourceStreamObjectCopyWith<$Res> {
  factory _$$SpotubeAudioSourceStreamObjectImplCopyWith(
          _$SpotubeAudioSourceStreamObjectImpl value,
          $Res Function(_$SpotubeAudioSourceStreamObjectImpl) then) =
      __$$SpotubeAudioSourceStreamObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      String container,
      SpotubeMediaCompressionType type,
      String? codec,
      double? bitrate,
      int? bitDepth,
      double? sampleRate});
}

/// @nodoc
class __$$SpotubeAudioSourceStreamObjectImplCopyWithImpl<$Res>
    extends _$SpotubeAudioSourceStreamObjectCopyWithImpl<$Res,
        _$SpotubeAudioSourceStreamObjectImpl>
    implements _$$SpotubeAudioSourceStreamObjectImplCopyWith<$Res> {
  __$$SpotubeAudioSourceStreamObjectImplCopyWithImpl(
      _$SpotubeAudioSourceStreamObjectImpl _value,
      $Res Function(_$SpotubeAudioSourceStreamObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeAudioSourceStreamObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? container = null,
    Object? type = null,
    Object? codec = freezed,
    Object? bitrate = freezed,
    Object? bitDepth = freezed,
    Object? sampleRate = freezed,
  }) {
    return _then(_$SpotubeAudioSourceStreamObjectImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      container: null == container
          ? _value.container
          : container // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SpotubeMediaCompressionType,
      codec: freezed == codec
          ? _value.codec
          : codec // ignore: cast_nullable_to_non_nullable
              as String?,
      bitrate: freezed == bitrate
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as double?,
      bitDepth: freezed == bitDepth
          ? _value.bitDepth
          : bitDepth // ignore: cast_nullable_to_non_nullable
              as int?,
      sampleRate: freezed == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeAudioSourceStreamObjectImpl
    implements _SpotubeAudioSourceStreamObject {
  _$SpotubeAudioSourceStreamObjectImpl(
      {required this.url,
      required this.container,
      required this.type,
      this.codec,
      this.bitrate,
      this.bitDepth,
      this.sampleRate});

  factory _$SpotubeAudioSourceStreamObjectImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeAudioSourceStreamObjectImplFromJson(json);

  @override
  final String url;
  @override
  final String container;
  @override
  final SpotubeMediaCompressionType type;
  @override
  final String? codec;
  @override
  final double? bitrate;
  @override
  final int? bitDepth;
  @override
  final double? sampleRate;

  @override
  String toString() {
    return 'SpotubeAudioSourceStreamObject(url: $url, container: $container, type: $type, codec: $codec, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeAudioSourceStreamObjectImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.container, container) ||
                other.container == container) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.codec, codec) || other.codec == codec) &&
            (identical(other.bitrate, bitrate) || other.bitrate == bitrate) &&
            (identical(other.bitDepth, bitDepth) ||
                other.bitDepth == bitDepth) &&
            (identical(other.sampleRate, sampleRate) ||
                other.sampleRate == sampleRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, container, type, codec, bitrate, bitDepth, sampleRate);

  /// Create a copy of SpotubeAudioSourceStreamObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeAudioSourceStreamObjectImplCopyWith<
          _$SpotubeAudioSourceStreamObjectImpl>
      get copyWith => __$$SpotubeAudioSourceStreamObjectImplCopyWithImpl<
          _$SpotubeAudioSourceStreamObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeAudioSourceStreamObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeAudioSourceStreamObject
    implements SpotubeAudioSourceStreamObject {
  factory _SpotubeAudioSourceStreamObject(
      {required final String url,
      required final String container,
      required final SpotubeMediaCompressionType type,
      final String? codec,
      final double? bitrate,
      final int? bitDepth,
      final double? sampleRate}) = _$SpotubeAudioSourceStreamObjectImpl;

  factory _SpotubeAudioSourceStreamObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeAudioSourceStreamObjectImpl.fromJson;

  @override
  String get url;
  @override
  String get container;
  @override
  SpotubeMediaCompressionType get type;
  @override
  String? get codec;
  @override
  double? get bitrate;
  @override
  int? get bitDepth;
  @override
  double? get sampleRate;

  /// Create a copy of SpotubeAudioSourceStreamObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeAudioSourceStreamObjectImplCopyWith<
          _$SpotubeAudioSourceStreamObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeFullAlbumObject _$SpotubeFullAlbumObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeFullAlbumObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeFullAlbumObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<SpotubeSimpleArtistObject> get artists =>
      throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  String get releaseDate => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  int get totalTracks => throw _privateConstructorUsedError;
  SpotubeAlbumType get albumType => throw _privateConstructorUsedError;
  String? get recordLabel => throw _privateConstructorUsedError;
  List<String>? get genres => throw _privateConstructorUsedError;

  /// Serializes this SpotubeFullAlbumObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeFullAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeFullAlbumObjectCopyWith<SpotubeFullAlbumObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeFullAlbumObjectCopyWith<$Res> {
  factory $SpotubeFullAlbumObjectCopyWith(SpotubeFullAlbumObject value,
          $Res Function(SpotubeFullAlbumObject) then) =
      _$SpotubeFullAlbumObjectCopyWithImpl<$Res, SpotubeFullAlbumObject>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<SpotubeSimpleArtistObject> artists,
      List<SpotubeImageObject> images,
      String releaseDate,
      String externalUri,
      int totalTracks,
      SpotubeAlbumType albumType,
      String? recordLabel,
      List<String>? genres});
}

/// @nodoc
class _$SpotubeFullAlbumObjectCopyWithImpl<$Res,
        $Val extends SpotubeFullAlbumObject>
    implements $SpotubeFullAlbumObjectCopyWith<$Res> {
  _$SpotubeFullAlbumObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeFullAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artists = null,
    Object? images = null,
    Object? releaseDate = null,
    Object? externalUri = null,
    Object? totalTracks = null,
    Object? albumType = null,
    Object? recordLabel = freezed,
    Object? genres = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleArtistObject>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      totalTracks: null == totalTracks
          ? _value.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      albumType: null == albumType
          ? _value.albumType
          : albumType // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumType,
      recordLabel: freezed == recordLabel
          ? _value.recordLabel
          : recordLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      genres: freezed == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeFullAlbumObjectImplCopyWith<$Res>
    implements $SpotubeFullAlbumObjectCopyWith<$Res> {
  factory _$$SpotubeFullAlbumObjectImplCopyWith(
          _$SpotubeFullAlbumObjectImpl value,
          $Res Function(_$SpotubeFullAlbumObjectImpl) then) =
      __$$SpotubeFullAlbumObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<SpotubeSimpleArtistObject> artists,
      List<SpotubeImageObject> images,
      String releaseDate,
      String externalUri,
      int totalTracks,
      SpotubeAlbumType albumType,
      String? recordLabel,
      List<String>? genres});
}

/// @nodoc
class __$$SpotubeFullAlbumObjectImplCopyWithImpl<$Res>
    extends _$SpotubeFullAlbumObjectCopyWithImpl<$Res,
        _$SpotubeFullAlbumObjectImpl>
    implements _$$SpotubeFullAlbumObjectImplCopyWith<$Res> {
  __$$SpotubeFullAlbumObjectImplCopyWithImpl(
      _$SpotubeFullAlbumObjectImpl _value,
      $Res Function(_$SpotubeFullAlbumObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeFullAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? artists = null,
    Object? images = null,
    Object? releaseDate = null,
    Object? externalUri = null,
    Object? totalTracks = null,
    Object? albumType = null,
    Object? recordLabel = freezed,
    Object? genres = freezed,
  }) {
    return _then(_$SpotubeFullAlbumObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleArtistObject>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      totalTracks: null == totalTracks
          ? _value.totalTracks
          : totalTracks // ignore: cast_nullable_to_non_nullable
              as int,
      albumType: null == albumType
          ? _value.albumType
          : albumType // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumType,
      recordLabel: freezed == recordLabel
          ? _value.recordLabel
          : recordLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      genres: freezed == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeFullAlbumObjectImpl implements _SpotubeFullAlbumObject {
  _$SpotubeFullAlbumObjectImpl(
      {required this.id,
      required this.name,
      required final List<SpotubeSimpleArtistObject> artists,
      final List<SpotubeImageObject> images = const [],
      required this.releaseDate,
      required this.externalUri,
      required this.totalTracks,
      required this.albumType,
      this.recordLabel,
      final List<String>? genres})
      : _artists = artists,
        _images = images,
        _genres = genres;

  factory _$SpotubeFullAlbumObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeFullAlbumObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<SpotubeSimpleArtistObject> _artists;
  @override
  List<SpotubeSimpleArtistObject> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

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
  final String externalUri;
  @override
  final int totalTracks;
  @override
  final SpotubeAlbumType albumType;
  @override
  final String? recordLabel;
  final List<String>? _genres;
  @override
  List<String>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SpotubeFullAlbumObject(id: $id, name: $name, artists: $artists, images: $images, releaseDate: $releaseDate, externalUri: $externalUri, totalTracks: $totalTracks, albumType: $albumType, recordLabel: $recordLabel, genres: $genres)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeFullAlbumObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            (identical(other.totalTracks, totalTracks) ||
                other.totalTracks == totalTracks) &&
            (identical(other.albumType, albumType) ||
                other.albumType == albumType) &&
            (identical(other.recordLabel, recordLabel) ||
                other.recordLabel == recordLabel) &&
            const DeepCollectionEquality().equals(other._genres, _genres));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_artists),
      const DeepCollectionEquality().hash(_images),
      releaseDate,
      externalUri,
      totalTracks,
      albumType,
      recordLabel,
      const DeepCollectionEquality().hash(_genres));

  /// Create a copy of SpotubeFullAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeFullAlbumObjectImplCopyWith<_$SpotubeFullAlbumObjectImpl>
      get copyWith => __$$SpotubeFullAlbumObjectImplCopyWithImpl<
          _$SpotubeFullAlbumObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeFullAlbumObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeFullAlbumObject implements SpotubeFullAlbumObject {
  factory _SpotubeFullAlbumObject(
      {required final String id,
      required final String name,
      required final List<SpotubeSimpleArtistObject> artists,
      final List<SpotubeImageObject> images,
      required final String releaseDate,
      required final String externalUri,
      required final int totalTracks,
      required final SpotubeAlbumType albumType,
      final String? recordLabel,
      final List<String>? genres}) = _$SpotubeFullAlbumObjectImpl;

  factory _SpotubeFullAlbumObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeFullAlbumObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<SpotubeSimpleArtistObject> get artists;
  @override
  List<SpotubeImageObject> get images;
  @override
  String get releaseDate;
  @override
  String get externalUri;
  @override
  int get totalTracks;
  @override
  SpotubeAlbumType get albumType;
  @override
  String? get recordLabel;
  @override
  List<String>? get genres;

  /// Create a copy of SpotubeFullAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeFullAlbumObjectImplCopyWith<_$SpotubeFullAlbumObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeSimpleAlbumObject _$SpotubeSimpleAlbumObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeSimpleAlbumObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeSimpleAlbumObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  List<SpotubeSimpleArtistObject> get artists =>
      throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  SpotubeAlbumType get albumType => throw _privateConstructorUsedError;
  String? get releaseDate => throw _privateConstructorUsedError;

  /// Serializes this SpotubeSimpleAlbumObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeSimpleAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeSimpleAlbumObjectCopyWith<SpotubeSimpleAlbumObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeSimpleAlbumObjectCopyWith<$Res> {
  factory $SpotubeSimpleAlbumObjectCopyWith(SpotubeSimpleAlbumObject value,
          $Res Function(SpotubeSimpleAlbumObject) then) =
      _$SpotubeSimpleAlbumObjectCopyWithImpl<$Res, SpotubeSimpleAlbumObject>;
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeSimpleArtistObject> artists,
      List<SpotubeImageObject> images,
      SpotubeAlbumType albumType,
      String? releaseDate});
}

/// @nodoc
class _$SpotubeSimpleAlbumObjectCopyWithImpl<$Res,
        $Val extends SpotubeSimpleAlbumObject>
    implements $SpotubeSimpleAlbumObjectCopyWith<$Res> {
  _$SpotubeSimpleAlbumObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeSimpleAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? artists = null,
    Object? images = null,
    Object? albumType = null,
    Object? releaseDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleArtistObject>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      albumType: null == albumType
          ? _value.albumType
          : albumType // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumType,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeSimpleAlbumObjectImplCopyWith<$Res>
    implements $SpotubeSimpleAlbumObjectCopyWith<$Res> {
  factory _$$SpotubeSimpleAlbumObjectImplCopyWith(
          _$SpotubeSimpleAlbumObjectImpl value,
          $Res Function(_$SpotubeSimpleAlbumObjectImpl) then) =
      __$$SpotubeSimpleAlbumObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeSimpleArtistObject> artists,
      List<SpotubeImageObject> images,
      SpotubeAlbumType albumType,
      String? releaseDate});
}

/// @nodoc
class __$$SpotubeSimpleAlbumObjectImplCopyWithImpl<$Res>
    extends _$SpotubeSimpleAlbumObjectCopyWithImpl<$Res,
        _$SpotubeSimpleAlbumObjectImpl>
    implements _$$SpotubeSimpleAlbumObjectImplCopyWith<$Res> {
  __$$SpotubeSimpleAlbumObjectImplCopyWithImpl(
      _$SpotubeSimpleAlbumObjectImpl _value,
      $Res Function(_$SpotubeSimpleAlbumObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeSimpleAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? artists = null,
    Object? images = null,
    Object? albumType = null,
    Object? releaseDate = freezed,
  }) {
    return _then(_$SpotubeSimpleAlbumObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleArtistObject>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      albumType: null == albumType
          ? _value.albumType
          : albumType // ignore: cast_nullable_to_non_nullable
              as SpotubeAlbumType,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeSimpleAlbumObjectImpl implements _SpotubeSimpleAlbumObject {
  _$SpotubeSimpleAlbumObjectImpl(
      {required this.id,
      required this.name,
      required this.externalUri,
      required final List<SpotubeSimpleArtistObject> artists,
      final List<SpotubeImageObject> images = const [],
      required this.albumType,
      this.releaseDate})
      : _artists = artists,
        _images = images;

  factory _$SpotubeSimpleAlbumObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeSimpleAlbumObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String externalUri;
  final List<SpotubeSimpleArtistObject> _artists;
  @override
  List<SpotubeSimpleArtistObject> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  final List<SpotubeImageObject> _images;
  @override
  @JsonKey()
  List<SpotubeImageObject> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final SpotubeAlbumType albumType;
  @override
  final String? releaseDate;

  @override
  String toString() {
    return 'SpotubeSimpleAlbumObject(id: $id, name: $name, externalUri: $externalUri, artists: $artists, images: $images, albumType: $albumType, releaseDate: $releaseDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeSimpleAlbumObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.albumType, albumType) ||
                other.albumType == albumType) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      externalUri,
      const DeepCollectionEquality().hash(_artists),
      const DeepCollectionEquality().hash(_images),
      albumType,
      releaseDate);

  /// Create a copy of SpotubeSimpleAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeSimpleAlbumObjectImplCopyWith<_$SpotubeSimpleAlbumObjectImpl>
      get copyWith => __$$SpotubeSimpleAlbumObjectImplCopyWithImpl<
          _$SpotubeSimpleAlbumObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeSimpleAlbumObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeSimpleAlbumObject implements SpotubeSimpleAlbumObject {
  factory _SpotubeSimpleAlbumObject(
      {required final String id,
      required final String name,
      required final String externalUri,
      required final List<SpotubeSimpleArtistObject> artists,
      final List<SpotubeImageObject> images,
      required final SpotubeAlbumType albumType,
      final String? releaseDate}) = _$SpotubeSimpleAlbumObjectImpl;

  factory _SpotubeSimpleAlbumObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeSimpleAlbumObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get externalUri;
  @override
  List<SpotubeSimpleArtistObject> get artists;
  @override
  List<SpotubeImageObject> get images;
  @override
  SpotubeAlbumType get albumType;
  @override
  String? get releaseDate;

  /// Create a copy of SpotubeSimpleAlbumObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeSimpleAlbumObjectImplCopyWith<_$SpotubeSimpleAlbumObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeFullArtistObject _$SpotubeFullArtistObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeFullArtistObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeFullArtistObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  List<String>? get genres => throw _privateConstructorUsedError;
  int? get followers => throw _privateConstructorUsedError;

  /// Serializes this SpotubeFullArtistObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeFullArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeFullArtistObjectCopyWith<SpotubeFullArtistObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeFullArtistObjectCopyWith<$Res> {
  factory $SpotubeFullArtistObjectCopyWith(SpotubeFullArtistObject value,
          $Res Function(SpotubeFullArtistObject) then) =
      _$SpotubeFullArtistObjectCopyWithImpl<$Res, SpotubeFullArtistObject>;
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeImageObject> images,
      List<String>? genres,
      int? followers});
}

/// @nodoc
class _$SpotubeFullArtistObjectCopyWithImpl<$Res,
        $Val extends SpotubeFullArtistObject>
    implements $SpotubeFullArtistObjectCopyWith<$Res> {
  _$SpotubeFullArtistObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeFullArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? images = null,
    Object? genres = freezed,
    Object? followers = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      genres: freezed == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeFullArtistObjectImplCopyWith<$Res>
    implements $SpotubeFullArtistObjectCopyWith<$Res> {
  factory _$$SpotubeFullArtistObjectImplCopyWith(
          _$SpotubeFullArtistObjectImpl value,
          $Res Function(_$SpotubeFullArtistObjectImpl) then) =
      __$$SpotubeFullArtistObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeImageObject> images,
      List<String>? genres,
      int? followers});
}

/// @nodoc
class __$$SpotubeFullArtistObjectImplCopyWithImpl<$Res>
    extends _$SpotubeFullArtistObjectCopyWithImpl<$Res,
        _$SpotubeFullArtistObjectImpl>
    implements _$$SpotubeFullArtistObjectImplCopyWith<$Res> {
  __$$SpotubeFullArtistObjectImplCopyWithImpl(
      _$SpotubeFullArtistObjectImpl _value,
      $Res Function(_$SpotubeFullArtistObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeFullArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? images = null,
    Object? genres = freezed,
    Object? followers = freezed,
  }) {
    return _then(_$SpotubeFullArtistObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      genres: freezed == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeFullArtistObjectImpl implements _SpotubeFullArtistObject {
  _$SpotubeFullArtistObjectImpl(
      {required this.id,
      required this.name,
      required this.externalUri,
      final List<SpotubeImageObject> images = const [],
      final List<String>? genres,
      this.followers})
      : _images = images,
        _genres = genres;

  factory _$SpotubeFullArtistObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeFullArtistObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String externalUri;
  final List<SpotubeImageObject> _images;
  @override
  @JsonKey()
  List<SpotubeImageObject> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String>? _genres;
  @override
  List<String>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? followers;

  @override
  String toString() {
    return 'SpotubeFullArtistObject(id: $id, name: $name, externalUri: $externalUri, images: $images, genres: $genres, followers: $followers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeFullArtistObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.followers, followers) ||
                other.followers == followers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      externalUri,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_genres),
      followers);

  /// Create a copy of SpotubeFullArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeFullArtistObjectImplCopyWith<_$SpotubeFullArtistObjectImpl>
      get copyWith => __$$SpotubeFullArtistObjectImplCopyWithImpl<
          _$SpotubeFullArtistObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeFullArtistObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeFullArtistObject implements SpotubeFullArtistObject {
  factory _SpotubeFullArtistObject(
      {required final String id,
      required final String name,
      required final String externalUri,
      final List<SpotubeImageObject> images,
      final List<String>? genres,
      final int? followers}) = _$SpotubeFullArtistObjectImpl;

  factory _SpotubeFullArtistObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeFullArtistObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get externalUri;
  @override
  List<SpotubeImageObject> get images;
  @override
  List<String>? get genres;
  @override
  int? get followers;

  /// Create a copy of SpotubeFullArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeFullArtistObjectImplCopyWith<_$SpotubeFullArtistObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeSimpleArtistObject _$SpotubeSimpleArtistObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeSimpleArtistObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeSimpleArtistObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  List<SpotubeImageObject>? get images => throw _privateConstructorUsedError;

  /// Serializes this SpotubeSimpleArtistObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeSimpleArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeSimpleArtistObjectCopyWith<SpotubeSimpleArtistObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeSimpleArtistObjectCopyWith<$Res> {
  factory $SpotubeSimpleArtistObjectCopyWith(SpotubeSimpleArtistObject value,
          $Res Function(SpotubeSimpleArtistObject) then) =
      _$SpotubeSimpleArtistObjectCopyWithImpl<$Res, SpotubeSimpleArtistObject>;
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeImageObject>? images});
}

/// @nodoc
class _$SpotubeSimpleArtistObjectCopyWithImpl<$Res,
        $Val extends SpotubeSimpleArtistObject>
    implements $SpotubeSimpleArtistObjectCopyWith<$Res> {
  _$SpotubeSimpleArtistObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeSimpleArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeSimpleArtistObjectImplCopyWith<$Res>
    implements $SpotubeSimpleArtistObjectCopyWith<$Res> {
  factory _$$SpotubeSimpleArtistObjectImplCopyWith(
          _$SpotubeSimpleArtistObjectImpl value,
          $Res Function(_$SpotubeSimpleArtistObjectImpl) then) =
      __$$SpotubeSimpleArtistObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeImageObject>? images});
}

/// @nodoc
class __$$SpotubeSimpleArtistObjectImplCopyWithImpl<$Res>
    extends _$SpotubeSimpleArtistObjectCopyWithImpl<$Res,
        _$SpotubeSimpleArtistObjectImpl>
    implements _$$SpotubeSimpleArtistObjectImplCopyWith<$Res> {
  __$$SpotubeSimpleArtistObjectImplCopyWithImpl(
      _$SpotubeSimpleArtistObjectImpl _value,
      $Res Function(_$SpotubeSimpleArtistObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeSimpleArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? images = freezed,
  }) {
    return _then(_$SpotubeSimpleArtistObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeSimpleArtistObjectImpl implements _SpotubeSimpleArtistObject {
  _$SpotubeSimpleArtistObjectImpl(
      {required this.id,
      required this.name,
      required this.externalUri,
      final List<SpotubeImageObject>? images})
      : _images = images;

  factory _$SpotubeSimpleArtistObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeSimpleArtistObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String externalUri;
  final List<SpotubeImageObject>? _images;
  @override
  List<SpotubeImageObject>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SpotubeSimpleArtistObject(id: $id, name: $name, externalUri: $externalUri, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeSimpleArtistObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, externalUri,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of SpotubeSimpleArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeSimpleArtistObjectImplCopyWith<_$SpotubeSimpleArtistObjectImpl>
      get copyWith => __$$SpotubeSimpleArtistObjectImplCopyWithImpl<
          _$SpotubeSimpleArtistObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeSimpleArtistObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeSimpleArtistObject implements SpotubeSimpleArtistObject {
  factory _SpotubeSimpleArtistObject(
          {required final String id,
          required final String name,
          required final String externalUri,
          final List<SpotubeImageObject>? images}) =
      _$SpotubeSimpleArtistObjectImpl;

  factory _SpotubeSimpleArtistObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeSimpleArtistObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get externalUri;
  @override
  List<SpotubeImageObject>? get images;

  /// Create a copy of SpotubeSimpleArtistObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeSimpleArtistObjectImplCopyWith<_$SpotubeSimpleArtistObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeBrowseSectionObject<T> _$SpotubeBrowseSectionObjectFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _SpotubeBrowseSectionObject<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$SpotubeBrowseSectionObject<T> {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  bool get browseMore => throw _privateConstructorUsedError;
  List<T> get items => throw _privateConstructorUsedError;

  /// Serializes this SpotubeBrowseSectionObject to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of SpotubeBrowseSectionObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeBrowseSectionObjectCopyWith<T, SpotubeBrowseSectionObject<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeBrowseSectionObjectCopyWith<T, $Res> {
  factory $SpotubeBrowseSectionObjectCopyWith(
          SpotubeBrowseSectionObject<T> value,
          $Res Function(SpotubeBrowseSectionObject<T>) then) =
      _$SpotubeBrowseSectionObjectCopyWithImpl<T, $Res,
          SpotubeBrowseSectionObject<T>>;
  @useResult
  $Res call(
      {String id,
      String title,
      String externalUri,
      bool browseMore,
      List<T> items});
}

/// @nodoc
class _$SpotubeBrowseSectionObjectCopyWithImpl<T, $Res,
        $Val extends SpotubeBrowseSectionObject<T>>
    implements $SpotubeBrowseSectionObjectCopyWith<T, $Res> {
  _$SpotubeBrowseSectionObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeBrowseSectionObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? externalUri = null,
    Object? browseMore = null,
    Object? items = null,
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
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      browseMore: null == browseMore
          ? _value.browseMore
          : browseMore // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotubeBrowseSectionObjectImplCopyWith<T, $Res>
    implements $SpotubeBrowseSectionObjectCopyWith<T, $Res> {
  factory _$$SpotubeBrowseSectionObjectImplCopyWith(
          _$SpotubeBrowseSectionObjectImpl<T> value,
          $Res Function(_$SpotubeBrowseSectionObjectImpl<T>) then) =
      __$$SpotubeBrowseSectionObjectImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String externalUri,
      bool browseMore,
      List<T> items});
}

/// @nodoc
class __$$SpotubeBrowseSectionObjectImplCopyWithImpl<T, $Res>
    extends _$SpotubeBrowseSectionObjectCopyWithImpl<T, $Res,
        _$SpotubeBrowseSectionObjectImpl<T>>
    implements _$$SpotubeBrowseSectionObjectImplCopyWith<T, $Res> {
  __$$SpotubeBrowseSectionObjectImplCopyWithImpl(
      _$SpotubeBrowseSectionObjectImpl<T> _value,
      $Res Function(_$SpotubeBrowseSectionObjectImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeBrowseSectionObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? externalUri = null,
    Object? browseMore = null,
    Object? items = null,
  }) {
    return _then(_$SpotubeBrowseSectionObjectImpl<T>(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      browseMore: null == browseMore
          ? _value.browseMore
          : browseMore // ignore: cast_nullable_to_non_nullable
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
class _$SpotubeBrowseSectionObjectImpl<T>
    implements _SpotubeBrowseSectionObject<T> {
  _$SpotubeBrowseSectionObjectImpl(
      {required this.id,
      required this.title,
      required this.externalUri,
      required this.browseMore,
      required final List<T> items})
      : _items = items;

  factory _$SpotubeBrowseSectionObjectImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$SpotubeBrowseSectionObjectImplFromJson(json, fromJsonT);

  @override
  final String id;
  @override
  final String title;
  @override
  final String externalUri;
  @override
  final bool browseMore;
  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'SpotubeBrowseSectionObject<$T>(id: $id, title: $title, externalUri: $externalUri, browseMore: $browseMore, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeBrowseSectionObjectImpl<T> &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            (identical(other.browseMore, browseMore) ||
                other.browseMore == browseMore) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, externalUri,
      browseMore, const DeepCollectionEquality().hash(_items));

  /// Create a copy of SpotubeBrowseSectionObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeBrowseSectionObjectImplCopyWith<T,
          _$SpotubeBrowseSectionObjectImpl<T>>
      get copyWith => __$$SpotubeBrowseSectionObjectImplCopyWithImpl<T,
          _$SpotubeBrowseSectionObjectImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$SpotubeBrowseSectionObjectImplToJson<T>(this, toJsonT);
  }
}

abstract class _SpotubeBrowseSectionObject<T>
    implements SpotubeBrowseSectionObject<T> {
  factory _SpotubeBrowseSectionObject(
      {required final String id,
      required final String title,
      required final String externalUri,
      required final bool browseMore,
      required final List<T> items}) = _$SpotubeBrowseSectionObjectImpl<T>;

  factory _SpotubeBrowseSectionObject.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$SpotubeBrowseSectionObjectImpl<T>.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get externalUri;
  @override
  bool get browseMore;
  @override
  List<T> get items;

  /// Create a copy of SpotubeBrowseSectionObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeBrowseSectionObjectImplCopyWith<T,
          _$SpotubeBrowseSectionObjectImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

MetadataFormFieldObject _$MetadataFormFieldObjectFromJson(
    Map<String, dynamic> json) {
  switch (json['objectType']) {
    case 'input':
      return MetadataFormFieldInputObject.fromJson(json);
    case 'text':
      return MetadataFormFieldTextObject.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'objectType',
          'MetadataFormFieldObject',
          'Invalid union type "${json['objectType']}"!');
  }
}

/// @nodoc
mixin _$MetadataFormFieldObject {
  String get objectType => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)
        input,
    required TResult Function(String objectType, String text) text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)?
        input,
    TResult? Function(String objectType, String text)? text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)?
        input,
    TResult Function(String objectType, String text)? text,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataFormFieldInputObject value) input,
    required TResult Function(MetadataFormFieldTextObject value) text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataFormFieldInputObject value)? input,
    TResult? Function(MetadataFormFieldTextObject value)? text,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataFormFieldInputObject value)? input,
    TResult Function(MetadataFormFieldTextObject value)? text,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MetadataFormFieldObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataFormFieldObjectCopyWith<MetadataFormFieldObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataFormFieldObjectCopyWith<$Res> {
  factory $MetadataFormFieldObjectCopyWith(MetadataFormFieldObject value,
          $Res Function(MetadataFormFieldObject) then) =
      _$MetadataFormFieldObjectCopyWithImpl<$Res, MetadataFormFieldObject>;
  @useResult
  $Res call({String objectType});
}

/// @nodoc
class _$MetadataFormFieldObjectCopyWithImpl<$Res,
        $Val extends MetadataFormFieldObject>
    implements $MetadataFormFieldObjectCopyWith<$Res> {
  _$MetadataFormFieldObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectType = null,
  }) {
    return _then(_value.copyWith(
      objectType: null == objectType
          ? _value.objectType
          : objectType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetadataFormFieldInputObjectImplCopyWith<$Res>
    implements $MetadataFormFieldObjectCopyWith<$Res> {
  factory _$$MetadataFormFieldInputObjectImplCopyWith(
          _$MetadataFormFieldInputObjectImpl value,
          $Res Function(_$MetadataFormFieldInputObjectImpl) then) =
      __$$MetadataFormFieldInputObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String objectType,
      String id,
      FormFieldVariant variant,
      String? placeholder,
      String? defaultValue,
      bool? required,
      String? regex});
}

/// @nodoc
class __$$MetadataFormFieldInputObjectImplCopyWithImpl<$Res>
    extends _$MetadataFormFieldObjectCopyWithImpl<$Res,
        _$MetadataFormFieldInputObjectImpl>
    implements _$$MetadataFormFieldInputObjectImplCopyWith<$Res> {
  __$$MetadataFormFieldInputObjectImplCopyWithImpl(
      _$MetadataFormFieldInputObjectImpl _value,
      $Res Function(_$MetadataFormFieldInputObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectType = null,
    Object? id = null,
    Object? variant = null,
    Object? placeholder = freezed,
    Object? defaultValue = freezed,
    Object? required = freezed,
    Object? regex = freezed,
  }) {
    return _then(_$MetadataFormFieldInputObjectImpl(
      objectType: null == objectType
          ? _value.objectType
          : objectType // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      variant: null == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as FormFieldVariant,
      placeholder: freezed == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      required: freezed == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool?,
      regex: freezed == regex
          ? _value.regex
          : regex // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataFormFieldInputObjectImpl
    implements MetadataFormFieldInputObject {
  _$MetadataFormFieldInputObjectImpl(
      {required this.objectType,
      required this.id,
      this.variant = FormFieldVariant.text,
      this.placeholder,
      this.defaultValue,
      this.required,
      this.regex});

  factory _$MetadataFormFieldInputObjectImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MetadataFormFieldInputObjectImplFromJson(json);

  @override
  final String objectType;
  @override
  final String id;
  @override
  @JsonKey()
  final FormFieldVariant variant;
  @override
  final String? placeholder;
  @override
  final String? defaultValue;
  @override
  final bool? required;
  @override
  final String? regex;

  @override
  String toString() {
    return 'MetadataFormFieldObject.input(objectType: $objectType, id: $id, variant: $variant, placeholder: $placeholder, defaultValue: $defaultValue, required: $required, regex: $regex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataFormFieldInputObjectImpl &&
            (identical(other.objectType, objectType) ||
                other.objectType == objectType) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.regex, regex) || other.regex == regex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, objectType, id, variant,
      placeholder, defaultValue, required, regex);

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataFormFieldInputObjectImplCopyWith<
          _$MetadataFormFieldInputObjectImpl>
      get copyWith => __$$MetadataFormFieldInputObjectImplCopyWithImpl<
          _$MetadataFormFieldInputObjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)
        input,
    required TResult Function(String objectType, String text) text,
  }) {
    return input(
        objectType, id, variant, placeholder, defaultValue, required, regex);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)?
        input,
    TResult? Function(String objectType, String text)? text,
  }) {
    return input?.call(
        objectType, id, variant, placeholder, defaultValue, required, regex);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)?
        input,
    TResult Function(String objectType, String text)? text,
    required TResult orElse(),
  }) {
    if (input != null) {
      return input(
          objectType, id, variant, placeholder, defaultValue, required, regex);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataFormFieldInputObject value) input,
    required TResult Function(MetadataFormFieldTextObject value) text,
  }) {
    return input(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataFormFieldInputObject value)? input,
    TResult? Function(MetadataFormFieldTextObject value)? text,
  }) {
    return input?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataFormFieldInputObject value)? input,
    TResult Function(MetadataFormFieldTextObject value)? text,
    required TResult orElse(),
  }) {
    if (input != null) {
      return input(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataFormFieldInputObjectImplToJson(
      this,
    );
  }
}

abstract class MetadataFormFieldInputObject implements MetadataFormFieldObject {
  factory MetadataFormFieldInputObject(
      {required final String objectType,
      required final String id,
      final FormFieldVariant variant,
      final String? placeholder,
      final String? defaultValue,
      final bool? required,
      final String? regex}) = _$MetadataFormFieldInputObjectImpl;

  factory MetadataFormFieldInputObject.fromJson(Map<String, dynamic> json) =
      _$MetadataFormFieldInputObjectImpl.fromJson;

  @override
  String get objectType;
  String get id;
  FormFieldVariant get variant;
  String? get placeholder;
  String? get defaultValue;
  bool? get required;
  String? get regex;

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataFormFieldInputObjectImplCopyWith<
          _$MetadataFormFieldInputObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataFormFieldTextObjectImplCopyWith<$Res>
    implements $MetadataFormFieldObjectCopyWith<$Res> {
  factory _$$MetadataFormFieldTextObjectImplCopyWith(
          _$MetadataFormFieldTextObjectImpl value,
          $Res Function(_$MetadataFormFieldTextObjectImpl) then) =
      __$$MetadataFormFieldTextObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String objectType, String text});
}

/// @nodoc
class __$$MetadataFormFieldTextObjectImplCopyWithImpl<$Res>
    extends _$MetadataFormFieldObjectCopyWithImpl<$Res,
        _$MetadataFormFieldTextObjectImpl>
    implements _$$MetadataFormFieldTextObjectImplCopyWith<$Res> {
  __$$MetadataFormFieldTextObjectImplCopyWithImpl(
      _$MetadataFormFieldTextObjectImpl _value,
      $Res Function(_$MetadataFormFieldTextObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objectType = null,
    Object? text = null,
  }) {
    return _then(_$MetadataFormFieldTextObjectImpl(
      objectType: null == objectType
          ? _value.objectType
          : objectType // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataFormFieldTextObjectImpl implements MetadataFormFieldTextObject {
  _$MetadataFormFieldTextObjectImpl(
      {required this.objectType, required this.text});

  factory _$MetadataFormFieldTextObjectImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MetadataFormFieldTextObjectImplFromJson(json);

  @override
  final String objectType;
  @override
  final String text;

  @override
  String toString() {
    return 'MetadataFormFieldObject.text(objectType: $objectType, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataFormFieldTextObjectImpl &&
            (identical(other.objectType, objectType) ||
                other.objectType == objectType) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, objectType, text);

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataFormFieldTextObjectImplCopyWith<_$MetadataFormFieldTextObjectImpl>
      get copyWith => __$$MetadataFormFieldTextObjectImplCopyWithImpl<
          _$MetadataFormFieldTextObjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)
        input,
    required TResult Function(String objectType, String text) text,
  }) {
    return text(objectType, this.text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)?
        input,
    TResult? Function(String objectType, String text)? text,
  }) {
    return text?.call(objectType, this.text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String objectType,
            String id,
            FormFieldVariant variant,
            String? placeholder,
            String? defaultValue,
            bool? required,
            String? regex)?
        input,
    TResult Function(String objectType, String text)? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(objectType, this.text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataFormFieldInputObject value) input,
    required TResult Function(MetadataFormFieldTextObject value) text,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataFormFieldInputObject value)? input,
    TResult? Function(MetadataFormFieldTextObject value)? text,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataFormFieldInputObject value)? input,
    TResult Function(MetadataFormFieldTextObject value)? text,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataFormFieldTextObjectImplToJson(
      this,
    );
  }
}

abstract class MetadataFormFieldTextObject implements MetadataFormFieldObject {
  factory MetadataFormFieldTextObject(
      {required final String objectType,
      required final String text}) = _$MetadataFormFieldTextObjectImpl;

  factory MetadataFormFieldTextObject.fromJson(Map<String, dynamic> json) =
      _$MetadataFormFieldTextObjectImpl.fromJson;

  @override
  String get objectType;
  String get text;

  /// Create a copy of MetadataFormFieldObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataFormFieldTextObjectImplCopyWith<_$MetadataFormFieldTextObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeImageObject _$SpotubeImageObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeImageObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeImageObject {
  String get url => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;

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
  $Res call({String url, int? width, int? height});
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
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
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
  $Res call({String url, int? width, int? height});
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
    Object? width = freezed,
    Object? height = freezed,
  }) {
    return _then(_$SpotubeImageObjectImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeImageObjectImpl implements _SpotubeImageObject {
  _$SpotubeImageObjectImpl({required this.url, this.width, this.height});

  factory _$SpotubeImageObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeImageObjectImplFromJson(json);

  @override
  final String url;
  @override
  final int? width;
  @override
  final int? height;

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
      final int? width,
      final int? height}) = _$SpotubeImageObjectImpl;

  factory _SpotubeImageObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeImageObjectImpl.fromJson;

  @override
  String get url;
  @override
  int? get width;
  @override
  int? get height;

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
  int get limit => throw _privateConstructorUsedError;
  int? get nextOffset => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
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
      {int limit, int? nextOffset, int total, bool hasMore, List<T> items});
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
    Object? limit = null,
    Object? nextOffset = freezed,
    Object? total = null,
    Object? hasMore = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      nextOffset: freezed == nextOffset
          ? _value.nextOffset
          : nextOffset // ignore: cast_nullable_to_non_nullable
              as int?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
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
      {int limit, int? nextOffset, int total, bool hasMore, List<T> items});
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
    Object? limit = null,
    Object? nextOffset = freezed,
    Object? total = null,
    Object? hasMore = null,
    Object? items = null,
  }) {
    return _then(_$SpotubePaginationResponseObjectImpl<T>(
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      nextOffset: freezed == nextOffset
          ? _value.nextOffset
          : nextOffset // ignore: cast_nullable_to_non_nullable
              as int?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
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
      {required this.limit,
      required this.nextOffset,
      required this.total,
      required this.hasMore,
      required final List<T> items})
      : _items = items;

  factory _$SpotubePaginationResponseObjectImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$SpotubePaginationResponseObjectImplFromJson(json, fromJsonT);

  @override
  final int limit;
  @override
  final int? nextOffset;
  @override
  final int total;
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
    return 'SpotubePaginationResponseObject<$T>(limit: $limit, nextOffset: $nextOffset, total: $total, hasMore: $hasMore, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubePaginationResponseObjectImpl<T> &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.nextOffset, nextOffset) ||
                other.nextOffset == nextOffset) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, limit, nextOffset, total,
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
      {required final int limit,
      required final int? nextOffset,
      required final int total,
      required final bool hasMore,
      required final List<T> items}) = _$SpotubePaginationResponseObjectImpl<T>;

  factory _SpotubePaginationResponseObject.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$SpotubePaginationResponseObjectImpl<T>.fromJson;

  @override
  int get limit;
  @override
  int? get nextOffset;
  @override
  int get total;
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

SpotubeFullPlaylistObject _$SpotubeFullPlaylistObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeFullPlaylistObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeFullPlaylistObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  SpotubeUserObject get owner => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  List<SpotubeUserObject> get collaborators =>
      throw _privateConstructorUsedError;
  bool get collaborative => throw _privateConstructorUsedError;
  bool get public => throw _privateConstructorUsedError;

  /// Serializes this SpotubeFullPlaylistObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeFullPlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeFullPlaylistObjectCopyWith<SpotubeFullPlaylistObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeFullPlaylistObjectCopyWith<$Res> {
  factory $SpotubeFullPlaylistObjectCopyWith(SpotubeFullPlaylistObject value,
          $Res Function(SpotubeFullPlaylistObject) then) =
      _$SpotubeFullPlaylistObjectCopyWithImpl<$Res, SpotubeFullPlaylistObject>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String externalUri,
      SpotubeUserObject owner,
      List<SpotubeImageObject> images,
      List<SpotubeUserObject> collaborators,
      bool collaborative,
      bool public});

  $SpotubeUserObjectCopyWith<$Res> get owner;
}

/// @nodoc
class _$SpotubeFullPlaylistObjectCopyWithImpl<$Res,
        $Val extends SpotubeFullPlaylistObject>
    implements $SpotubeFullPlaylistObjectCopyWith<$Res> {
  _$SpotubeFullPlaylistObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeFullPlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? externalUri = null,
    Object? owner = null,
    Object? images = null,
    Object? collaborators = null,
    Object? collaborative = null,
    Object? public = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpotubeUserObject,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      collaborators: null == collaborators
          ? _value.collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<SpotubeUserObject>,
      collaborative: null == collaborative
          ? _value.collaborative
          : collaborative // ignore: cast_nullable_to_non_nullable
              as bool,
      public: null == public
          ? _value.public
          : public // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of SpotubeFullPlaylistObject
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
abstract class _$$SpotubeFullPlaylistObjectImplCopyWith<$Res>
    implements $SpotubeFullPlaylistObjectCopyWith<$Res> {
  factory _$$SpotubeFullPlaylistObjectImplCopyWith(
          _$SpotubeFullPlaylistObjectImpl value,
          $Res Function(_$SpotubeFullPlaylistObjectImpl) then) =
      __$$SpotubeFullPlaylistObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String externalUri,
      SpotubeUserObject owner,
      List<SpotubeImageObject> images,
      List<SpotubeUserObject> collaborators,
      bool collaborative,
      bool public});

  @override
  $SpotubeUserObjectCopyWith<$Res> get owner;
}

/// @nodoc
class __$$SpotubeFullPlaylistObjectImplCopyWithImpl<$Res>
    extends _$SpotubeFullPlaylistObjectCopyWithImpl<$Res,
        _$SpotubeFullPlaylistObjectImpl>
    implements _$$SpotubeFullPlaylistObjectImplCopyWith<$Res> {
  __$$SpotubeFullPlaylistObjectImplCopyWithImpl(
      _$SpotubeFullPlaylistObjectImpl _value,
      $Res Function(_$SpotubeFullPlaylistObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeFullPlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? externalUri = null,
    Object? owner = null,
    Object? images = null,
    Object? collaborators = null,
    Object? collaborative = null,
    Object? public = null,
  }) {
    return _then(_$SpotubeFullPlaylistObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpotubeUserObject,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      collaborators: null == collaborators
          ? _value._collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<SpotubeUserObject>,
      collaborative: null == collaborative
          ? _value.collaborative
          : collaborative // ignore: cast_nullable_to_non_nullable
              as bool,
      public: null == public
          ? _value.public
          : public // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeFullPlaylistObjectImpl implements _SpotubeFullPlaylistObject {
  _$SpotubeFullPlaylistObjectImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.externalUri,
      required this.owner,
      final List<SpotubeImageObject> images = const [],
      final List<SpotubeUserObject> collaborators = const [],
      this.collaborative = false,
      this.public = false})
      : _images = images,
        _collaborators = collaborators;

  factory _$SpotubeFullPlaylistObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeFullPlaylistObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String externalUri;
  @override
  final SpotubeUserObject owner;
  final List<SpotubeImageObject> _images;
  @override
  @JsonKey()
  List<SpotubeImageObject> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<SpotubeUserObject> _collaborators;
  @override
  @JsonKey()
  List<SpotubeUserObject> get collaborators {
    if (_collaborators is EqualUnmodifiableListView) return _collaborators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collaborators);
  }

  @override
  @JsonKey()
  final bool collaborative;
  @override
  @JsonKey()
  final bool public;

  @override
  String toString() {
    return 'SpotubeFullPlaylistObject(id: $id, name: $name, description: $description, externalUri: $externalUri, owner: $owner, images: $images, collaborators: $collaborators, collaborative: $collaborative, public: $public)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeFullPlaylistObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._collaborators, _collaborators) &&
            (identical(other.collaborative, collaborative) ||
                other.collaborative == collaborative) &&
            (identical(other.public, public) || other.public == public));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      externalUri,
      owner,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_collaborators),
      collaborative,
      public);

  /// Create a copy of SpotubeFullPlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeFullPlaylistObjectImplCopyWith<_$SpotubeFullPlaylistObjectImpl>
      get copyWith => __$$SpotubeFullPlaylistObjectImplCopyWithImpl<
          _$SpotubeFullPlaylistObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeFullPlaylistObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeFullPlaylistObject implements SpotubeFullPlaylistObject {
  factory _SpotubeFullPlaylistObject(
      {required final String id,
      required final String name,
      required final String description,
      required final String externalUri,
      required final SpotubeUserObject owner,
      final List<SpotubeImageObject> images,
      final List<SpotubeUserObject> collaborators,
      final bool collaborative,
      final bool public}) = _$SpotubeFullPlaylistObjectImpl;

  factory _SpotubeFullPlaylistObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeFullPlaylistObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get externalUri;
  @override
  SpotubeUserObject get owner;
  @override
  List<SpotubeImageObject> get images;
  @override
  List<SpotubeUserObject> get collaborators;
  @override
  bool get collaborative;
  @override
  bool get public;

  /// Create a copy of SpotubeFullPlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeFullPlaylistObjectImplCopyWith<_$SpotubeFullPlaylistObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeSimplePlaylistObject _$SpotubeSimplePlaylistObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeSimplePlaylistObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeSimplePlaylistObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  SpotubeUserObject get owner => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;

  /// Serializes this SpotubeSimplePlaylistObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpotubeSimplePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotubeSimplePlaylistObjectCopyWith<SpotubeSimplePlaylistObject>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotubeSimplePlaylistObjectCopyWith<$Res> {
  factory $SpotubeSimplePlaylistObjectCopyWith(
          SpotubeSimplePlaylistObject value,
          $Res Function(SpotubeSimplePlaylistObject) then) =
      _$SpotubeSimplePlaylistObjectCopyWithImpl<$Res,
          SpotubeSimplePlaylistObject>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String externalUri,
      SpotubeUserObject owner,
      List<SpotubeImageObject> images});

  $SpotubeUserObjectCopyWith<$Res> get owner;
}

/// @nodoc
class _$SpotubeSimplePlaylistObjectCopyWithImpl<$Res,
        $Val extends SpotubeSimplePlaylistObject>
    implements $SpotubeSimplePlaylistObjectCopyWith<$Res> {
  _$SpotubeSimplePlaylistObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpotubeSimplePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? externalUri = null,
    Object? owner = null,
    Object? images = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpotubeUserObject,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
    ) as $Val);
  }

  /// Create a copy of SpotubeSimplePlaylistObject
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
abstract class _$$SpotubeSimplePlaylistObjectImplCopyWith<$Res>
    implements $SpotubeSimplePlaylistObjectCopyWith<$Res> {
  factory _$$SpotubeSimplePlaylistObjectImplCopyWith(
          _$SpotubeSimplePlaylistObjectImpl value,
          $Res Function(_$SpotubeSimplePlaylistObjectImpl) then) =
      __$$SpotubeSimplePlaylistObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String externalUri,
      SpotubeUserObject owner,
      List<SpotubeImageObject> images});

  @override
  $SpotubeUserObjectCopyWith<$Res> get owner;
}

/// @nodoc
class __$$SpotubeSimplePlaylistObjectImplCopyWithImpl<$Res>
    extends _$SpotubeSimplePlaylistObjectCopyWithImpl<$Res,
        _$SpotubeSimplePlaylistObjectImpl>
    implements _$$SpotubeSimplePlaylistObjectImplCopyWith<$Res> {
  __$$SpotubeSimplePlaylistObjectImplCopyWithImpl(
      _$SpotubeSimplePlaylistObjectImpl _value,
      $Res Function(_$SpotubeSimplePlaylistObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeSimplePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? externalUri = null,
    Object? owner = null,
    Object? images = null,
  }) {
    return _then(_$SpotubeSimplePlaylistObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as SpotubeUserObject,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeSimplePlaylistObjectImpl
    implements _SpotubeSimplePlaylistObject {
  _$SpotubeSimplePlaylistObjectImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.externalUri,
      required this.owner,
      final List<SpotubeImageObject> images = const []})
      : _images = images;

  factory _$SpotubeSimplePlaylistObjectImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeSimplePlaylistObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String externalUri;
  @override
  final SpotubeUserObject owner;
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
    return 'SpotubeSimplePlaylistObject(id: $id, name: $name, description: $description, externalUri: $externalUri, owner: $owner, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeSimplePlaylistObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      externalUri, owner, const DeepCollectionEquality().hash(_images));

  /// Create a copy of SpotubeSimplePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeSimplePlaylistObjectImplCopyWith<_$SpotubeSimplePlaylistObjectImpl>
      get copyWith => __$$SpotubeSimplePlaylistObjectImplCopyWithImpl<
          _$SpotubeSimplePlaylistObjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeSimplePlaylistObjectImplToJson(
      this,
    );
  }
}

abstract class _SpotubeSimplePlaylistObject
    implements SpotubeSimplePlaylistObject {
  factory _SpotubeSimplePlaylistObject(
          {required final String id,
          required final String name,
          required final String description,
          required final String externalUri,
          required final SpotubeUserObject owner,
          final List<SpotubeImageObject> images}) =
      _$SpotubeSimplePlaylistObjectImpl;

  factory _SpotubeSimplePlaylistObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeSimplePlaylistObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get externalUri;
  @override
  SpotubeUserObject get owner;
  @override
  List<SpotubeImageObject> get images;

  /// Create a copy of SpotubeSimplePlaylistObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeSimplePlaylistObjectImplCopyWith<_$SpotubeSimplePlaylistObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeSearchResponseObject _$SpotubeSearchResponseObjectFromJson(
    Map<String, dynamic> json) {
  return _SpotubeSearchResponseObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeSearchResponseObject {
  List<SpotubeSimpleAlbumObject> get albums =>
      throw _privateConstructorUsedError;
  List<SpotubeFullArtistObject> get artists =>
      throw _privateConstructorUsedError;
  List<SpotubeSimplePlaylistObject> get playlists =>
      throw _privateConstructorUsedError;
  List<SpotubeFullTrackObject> get tracks => throw _privateConstructorUsedError;

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
      {List<SpotubeSimpleAlbumObject> albums,
      List<SpotubeFullArtistObject> artists,
      List<SpotubeSimplePlaylistObject> playlists,
      List<SpotubeFullTrackObject> tracks});
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
    Object? albums = null,
    Object? artists = null,
    Object? playlists = null,
    Object? tracks = null,
  }) {
    return _then(_value.copyWith(
      albums: null == albums
          ? _value.albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleAlbumObject>,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeFullArtistObject>,
      playlists: null == playlists
          ? _value.playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimplePlaylistObject>,
      tracks: null == tracks
          ? _value.tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as List<SpotubeFullTrackObject>,
    ) as $Val);
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
      {List<SpotubeSimpleAlbumObject> albums,
      List<SpotubeFullArtistObject> artists,
      List<SpotubeSimplePlaylistObject> playlists,
      List<SpotubeFullTrackObject> tracks});
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
    Object? albums = null,
    Object? artists = null,
    Object? playlists = null,
    Object? tracks = null,
  }) {
    return _then(_$SpotubeSearchResponseObjectImpl(
      albums: null == albums
          ? _value._albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleAlbumObject>,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeFullArtistObject>,
      playlists: null == playlists
          ? _value._playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimplePlaylistObject>,
      tracks: null == tracks
          ? _value._tracks
          : tracks // ignore: cast_nullable_to_non_nullable
              as List<SpotubeFullTrackObject>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeSearchResponseObjectImpl
    implements _SpotubeSearchResponseObject {
  _$SpotubeSearchResponseObjectImpl(
      {required final List<SpotubeSimpleAlbumObject> albums,
      required final List<SpotubeFullArtistObject> artists,
      required final List<SpotubeSimplePlaylistObject> playlists,
      required final List<SpotubeFullTrackObject> tracks})
      : _albums = albums,
        _artists = artists,
        _playlists = playlists,
        _tracks = tracks;

  factory _$SpotubeSearchResponseObjectImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpotubeSearchResponseObjectImplFromJson(json);

  final List<SpotubeSimpleAlbumObject> _albums;
  @override
  List<SpotubeSimpleAlbumObject> get albums {
    if (_albums is EqualUnmodifiableListView) return _albums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_albums);
  }

  final List<SpotubeFullArtistObject> _artists;
  @override
  List<SpotubeFullArtistObject> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  final List<SpotubeSimplePlaylistObject> _playlists;
  @override
  List<SpotubeSimplePlaylistObject> get playlists {
    if (_playlists is EqualUnmodifiableListView) return _playlists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playlists);
  }

  final List<SpotubeFullTrackObject> _tracks;
  @override
  List<SpotubeFullTrackObject> get tracks {
    if (_tracks is EqualUnmodifiableListView) return _tracks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tracks);
  }

  @override
  String toString() {
    return 'SpotubeSearchResponseObject(albums: $albums, artists: $artists, playlists: $playlists, tracks: $tracks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeSearchResponseObjectImpl &&
            const DeepCollectionEquality().equals(other._albums, _albums) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            const DeepCollectionEquality()
                .equals(other._playlists, _playlists) &&
            const DeepCollectionEquality().equals(other._tracks, _tracks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_albums),
      const DeepCollectionEquality().hash(_artists),
      const DeepCollectionEquality().hash(_playlists),
      const DeepCollectionEquality().hash(_tracks));

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
          {required final List<SpotubeSimpleAlbumObject> albums,
          required final List<SpotubeFullArtistObject> artists,
          required final List<SpotubeSimplePlaylistObject> playlists,
          required final List<SpotubeFullTrackObject> tracks}) =
      _$SpotubeSearchResponseObjectImpl;

  factory _SpotubeSearchResponseObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeSearchResponseObjectImpl.fromJson;

  @override
  List<SpotubeSimpleAlbumObject> get albums;
  @override
  List<SpotubeFullArtistObject> get artists;
  @override
  List<SpotubeSimplePlaylistObject> get playlists;
  @override
  List<SpotubeFullTrackObject> get tracks;

  /// Create a copy of SpotubeSearchResponseObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeSearchResponseObjectImplCopyWith<_$SpotubeSearchResponseObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeTrackObject _$SpotubeTrackObjectFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'local':
      return SpotubeLocalTrackObject.fromJson(json);
    case 'full':
      return SpotubeFullTrackObject.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'SpotubeTrackObject',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$SpotubeTrackObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;
  List<SpotubeSimpleArtistObject> get artists =>
      throw _privateConstructorUsedError;
  SpotubeSimpleAlbumObject get album => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)
        local,
    required TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)
        full,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)?
        local,
    TResult? Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)?
        full,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)?
        local,
    TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)?
        full,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpotubeLocalTrackObject value) local,
    required TResult Function(SpotubeFullTrackObject value) full,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpotubeLocalTrackObject value)? local,
    TResult? Function(SpotubeFullTrackObject value)? full,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpotubeLocalTrackObject value)? local,
    TResult Function(SpotubeFullTrackObject value)? full,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

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
      {String id,
      String name,
      String externalUri,
      List<SpotubeSimpleArtistObject> artists,
      SpotubeSimpleAlbumObject album,
      int durationMs});

  $SpotubeSimpleAlbumObjectCopyWith<$Res> get album;
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
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? artists = null,
    Object? album = null,
    Object? durationMs = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleArtistObject>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotubeSimpleAlbumObject,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotubeSimpleAlbumObjectCopyWith<$Res> get album {
    return $SpotubeSimpleAlbumObjectCopyWith<$Res>(_value.album, (value) {
      return _then(_value.copyWith(album: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpotubeLocalTrackObjectImplCopyWith<$Res>
    implements $SpotubeTrackObjectCopyWith<$Res> {
  factory _$$SpotubeLocalTrackObjectImplCopyWith(
          _$SpotubeLocalTrackObjectImpl value,
          $Res Function(_$SpotubeLocalTrackObjectImpl) then) =
      __$$SpotubeLocalTrackObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeSimpleArtistObject> artists,
      SpotubeSimpleAlbumObject album,
      int durationMs,
      String path});

  @override
  $SpotubeSimpleAlbumObjectCopyWith<$Res> get album;
}

/// @nodoc
class __$$SpotubeLocalTrackObjectImplCopyWithImpl<$Res>
    extends _$SpotubeTrackObjectCopyWithImpl<$Res,
        _$SpotubeLocalTrackObjectImpl>
    implements _$$SpotubeLocalTrackObjectImplCopyWith<$Res> {
  __$$SpotubeLocalTrackObjectImplCopyWithImpl(
      _$SpotubeLocalTrackObjectImpl _value,
      $Res Function(_$SpotubeLocalTrackObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? artists = null,
    Object? album = null,
    Object? durationMs = null,
    Object? path = null,
  }) {
    return _then(_$SpotubeLocalTrackObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleArtistObject>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotubeSimpleAlbumObject,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeLocalTrackObjectImpl implements SpotubeLocalTrackObject {
  _$SpotubeLocalTrackObjectImpl(
      {required this.id,
      required this.name,
      required this.externalUri,
      final List<SpotubeSimpleArtistObject> artists = const [],
      required this.album,
      required this.durationMs,
      required this.path,
      final String? $type})
      : _artists = artists,
        $type = $type ?? 'local';

  factory _$SpotubeLocalTrackObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeLocalTrackObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String externalUri;
  final List<SpotubeSimpleArtistObject> _artists;
  @override
  @JsonKey()
  List<SpotubeSimpleArtistObject> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  @override
  final SpotubeSimpleAlbumObject album;
  @override
  final int durationMs;
  @override
  final String path;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SpotubeTrackObject.local(id: $id, name: $name, externalUri: $externalUri, artists: $artists, album: $album, durationMs: $durationMs, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeLocalTrackObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.path, path) || other.path == path));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, externalUri,
      const DeepCollectionEquality().hash(_artists), album, durationMs, path);

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeLocalTrackObjectImplCopyWith<_$SpotubeLocalTrackObjectImpl>
      get copyWith => __$$SpotubeLocalTrackObjectImplCopyWithImpl<
          _$SpotubeLocalTrackObjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)
        local,
    required TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)
        full,
  }) {
    return local(id, name, externalUri, artists, album, durationMs, path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)?
        local,
    TResult? Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)?
        full,
  }) {
    return local?.call(id, name, externalUri, artists, album, durationMs, path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)?
        local,
    TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)?
        full,
    required TResult orElse(),
  }) {
    if (local != null) {
      return local(id, name, externalUri, artists, album, durationMs, path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpotubeLocalTrackObject value) local,
    required TResult Function(SpotubeFullTrackObject value) full,
  }) {
    return local(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpotubeLocalTrackObject value)? local,
    TResult? Function(SpotubeFullTrackObject value)? full,
  }) {
    return local?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpotubeLocalTrackObject value)? local,
    TResult Function(SpotubeFullTrackObject value)? full,
    required TResult orElse(),
  }) {
    if (local != null) {
      return local(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeLocalTrackObjectImplToJson(
      this,
    );
  }
}

abstract class SpotubeLocalTrackObject implements SpotubeTrackObject {
  factory SpotubeLocalTrackObject(
      {required final String id,
      required final String name,
      required final String externalUri,
      final List<SpotubeSimpleArtistObject> artists,
      required final SpotubeSimpleAlbumObject album,
      required final int durationMs,
      required final String path}) = _$SpotubeLocalTrackObjectImpl;

  factory SpotubeLocalTrackObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeLocalTrackObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get externalUri;
  @override
  List<SpotubeSimpleArtistObject> get artists;
  @override
  SpotubeSimpleAlbumObject get album;
  @override
  int get durationMs;
  String get path;

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeLocalTrackObjectImplCopyWith<_$SpotubeLocalTrackObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpotubeFullTrackObjectImplCopyWith<$Res>
    implements $SpotubeTrackObjectCopyWith<$Res> {
  factory _$$SpotubeFullTrackObjectImplCopyWith(
          _$SpotubeFullTrackObjectImpl value,
          $Res Function(_$SpotubeFullTrackObjectImpl) then) =
      __$$SpotubeFullTrackObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String externalUri,
      List<SpotubeSimpleArtistObject> artists,
      SpotubeSimpleAlbumObject album,
      int durationMs,
      String isrc,
      bool explicit});

  @override
  $SpotubeSimpleAlbumObjectCopyWith<$Res> get album;
}

/// @nodoc
class __$$SpotubeFullTrackObjectImplCopyWithImpl<$Res>
    extends _$SpotubeTrackObjectCopyWithImpl<$Res, _$SpotubeFullTrackObjectImpl>
    implements _$$SpotubeFullTrackObjectImplCopyWith<$Res> {
  __$$SpotubeFullTrackObjectImplCopyWithImpl(
      _$SpotubeFullTrackObjectImpl _value,
      $Res Function(_$SpotubeFullTrackObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? externalUri = null,
    Object? artists = null,
    Object? album = null,
    Object? durationMs = null,
    Object? isrc = null,
    Object? explicit = null,
  }) {
    return _then(_$SpotubeFullTrackObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotubeSimpleArtistObject>,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotubeSimpleAlbumObject,
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
class _$SpotubeFullTrackObjectImpl implements SpotubeFullTrackObject {
  _$SpotubeFullTrackObjectImpl(
      {required this.id,
      required this.name,
      required this.externalUri,
      final List<SpotubeSimpleArtistObject> artists = const [],
      required this.album,
      required this.durationMs,
      required this.isrc,
      required this.explicit,
      final String? $type})
      : _artists = artists,
        $type = $type ?? 'full';

  factory _$SpotubeFullTrackObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeFullTrackObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String externalUri;
  final List<SpotubeSimpleArtistObject> _artists;
  @override
  @JsonKey()
  List<SpotubeSimpleArtistObject> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  @override
  final SpotubeSimpleAlbumObject album;
  @override
  final int durationMs;
  @override
  final String isrc;
  @override
  final bool explicit;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SpotubeTrackObject.full(id: $id, name: $name, externalUri: $externalUri, artists: $artists, album: $album, durationMs: $durationMs, isrc: $isrc, explicit: $explicit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeFullTrackObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri) &&
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
      name,
      externalUri,
      const DeepCollectionEquality().hash(_artists),
      album,
      durationMs,
      isrc,
      explicit);

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotubeFullTrackObjectImplCopyWith<_$SpotubeFullTrackObjectImpl>
      get copyWith => __$$SpotubeFullTrackObjectImplCopyWithImpl<
          _$SpotubeFullTrackObjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)
        local,
    required TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)
        full,
  }) {
    return full(
        id, name, externalUri, artists, album, durationMs, isrc, explicit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)?
        local,
    TResult? Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)?
        full,
  }) {
    return full?.call(
        id, name, externalUri, artists, album, durationMs, isrc, explicit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String path)?
        local,
    TResult Function(
            String id,
            String name,
            String externalUri,
            List<SpotubeSimpleArtistObject> artists,
            SpotubeSimpleAlbumObject album,
            int durationMs,
            String isrc,
            bool explicit)?
        full,
    required TResult orElse(),
  }) {
    if (full != null) {
      return full(
          id, name, externalUri, artists, album, durationMs, isrc, explicit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpotubeLocalTrackObject value) local,
    required TResult Function(SpotubeFullTrackObject value) full,
  }) {
    return full(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpotubeLocalTrackObject value)? local,
    TResult? Function(SpotubeFullTrackObject value)? full,
  }) {
    return full?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpotubeLocalTrackObject value)? local,
    TResult Function(SpotubeFullTrackObject value)? full,
    required TResult orElse(),
  }) {
    if (full != null) {
      return full(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotubeFullTrackObjectImplToJson(
      this,
    );
  }
}

abstract class SpotubeFullTrackObject implements SpotubeTrackObject {
  factory SpotubeFullTrackObject(
      {required final String id,
      required final String name,
      required final String externalUri,
      final List<SpotubeSimpleArtistObject> artists,
      required final SpotubeSimpleAlbumObject album,
      required final int durationMs,
      required final String isrc,
      required final bool explicit}) = _$SpotubeFullTrackObjectImpl;

  factory SpotubeFullTrackObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeFullTrackObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get externalUri;
  @override
  List<SpotubeSimpleArtistObject> get artists;
  @override
  SpotubeSimpleAlbumObject get album;
  @override
  int get durationMs;
  String get isrc;
  bool get explicit;

  /// Create a copy of SpotubeTrackObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotubeFullTrackObjectImplCopyWith<_$SpotubeFullTrackObjectImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SpotubeUserObject _$SpotubeUserObjectFromJson(Map<String, dynamic> json) {
  return _SpotubeUserObject.fromJson(json);
}

/// @nodoc
mixin _$SpotubeUserObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<SpotubeImageObject> get images => throw _privateConstructorUsedError;
  String get externalUri => throw _privateConstructorUsedError;

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
      {String id,
      String name,
      List<SpotubeImageObject> images,
      String externalUri});
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
    Object? id = null,
    Object? name = null,
    Object? images = null,
    Object? externalUri = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
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
      {String id,
      String name,
      List<SpotubeImageObject> images,
      String externalUri});
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
    Object? id = null,
    Object? name = null,
    Object? images = null,
    Object? externalUri = null,
  }) {
    return _then(_$SpotubeUserObjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotubeImageObject>,
      externalUri: null == externalUri
          ? _value.externalUri
          : externalUri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotubeUserObjectImpl implements _SpotubeUserObject {
  _$SpotubeUserObjectImpl(
      {required this.id,
      required this.name,
      final List<SpotubeImageObject> images = const [],
      required this.externalUri})
      : _images = images;

  factory _$SpotubeUserObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotubeUserObjectImplFromJson(json);

  @override
  final String id;
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
  final String externalUri;

  @override
  String toString() {
    return 'SpotubeUserObject(id: $id, name: $name, images: $images, externalUri: $externalUri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotubeUserObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.externalUri, externalUri) ||
                other.externalUri == externalUri));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      const DeepCollectionEquality().hash(_images), externalUri);

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
      {required final String id,
      required final String name,
      final List<SpotubeImageObject> images,
      required final String externalUri}) = _$SpotubeUserObjectImpl;

  factory _SpotubeUserObject.fromJson(Map<String, dynamic> json) =
      _$SpotubeUserObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<SpotubeImageObject> get images;
  @override
  String get externalUri;

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
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get entryPoint => throw _privateConstructorUsedError;
  String get pluginApiVersion => throw _privateConstructorUsedError;
  List<PluginApis> get apis => throw _privateConstructorUsedError;
  List<PluginAbilities> get abilities => throw _privateConstructorUsedError;
  String? get repository => throw _privateConstructorUsedError;

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
      {String name,
      String description,
      String version,
      String author,
      String entryPoint,
      String pluginApiVersion,
      List<PluginApis> apis,
      List<PluginAbilities> abilities,
      String? repository});
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
    Object? name = null,
    Object? description = null,
    Object? version = null,
    Object? author = null,
    Object? entryPoint = null,
    Object? pluginApiVersion = null,
    Object? apis = null,
    Object? abilities = null,
    Object? repository = freezed,
  }) {
    return _then(_value.copyWith(
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
      pluginApiVersion: null == pluginApiVersion
          ? _value.pluginApiVersion
          : pluginApiVersion // ignore: cast_nullable_to_non_nullable
              as String,
      apis: null == apis
          ? _value.apis
          : apis // ignore: cast_nullable_to_non_nullable
              as List<PluginApis>,
      abilities: null == abilities
          ? _value.abilities
          : abilities // ignore: cast_nullable_to_non_nullable
              as List<PluginAbilities>,
      repository: freezed == repository
          ? _value.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String name,
      String description,
      String version,
      String author,
      String entryPoint,
      String pluginApiVersion,
      List<PluginApis> apis,
      List<PluginAbilities> abilities,
      String? repository});
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
    Object? name = null,
    Object? description = null,
    Object? version = null,
    Object? author = null,
    Object? entryPoint = null,
    Object? pluginApiVersion = null,
    Object? apis = null,
    Object? abilities = null,
    Object? repository = freezed,
  }) {
    return _then(_$PluginConfigurationImpl(
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
      pluginApiVersion: null == pluginApiVersion
          ? _value.pluginApiVersion
          : pluginApiVersion // ignore: cast_nullable_to_non_nullable
              as String,
      apis: null == apis
          ? _value._apis
          : apis // ignore: cast_nullable_to_non_nullable
              as List<PluginApis>,
      abilities: null == abilities
          ? _value._abilities
          : abilities // ignore: cast_nullable_to_non_nullable
              as List<PluginAbilities>,
      repository: freezed == repository
          ? _value.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PluginConfigurationImpl extends _PluginConfiguration {
  _$PluginConfigurationImpl(
      {required this.name,
      required this.description,
      required this.version,
      required this.author,
      required this.entryPoint,
      required this.pluginApiVersion,
      final List<PluginApis> apis = const [],
      final List<PluginAbilities> abilities = const [],
      this.repository})
      : _apis = apis,
        _abilities = abilities,
        super._();

  factory _$PluginConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PluginConfigurationImplFromJson(json);

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
  @override
  final String pluginApiVersion;
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
  final String? repository;

  @override
  String toString() {
    return 'PluginConfiguration(name: $name, description: $description, version: $version, author: $author, entryPoint: $entryPoint, pluginApiVersion: $pluginApiVersion, apis: $apis, abilities: $abilities, repository: $repository)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PluginConfigurationImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.entryPoint, entryPoint) ||
                other.entryPoint == entryPoint) &&
            (identical(other.pluginApiVersion, pluginApiVersion) ||
                other.pluginApiVersion == pluginApiVersion) &&
            const DeepCollectionEquality().equals(other._apis, _apis) &&
            const DeepCollectionEquality()
                .equals(other._abilities, _abilities) &&
            (identical(other.repository, repository) ||
                other.repository == repository));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      version,
      author,
      entryPoint,
      pluginApiVersion,
      const DeepCollectionEquality().hash(_apis),
      const DeepCollectionEquality().hash(_abilities),
      repository);

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
      {required final String name,
      required final String description,
      required final String version,
      required final String author,
      required final String entryPoint,
      required final String pluginApiVersion,
      final List<PluginApis> apis,
      final List<PluginAbilities> abilities,
      final String? repository}) = _$PluginConfigurationImpl;
  _PluginConfiguration._() : super._();

  factory _PluginConfiguration.fromJson(Map<String, dynamic> json) =
      _$PluginConfigurationImpl.fromJson;

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
  String get pluginApiVersion;
  @override
  List<PluginApis> get apis;
  @override
  List<PluginAbilities> get abilities;
  @override
  String? get repository;

  /// Create a copy of PluginConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PluginConfigurationImplCopyWith<_$PluginConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PluginUpdateAvailable _$PluginUpdateAvailableFromJson(
    Map<String, dynamic> json) {
  return _PluginUpdateAvailable.fromJson(json);
}

/// @nodoc
mixin _$PluginUpdateAvailable {
  String get downloadUrl => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String? get changelog => throw _privateConstructorUsedError;

  /// Serializes this PluginUpdateAvailable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PluginUpdateAvailable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PluginUpdateAvailableCopyWith<PluginUpdateAvailable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PluginUpdateAvailableCopyWith<$Res> {
  factory $PluginUpdateAvailableCopyWith(PluginUpdateAvailable value,
          $Res Function(PluginUpdateAvailable) then) =
      _$PluginUpdateAvailableCopyWithImpl<$Res, PluginUpdateAvailable>;
  @useResult
  $Res call({String downloadUrl, String version, String? changelog});
}

/// @nodoc
class _$PluginUpdateAvailableCopyWithImpl<$Res,
        $Val extends PluginUpdateAvailable>
    implements $PluginUpdateAvailableCopyWith<$Res> {
  _$PluginUpdateAvailableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PluginUpdateAvailable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? downloadUrl = null,
    Object? version = null,
    Object? changelog = freezed,
  }) {
    return _then(_value.copyWith(
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      changelog: freezed == changelog
          ? _value.changelog
          : changelog // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PluginUpdateAvailableImplCopyWith<$Res>
    implements $PluginUpdateAvailableCopyWith<$Res> {
  factory _$$PluginUpdateAvailableImplCopyWith(
          _$PluginUpdateAvailableImpl value,
          $Res Function(_$PluginUpdateAvailableImpl) then) =
      __$$PluginUpdateAvailableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String downloadUrl, String version, String? changelog});
}

/// @nodoc
class __$$PluginUpdateAvailableImplCopyWithImpl<$Res>
    extends _$PluginUpdateAvailableCopyWithImpl<$Res,
        _$PluginUpdateAvailableImpl>
    implements _$$PluginUpdateAvailableImplCopyWith<$Res> {
  __$$PluginUpdateAvailableImplCopyWithImpl(_$PluginUpdateAvailableImpl _value,
      $Res Function(_$PluginUpdateAvailableImpl) _then)
      : super(_value, _then);

  /// Create a copy of PluginUpdateAvailable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? downloadUrl = null,
    Object? version = null,
    Object? changelog = freezed,
  }) {
    return _then(_$PluginUpdateAvailableImpl(
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      changelog: freezed == changelog
          ? _value.changelog
          : changelog // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PluginUpdateAvailableImpl implements _PluginUpdateAvailable {
  _$PluginUpdateAvailableImpl(
      {required this.downloadUrl, required this.version, this.changelog});

  factory _$PluginUpdateAvailableImpl.fromJson(Map<String, dynamic> json) =>
      _$$PluginUpdateAvailableImplFromJson(json);

  @override
  final String downloadUrl;
  @override
  final String version;
  @override
  final String? changelog;

  @override
  String toString() {
    return 'PluginUpdateAvailable(downloadUrl: $downloadUrl, version: $version, changelog: $changelog)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PluginUpdateAvailableImpl &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.changelog, changelog) ||
                other.changelog == changelog));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, downloadUrl, version, changelog);

  /// Create a copy of PluginUpdateAvailable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PluginUpdateAvailableImplCopyWith<_$PluginUpdateAvailableImpl>
      get copyWith => __$$PluginUpdateAvailableImplCopyWithImpl<
          _$PluginUpdateAvailableImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PluginUpdateAvailableImplToJson(
      this,
    );
  }
}

abstract class _PluginUpdateAvailable implements PluginUpdateAvailable {
  factory _PluginUpdateAvailable(
      {required final String downloadUrl,
      required final String version,
      final String? changelog}) = _$PluginUpdateAvailableImpl;

  factory _PluginUpdateAvailable.fromJson(Map<String, dynamic> json) =
      _$PluginUpdateAvailableImpl.fromJson;

  @override
  String get downloadUrl;
  @override
  String get version;
  @override
  String? get changelog;

  /// Create a copy of PluginUpdateAvailable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PluginUpdateAvailableImplCopyWith<_$PluginUpdateAvailableImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MetadataPluginRepository _$MetadataPluginRepositoryFromJson(
    Map<String, dynamic> json) {
  return _MetadataPluginRepository.fromJson(json);
}

/// @nodoc
mixin _$MetadataPluginRepository {
  String get name => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get repoUrl => throw _privateConstructorUsedError;
  List<String> get topics => throw _privateConstructorUsedError;

  /// Serializes this MetadataPluginRepository to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetadataPluginRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataPluginRepositoryCopyWith<MetadataPluginRepository> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataPluginRepositoryCopyWith<$Res> {
  factory $MetadataPluginRepositoryCopyWith(MetadataPluginRepository value,
          $Res Function(MetadataPluginRepository) then) =
      _$MetadataPluginRepositoryCopyWithImpl<$Res, MetadataPluginRepository>;
  @useResult
  $Res call(
      {String name,
      String owner,
      String description,
      String repoUrl,
      List<String> topics});
}

/// @nodoc
class _$MetadataPluginRepositoryCopyWithImpl<$Res,
        $Val extends MetadataPluginRepository>
    implements $MetadataPluginRepositoryCopyWith<$Res> {
  _$MetadataPluginRepositoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataPluginRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? owner = null,
    Object? description = null,
    Object? repoUrl = null,
    Object? topics = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      repoUrl: null == repoUrl
          ? _value.repoUrl
          : repoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetadataPluginRepositoryImplCopyWith<$Res>
    implements $MetadataPluginRepositoryCopyWith<$Res> {
  factory _$$MetadataPluginRepositoryImplCopyWith(
          _$MetadataPluginRepositoryImpl value,
          $Res Function(_$MetadataPluginRepositoryImpl) then) =
      __$$MetadataPluginRepositoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String owner,
      String description,
      String repoUrl,
      List<String> topics});
}

/// @nodoc
class __$$MetadataPluginRepositoryImplCopyWithImpl<$Res>
    extends _$MetadataPluginRepositoryCopyWithImpl<$Res,
        _$MetadataPluginRepositoryImpl>
    implements _$$MetadataPluginRepositoryImplCopyWith<$Res> {
  __$$MetadataPluginRepositoryImplCopyWithImpl(
      _$MetadataPluginRepositoryImpl _value,
      $Res Function(_$MetadataPluginRepositoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetadataPluginRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? owner = null,
    Object? description = null,
    Object? repoUrl = null,
    Object? topics = null,
  }) {
    return _then(_$MetadataPluginRepositoryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      repoUrl: null == repoUrl
          ? _value.repoUrl
          : repoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataPluginRepositoryImpl implements _MetadataPluginRepository {
  _$MetadataPluginRepositoryImpl(
      {required this.name,
      required this.owner,
      required this.description,
      required this.repoUrl,
      required final List<String> topics})
      : _topics = topics;

  factory _$MetadataPluginRepositoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataPluginRepositoryImplFromJson(json);

  @override
  final String name;
  @override
  final String owner;
  @override
  final String description;
  @override
  final String repoUrl;
  final List<String> _topics;
  @override
  List<String> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  String toString() {
    return 'MetadataPluginRepository(name: $name, owner: $owner, description: $description, repoUrl: $repoUrl, topics: $topics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataPluginRepositoryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.repoUrl, repoUrl) || other.repoUrl == repoUrl) &&
            const DeepCollectionEquality().equals(other._topics, _topics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, owner, description,
      repoUrl, const DeepCollectionEquality().hash(_topics));

  /// Create a copy of MetadataPluginRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataPluginRepositoryImplCopyWith<_$MetadataPluginRepositoryImpl>
      get copyWith => __$$MetadataPluginRepositoryImplCopyWithImpl<
          _$MetadataPluginRepositoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataPluginRepositoryImplToJson(
      this,
    );
  }
}

abstract class _MetadataPluginRepository implements MetadataPluginRepository {
  factory _MetadataPluginRepository(
      {required final String name,
      required final String owner,
      required final String description,
      required final String repoUrl,
      required final List<String> topics}) = _$MetadataPluginRepositoryImpl;

  factory _MetadataPluginRepository.fromJson(Map<String, dynamic> json) =
      _$MetadataPluginRepositoryImpl.fromJson;

  @override
  String get name;
  @override
  String get owner;
  @override
  String get description;
  @override
  String get repoUrl;
  @override
  List<String> get topics;

  /// Create a copy of MetadataPluginRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataPluginRepositoryImplCopyWith<_$MetadataPluginRepositoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
