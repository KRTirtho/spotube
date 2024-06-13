// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PreferencesTableTable extends PreferencesTable
    with TableInfo<$PreferencesTableTable, PreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _audioQualityMeta =
      const VerificationMeta('audioQuality');
  @override
  late final GeneratedColumnWithTypeConverter<SourceQualities, String>
      audioQuality = GeneratedColumn<String>(
              'audio_quality', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SourceQualities.high.name))
          .withConverter<SourceQualities>(
              $PreferencesTableTable.$converteraudioQuality);
  static const VerificationMeta _albumColorSyncMeta =
      const VerificationMeta('albumColorSync');
  @override
  late final GeneratedColumn<bool> albumColorSync = GeneratedColumn<bool>(
      'album_color_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("album_color_sync" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _amoledDarkThemeMeta =
      const VerificationMeta('amoledDarkTheme');
  @override
  late final GeneratedColumn<bool> amoledDarkTheme = GeneratedColumn<bool>(
      'amoled_dark_theme', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("amoled_dark_theme" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _checkUpdateMeta =
      const VerificationMeta('checkUpdate');
  @override
  late final GeneratedColumn<bool> checkUpdate = GeneratedColumn<bool>(
      'check_update', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("check_update" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _normalizeAudioMeta =
      const VerificationMeta('normalizeAudio');
  @override
  late final GeneratedColumn<bool> normalizeAudio = GeneratedColumn<bool>(
      'normalize_audio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("normalize_audio" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _showSystemTrayIconMeta =
      const VerificationMeta('showSystemTrayIcon');
  @override
  late final GeneratedColumn<bool> showSystemTrayIcon = GeneratedColumn<bool>(
      'show_system_tray_icon', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_system_tray_icon" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _systemTitleBarMeta =
      const VerificationMeta('systemTitleBar');
  @override
  late final GeneratedColumn<bool> systemTitleBar = GeneratedColumn<bool>(
      'system_title_bar', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("system_title_bar" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _skipNonMusicMeta =
      const VerificationMeta('skipNonMusic');
  @override
  late final GeneratedColumn<bool> skipNonMusic = GeneratedColumn<bool>(
      'skip_non_music', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("skip_non_music" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _closeBehaviorMeta =
      const VerificationMeta('closeBehavior');
  @override
  late final GeneratedColumnWithTypeConverter<CloseBehavior, String>
      closeBehavior = GeneratedColumn<String>(
              'close_behavior', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(CloseBehavior.close.name))
          .withConverter<CloseBehavior>(
              $PreferencesTableTable.$convertercloseBehavior);
  static const VerificationMeta _accentColorSchemeMeta =
      const VerificationMeta('accentColorScheme');
  @override
  late final GeneratedColumnWithTypeConverter<SpotubeColor, String>
      accentColorScheme = GeneratedColumn<String>(
              'accent_color_scheme', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant("Blue:0xFF2196F3"))
          .withConverter<SpotubeColor>(
              $PreferencesTableTable.$converteraccentColorScheme);
  static const VerificationMeta _layoutModeMeta =
      const VerificationMeta('layoutMode');
  @override
  late final GeneratedColumnWithTypeConverter<LayoutMode, String> layoutMode =
      GeneratedColumn<String>('layout_mode', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(LayoutMode.adaptive.name))
          .withConverter<LayoutMode>(
              $PreferencesTableTable.$converterlayoutMode);
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumnWithTypeConverter<Locale, String> locale =
      GeneratedColumn<String>('locale', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant(
                  '{"languageCode":"system","countryCode":"system"}'))
          .withConverter<Locale>($PreferencesTableTable.$converterlocale);
  static const VerificationMeta _marketMeta = const VerificationMeta('market');
  @override
  late final GeneratedColumnWithTypeConverter<Market, String> market =
      GeneratedColumn<String>('market', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(Market.US.name))
          .withConverter<Market>($PreferencesTableTable.$convertermarket);
  static const VerificationMeta _searchModeMeta =
      const VerificationMeta('searchMode');
  @override
  late final GeneratedColumnWithTypeConverter<SearchMode, String> searchMode =
      GeneratedColumn<String>('search_mode', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SearchMode.youtube.name))
          .withConverter<SearchMode>(
              $PreferencesTableTable.$convertersearchMode);
  static const VerificationMeta _downloadLocationMeta =
      const VerificationMeta('downloadLocation');
  @override
  late final GeneratedColumn<String> downloadLocation = GeneratedColumn<String>(
      'download_location', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  static const VerificationMeta _localLibraryLocationMeta =
      const VerificationMeta('localLibraryLocation');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      localLibraryLocation = GeneratedColumn<String>(
              'local_library_location', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant(""))
          .withConverter<List<String>>(
              $PreferencesTableTable.$converterlocalLibraryLocation);
  static const VerificationMeta _pipedInstanceMeta =
      const VerificationMeta('pipedInstance');
  @override
  late final GeneratedColumn<String> pipedInstance = GeneratedColumn<String>(
      'piped_instance', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("https://pipedapi.kavin.rocks"));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumnWithTypeConverter<ThemeMode, String> themeMode =
      GeneratedColumn<String>('theme_mode', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(ThemeMode.system.name))
          .withConverter<ThemeMode>($PreferencesTableTable.$converterthemeMode);
  static const VerificationMeta _audioSourceMeta =
      const VerificationMeta('audioSource');
  @override
  late final GeneratedColumnWithTypeConverter<AudioSource, String> audioSource =
      GeneratedColumn<String>('audio_source', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(AudioSource.youtube.name))
          .withConverter<AudioSource>(
              $PreferencesTableTable.$converteraudioSource);
  static const VerificationMeta _streamMusicCodecMeta =
      const VerificationMeta('streamMusicCodec');
  @override
  late final GeneratedColumnWithTypeConverter<SourceCodecs, String>
      streamMusicCodec = GeneratedColumn<String>(
              'stream_music_codec', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SourceCodecs.weba.name))
          .withConverter<SourceCodecs>(
              $PreferencesTableTable.$converterstreamMusicCodec);
  static const VerificationMeta _downloadMusicCodecMeta =
      const VerificationMeta('downloadMusicCodec');
  @override
  late final GeneratedColumnWithTypeConverter<SourceCodecs, String>
      downloadMusicCodec = GeneratedColumn<String>(
              'download_music_codec', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SourceCodecs.m4a.name))
          .withConverter<SourceCodecs>(
              $PreferencesTableTable.$converterdownloadMusicCodec);
  static const VerificationMeta _discordPresenceMeta =
      const VerificationMeta('discordPresence');
  @override
  late final GeneratedColumn<bool> discordPresence = GeneratedColumn<bool>(
      'discord_presence', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("discord_presence" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _endlessPlaybackMeta =
      const VerificationMeta('endlessPlayback');
  @override
  late final GeneratedColumn<bool> endlessPlayback = GeneratedColumn<bool>(
      'endless_playback', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("endless_playback" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _enableConnectMeta =
      const VerificationMeta('enableConnect');
  @override
  late final GeneratedColumn<bool> enableConnect = GeneratedColumn<bool>(
      'enable_connect', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_connect" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        audioQuality,
        albumColorSync,
        amoledDarkTheme,
        checkUpdate,
        normalizeAudio,
        showSystemTrayIcon,
        systemTitleBar,
        skipNonMusic,
        closeBehavior,
        accentColorScheme,
        layoutMode,
        locale,
        market,
        searchMode,
        downloadLocation,
        localLibraryLocation,
        pipedInstance,
        themeMode,
        audioSource,
        streamMusicCodec,
        downloadMusicCodec,
        discordPresence,
        endlessPlayback,
        enableConnect
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PreferencesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_audioQualityMeta, const VerificationResult.success());
    if (data.containsKey('album_color_sync')) {
      context.handle(
          _albumColorSyncMeta,
          albumColorSync.isAcceptableOrUnknown(
              data['album_color_sync']!, _albumColorSyncMeta));
    }
    if (data.containsKey('amoled_dark_theme')) {
      context.handle(
          _amoledDarkThemeMeta,
          amoledDarkTheme.isAcceptableOrUnknown(
              data['amoled_dark_theme']!, _amoledDarkThemeMeta));
    }
    if (data.containsKey('check_update')) {
      context.handle(
          _checkUpdateMeta,
          checkUpdate.isAcceptableOrUnknown(
              data['check_update']!, _checkUpdateMeta));
    }
    if (data.containsKey('normalize_audio')) {
      context.handle(
          _normalizeAudioMeta,
          normalizeAudio.isAcceptableOrUnknown(
              data['normalize_audio']!, _normalizeAudioMeta));
    }
    if (data.containsKey('show_system_tray_icon')) {
      context.handle(
          _showSystemTrayIconMeta,
          showSystemTrayIcon.isAcceptableOrUnknown(
              data['show_system_tray_icon']!, _showSystemTrayIconMeta));
    }
    if (data.containsKey('system_title_bar')) {
      context.handle(
          _systemTitleBarMeta,
          systemTitleBar.isAcceptableOrUnknown(
              data['system_title_bar']!, _systemTitleBarMeta));
    }
    if (data.containsKey('skip_non_music')) {
      context.handle(
          _skipNonMusicMeta,
          skipNonMusic.isAcceptableOrUnknown(
              data['skip_non_music']!, _skipNonMusicMeta));
    }
    context.handle(_closeBehaviorMeta, const VerificationResult.success());
    context.handle(_accentColorSchemeMeta, const VerificationResult.success());
    context.handle(_layoutModeMeta, const VerificationResult.success());
    context.handle(_localeMeta, const VerificationResult.success());
    context.handle(_marketMeta, const VerificationResult.success());
    context.handle(_searchModeMeta, const VerificationResult.success());
    if (data.containsKey('download_location')) {
      context.handle(
          _downloadLocationMeta,
          downloadLocation.isAcceptableOrUnknown(
              data['download_location']!, _downloadLocationMeta));
    }
    context.handle(
        _localLibraryLocationMeta, const VerificationResult.success());
    if (data.containsKey('piped_instance')) {
      context.handle(
          _pipedInstanceMeta,
          pipedInstance.isAcceptableOrUnknown(
              data['piped_instance']!, _pipedInstanceMeta));
    }
    context.handle(_themeModeMeta, const VerificationResult.success());
    context.handle(_audioSourceMeta, const VerificationResult.success());
    context.handle(_streamMusicCodecMeta, const VerificationResult.success());
    context.handle(_downloadMusicCodecMeta, const VerificationResult.success());
    if (data.containsKey('discord_presence')) {
      context.handle(
          _discordPresenceMeta,
          discordPresence.isAcceptableOrUnknown(
              data['discord_presence']!, _discordPresenceMeta));
    }
    if (data.containsKey('endless_playback')) {
      context.handle(
          _endlessPlaybackMeta,
          endlessPlayback.isAcceptableOrUnknown(
              data['endless_playback']!, _endlessPlaybackMeta));
    }
    if (data.containsKey('enable_connect')) {
      context.handle(
          _enableConnectMeta,
          enableConnect.isAcceptableOrUnknown(
              data['enable_connect']!, _enableConnectMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      audioQuality: $PreferencesTableTable.$converteraudioQuality.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}audio_quality'])!),
      albumColorSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}album_color_sync'])!,
      amoledDarkTheme: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}amoled_dark_theme'])!,
      checkUpdate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}check_update'])!,
      normalizeAudio: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}normalize_audio'])!,
      showSystemTrayIcon: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_system_tray_icon'])!,
      systemTitleBar: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}system_title_bar'])!,
      skipNonMusic: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}skip_non_music'])!,
      closeBehavior: $PreferencesTableTable.$convertercloseBehavior.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}close_behavior'])!),
      accentColorScheme: $PreferencesTableTable.$converteraccentColorScheme
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}accent_color_scheme'])!),
      layoutMode: $PreferencesTableTable.$converterlayoutMode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}layout_mode'])!),
      locale: $PreferencesTableTable.$converterlocale.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}locale'])!),
      market: $PreferencesTableTable.$convertermarket.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market'])!),
      searchMode: $PreferencesTableTable.$convertersearchMode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}search_mode'])!),
      downloadLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}download_location'])!,
      localLibraryLocation: $PreferencesTableTable
          .$converterlocalLibraryLocation
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}local_library_location'])!),
      pipedInstance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}piped_instance'])!,
      themeMode: $PreferencesTableTable.$converterthemeMode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}theme_mode'])!),
      audioSource: $PreferencesTableTable.$converteraudioSource.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}audio_source'])!),
      streamMusicCodec: $PreferencesTableTable.$converterstreamMusicCodec
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}stream_music_codec'])!),
      downloadMusicCodec: $PreferencesTableTable.$converterdownloadMusicCodec
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}download_music_codec'])!),
      discordPresence: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}discord_presence'])!,
      endlessPlayback: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}endless_playback'])!,
      enableConnect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enable_connect'])!,
    );
  }

  @override
  $PreferencesTableTable createAlias(String alias) {
    return $PreferencesTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceQualities, String, String>
      $converteraudioQuality =
      const EnumNameConverter<SourceQualities>(SourceQualities.values);
  static JsonTypeConverter2<CloseBehavior, String, String>
      $convertercloseBehavior =
      const EnumNameConverter<CloseBehavior>(CloseBehavior.values);
  static TypeConverter<SpotubeColor, String> $converteraccentColorScheme =
      const SpotubeColorConverter();
  static JsonTypeConverter2<LayoutMode, String, String> $converterlayoutMode =
      const EnumNameConverter<LayoutMode>(LayoutMode.values);
  static TypeConverter<Locale, String> $converterlocale =
      const LocaleConverter();
  static JsonTypeConverter2<Market, String, String> $convertermarket =
      const EnumNameConverter<Market>(Market.values);
  static JsonTypeConverter2<SearchMode, String, String> $convertersearchMode =
      const EnumNameConverter<SearchMode>(SearchMode.values);
  static TypeConverter<List<String>, String> $converterlocalLibraryLocation =
      const StringListConverter();
  static JsonTypeConverter2<ThemeMode, String, String> $converterthemeMode =
      const EnumNameConverter<ThemeMode>(ThemeMode.values);
  static JsonTypeConverter2<AudioSource, String, String> $converteraudioSource =
      const EnumNameConverter<AudioSource>(AudioSource.values);
  static JsonTypeConverter2<SourceCodecs, String, String>
      $converterstreamMusicCodec =
      const EnumNameConverter<SourceCodecs>(SourceCodecs.values);
  static JsonTypeConverter2<SourceCodecs, String, String>
      $converterdownloadMusicCodec =
      const EnumNameConverter<SourceCodecs>(SourceCodecs.values);
}

class PreferencesTableData extends DataClass
    implements Insertable<PreferencesTableData> {
  final int id;
  final SourceQualities audioQuality;
  final bool albumColorSync;
  final bool amoledDarkTheme;
  final bool checkUpdate;
  final bool normalizeAudio;
  final bool showSystemTrayIcon;
  final bool systemTitleBar;
  final bool skipNonMusic;
  final CloseBehavior closeBehavior;
  final SpotubeColor accentColorScheme;
  final LayoutMode layoutMode;
  final Locale locale;
  final Market market;
  final SearchMode searchMode;
  final String downloadLocation;
  final List<String> localLibraryLocation;
  final String pipedInstance;
  final ThemeMode themeMode;
  final AudioSource audioSource;
  final SourceCodecs streamMusicCodec;
  final SourceCodecs downloadMusicCodec;
  final bool discordPresence;
  final bool endlessPlayback;
  final bool enableConnect;
  const PreferencesTableData(
      {required this.id,
      required this.audioQuality,
      required this.albumColorSync,
      required this.amoledDarkTheme,
      required this.checkUpdate,
      required this.normalizeAudio,
      required this.showSystemTrayIcon,
      required this.systemTitleBar,
      required this.skipNonMusic,
      required this.closeBehavior,
      required this.accentColorScheme,
      required this.layoutMode,
      required this.locale,
      required this.market,
      required this.searchMode,
      required this.downloadLocation,
      required this.localLibraryLocation,
      required this.pipedInstance,
      required this.themeMode,
      required this.audioSource,
      required this.streamMusicCodec,
      required this.downloadMusicCodec,
      required this.discordPresence,
      required this.endlessPlayback,
      required this.enableConnect});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['audio_quality'] = Variable<String>(
          $PreferencesTableTable.$converteraudioQuality.toSql(audioQuality));
    }
    map['album_color_sync'] = Variable<bool>(albumColorSync);
    map['amoled_dark_theme'] = Variable<bool>(amoledDarkTheme);
    map['check_update'] = Variable<bool>(checkUpdate);
    map['normalize_audio'] = Variable<bool>(normalizeAudio);
    map['show_system_tray_icon'] = Variable<bool>(showSystemTrayIcon);
    map['system_title_bar'] = Variable<bool>(systemTitleBar);
    map['skip_non_music'] = Variable<bool>(skipNonMusic);
    {
      map['close_behavior'] = Variable<String>(
          $PreferencesTableTable.$convertercloseBehavior.toSql(closeBehavior));
    }
    {
      map['accent_color_scheme'] = Variable<String>($PreferencesTableTable
          .$converteraccentColorScheme
          .toSql(accentColorScheme));
    }
    {
      map['layout_mode'] = Variable<String>(
          $PreferencesTableTable.$converterlayoutMode.toSql(layoutMode));
    }
    {
      map['locale'] = Variable<String>(
          $PreferencesTableTable.$converterlocale.toSql(locale));
    }
    {
      map['market'] = Variable<String>(
          $PreferencesTableTable.$convertermarket.toSql(market));
    }
    {
      map['search_mode'] = Variable<String>(
          $PreferencesTableTable.$convertersearchMode.toSql(searchMode));
    }
    map['download_location'] = Variable<String>(downloadLocation);
    {
      map['local_library_location'] = Variable<String>($PreferencesTableTable
          .$converterlocalLibraryLocation
          .toSql(localLibraryLocation));
    }
    map['piped_instance'] = Variable<String>(pipedInstance);
    {
      map['theme_mode'] = Variable<String>(
          $PreferencesTableTable.$converterthemeMode.toSql(themeMode));
    }
    {
      map['audio_source'] = Variable<String>(
          $PreferencesTableTable.$converteraudioSource.toSql(audioSource));
    }
    {
      map['stream_music_codec'] = Variable<String>($PreferencesTableTable
          .$converterstreamMusicCodec
          .toSql(streamMusicCodec));
    }
    {
      map['download_music_codec'] = Variable<String>($PreferencesTableTable
          .$converterdownloadMusicCodec
          .toSql(downloadMusicCodec));
    }
    map['discord_presence'] = Variable<bool>(discordPresence);
    map['endless_playback'] = Variable<bool>(endlessPlayback);
    map['enable_connect'] = Variable<bool>(enableConnect);
    return map;
  }

  PreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return PreferencesTableCompanion(
      id: Value(id),
      audioQuality: Value(audioQuality),
      albumColorSync: Value(albumColorSync),
      amoledDarkTheme: Value(amoledDarkTheme),
      checkUpdate: Value(checkUpdate),
      normalizeAudio: Value(normalizeAudio),
      showSystemTrayIcon: Value(showSystemTrayIcon),
      systemTitleBar: Value(systemTitleBar),
      skipNonMusic: Value(skipNonMusic),
      closeBehavior: Value(closeBehavior),
      accentColorScheme: Value(accentColorScheme),
      layoutMode: Value(layoutMode),
      locale: Value(locale),
      market: Value(market),
      searchMode: Value(searchMode),
      downloadLocation: Value(downloadLocation),
      localLibraryLocation: Value(localLibraryLocation),
      pipedInstance: Value(pipedInstance),
      themeMode: Value(themeMode),
      audioSource: Value(audioSource),
      streamMusicCodec: Value(streamMusicCodec),
      downloadMusicCodec: Value(downloadMusicCodec),
      discordPresence: Value(discordPresence),
      endlessPlayback: Value(endlessPlayback),
      enableConnect: Value(enableConnect),
    );
  }

  factory PreferencesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesTableData(
      id: serializer.fromJson<int>(json['id']),
      audioQuality: $PreferencesTableTable.$converteraudioQuality
          .fromJson(serializer.fromJson<String>(json['audioQuality'])),
      albumColorSync: serializer.fromJson<bool>(json['albumColorSync']),
      amoledDarkTheme: serializer.fromJson<bool>(json['amoledDarkTheme']),
      checkUpdate: serializer.fromJson<bool>(json['checkUpdate']),
      normalizeAudio: serializer.fromJson<bool>(json['normalizeAudio']),
      showSystemTrayIcon: serializer.fromJson<bool>(json['showSystemTrayIcon']),
      systemTitleBar: serializer.fromJson<bool>(json['systemTitleBar']),
      skipNonMusic: serializer.fromJson<bool>(json['skipNonMusic']),
      closeBehavior: $PreferencesTableTable.$convertercloseBehavior
          .fromJson(serializer.fromJson<String>(json['closeBehavior'])),
      accentColorScheme:
          serializer.fromJson<SpotubeColor>(json['accentColorScheme']),
      layoutMode: $PreferencesTableTable.$converterlayoutMode
          .fromJson(serializer.fromJson<String>(json['layoutMode'])),
      locale: serializer.fromJson<Locale>(json['locale']),
      market: $PreferencesTableTable.$convertermarket
          .fromJson(serializer.fromJson<String>(json['market'])),
      searchMode: $PreferencesTableTable.$convertersearchMode
          .fromJson(serializer.fromJson<String>(json['searchMode'])),
      downloadLocation: serializer.fromJson<String>(json['downloadLocation']),
      localLibraryLocation:
          serializer.fromJson<List<String>>(json['localLibraryLocation']),
      pipedInstance: serializer.fromJson<String>(json['pipedInstance']),
      themeMode: $PreferencesTableTable.$converterthemeMode
          .fromJson(serializer.fromJson<String>(json['themeMode'])),
      audioSource: $PreferencesTableTable.$converteraudioSource
          .fromJson(serializer.fromJson<String>(json['audioSource'])),
      streamMusicCodec: $PreferencesTableTable.$converterstreamMusicCodec
          .fromJson(serializer.fromJson<String>(json['streamMusicCodec'])),
      downloadMusicCodec: $PreferencesTableTable.$converterdownloadMusicCodec
          .fromJson(serializer.fromJson<String>(json['downloadMusicCodec'])),
      discordPresence: serializer.fromJson<bool>(json['discordPresence']),
      endlessPlayback: serializer.fromJson<bool>(json['endlessPlayback']),
      enableConnect: serializer.fromJson<bool>(json['enableConnect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'audioQuality': serializer.toJson<String>(
          $PreferencesTableTable.$converteraudioQuality.toJson(audioQuality)),
      'albumColorSync': serializer.toJson<bool>(albumColorSync),
      'amoledDarkTheme': serializer.toJson<bool>(amoledDarkTheme),
      'checkUpdate': serializer.toJson<bool>(checkUpdate),
      'normalizeAudio': serializer.toJson<bool>(normalizeAudio),
      'showSystemTrayIcon': serializer.toJson<bool>(showSystemTrayIcon),
      'systemTitleBar': serializer.toJson<bool>(systemTitleBar),
      'skipNonMusic': serializer.toJson<bool>(skipNonMusic),
      'closeBehavior': serializer.toJson<String>(
          $PreferencesTableTable.$convertercloseBehavior.toJson(closeBehavior)),
      'accentColorScheme': serializer.toJson<SpotubeColor>(accentColorScheme),
      'layoutMode': serializer.toJson<String>(
          $PreferencesTableTable.$converterlayoutMode.toJson(layoutMode)),
      'locale': serializer.toJson<Locale>(locale),
      'market': serializer.toJson<String>(
          $PreferencesTableTable.$convertermarket.toJson(market)),
      'searchMode': serializer.toJson<String>(
          $PreferencesTableTable.$convertersearchMode.toJson(searchMode)),
      'downloadLocation': serializer.toJson<String>(downloadLocation),
      'localLibraryLocation':
          serializer.toJson<List<String>>(localLibraryLocation),
      'pipedInstance': serializer.toJson<String>(pipedInstance),
      'themeMode': serializer.toJson<String>(
          $PreferencesTableTable.$converterthemeMode.toJson(themeMode)),
      'audioSource': serializer.toJson<String>(
          $PreferencesTableTable.$converteraudioSource.toJson(audioSource)),
      'streamMusicCodec': serializer.toJson<String>($PreferencesTableTable
          .$converterstreamMusicCodec
          .toJson(streamMusicCodec)),
      'downloadMusicCodec': serializer.toJson<String>($PreferencesTableTable
          .$converterdownloadMusicCodec
          .toJson(downloadMusicCodec)),
      'discordPresence': serializer.toJson<bool>(discordPresence),
      'endlessPlayback': serializer.toJson<bool>(endlessPlayback),
      'enableConnect': serializer.toJson<bool>(enableConnect),
    };
  }

  PreferencesTableData copyWith(
          {int? id,
          SourceQualities? audioQuality,
          bool? albumColorSync,
          bool? amoledDarkTheme,
          bool? checkUpdate,
          bool? normalizeAudio,
          bool? showSystemTrayIcon,
          bool? systemTitleBar,
          bool? skipNonMusic,
          CloseBehavior? closeBehavior,
          SpotubeColor? accentColorScheme,
          LayoutMode? layoutMode,
          Locale? locale,
          Market? market,
          SearchMode? searchMode,
          String? downloadLocation,
          List<String>? localLibraryLocation,
          String? pipedInstance,
          ThemeMode? themeMode,
          AudioSource? audioSource,
          SourceCodecs? streamMusicCodec,
          SourceCodecs? downloadMusicCodec,
          bool? discordPresence,
          bool? endlessPlayback,
          bool? enableConnect}) =>
      PreferencesTableData(
        id: id ?? this.id,
        audioQuality: audioQuality ?? this.audioQuality,
        albumColorSync: albumColorSync ?? this.albumColorSync,
        amoledDarkTheme: amoledDarkTheme ?? this.amoledDarkTheme,
        checkUpdate: checkUpdate ?? this.checkUpdate,
        normalizeAudio: normalizeAudio ?? this.normalizeAudio,
        showSystemTrayIcon: showSystemTrayIcon ?? this.showSystemTrayIcon,
        systemTitleBar: systemTitleBar ?? this.systemTitleBar,
        skipNonMusic: skipNonMusic ?? this.skipNonMusic,
        closeBehavior: closeBehavior ?? this.closeBehavior,
        accentColorScheme: accentColorScheme ?? this.accentColorScheme,
        layoutMode: layoutMode ?? this.layoutMode,
        locale: locale ?? this.locale,
        market: market ?? this.market,
        searchMode: searchMode ?? this.searchMode,
        downloadLocation: downloadLocation ?? this.downloadLocation,
        localLibraryLocation: localLibraryLocation ?? this.localLibraryLocation,
        pipedInstance: pipedInstance ?? this.pipedInstance,
        themeMode: themeMode ?? this.themeMode,
        audioSource: audioSource ?? this.audioSource,
        streamMusicCodec: streamMusicCodec ?? this.streamMusicCodec,
        downloadMusicCodec: downloadMusicCodec ?? this.downloadMusicCodec,
        discordPresence: discordPresence ?? this.discordPresence,
        endlessPlayback: endlessPlayback ?? this.endlessPlayback,
        enableConnect: enableConnect ?? this.enableConnect,
      );
  @override
  String toString() {
    return (StringBuffer('PreferencesTableData(')
          ..write('id: $id, ')
          ..write('audioQuality: $audioQuality, ')
          ..write('albumColorSync: $albumColorSync, ')
          ..write('amoledDarkTheme: $amoledDarkTheme, ')
          ..write('checkUpdate: $checkUpdate, ')
          ..write('normalizeAudio: $normalizeAudio, ')
          ..write('showSystemTrayIcon: $showSystemTrayIcon, ')
          ..write('systemTitleBar: $systemTitleBar, ')
          ..write('skipNonMusic: $skipNonMusic, ')
          ..write('closeBehavior: $closeBehavior, ')
          ..write('accentColorScheme: $accentColorScheme, ')
          ..write('layoutMode: $layoutMode, ')
          ..write('locale: $locale, ')
          ..write('market: $market, ')
          ..write('searchMode: $searchMode, ')
          ..write('downloadLocation: $downloadLocation, ')
          ..write('localLibraryLocation: $localLibraryLocation, ')
          ..write('pipedInstance: $pipedInstance, ')
          ..write('themeMode: $themeMode, ')
          ..write('audioSource: $audioSource, ')
          ..write('streamMusicCodec: $streamMusicCodec, ')
          ..write('downloadMusicCodec: $downloadMusicCodec, ')
          ..write('discordPresence: $discordPresence, ')
          ..write('endlessPlayback: $endlessPlayback, ')
          ..write('enableConnect: $enableConnect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        audioQuality,
        albumColorSync,
        amoledDarkTheme,
        checkUpdate,
        normalizeAudio,
        showSystemTrayIcon,
        systemTitleBar,
        skipNonMusic,
        closeBehavior,
        accentColorScheme,
        layoutMode,
        locale,
        market,
        searchMode,
        downloadLocation,
        localLibraryLocation,
        pipedInstance,
        themeMode,
        audioSource,
        streamMusicCodec,
        downloadMusicCodec,
        discordPresence,
        endlessPlayback,
        enableConnect
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferencesTableData &&
          other.id == this.id &&
          other.audioQuality == this.audioQuality &&
          other.albumColorSync == this.albumColorSync &&
          other.amoledDarkTheme == this.amoledDarkTheme &&
          other.checkUpdate == this.checkUpdate &&
          other.normalizeAudio == this.normalizeAudio &&
          other.showSystemTrayIcon == this.showSystemTrayIcon &&
          other.systemTitleBar == this.systemTitleBar &&
          other.skipNonMusic == this.skipNonMusic &&
          other.closeBehavior == this.closeBehavior &&
          other.accentColorScheme == this.accentColorScheme &&
          other.layoutMode == this.layoutMode &&
          other.locale == this.locale &&
          other.market == this.market &&
          other.searchMode == this.searchMode &&
          other.downloadLocation == this.downloadLocation &&
          other.localLibraryLocation == this.localLibraryLocation &&
          other.pipedInstance == this.pipedInstance &&
          other.themeMode == this.themeMode &&
          other.audioSource == this.audioSource &&
          other.streamMusicCodec == this.streamMusicCodec &&
          other.downloadMusicCodec == this.downloadMusicCodec &&
          other.discordPresence == this.discordPresence &&
          other.endlessPlayback == this.endlessPlayback &&
          other.enableConnect == this.enableConnect);
}

class PreferencesTableCompanion extends UpdateCompanion<PreferencesTableData> {
  final Value<int> id;
  final Value<SourceQualities> audioQuality;
  final Value<bool> albumColorSync;
  final Value<bool> amoledDarkTheme;
  final Value<bool> checkUpdate;
  final Value<bool> normalizeAudio;
  final Value<bool> showSystemTrayIcon;
  final Value<bool> systemTitleBar;
  final Value<bool> skipNonMusic;
  final Value<CloseBehavior> closeBehavior;
  final Value<SpotubeColor> accentColorScheme;
  final Value<LayoutMode> layoutMode;
  final Value<Locale> locale;
  final Value<Market> market;
  final Value<SearchMode> searchMode;
  final Value<String> downloadLocation;
  final Value<List<String>> localLibraryLocation;
  final Value<String> pipedInstance;
  final Value<ThemeMode> themeMode;
  final Value<AudioSource> audioSource;
  final Value<SourceCodecs> streamMusicCodec;
  final Value<SourceCodecs> downloadMusicCodec;
  final Value<bool> discordPresence;
  final Value<bool> endlessPlayback;
  final Value<bool> enableConnect;
  const PreferencesTableCompanion({
    this.id = const Value.absent(),
    this.audioQuality = const Value.absent(),
    this.albumColorSync = const Value.absent(),
    this.amoledDarkTheme = const Value.absent(),
    this.checkUpdate = const Value.absent(),
    this.normalizeAudio = const Value.absent(),
    this.showSystemTrayIcon = const Value.absent(),
    this.systemTitleBar = const Value.absent(),
    this.skipNonMusic = const Value.absent(),
    this.closeBehavior = const Value.absent(),
    this.accentColorScheme = const Value.absent(),
    this.layoutMode = const Value.absent(),
    this.locale = const Value.absent(),
    this.market = const Value.absent(),
    this.searchMode = const Value.absent(),
    this.downloadLocation = const Value.absent(),
    this.localLibraryLocation = const Value.absent(),
    this.pipedInstance = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.audioSource = const Value.absent(),
    this.streamMusicCodec = const Value.absent(),
    this.downloadMusicCodec = const Value.absent(),
    this.discordPresence = const Value.absent(),
    this.endlessPlayback = const Value.absent(),
    this.enableConnect = const Value.absent(),
  });
  PreferencesTableCompanion.insert({
    this.id = const Value.absent(),
    this.audioQuality = const Value.absent(),
    this.albumColorSync = const Value.absent(),
    this.amoledDarkTheme = const Value.absent(),
    this.checkUpdate = const Value.absent(),
    this.normalizeAudio = const Value.absent(),
    this.showSystemTrayIcon = const Value.absent(),
    this.systemTitleBar = const Value.absent(),
    this.skipNonMusic = const Value.absent(),
    this.closeBehavior = const Value.absent(),
    this.accentColorScheme = const Value.absent(),
    this.layoutMode = const Value.absent(),
    this.locale = const Value.absent(),
    this.market = const Value.absent(),
    this.searchMode = const Value.absent(),
    this.downloadLocation = const Value.absent(),
    this.localLibraryLocation = const Value.absent(),
    this.pipedInstance = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.audioSource = const Value.absent(),
    this.streamMusicCodec = const Value.absent(),
    this.downloadMusicCodec = const Value.absent(),
    this.discordPresence = const Value.absent(),
    this.endlessPlayback = const Value.absent(),
    this.enableConnect = const Value.absent(),
  });
  static Insertable<PreferencesTableData> custom({
    Expression<int>? id,
    Expression<String>? audioQuality,
    Expression<bool>? albumColorSync,
    Expression<bool>? amoledDarkTheme,
    Expression<bool>? checkUpdate,
    Expression<bool>? normalizeAudio,
    Expression<bool>? showSystemTrayIcon,
    Expression<bool>? systemTitleBar,
    Expression<bool>? skipNonMusic,
    Expression<String>? closeBehavior,
    Expression<String>? accentColorScheme,
    Expression<String>? layoutMode,
    Expression<String>? locale,
    Expression<String>? market,
    Expression<String>? searchMode,
    Expression<String>? downloadLocation,
    Expression<String>? localLibraryLocation,
    Expression<String>? pipedInstance,
    Expression<String>? themeMode,
    Expression<String>? audioSource,
    Expression<String>? streamMusicCodec,
    Expression<String>? downloadMusicCodec,
    Expression<bool>? discordPresence,
    Expression<bool>? endlessPlayback,
    Expression<bool>? enableConnect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (audioQuality != null) 'audio_quality': audioQuality,
      if (albumColorSync != null) 'album_color_sync': albumColorSync,
      if (amoledDarkTheme != null) 'amoled_dark_theme': amoledDarkTheme,
      if (checkUpdate != null) 'check_update': checkUpdate,
      if (normalizeAudio != null) 'normalize_audio': normalizeAudio,
      if (showSystemTrayIcon != null)
        'show_system_tray_icon': showSystemTrayIcon,
      if (systemTitleBar != null) 'system_title_bar': systemTitleBar,
      if (skipNonMusic != null) 'skip_non_music': skipNonMusic,
      if (closeBehavior != null) 'close_behavior': closeBehavior,
      if (accentColorScheme != null) 'accent_color_scheme': accentColorScheme,
      if (layoutMode != null) 'layout_mode': layoutMode,
      if (locale != null) 'locale': locale,
      if (market != null) 'market': market,
      if (searchMode != null) 'search_mode': searchMode,
      if (downloadLocation != null) 'download_location': downloadLocation,
      if (localLibraryLocation != null)
        'local_library_location': localLibraryLocation,
      if (pipedInstance != null) 'piped_instance': pipedInstance,
      if (themeMode != null) 'theme_mode': themeMode,
      if (audioSource != null) 'audio_source': audioSource,
      if (streamMusicCodec != null) 'stream_music_codec': streamMusicCodec,
      if (downloadMusicCodec != null)
        'download_music_codec': downloadMusicCodec,
      if (discordPresence != null) 'discord_presence': discordPresence,
      if (endlessPlayback != null) 'endless_playback': endlessPlayback,
      if (enableConnect != null) 'enable_connect': enableConnect,
    });
  }

  PreferencesTableCompanion copyWith(
      {Value<int>? id,
      Value<SourceQualities>? audioQuality,
      Value<bool>? albumColorSync,
      Value<bool>? amoledDarkTheme,
      Value<bool>? checkUpdate,
      Value<bool>? normalizeAudio,
      Value<bool>? showSystemTrayIcon,
      Value<bool>? systemTitleBar,
      Value<bool>? skipNonMusic,
      Value<CloseBehavior>? closeBehavior,
      Value<SpotubeColor>? accentColorScheme,
      Value<LayoutMode>? layoutMode,
      Value<Locale>? locale,
      Value<Market>? market,
      Value<SearchMode>? searchMode,
      Value<String>? downloadLocation,
      Value<List<String>>? localLibraryLocation,
      Value<String>? pipedInstance,
      Value<ThemeMode>? themeMode,
      Value<AudioSource>? audioSource,
      Value<SourceCodecs>? streamMusicCodec,
      Value<SourceCodecs>? downloadMusicCodec,
      Value<bool>? discordPresence,
      Value<bool>? endlessPlayback,
      Value<bool>? enableConnect}) {
    return PreferencesTableCompanion(
      id: id ?? this.id,
      audioQuality: audioQuality ?? this.audioQuality,
      albumColorSync: albumColorSync ?? this.albumColorSync,
      amoledDarkTheme: amoledDarkTheme ?? this.amoledDarkTheme,
      checkUpdate: checkUpdate ?? this.checkUpdate,
      normalizeAudio: normalizeAudio ?? this.normalizeAudio,
      showSystemTrayIcon: showSystemTrayIcon ?? this.showSystemTrayIcon,
      systemTitleBar: systemTitleBar ?? this.systemTitleBar,
      skipNonMusic: skipNonMusic ?? this.skipNonMusic,
      closeBehavior: closeBehavior ?? this.closeBehavior,
      accentColorScheme: accentColorScheme ?? this.accentColorScheme,
      layoutMode: layoutMode ?? this.layoutMode,
      locale: locale ?? this.locale,
      market: market ?? this.market,
      searchMode: searchMode ?? this.searchMode,
      downloadLocation: downloadLocation ?? this.downloadLocation,
      localLibraryLocation: localLibraryLocation ?? this.localLibraryLocation,
      pipedInstance: pipedInstance ?? this.pipedInstance,
      themeMode: themeMode ?? this.themeMode,
      audioSource: audioSource ?? this.audioSource,
      streamMusicCodec: streamMusicCodec ?? this.streamMusicCodec,
      downloadMusicCodec: downloadMusicCodec ?? this.downloadMusicCodec,
      discordPresence: discordPresence ?? this.discordPresence,
      endlessPlayback: endlessPlayback ?? this.endlessPlayback,
      enableConnect: enableConnect ?? this.enableConnect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (audioQuality.present) {
      map['audio_quality'] = Variable<String>($PreferencesTableTable
          .$converteraudioQuality
          .toSql(audioQuality.value));
    }
    if (albumColorSync.present) {
      map['album_color_sync'] = Variable<bool>(albumColorSync.value);
    }
    if (amoledDarkTheme.present) {
      map['amoled_dark_theme'] = Variable<bool>(amoledDarkTheme.value);
    }
    if (checkUpdate.present) {
      map['check_update'] = Variable<bool>(checkUpdate.value);
    }
    if (normalizeAudio.present) {
      map['normalize_audio'] = Variable<bool>(normalizeAudio.value);
    }
    if (showSystemTrayIcon.present) {
      map['show_system_tray_icon'] = Variable<bool>(showSystemTrayIcon.value);
    }
    if (systemTitleBar.present) {
      map['system_title_bar'] = Variable<bool>(systemTitleBar.value);
    }
    if (skipNonMusic.present) {
      map['skip_non_music'] = Variable<bool>(skipNonMusic.value);
    }
    if (closeBehavior.present) {
      map['close_behavior'] = Variable<String>($PreferencesTableTable
          .$convertercloseBehavior
          .toSql(closeBehavior.value));
    }
    if (accentColorScheme.present) {
      map['accent_color_scheme'] = Variable<String>($PreferencesTableTable
          .$converteraccentColorScheme
          .toSql(accentColorScheme.value));
    }
    if (layoutMode.present) {
      map['layout_mode'] = Variable<String>(
          $PreferencesTableTable.$converterlayoutMode.toSql(layoutMode.value));
    }
    if (locale.present) {
      map['locale'] = Variable<String>(
          $PreferencesTableTable.$converterlocale.toSql(locale.value));
    }
    if (market.present) {
      map['market'] = Variable<String>(
          $PreferencesTableTable.$convertermarket.toSql(market.value));
    }
    if (searchMode.present) {
      map['search_mode'] = Variable<String>(
          $PreferencesTableTable.$convertersearchMode.toSql(searchMode.value));
    }
    if (downloadLocation.present) {
      map['download_location'] = Variable<String>(downloadLocation.value);
    }
    if (localLibraryLocation.present) {
      map['local_library_location'] = Variable<String>($PreferencesTableTable
          .$converterlocalLibraryLocation
          .toSql(localLibraryLocation.value));
    }
    if (pipedInstance.present) {
      map['piped_instance'] = Variable<String>(pipedInstance.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(
          $PreferencesTableTable.$converterthemeMode.toSql(themeMode.value));
    }
    if (audioSource.present) {
      map['audio_source'] = Variable<String>($PreferencesTableTable
          .$converteraudioSource
          .toSql(audioSource.value));
    }
    if (streamMusicCodec.present) {
      map['stream_music_codec'] = Variable<String>($PreferencesTableTable
          .$converterstreamMusicCodec
          .toSql(streamMusicCodec.value));
    }
    if (downloadMusicCodec.present) {
      map['download_music_codec'] = Variable<String>($PreferencesTableTable
          .$converterdownloadMusicCodec
          .toSql(downloadMusicCodec.value));
    }
    if (discordPresence.present) {
      map['discord_presence'] = Variable<bool>(discordPresence.value);
    }
    if (endlessPlayback.present) {
      map['endless_playback'] = Variable<bool>(endlessPlayback.value);
    }
    if (enableConnect.present) {
      map['enable_connect'] = Variable<bool>(enableConnect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('audioQuality: $audioQuality, ')
          ..write('albumColorSync: $albumColorSync, ')
          ..write('amoledDarkTheme: $amoledDarkTheme, ')
          ..write('checkUpdate: $checkUpdate, ')
          ..write('normalizeAudio: $normalizeAudio, ')
          ..write('showSystemTrayIcon: $showSystemTrayIcon, ')
          ..write('systemTitleBar: $systemTitleBar, ')
          ..write('skipNonMusic: $skipNonMusic, ')
          ..write('closeBehavior: $closeBehavior, ')
          ..write('accentColorScheme: $accentColorScheme, ')
          ..write('layoutMode: $layoutMode, ')
          ..write('locale: $locale, ')
          ..write('market: $market, ')
          ..write('searchMode: $searchMode, ')
          ..write('downloadLocation: $downloadLocation, ')
          ..write('localLibraryLocation: $localLibraryLocation, ')
          ..write('pipedInstance: $pipedInstance, ')
          ..write('themeMode: $themeMode, ')
          ..write('audioSource: $audioSource, ')
          ..write('streamMusicCodec: $streamMusicCodec, ')
          ..write('downloadMusicCodec: $downloadMusicCodec, ')
          ..write('discordPresence: $discordPresence, ')
          ..write('endlessPlayback: $endlessPlayback, ')
          ..write('enableConnect: $enableConnect')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $PreferencesTableTable preferencesTable =
      $PreferencesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferencesTable];
}

typedef $$PreferencesTableTableInsertCompanionBuilder
    = PreferencesTableCompanion Function({
  Value<int> id,
  Value<SourceQualities> audioQuality,
  Value<bool> albumColorSync,
  Value<bool> amoledDarkTheme,
  Value<bool> checkUpdate,
  Value<bool> normalizeAudio,
  Value<bool> showSystemTrayIcon,
  Value<bool> systemTitleBar,
  Value<bool> skipNonMusic,
  Value<CloseBehavior> closeBehavior,
  Value<SpotubeColor> accentColorScheme,
  Value<LayoutMode> layoutMode,
  Value<Locale> locale,
  Value<Market> market,
  Value<SearchMode> searchMode,
  Value<String> downloadLocation,
  Value<List<String>> localLibraryLocation,
  Value<String> pipedInstance,
  Value<ThemeMode> themeMode,
  Value<AudioSource> audioSource,
  Value<SourceCodecs> streamMusicCodec,
  Value<SourceCodecs> downloadMusicCodec,
  Value<bool> discordPresence,
  Value<bool> endlessPlayback,
  Value<bool> enableConnect,
});
typedef $$PreferencesTableTableUpdateCompanionBuilder
    = PreferencesTableCompanion Function({
  Value<int> id,
  Value<SourceQualities> audioQuality,
  Value<bool> albumColorSync,
  Value<bool> amoledDarkTheme,
  Value<bool> checkUpdate,
  Value<bool> normalizeAudio,
  Value<bool> showSystemTrayIcon,
  Value<bool> systemTitleBar,
  Value<bool> skipNonMusic,
  Value<CloseBehavior> closeBehavior,
  Value<SpotubeColor> accentColorScheme,
  Value<LayoutMode> layoutMode,
  Value<Locale> locale,
  Value<Market> market,
  Value<SearchMode> searchMode,
  Value<String> downloadLocation,
  Value<List<String>> localLibraryLocation,
  Value<String> pipedInstance,
  Value<ThemeMode> themeMode,
  Value<AudioSource> audioSource,
  Value<SourceCodecs> streamMusicCodec,
  Value<SourceCodecs> downloadMusicCodec,
  Value<bool> discordPresence,
  Value<bool> endlessPlayback,
  Value<bool> enableConnect,
});

class $$PreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PreferencesTableTable,
    PreferencesTableData,
    $$PreferencesTableTableFilterComposer,
    $$PreferencesTableTableOrderingComposer,
    $$PreferencesTableTableProcessedTableManager,
    $$PreferencesTableTableInsertCompanionBuilder,
    $$PreferencesTableTableUpdateCompanionBuilder> {
  $$PreferencesTableTableTableManager(
      _$AppDatabase db, $PreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PreferencesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PreferencesTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PreferencesTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<SourceQualities> audioQuality = const Value.absent(),
            Value<bool> albumColorSync = const Value.absent(),
            Value<bool> amoledDarkTheme = const Value.absent(),
            Value<bool> checkUpdate = const Value.absent(),
            Value<bool> normalizeAudio = const Value.absent(),
            Value<bool> showSystemTrayIcon = const Value.absent(),
            Value<bool> systemTitleBar = const Value.absent(),
            Value<bool> skipNonMusic = const Value.absent(),
            Value<CloseBehavior> closeBehavior = const Value.absent(),
            Value<SpotubeColor> accentColorScheme = const Value.absent(),
            Value<LayoutMode> layoutMode = const Value.absent(),
            Value<Locale> locale = const Value.absent(),
            Value<Market> market = const Value.absent(),
            Value<SearchMode> searchMode = const Value.absent(),
            Value<String> downloadLocation = const Value.absent(),
            Value<List<String>> localLibraryLocation = const Value.absent(),
            Value<String> pipedInstance = const Value.absent(),
            Value<ThemeMode> themeMode = const Value.absent(),
            Value<AudioSource> audioSource = const Value.absent(),
            Value<SourceCodecs> streamMusicCodec = const Value.absent(),
            Value<SourceCodecs> downloadMusicCodec = const Value.absent(),
            Value<bool> discordPresence = const Value.absent(),
            Value<bool> endlessPlayback = const Value.absent(),
            Value<bool> enableConnect = const Value.absent(),
          }) =>
              PreferencesTableCompanion(
            id: id,
            audioQuality: audioQuality,
            albumColorSync: albumColorSync,
            amoledDarkTheme: amoledDarkTheme,
            checkUpdate: checkUpdate,
            normalizeAudio: normalizeAudio,
            showSystemTrayIcon: showSystemTrayIcon,
            systemTitleBar: systemTitleBar,
            skipNonMusic: skipNonMusic,
            closeBehavior: closeBehavior,
            accentColorScheme: accentColorScheme,
            layoutMode: layoutMode,
            locale: locale,
            market: market,
            searchMode: searchMode,
            downloadLocation: downloadLocation,
            localLibraryLocation: localLibraryLocation,
            pipedInstance: pipedInstance,
            themeMode: themeMode,
            audioSource: audioSource,
            streamMusicCodec: streamMusicCodec,
            downloadMusicCodec: downloadMusicCodec,
            discordPresence: discordPresence,
            endlessPlayback: endlessPlayback,
            enableConnect: enableConnect,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<SourceQualities> audioQuality = const Value.absent(),
            Value<bool> albumColorSync = const Value.absent(),
            Value<bool> amoledDarkTheme = const Value.absent(),
            Value<bool> checkUpdate = const Value.absent(),
            Value<bool> normalizeAudio = const Value.absent(),
            Value<bool> showSystemTrayIcon = const Value.absent(),
            Value<bool> systemTitleBar = const Value.absent(),
            Value<bool> skipNonMusic = const Value.absent(),
            Value<CloseBehavior> closeBehavior = const Value.absent(),
            Value<SpotubeColor> accentColorScheme = const Value.absent(),
            Value<LayoutMode> layoutMode = const Value.absent(),
            Value<Locale> locale = const Value.absent(),
            Value<Market> market = const Value.absent(),
            Value<SearchMode> searchMode = const Value.absent(),
            Value<String> downloadLocation = const Value.absent(),
            Value<List<String>> localLibraryLocation = const Value.absent(),
            Value<String> pipedInstance = const Value.absent(),
            Value<ThemeMode> themeMode = const Value.absent(),
            Value<AudioSource> audioSource = const Value.absent(),
            Value<SourceCodecs> streamMusicCodec = const Value.absent(),
            Value<SourceCodecs> downloadMusicCodec = const Value.absent(),
            Value<bool> discordPresence = const Value.absent(),
            Value<bool> endlessPlayback = const Value.absent(),
            Value<bool> enableConnect = const Value.absent(),
          }) =>
              PreferencesTableCompanion.insert(
            id: id,
            audioQuality: audioQuality,
            albumColorSync: albumColorSync,
            amoledDarkTheme: amoledDarkTheme,
            checkUpdate: checkUpdate,
            normalizeAudio: normalizeAudio,
            showSystemTrayIcon: showSystemTrayIcon,
            systemTitleBar: systemTitleBar,
            skipNonMusic: skipNonMusic,
            closeBehavior: closeBehavior,
            accentColorScheme: accentColorScheme,
            layoutMode: layoutMode,
            locale: locale,
            market: market,
            searchMode: searchMode,
            downloadLocation: downloadLocation,
            localLibraryLocation: localLibraryLocation,
            pipedInstance: pipedInstance,
            themeMode: themeMode,
            audioSource: audioSource,
            streamMusicCodec: streamMusicCodec,
            downloadMusicCodec: downloadMusicCodec,
            discordPresence: discordPresence,
            endlessPlayback: endlessPlayback,
            enableConnect: enableConnect,
          ),
        ));
}

class $$PreferencesTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $PreferencesTableTable,
        PreferencesTableData,
        $$PreferencesTableTableFilterComposer,
        $$PreferencesTableTableOrderingComposer,
        $$PreferencesTableTableProcessedTableManager,
        $$PreferencesTableTableInsertCompanionBuilder,
        $$PreferencesTableTableUpdateCompanionBuilder> {
  $$PreferencesTableTableProcessedTableManager(super.$state);
}

class $$PreferencesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SourceQualities, SourceQualities, String>
      get audioQuality => $state.composableBuilder(
          column: $state.table.audioQuality,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<bool> get albumColorSync => $state.composableBuilder(
      column: $state.table.albumColorSync,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get amoledDarkTheme => $state.composableBuilder(
      column: $state.table.amoledDarkTheme,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get checkUpdate => $state.composableBuilder(
      column: $state.table.checkUpdate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get normalizeAudio => $state.composableBuilder(
      column: $state.table.normalizeAudio,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showSystemTrayIcon => $state.composableBuilder(
      column: $state.table.showSystemTrayIcon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get systemTitleBar => $state.composableBuilder(
      column: $state.table.systemTitleBar,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get skipNonMusic => $state.composableBuilder(
      column: $state.table.skipNonMusic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<CloseBehavior, CloseBehavior, String>
      get closeBehavior => $state.composableBuilder(
          column: $state.table.closeBehavior,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SpotubeColor, SpotubeColor, String>
      get accentColorScheme => $state.composableBuilder(
          column: $state.table.accentColorScheme,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<LayoutMode, LayoutMode, String>
      get layoutMode => $state.composableBuilder(
          column: $state.table.layoutMode,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Locale, Locale, String> get locale =>
      $state.composableBuilder(
          column: $state.table.locale,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Market, Market, String> get market =>
      $state.composableBuilder(
          column: $state.table.market,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SearchMode, SearchMode, String>
      get searchMode => $state.composableBuilder(
          column: $state.table.searchMode,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get downloadLocation => $state.composableBuilder(
      column: $state.table.downloadLocation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get localLibraryLocation => $state.composableBuilder(
          column: $state.table.localLibraryLocation,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get pipedInstance => $state.composableBuilder(
      column: $state.table.pipedInstance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<ThemeMode, ThemeMode, String> get themeMode =>
      $state.composableBuilder(
          column: $state.table.themeMode,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<AudioSource, AudioSource, String>
      get audioSource => $state.composableBuilder(
          column: $state.table.audioSource,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SourceCodecs, SourceCodecs, String>
      get streamMusicCodec => $state.composableBuilder(
          column: $state.table.streamMusicCodec,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SourceCodecs, SourceCodecs, String>
      get downloadMusicCodec => $state.composableBuilder(
          column: $state.table.downloadMusicCodec,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<bool> get discordPresence => $state.composableBuilder(
      column: $state.table.discordPresence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get endlessPlayback => $state.composableBuilder(
      column: $state.table.endlessPlayback,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get enableConnect => $state.composableBuilder(
      column: $state.table.enableConnect,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PreferencesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get audioQuality => $state.composableBuilder(
      column: $state.table.audioQuality,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get albumColorSync => $state.composableBuilder(
      column: $state.table.albumColorSync,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get amoledDarkTheme => $state.composableBuilder(
      column: $state.table.amoledDarkTheme,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get checkUpdate => $state.composableBuilder(
      column: $state.table.checkUpdate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get normalizeAudio => $state.composableBuilder(
      column: $state.table.normalizeAudio,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showSystemTrayIcon => $state.composableBuilder(
      column: $state.table.showSystemTrayIcon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get systemTitleBar => $state.composableBuilder(
      column: $state.table.systemTitleBar,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get skipNonMusic => $state.composableBuilder(
      column: $state.table.skipNonMusic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get closeBehavior => $state.composableBuilder(
      column: $state.table.closeBehavior,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accentColorScheme => $state.composableBuilder(
      column: $state.table.accentColorScheme,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get layoutMode => $state.composableBuilder(
      column: $state.table.layoutMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get locale => $state.composableBuilder(
      column: $state.table.locale,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get market => $state.composableBuilder(
      column: $state.table.market,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get searchMode => $state.composableBuilder(
      column: $state.table.searchMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get downloadLocation => $state.composableBuilder(
      column: $state.table.downloadLocation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get localLibraryLocation => $state.composableBuilder(
      column: $state.table.localLibraryLocation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pipedInstance => $state.composableBuilder(
      column: $state.table.pipedInstance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get audioSource => $state.composableBuilder(
      column: $state.table.audioSource,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get streamMusicCodec => $state.composableBuilder(
      column: $state.table.streamMusicCodec,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get downloadMusicCodec => $state.composableBuilder(
      column: $state.table.downloadMusicCodec,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get discordPresence => $state.composableBuilder(
      column: $state.table.discordPresence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get endlessPlayback => $state.composableBuilder(
      column: $state.table.endlessPlayback,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get enableConnect => $state.composableBuilder(
      column: $state.table.enableConnect,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$PreferencesTableTableTableManager get preferencesTable =>
      $$PreferencesTableTableTableManager(_db, _db.preferencesTable);
}
