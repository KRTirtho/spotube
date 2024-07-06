// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adapters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  SourceQualities get audioQuality => throw _privateConstructorUsedError;
  bool get albumColorSync => throw _privateConstructorUsedError;
  bool get amoledDarkTheme => throw _privateConstructorUsedError;
  bool get checkUpdate => throw _privateConstructorUsedError;
  bool get normalizeAudio => throw _privateConstructorUsedError;
  bool get showSystemTrayIcon => throw _privateConstructorUsedError;
  bool get skipNonMusic => throw _privateConstructorUsedError;
  bool get systemTitleBar => throw _privateConstructorUsedError;
  CloseBehavior get closeBehavior => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: UserPreferences._accentColorSchemeFromJson,
      toJson: UserPreferences._accentColorSchemeToJson,
      readValue: UserPreferences._accentColorSchemeReadValue)
  SpotubeColor get accentColorScheme => throw _privateConstructorUsedError;
  LayoutMode get layoutMode => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: UserPreferences._localeFromJson,
      toJson: UserPreferences._localeToJson,
      readValue: UserPreferences._localeReadValue)
  Locale get locale => throw _privateConstructorUsedError;
  Market get recommendationMarket => throw _privateConstructorUsedError;
  SearchMode get searchMode => throw _privateConstructorUsedError;
  String get downloadLocation => throw _privateConstructorUsedError;
  List<String> get localLibraryLocation => throw _privateConstructorUsedError;
  String get pipedInstance => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  AudioSource get audioSource => throw _privateConstructorUsedError;
  SourceCodecs get streamMusicCodec => throw _privateConstructorUsedError;
  SourceCodecs get downloadMusicCodec => throw _privateConstructorUsedError;
  bool get discordPresence => throw _privateConstructorUsedError;
  bool get endlessPlayback => throw _privateConstructorUsedError;
  bool get enableConnect => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
          UserPreferences value, $Res Function(UserPreferences) then) =
      _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call(
      {SourceQualities audioQuality,
      bool albumColorSync,
      bool amoledDarkTheme,
      bool checkUpdate,
      bool normalizeAudio,
      bool showSystemTrayIcon,
      bool skipNonMusic,
      bool systemTitleBar,
      CloseBehavior closeBehavior,
      @JsonKey(
          fromJson: UserPreferences._accentColorSchemeFromJson,
          toJson: UserPreferences._accentColorSchemeToJson,
          readValue: UserPreferences._accentColorSchemeReadValue)
      SpotubeColor accentColorScheme,
      LayoutMode layoutMode,
      @JsonKey(
          fromJson: UserPreferences._localeFromJson,
          toJson: UserPreferences._localeToJson,
          readValue: UserPreferences._localeReadValue)
      Locale locale,
      Market recommendationMarket,
      SearchMode searchMode,
      String downloadLocation,
      List<String> localLibraryLocation,
      String pipedInstance,
      ThemeMode themeMode,
      AudioSource audioSource,
      SourceCodecs streamMusicCodec,
      SourceCodecs downloadMusicCodec,
      bool discordPresence,
      bool endlessPlayback,
      bool enableConnect});
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioQuality = null,
    Object? albumColorSync = null,
    Object? amoledDarkTheme = null,
    Object? checkUpdate = null,
    Object? normalizeAudio = null,
    Object? showSystemTrayIcon = null,
    Object? skipNonMusic = null,
    Object? systemTitleBar = null,
    Object? closeBehavior = null,
    Object? accentColorScheme = null,
    Object? layoutMode = null,
    Object? locale = null,
    Object? recommendationMarket = null,
    Object? searchMode = null,
    Object? downloadLocation = null,
    Object? localLibraryLocation = null,
    Object? pipedInstance = null,
    Object? themeMode = null,
    Object? audioSource = null,
    Object? streamMusicCodec = null,
    Object? downloadMusicCodec = null,
    Object? discordPresence = null,
    Object? endlessPlayback = null,
    Object? enableConnect = null,
  }) {
    return _then(_value.copyWith(
      audioQuality: null == audioQuality
          ? _value.audioQuality
          : audioQuality // ignore: cast_nullable_to_non_nullable
              as SourceQualities,
      albumColorSync: null == albumColorSync
          ? _value.albumColorSync
          : albumColorSync // ignore: cast_nullable_to_non_nullable
              as bool,
      amoledDarkTheme: null == amoledDarkTheme
          ? _value.amoledDarkTheme
          : amoledDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      checkUpdate: null == checkUpdate
          ? _value.checkUpdate
          : checkUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      normalizeAudio: null == normalizeAudio
          ? _value.normalizeAudio
          : normalizeAudio // ignore: cast_nullable_to_non_nullable
              as bool,
      showSystemTrayIcon: null == showSystemTrayIcon
          ? _value.showSystemTrayIcon
          : showSystemTrayIcon // ignore: cast_nullable_to_non_nullable
              as bool,
      skipNonMusic: null == skipNonMusic
          ? _value.skipNonMusic
          : skipNonMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      systemTitleBar: null == systemTitleBar
          ? _value.systemTitleBar
          : systemTitleBar // ignore: cast_nullable_to_non_nullable
              as bool,
      closeBehavior: null == closeBehavior
          ? _value.closeBehavior
          : closeBehavior // ignore: cast_nullable_to_non_nullable
              as CloseBehavior,
      accentColorScheme: null == accentColorScheme
          ? _value.accentColorScheme
          : accentColorScheme // ignore: cast_nullable_to_non_nullable
              as SpotubeColor,
      layoutMode: null == layoutMode
          ? _value.layoutMode
          : layoutMode // ignore: cast_nullable_to_non_nullable
              as LayoutMode,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as Locale,
      recommendationMarket: null == recommendationMarket
          ? _value.recommendationMarket
          : recommendationMarket // ignore: cast_nullable_to_non_nullable
              as Market,
      searchMode: null == searchMode
          ? _value.searchMode
          : searchMode // ignore: cast_nullable_to_non_nullable
              as SearchMode,
      downloadLocation: null == downloadLocation
          ? _value.downloadLocation
          : downloadLocation // ignore: cast_nullable_to_non_nullable
              as String,
      localLibraryLocation: null == localLibraryLocation
          ? _value.localLibraryLocation
          : localLibraryLocation // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pipedInstance: null == pipedInstance
          ? _value.pipedInstance
          : pipedInstance // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      audioSource: null == audioSource
          ? _value.audioSource
          : audioSource // ignore: cast_nullable_to_non_nullable
              as AudioSource,
      streamMusicCodec: null == streamMusicCodec
          ? _value.streamMusicCodec
          : streamMusicCodec // ignore: cast_nullable_to_non_nullable
              as SourceCodecs,
      downloadMusicCodec: null == downloadMusicCodec
          ? _value.downloadMusicCodec
          : downloadMusicCodec // ignore: cast_nullable_to_non_nullable
              as SourceCodecs,
      discordPresence: null == discordPresence
          ? _value.discordPresence
          : discordPresence // ignore: cast_nullable_to_non_nullable
              as bool,
      endlessPlayback: null == endlessPlayback
          ? _value.endlessPlayback
          : endlessPlayback // ignore: cast_nullable_to_non_nullable
              as bool,
      enableConnect: null == enableConnect
          ? _value.enableConnect
          : enableConnect // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(_$UserPreferencesImpl value,
          $Res Function(_$UserPreferencesImpl) then) =
      __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SourceQualities audioQuality,
      bool albumColorSync,
      bool amoledDarkTheme,
      bool checkUpdate,
      bool normalizeAudio,
      bool showSystemTrayIcon,
      bool skipNonMusic,
      bool systemTitleBar,
      CloseBehavior closeBehavior,
      @JsonKey(
          fromJson: UserPreferences._accentColorSchemeFromJson,
          toJson: UserPreferences._accentColorSchemeToJson,
          readValue: UserPreferences._accentColorSchemeReadValue)
      SpotubeColor accentColorScheme,
      LayoutMode layoutMode,
      @JsonKey(
          fromJson: UserPreferences._localeFromJson,
          toJson: UserPreferences._localeToJson,
          readValue: UserPreferences._localeReadValue)
      Locale locale,
      Market recommendationMarket,
      SearchMode searchMode,
      String downloadLocation,
      List<String> localLibraryLocation,
      String pipedInstance,
      ThemeMode themeMode,
      AudioSource audioSource,
      SourceCodecs streamMusicCodec,
      SourceCodecs downloadMusicCodec,
      bool discordPresence,
      bool endlessPlayback,
      bool enableConnect});
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
      _$UserPreferencesImpl _value, $Res Function(_$UserPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioQuality = null,
    Object? albumColorSync = null,
    Object? amoledDarkTheme = null,
    Object? checkUpdate = null,
    Object? normalizeAudio = null,
    Object? showSystemTrayIcon = null,
    Object? skipNonMusic = null,
    Object? systemTitleBar = null,
    Object? closeBehavior = null,
    Object? accentColorScheme = null,
    Object? layoutMode = null,
    Object? locale = null,
    Object? recommendationMarket = null,
    Object? searchMode = null,
    Object? downloadLocation = null,
    Object? localLibraryLocation = null,
    Object? pipedInstance = null,
    Object? themeMode = null,
    Object? audioSource = null,
    Object? streamMusicCodec = null,
    Object? downloadMusicCodec = null,
    Object? discordPresence = null,
    Object? endlessPlayback = null,
    Object? enableConnect = null,
  }) {
    return _then(_$UserPreferencesImpl(
      audioQuality: null == audioQuality
          ? _value.audioQuality
          : audioQuality // ignore: cast_nullable_to_non_nullable
              as SourceQualities,
      albumColorSync: null == albumColorSync
          ? _value.albumColorSync
          : albumColorSync // ignore: cast_nullable_to_non_nullable
              as bool,
      amoledDarkTheme: null == amoledDarkTheme
          ? _value.amoledDarkTheme
          : amoledDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      checkUpdate: null == checkUpdate
          ? _value.checkUpdate
          : checkUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      normalizeAudio: null == normalizeAudio
          ? _value.normalizeAudio
          : normalizeAudio // ignore: cast_nullable_to_non_nullable
              as bool,
      showSystemTrayIcon: null == showSystemTrayIcon
          ? _value.showSystemTrayIcon
          : showSystemTrayIcon // ignore: cast_nullable_to_non_nullable
              as bool,
      skipNonMusic: null == skipNonMusic
          ? _value.skipNonMusic
          : skipNonMusic // ignore: cast_nullable_to_non_nullable
              as bool,
      systemTitleBar: null == systemTitleBar
          ? _value.systemTitleBar
          : systemTitleBar // ignore: cast_nullable_to_non_nullable
              as bool,
      closeBehavior: null == closeBehavior
          ? _value.closeBehavior
          : closeBehavior // ignore: cast_nullable_to_non_nullable
              as CloseBehavior,
      accentColorScheme: null == accentColorScheme
          ? _value.accentColorScheme
          : accentColorScheme // ignore: cast_nullable_to_non_nullable
              as SpotubeColor,
      layoutMode: null == layoutMode
          ? _value.layoutMode
          : layoutMode // ignore: cast_nullable_to_non_nullable
              as LayoutMode,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as Locale,
      recommendationMarket: null == recommendationMarket
          ? _value.recommendationMarket
          : recommendationMarket // ignore: cast_nullable_to_non_nullable
              as Market,
      searchMode: null == searchMode
          ? _value.searchMode
          : searchMode // ignore: cast_nullable_to_non_nullable
              as SearchMode,
      downloadLocation: null == downloadLocation
          ? _value.downloadLocation
          : downloadLocation // ignore: cast_nullable_to_non_nullable
              as String,
      localLibraryLocation: null == localLibraryLocation
          ? _value._localLibraryLocation
          : localLibraryLocation // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pipedInstance: null == pipedInstance
          ? _value.pipedInstance
          : pipedInstance // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      audioSource: null == audioSource
          ? _value.audioSource
          : audioSource // ignore: cast_nullable_to_non_nullable
              as AudioSource,
      streamMusicCodec: null == streamMusicCodec
          ? _value.streamMusicCodec
          : streamMusicCodec // ignore: cast_nullable_to_non_nullable
              as SourceCodecs,
      downloadMusicCodec: null == downloadMusicCodec
          ? _value.downloadMusicCodec
          : downloadMusicCodec // ignore: cast_nullable_to_non_nullable
              as SourceCodecs,
      discordPresence: null == discordPresence
          ? _value.discordPresence
          : discordPresence // ignore: cast_nullable_to_non_nullable
              as bool,
      endlessPlayback: null == endlessPlayback
          ? _value.endlessPlayback
          : endlessPlayback // ignore: cast_nullable_to_non_nullable
              as bool,
      enableConnect: null == enableConnect
          ? _value.enableConnect
          : enableConnect // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl(
      {this.audioQuality = SourceQualities.high,
      this.albumColorSync = true,
      this.amoledDarkTheme = false,
      this.checkUpdate = true,
      this.normalizeAudio = false,
      this.showSystemTrayIcon = false,
      this.skipNonMusic = false,
      this.systemTitleBar = false,
      this.closeBehavior = CloseBehavior.close,
      @JsonKey(
          fromJson: UserPreferences._accentColorSchemeFromJson,
          toJson: UserPreferences._accentColorSchemeToJson,
          readValue: UserPreferences._accentColorSchemeReadValue)
      this.accentColorScheme = const SpotubeColor(0xFF2196F3, name: "Blue"),
      this.layoutMode = LayoutMode.adaptive,
      @JsonKey(
          fromJson: UserPreferences._localeFromJson,
          toJson: UserPreferences._localeToJson,
          readValue: UserPreferences._localeReadValue)
      this.locale = const Locale("system", "system"),
      this.recommendationMarket = Market.US,
      this.searchMode = SearchMode.youtube,
      this.downloadLocation = "",
      final List<String> localLibraryLocation = const [],
      this.pipedInstance = "https://pipedapi.kavin.rocks",
      this.themeMode = ThemeMode.system,
      this.audioSource = AudioSource.youtube,
      this.streamMusicCodec = SourceCodecs.weba,
      this.downloadMusicCodec = SourceCodecs.m4a,
      this.discordPresence = true,
      this.endlessPlayback = true,
      this.enableConnect = false})
      : _localLibraryLocation = localLibraryLocation;

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final SourceQualities audioQuality;
  @override
  @JsonKey()
  final bool albumColorSync;
  @override
  @JsonKey()
  final bool amoledDarkTheme;
  @override
  @JsonKey()
  final bool checkUpdate;
  @override
  @JsonKey()
  final bool normalizeAudio;
  @override
  @JsonKey()
  final bool showSystemTrayIcon;
  @override
  @JsonKey()
  final bool skipNonMusic;
  @override
  @JsonKey()
  final bool systemTitleBar;
  @override
  @JsonKey()
  final CloseBehavior closeBehavior;
  @override
  @JsonKey(
      fromJson: UserPreferences._accentColorSchemeFromJson,
      toJson: UserPreferences._accentColorSchemeToJson,
      readValue: UserPreferences._accentColorSchemeReadValue)
  final SpotubeColor accentColorScheme;
  @override
  @JsonKey()
  final LayoutMode layoutMode;
  @override
  @JsonKey(
      fromJson: UserPreferences._localeFromJson,
      toJson: UserPreferences._localeToJson,
      readValue: UserPreferences._localeReadValue)
  final Locale locale;
  @override
  @JsonKey()
  final Market recommendationMarket;
  @override
  @JsonKey()
  final SearchMode searchMode;
  @override
  @JsonKey()
  final String downloadLocation;
  final List<String> _localLibraryLocation;
  @override
  @JsonKey()
  List<String> get localLibraryLocation {
    if (_localLibraryLocation is EqualUnmodifiableListView)
      return _localLibraryLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_localLibraryLocation);
  }

  @override
  @JsonKey()
  final String pipedInstance;
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final AudioSource audioSource;
  @override
  @JsonKey()
  final SourceCodecs streamMusicCodec;
  @override
  @JsonKey()
  final SourceCodecs downloadMusicCodec;
  @override
  @JsonKey()
  final bool discordPresence;
  @override
  @JsonKey()
  final bool endlessPlayback;
  @override
  @JsonKey()
  final bool enableConnect;

  @override
  String toString() {
    return 'UserPreferences(audioQuality: $audioQuality, albumColorSync: $albumColorSync, amoledDarkTheme: $amoledDarkTheme, checkUpdate: $checkUpdate, normalizeAudio: $normalizeAudio, showSystemTrayIcon: $showSystemTrayIcon, skipNonMusic: $skipNonMusic, systemTitleBar: $systemTitleBar, closeBehavior: $closeBehavior, accentColorScheme: $accentColorScheme, layoutMode: $layoutMode, locale: $locale, recommendationMarket: $recommendationMarket, searchMode: $searchMode, downloadLocation: $downloadLocation, localLibraryLocation: $localLibraryLocation, pipedInstance: $pipedInstance, themeMode: $themeMode, audioSource: $audioSource, streamMusicCodec: $streamMusicCodec, downloadMusicCodec: $downloadMusicCodec, discordPresence: $discordPresence, endlessPlayback: $endlessPlayback, enableConnect: $enableConnect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.audioQuality, audioQuality) ||
                other.audioQuality == audioQuality) &&
            (identical(other.albumColorSync, albumColorSync) ||
                other.albumColorSync == albumColorSync) &&
            (identical(other.amoledDarkTheme, amoledDarkTheme) ||
                other.amoledDarkTheme == amoledDarkTheme) &&
            (identical(other.checkUpdate, checkUpdate) ||
                other.checkUpdate == checkUpdate) &&
            (identical(other.normalizeAudio, normalizeAudio) ||
                other.normalizeAudio == normalizeAudio) &&
            (identical(other.showSystemTrayIcon, showSystemTrayIcon) ||
                other.showSystemTrayIcon == showSystemTrayIcon) &&
            (identical(other.skipNonMusic, skipNonMusic) ||
                other.skipNonMusic == skipNonMusic) &&
            (identical(other.systemTitleBar, systemTitleBar) ||
                other.systemTitleBar == systemTitleBar) &&
            (identical(other.closeBehavior, closeBehavior) ||
                other.closeBehavior == closeBehavior) &&
            (identical(other.accentColorScheme, accentColorScheme) ||
                other.accentColorScheme == accentColorScheme) &&
            (identical(other.layoutMode, layoutMode) ||
                other.layoutMode == layoutMode) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.recommendationMarket, recommendationMarket) ||
                other.recommendationMarket == recommendationMarket) &&
            (identical(other.searchMode, searchMode) ||
                other.searchMode == searchMode) &&
            (identical(other.downloadLocation, downloadLocation) ||
                other.downloadLocation == downloadLocation) &&
            const DeepCollectionEquality()
                .equals(other._localLibraryLocation, _localLibraryLocation) &&
            (identical(other.pipedInstance, pipedInstance) ||
                other.pipedInstance == pipedInstance) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.audioSource, audioSource) ||
                other.audioSource == audioSource) &&
            (identical(other.streamMusicCodec, streamMusicCodec) ||
                other.streamMusicCodec == streamMusicCodec) &&
            (identical(other.downloadMusicCodec, downloadMusicCodec) ||
                other.downloadMusicCodec == downloadMusicCodec) &&
            (identical(other.discordPresence, discordPresence) ||
                other.discordPresence == discordPresence) &&
            (identical(other.endlessPlayback, endlessPlayback) ||
                other.endlessPlayback == endlessPlayback) &&
            (identical(other.enableConnect, enableConnect) ||
                other.enableConnect == enableConnect));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        audioQuality,
        albumColorSync,
        amoledDarkTheme,
        checkUpdate,
        normalizeAudio,
        showSystemTrayIcon,
        skipNonMusic,
        systemTitleBar,
        closeBehavior,
        accentColorScheme,
        layoutMode,
        locale,
        recommendationMarket,
        searchMode,
        downloadLocation,
        const DeepCollectionEquality().hash(_localLibraryLocation),
        pipedInstance,
        themeMode,
        audioSource,
        streamMusicCodec,
        downloadMusicCodec,
        discordPresence,
        endlessPlayback,
        enableConnect
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences(
      {final SourceQualities audioQuality,
      final bool albumColorSync,
      final bool amoledDarkTheme,
      final bool checkUpdate,
      final bool normalizeAudio,
      final bool showSystemTrayIcon,
      final bool skipNonMusic,
      final bool systemTitleBar,
      final CloseBehavior closeBehavior,
      @JsonKey(
          fromJson: UserPreferences._accentColorSchemeFromJson,
          toJson: UserPreferences._accentColorSchemeToJson,
          readValue: UserPreferences._accentColorSchemeReadValue)
      final SpotubeColor accentColorScheme,
      final LayoutMode layoutMode,
      @JsonKey(
          fromJson: UserPreferences._localeFromJson,
          toJson: UserPreferences._localeToJson,
          readValue: UserPreferences._localeReadValue)
      final Locale locale,
      final Market recommendationMarket,
      final SearchMode searchMode,
      final String downloadLocation,
      final List<String> localLibraryLocation,
      final String pipedInstance,
      final ThemeMode themeMode,
      final AudioSource audioSource,
      final SourceCodecs streamMusicCodec,
      final SourceCodecs downloadMusicCodec,
      final bool discordPresence,
      final bool endlessPlayback,
      final bool enableConnect}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  SourceQualities get audioQuality;
  @override
  bool get albumColorSync;
  @override
  bool get amoledDarkTheme;
  @override
  bool get checkUpdate;
  @override
  bool get normalizeAudio;
  @override
  bool get showSystemTrayIcon;
  @override
  bool get skipNonMusic;
  @override
  bool get systemTitleBar;
  @override
  CloseBehavior get closeBehavior;
  @override
  @JsonKey(
      fromJson: UserPreferences._accentColorSchemeFromJson,
      toJson: UserPreferences._accentColorSchemeToJson,
      readValue: UserPreferences._accentColorSchemeReadValue)
  SpotubeColor get accentColorScheme;
  @override
  LayoutMode get layoutMode;
  @override
  @JsonKey(
      fromJson: UserPreferences._localeFromJson,
      toJson: UserPreferences._localeToJson,
      readValue: UserPreferences._localeReadValue)
  Locale get locale;
  @override
  Market get recommendationMarket;
  @override
  SearchMode get searchMode;
  @override
  String get downloadLocation;
  @override
  List<String> get localLibraryLocation;
  @override
  String get pipedInstance;
  @override
  ThemeMode get themeMode;
  @override
  AudioSource get audioSource;
  @override
  SourceCodecs get streamMusicCodec;
  @override
  SourceCodecs get downloadMusicCodec;
  @override
  bool get discordPresence;
  @override
  bool get endlessPlayback;
  @override
  bool get enableConnect;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
