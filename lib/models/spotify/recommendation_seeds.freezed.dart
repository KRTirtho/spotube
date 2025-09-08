// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_seeds.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GeneratePlaylistProviderInput {
  Iterable<String>? get seedArtists => throw _privateConstructorUsedError;
  Iterable<String>? get seedGenres => throw _privateConstructorUsedError;
  Iterable<String>? get seedTracks => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  RecommendationSeeds? get max => throw _privateConstructorUsedError;
  RecommendationSeeds? get min => throw _privateConstructorUsedError;
  RecommendationSeeds? get target => throw _privateConstructorUsedError;

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneratePlaylistProviderInputCopyWith<GeneratePlaylistProviderInput>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratePlaylistProviderInputCopyWith<$Res> {
  factory $GeneratePlaylistProviderInputCopyWith(
          GeneratePlaylistProviderInput value,
          $Res Function(GeneratePlaylistProviderInput) then) =
      _$GeneratePlaylistProviderInputCopyWithImpl<$Res,
          GeneratePlaylistProviderInput>;
  @useResult
  $Res call(
      {Iterable<String>? seedArtists,
      Iterable<String>? seedGenres,
      Iterable<String>? seedTracks,
      int limit,
      RecommendationSeeds? max,
      RecommendationSeeds? min,
      RecommendationSeeds? target});

  $RecommendationSeedsCopyWith<$Res>? get max;
  $RecommendationSeedsCopyWith<$Res>? get min;
  $RecommendationSeedsCopyWith<$Res>? get target;
}

/// @nodoc
class _$GeneratePlaylistProviderInputCopyWithImpl<$Res,
        $Val extends GeneratePlaylistProviderInput>
    implements $GeneratePlaylistProviderInputCopyWith<$Res> {
  _$GeneratePlaylistProviderInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seedArtists = freezed,
    Object? seedGenres = freezed,
    Object? seedTracks = freezed,
    Object? limit = null,
    Object? max = freezed,
    Object? min = freezed,
    Object? target = freezed,
  }) {
    return _then(_value.copyWith(
      seedArtists: freezed == seedArtists
          ? _value.seedArtists
          : seedArtists // ignore: cast_nullable_to_non_nullable
              as Iterable<String>?,
      seedGenres: freezed == seedGenres
          ? _value.seedGenres
          : seedGenres // ignore: cast_nullable_to_non_nullable
              as Iterable<String>?,
      seedTracks: freezed == seedTracks
          ? _value.seedTracks
          : seedTracks // ignore: cast_nullable_to_non_nullable
              as Iterable<String>?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as RecommendationSeeds?,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as RecommendationSeeds?,
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as RecommendationSeeds?,
    ) as $Val);
  }

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationSeedsCopyWith<$Res>? get max {
    if (_value.max == null) {
      return null;
    }

    return $RecommendationSeedsCopyWith<$Res>(_value.max!, (value) {
      return _then(_value.copyWith(max: value) as $Val);
    });
  }

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationSeedsCopyWith<$Res>? get min {
    if (_value.min == null) {
      return null;
    }

    return $RecommendationSeedsCopyWith<$Res>(_value.min!, (value) {
      return _then(_value.copyWith(min: value) as $Val);
    });
  }

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecommendationSeedsCopyWith<$Res>? get target {
    if (_value.target == null) {
      return null;
    }

    return $RecommendationSeedsCopyWith<$Res>(_value.target!, (value) {
      return _then(_value.copyWith(target: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GeneratePlaylistProviderInputImplCopyWith<$Res>
    implements $GeneratePlaylistProviderInputCopyWith<$Res> {
  factory _$$GeneratePlaylistProviderInputImplCopyWith(
          _$GeneratePlaylistProviderInputImpl value,
          $Res Function(_$GeneratePlaylistProviderInputImpl) then) =
      __$$GeneratePlaylistProviderInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Iterable<String>? seedArtists,
      Iterable<String>? seedGenres,
      Iterable<String>? seedTracks,
      int limit,
      RecommendationSeeds? max,
      RecommendationSeeds? min,
      RecommendationSeeds? target});

  @override
  $RecommendationSeedsCopyWith<$Res>? get max;
  @override
  $RecommendationSeedsCopyWith<$Res>? get min;
  @override
  $RecommendationSeedsCopyWith<$Res>? get target;
}

/// @nodoc
class __$$GeneratePlaylistProviderInputImplCopyWithImpl<$Res>
    extends _$GeneratePlaylistProviderInputCopyWithImpl<$Res,
        _$GeneratePlaylistProviderInputImpl>
    implements _$$GeneratePlaylistProviderInputImplCopyWith<$Res> {
  __$$GeneratePlaylistProviderInputImplCopyWithImpl(
      _$GeneratePlaylistProviderInputImpl _value,
      $Res Function(_$GeneratePlaylistProviderInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seedArtists = freezed,
    Object? seedGenres = freezed,
    Object? seedTracks = freezed,
    Object? limit = null,
    Object? max = freezed,
    Object? min = freezed,
    Object? target = freezed,
  }) {
    return _then(_$GeneratePlaylistProviderInputImpl(
      seedArtists: freezed == seedArtists
          ? _value.seedArtists
          : seedArtists // ignore: cast_nullable_to_non_nullable
              as Iterable<String>?,
      seedGenres: freezed == seedGenres
          ? _value.seedGenres
          : seedGenres // ignore: cast_nullable_to_non_nullable
              as Iterable<String>?,
      seedTracks: freezed == seedTracks
          ? _value.seedTracks
          : seedTracks // ignore: cast_nullable_to_non_nullable
              as Iterable<String>?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as RecommendationSeeds?,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as RecommendationSeeds?,
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as RecommendationSeeds?,
    ));
  }
}

/// @nodoc

class _$GeneratePlaylistProviderInputImpl
    implements _GeneratePlaylistProviderInput {
  _$GeneratePlaylistProviderInputImpl(
      {this.seedArtists,
      this.seedGenres,
      this.seedTracks,
      required this.limit,
      this.max,
      this.min,
      this.target});

  @override
  final Iterable<String>? seedArtists;
  @override
  final Iterable<String>? seedGenres;
  @override
  final Iterable<String>? seedTracks;
  @override
  final int limit;
  @override
  final RecommendationSeeds? max;
  @override
  final RecommendationSeeds? min;
  @override
  final RecommendationSeeds? target;

  @override
  String toString() {
    return 'GeneratePlaylistProviderInput(seedArtists: $seedArtists, seedGenres: $seedGenres, seedTracks: $seedTracks, limit: $limit, max: $max, min: $min, target: $target)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratePlaylistProviderInputImpl &&
            const DeepCollectionEquality()
                .equals(other.seedArtists, seedArtists) &&
            const DeepCollectionEquality()
                .equals(other.seedGenres, seedGenres) &&
            const DeepCollectionEquality()
                .equals(other.seedTracks, seedTracks) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.target, target) || other.target == target));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(seedArtists),
      const DeepCollectionEquality().hash(seedGenres),
      const DeepCollectionEquality().hash(seedTracks),
      limit,
      max,
      min,
      target);

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratePlaylistProviderInputImplCopyWith<
          _$GeneratePlaylistProviderInputImpl>
      get copyWith => __$$GeneratePlaylistProviderInputImplCopyWithImpl<
          _$GeneratePlaylistProviderInputImpl>(this, _$identity);
}

abstract class _GeneratePlaylistProviderInput
    implements GeneratePlaylistProviderInput {
  factory _GeneratePlaylistProviderInput(
      {final Iterable<String>? seedArtists,
      final Iterable<String>? seedGenres,
      final Iterable<String>? seedTracks,
      required final int limit,
      final RecommendationSeeds? max,
      final RecommendationSeeds? min,
      final RecommendationSeeds? target}) = _$GeneratePlaylistProviderInputImpl;

  @override
  Iterable<String>? get seedArtists;
  @override
  Iterable<String>? get seedGenres;
  @override
  Iterable<String>? get seedTracks;
  @override
  int get limit;
  @override
  RecommendationSeeds? get max;
  @override
  RecommendationSeeds? get min;
  @override
  RecommendationSeeds? get target;

  /// Create a copy of GeneratePlaylistProviderInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneratePlaylistProviderInputImplCopyWith<
          _$GeneratePlaylistProviderInputImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RecommendationSeeds _$RecommendationSeedsFromJson(Map<String, dynamic> json) {
  return _RecommendationSeeds.fromJson(json);
}

/// @nodoc
mixin _$RecommendationSeeds {
  num? get acousticness => throw _privateConstructorUsedError;
  num? get danceability => throw _privateConstructorUsedError;
  @JsonKey(name: "duration_ms")
  num? get durationMs => throw _privateConstructorUsedError;
  num? get energy => throw _privateConstructorUsedError;
  num? get instrumentalness => throw _privateConstructorUsedError;
  num? get key => throw _privateConstructorUsedError;
  num? get liveness => throw _privateConstructorUsedError;
  num? get loudness => throw _privateConstructorUsedError;
  num? get mode => throw _privateConstructorUsedError;
  num? get popularity => throw _privateConstructorUsedError;
  num? get speechiness => throw _privateConstructorUsedError;
  num? get tempo => throw _privateConstructorUsedError;
  @JsonKey(name: "time_signature")
  num? get timeSignature => throw _privateConstructorUsedError;
  num? get valence => throw _privateConstructorUsedError;

  /// Serializes this RecommendationSeeds to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationSeeds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationSeedsCopyWith<RecommendationSeeds> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationSeedsCopyWith<$Res> {
  factory $RecommendationSeedsCopyWith(
          RecommendationSeeds value, $Res Function(RecommendationSeeds) then) =
      _$RecommendationSeedsCopyWithImpl<$Res, RecommendationSeeds>;
  @useResult
  $Res call(
      {num? acousticness,
      num? danceability,
      @JsonKey(name: "duration_ms") num? durationMs,
      num? energy,
      num? instrumentalness,
      num? key,
      num? liveness,
      num? loudness,
      num? mode,
      num? popularity,
      num? speechiness,
      num? tempo,
      @JsonKey(name: "time_signature") num? timeSignature,
      num? valence});
}

/// @nodoc
class _$RecommendationSeedsCopyWithImpl<$Res, $Val extends RecommendationSeeds>
    implements $RecommendationSeedsCopyWith<$Res> {
  _$RecommendationSeedsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationSeeds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acousticness = freezed,
    Object? danceability = freezed,
    Object? durationMs = freezed,
    Object? energy = freezed,
    Object? instrumentalness = freezed,
    Object? key = freezed,
    Object? liveness = freezed,
    Object? loudness = freezed,
    Object? mode = freezed,
    Object? popularity = freezed,
    Object? speechiness = freezed,
    Object? tempo = freezed,
    Object? timeSignature = freezed,
    Object? valence = freezed,
  }) {
    return _then(_value.copyWith(
      acousticness: freezed == acousticness
          ? _value.acousticness
          : acousticness // ignore: cast_nullable_to_non_nullable
              as num?,
      danceability: freezed == danceability
          ? _value.danceability
          : danceability // ignore: cast_nullable_to_non_nullable
              as num?,
      durationMs: freezed == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as num?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as num?,
      instrumentalness: freezed == instrumentalness
          ? _value.instrumentalness
          : instrumentalness // ignore: cast_nullable_to_non_nullable
              as num?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as num?,
      liveness: freezed == liveness
          ? _value.liveness
          : liveness // ignore: cast_nullable_to_non_nullable
              as num?,
      loudness: freezed == loudness
          ? _value.loudness
          : loudness // ignore: cast_nullable_to_non_nullable
              as num?,
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as num?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as num?,
      speechiness: freezed == speechiness
          ? _value.speechiness
          : speechiness // ignore: cast_nullable_to_non_nullable
              as num?,
      tempo: freezed == tempo
          ? _value.tempo
          : tempo // ignore: cast_nullable_to_non_nullable
              as num?,
      timeSignature: freezed == timeSignature
          ? _value.timeSignature
          : timeSignature // ignore: cast_nullable_to_non_nullable
              as num?,
      valence: freezed == valence
          ? _value.valence
          : valence // ignore: cast_nullable_to_non_nullable
              as num?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationSeedsImplCopyWith<$Res>
    implements $RecommendationSeedsCopyWith<$Res> {
  factory _$$RecommendationSeedsImplCopyWith(_$RecommendationSeedsImpl value,
          $Res Function(_$RecommendationSeedsImpl) then) =
      __$$RecommendationSeedsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {num? acousticness,
      num? danceability,
      @JsonKey(name: "duration_ms") num? durationMs,
      num? energy,
      num? instrumentalness,
      num? key,
      num? liveness,
      num? loudness,
      num? mode,
      num? popularity,
      num? speechiness,
      num? tempo,
      @JsonKey(name: "time_signature") num? timeSignature,
      num? valence});
}

/// @nodoc
class __$$RecommendationSeedsImplCopyWithImpl<$Res>
    extends _$RecommendationSeedsCopyWithImpl<$Res, _$RecommendationSeedsImpl>
    implements _$$RecommendationSeedsImplCopyWith<$Res> {
  __$$RecommendationSeedsImplCopyWithImpl(_$RecommendationSeedsImpl _value,
      $Res Function(_$RecommendationSeedsImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationSeeds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acousticness = freezed,
    Object? danceability = freezed,
    Object? durationMs = freezed,
    Object? energy = freezed,
    Object? instrumentalness = freezed,
    Object? key = freezed,
    Object? liveness = freezed,
    Object? loudness = freezed,
    Object? mode = freezed,
    Object? popularity = freezed,
    Object? speechiness = freezed,
    Object? tempo = freezed,
    Object? timeSignature = freezed,
    Object? valence = freezed,
  }) {
    return _then(_$RecommendationSeedsImpl(
      acousticness: freezed == acousticness
          ? _value.acousticness
          : acousticness // ignore: cast_nullable_to_non_nullable
              as num?,
      danceability: freezed == danceability
          ? _value.danceability
          : danceability // ignore: cast_nullable_to_non_nullable
              as num?,
      durationMs: freezed == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as num?,
      energy: freezed == energy
          ? _value.energy
          : energy // ignore: cast_nullable_to_non_nullable
              as num?,
      instrumentalness: freezed == instrumentalness
          ? _value.instrumentalness
          : instrumentalness // ignore: cast_nullable_to_non_nullable
              as num?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as num?,
      liveness: freezed == liveness
          ? _value.liveness
          : liveness // ignore: cast_nullable_to_non_nullable
              as num?,
      loudness: freezed == loudness
          ? _value.loudness
          : loudness // ignore: cast_nullable_to_non_nullable
              as num?,
      mode: freezed == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as num?,
      popularity: freezed == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as num?,
      speechiness: freezed == speechiness
          ? _value.speechiness
          : speechiness // ignore: cast_nullable_to_non_nullable
              as num?,
      tempo: freezed == tempo
          ? _value.tempo
          : tempo // ignore: cast_nullable_to_non_nullable
              as num?,
      timeSignature: freezed == timeSignature
          ? _value.timeSignature
          : timeSignature // ignore: cast_nullable_to_non_nullable
              as num?,
      valence: freezed == valence
          ? _value.valence
          : valence // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationSeedsImpl implements _RecommendationSeeds {
  _$RecommendationSeedsImpl(
      {this.acousticness,
      this.danceability,
      @JsonKey(name: "duration_ms") this.durationMs,
      this.energy,
      this.instrumentalness,
      this.key,
      this.liveness,
      this.loudness,
      this.mode,
      this.popularity,
      this.speechiness,
      this.tempo,
      @JsonKey(name: "time_signature") this.timeSignature,
      this.valence});

  factory _$RecommendationSeedsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationSeedsImplFromJson(json);

  @override
  final num? acousticness;
  @override
  final num? danceability;
  @override
  @JsonKey(name: "duration_ms")
  final num? durationMs;
  @override
  final num? energy;
  @override
  final num? instrumentalness;
  @override
  final num? key;
  @override
  final num? liveness;
  @override
  final num? loudness;
  @override
  final num? mode;
  @override
  final num? popularity;
  @override
  final num? speechiness;
  @override
  final num? tempo;
  @override
  @JsonKey(name: "time_signature")
  final num? timeSignature;
  @override
  final num? valence;

  @override
  String toString() {
    return 'RecommendationSeeds(acousticness: $acousticness, danceability: $danceability, durationMs: $durationMs, energy: $energy, instrumentalness: $instrumentalness, key: $key, liveness: $liveness, loudness: $loudness, mode: $mode, popularity: $popularity, speechiness: $speechiness, tempo: $tempo, timeSignature: $timeSignature, valence: $valence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationSeedsImpl &&
            (identical(other.acousticness, acousticness) ||
                other.acousticness == acousticness) &&
            (identical(other.danceability, danceability) ||
                other.danceability == danceability) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.energy, energy) || other.energy == energy) &&
            (identical(other.instrumentalness, instrumentalness) ||
                other.instrumentalness == instrumentalness) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.liveness, liveness) ||
                other.liveness == liveness) &&
            (identical(other.loudness, loudness) ||
                other.loudness == loudness) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.speechiness, speechiness) ||
                other.speechiness == speechiness) &&
            (identical(other.tempo, tempo) || other.tempo == tempo) &&
            (identical(other.timeSignature, timeSignature) ||
                other.timeSignature == timeSignature) &&
            (identical(other.valence, valence) || other.valence == valence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      acousticness,
      danceability,
      durationMs,
      energy,
      instrumentalness,
      key,
      liveness,
      loudness,
      mode,
      popularity,
      speechiness,
      tempo,
      timeSignature,
      valence);

  /// Create a copy of RecommendationSeeds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationSeedsImplCopyWith<_$RecommendationSeedsImpl> get copyWith =>
      __$$RecommendationSeedsImplCopyWithImpl<_$RecommendationSeedsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationSeedsImplToJson(
      this,
    );
  }
}

abstract class _RecommendationSeeds implements RecommendationSeeds {
  factory _RecommendationSeeds(
      {final num? acousticness,
      final num? danceability,
      @JsonKey(name: "duration_ms") final num? durationMs,
      final num? energy,
      final num? instrumentalness,
      final num? key,
      final num? liveness,
      final num? loudness,
      final num? mode,
      final num? popularity,
      final num? speechiness,
      final num? tempo,
      @JsonKey(name: "time_signature") final num? timeSignature,
      final num? valence}) = _$RecommendationSeedsImpl;

  factory _RecommendationSeeds.fromJson(Map<String, dynamic> json) =
      _$RecommendationSeedsImpl.fromJson;

  @override
  num? get acousticness;
  @override
  num? get danceability;
  @override
  @JsonKey(name: "duration_ms")
  num? get durationMs;
  @override
  num? get energy;
  @override
  num? get instrumentalness;
  @override
  num? get key;
  @override
  num? get liveness;
  @override
  num? get loudness;
  @override
  num? get mode;
  @override
  num? get popularity;
  @override
  num? get speechiness;
  @override
  num? get tempo;
  @override
  @JsonKey(name: "time_signature")
  num? get timeSignature;
  @override
  num? get valence;

  /// Create a copy of RecommendationSeeds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationSeedsImplCopyWith<_$RecommendationSeedsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
