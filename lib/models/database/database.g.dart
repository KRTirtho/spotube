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

class $SourceMatchTableTable extends SourceMatchTable
    with TableInfo<$SourceMatchTableTable, SourceMatchTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceMatchTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _trackIdMeta =
      const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
      'track_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumnWithTypeConverter<SourceType, String> sourceType =
      GeneratedColumn<String>('source_type', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SourceType.youtube.name))
          .withConverter<SourceType>(
              $SourceMatchTableTable.$convertersourceType);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, trackId, sourceId, sourceType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_match_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SourceMatchTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta,
          trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    context.handle(_sourceTypeMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceMatchTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceMatchTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      trackId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      sourceType: $SourceMatchTableTable.$convertersourceType.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}source_type'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SourceMatchTableTable createAlias(String alias) {
    return $SourceMatchTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceType, String, String> $convertersourceType =
      const EnumNameConverter<SourceType>(SourceType.values);
}

class SourceMatchTableData extends DataClass
    implements Insertable<SourceMatchTableData> {
  final int id;
  final String trackId;
  final String sourceId;
  final SourceType sourceType;
  final DateTime createdAt;
  const SourceMatchTableData(
      {required this.id,
      required this.trackId,
      required this.sourceId,
      required this.sourceType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<String>(trackId);
    map['source_id'] = Variable<String>(sourceId);
    {
      map['source_type'] = Variable<String>(
          $SourceMatchTableTable.$convertersourceType.toSql(sourceType));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SourceMatchTableCompanion toCompanion(bool nullToAbsent) {
    return SourceMatchTableCompanion(
      id: Value(id),
      trackId: Value(trackId),
      sourceId: Value(sourceId),
      sourceType: Value(sourceType),
      createdAt: Value(createdAt),
    );
  }

  factory SourceMatchTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceMatchTableData(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      sourceType: $SourceMatchTableTable.$convertersourceType
          .fromJson(serializer.fromJson<String>(json['sourceType'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<String>(trackId),
      'sourceId': serializer.toJson<String>(sourceId),
      'sourceType': serializer.toJson<String>(
          $SourceMatchTableTable.$convertersourceType.toJson(sourceType)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SourceMatchTableData copyWith(
          {int? id,
          String? trackId,
          String? sourceId,
          SourceType? sourceType,
          DateTime? createdAt}) =>
      SourceMatchTableData(
        id: id ?? this.id,
        trackId: trackId ?? this.trackId,
        sourceId: sourceId ?? this.sourceId,
        sourceType: sourceType ?? this.sourceType,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('SourceMatchTableData(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceType: $sourceType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, sourceId, sourceType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceMatchTableData &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.sourceId == this.sourceId &&
          other.sourceType == this.sourceType &&
          other.createdAt == this.createdAt);
}

class SourceMatchTableCompanion extends UpdateCompanion<SourceMatchTableData> {
  final Value<int> id;
  final Value<String> trackId;
  final Value<String> sourceId;
  final Value<SourceType> sourceType;
  final Value<DateTime> createdAt;
  const SourceMatchTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SourceMatchTableCompanion.insert({
    this.id = const Value.absent(),
    required String trackId,
    required String sourceId,
    this.sourceType = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : trackId = Value(trackId),
        sourceId = Value(sourceId);
  static Insertable<SourceMatchTableData> custom({
    Expression<int>? id,
    Expression<String>? trackId,
    Expression<String>? sourceId,
    Expression<String>? sourceType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceType != null) 'source_type': sourceType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SourceMatchTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? trackId,
      Value<String>? sourceId,
      Value<SourceType>? sourceType,
      Value<DateTime>? createdAt}) {
    return SourceMatchTableCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      sourceId: sourceId ?? this.sourceId,
      sourceType: sourceType ?? this.sourceType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(
          $SourceMatchTableTable.$convertersourceType.toSql(sourceType.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceMatchTableCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceType: $sourceType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SkipSegmentTableTable extends SkipSegmentTable
    with TableInfo<$SkipSegmentTableTable, SkipSegmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkipSegmentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<int> start = GeneratedColumn<int>(
      'start', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<int> end = GeneratedColumn<int>(
      'end', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _trackIdMeta =
      const VerificationMeta('trackId');
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
      'track_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, start, end, trackId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skip_segment_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SkipSegmentTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start']!, _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end']!, _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(_trackIdMeta,
          trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta));
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SkipSegmentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkipSegmentTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      start: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start'])!,
      end: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end'])!,
      trackId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SkipSegmentTableTable createAlias(String alias) {
    return $SkipSegmentTableTable(attachedDatabase, alias);
  }
}

class SkipSegmentTableData extends DataClass
    implements Insertable<SkipSegmentTableData> {
  final int id;
  final int start;
  final int end;
  final String trackId;
  final DateTime createdAt;
  const SkipSegmentTableData(
      {required this.id,
      required this.start,
      required this.end,
      required this.trackId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start'] = Variable<int>(start);
    map['end'] = Variable<int>(end);
    map['track_id'] = Variable<String>(trackId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SkipSegmentTableCompanion toCompanion(bool nullToAbsent) {
    return SkipSegmentTableCompanion(
      id: Value(id),
      start: Value(start),
      end: Value(end),
      trackId: Value(trackId),
      createdAt: Value(createdAt),
    );
  }

  factory SkipSegmentTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkipSegmentTableData(
      id: serializer.fromJson<int>(json['id']),
      start: serializer.fromJson<int>(json['start']),
      end: serializer.fromJson<int>(json['end']),
      trackId: serializer.fromJson<String>(json['trackId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'start': serializer.toJson<int>(start),
      'end': serializer.toJson<int>(end),
      'trackId': serializer.toJson<String>(trackId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SkipSegmentTableData copyWith(
          {int? id,
          int? start,
          int? end,
          String? trackId,
          DateTime? createdAt}) =>
      SkipSegmentTableData(
        id: id ?? this.id,
        start: start ?? this.start,
        end: end ?? this.end,
        trackId: trackId ?? this.trackId,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('SkipSegmentTableData(')
          ..write('id: $id, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('trackId: $trackId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, start, end, trackId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkipSegmentTableData &&
          other.id == this.id &&
          other.start == this.start &&
          other.end == this.end &&
          other.trackId == this.trackId &&
          other.createdAt == this.createdAt);
}

class SkipSegmentTableCompanion extends UpdateCompanion<SkipSegmentTableData> {
  final Value<int> id;
  final Value<int> start;
  final Value<int> end;
  final Value<String> trackId;
  final Value<DateTime> createdAt;
  const SkipSegmentTableCompanion({
    this.id = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.trackId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SkipSegmentTableCompanion.insert({
    this.id = const Value.absent(),
    required int start,
    required int end,
    required String trackId,
    this.createdAt = const Value.absent(),
  })  : start = Value(start),
        end = Value(end),
        trackId = Value(trackId);
  static Insertable<SkipSegmentTableData> custom({
    Expression<int>? id,
    Expression<int>? start,
    Expression<int>? end,
    Expression<String>? trackId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (trackId != null) 'track_id': trackId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SkipSegmentTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? start,
      Value<int>? end,
      Value<String>? trackId,
      Value<DateTime>? createdAt}) {
    return SkipSegmentTableCompanion(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      trackId: trackId ?? this.trackId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (start.present) {
      map['start'] = Variable<int>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<int>(end.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkipSegmentTableCompanion(')
          ..write('id: $id, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('trackId: $trackId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BlacklistTableTable extends BlacklistTable
    with TableInfo<$BlacklistTableTable, BlacklistTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlacklistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _elementTypeMeta =
      const VerificationMeta('elementType');
  @override
  late final GeneratedColumnWithTypeConverter<BlacklistedType, String>
      elementType = GeneratedColumn<String>('element_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<BlacklistedType>(
              $BlacklistTableTable.$converterelementType);
  static const VerificationMeta _elementIdMeta =
      const VerificationMeta('elementId');
  @override
  late final GeneratedColumn<String> elementId = GeneratedColumn<String>(
      'element_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, elementType, elementId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blacklist_table';
  @override
  VerificationContext validateIntegrity(Insertable<BlacklistTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_elementTypeMeta, const VerificationResult.success());
    if (data.containsKey('element_id')) {
      context.handle(_elementIdMeta,
          elementId.isAcceptableOrUnknown(data['element_id']!, _elementIdMeta));
    } else if (isInserting) {
      context.missing(_elementIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlacklistTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlacklistTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      elementType: $BlacklistTableTable.$converterelementType.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}element_type'])!),
      elementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}element_id'])!,
    );
  }

  @override
  $BlacklistTableTable createAlias(String alias) {
    return $BlacklistTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BlacklistedType, String, String>
      $converterelementType =
      const EnumNameConverter<BlacklistedType>(BlacklistedType.values);
}

class BlacklistTableData extends DataClass
    implements Insertable<BlacklistTableData> {
  final int id;
  final String name;
  final BlacklistedType elementType;
  final String elementId;
  const BlacklistTableData(
      {required this.id,
      required this.name,
      required this.elementType,
      required this.elementId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['element_type'] = Variable<String>(
          $BlacklistTableTable.$converterelementType.toSql(elementType));
    }
    map['element_id'] = Variable<String>(elementId);
    return map;
  }

  BlacklistTableCompanion toCompanion(bool nullToAbsent) {
    return BlacklistTableCompanion(
      id: Value(id),
      name: Value(name),
      elementType: Value(elementType),
      elementId: Value(elementId),
    );
  }

  factory BlacklistTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlacklistTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      elementType: $BlacklistTableTable.$converterelementType
          .fromJson(serializer.fromJson<String>(json['elementType'])),
      elementId: serializer.fromJson<String>(json['elementId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'elementType': serializer.toJson<String>(
          $BlacklistTableTable.$converterelementType.toJson(elementType)),
      'elementId': serializer.toJson<String>(elementId),
    };
  }

  BlacklistTableData copyWith(
          {int? id,
          String? name,
          BlacklistedType? elementType,
          String? elementId}) =>
      BlacklistTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        elementType: elementType ?? this.elementType,
        elementId: elementId ?? this.elementId,
      );
  @override
  String toString() {
    return (StringBuffer('BlacklistTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('elementType: $elementType, ')
          ..write('elementId: $elementId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, elementType, elementId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlacklistTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.elementType == this.elementType &&
          other.elementId == this.elementId);
}

class BlacklistTableCompanion extends UpdateCompanion<BlacklistTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<BlacklistedType> elementType;
  final Value<String> elementId;
  const BlacklistTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.elementType = const Value.absent(),
    this.elementId = const Value.absent(),
  });
  BlacklistTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required BlacklistedType elementType,
    required String elementId,
  })  : name = Value(name),
        elementType = Value(elementType),
        elementId = Value(elementId);
  static Insertable<BlacklistTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? elementType,
    Expression<String>? elementId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (elementType != null) 'element_type': elementType,
      if (elementId != null) 'element_id': elementId,
    });
  }

  BlacklistTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<BlacklistedType>? elementType,
      Value<String>? elementId}) {
    return BlacklistTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      elementType: elementType ?? this.elementType,
      elementId: elementId ?? this.elementId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (elementType.present) {
      map['element_type'] = Variable<String>(
          $BlacklistTableTable.$converterelementType.toSql(elementType.value));
    }
    if (elementId.present) {
      map['element_id'] = Variable<String>(elementId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlacklistTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('elementType: $elementType, ')
          ..write('elementId: $elementId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $PreferencesTableTable preferencesTable =
      $PreferencesTableTable(this);
  late final $SourceMatchTableTable sourceMatchTable =
      $SourceMatchTableTable(this);
  late final $SkipSegmentTableTable skipSegmentTable =
      $SkipSegmentTableTable(this);
  late final $BlacklistTableTable blacklistTable = $BlacklistTableTable(this);
  late final Index uniqTrackMatch = Index('uniq_track_match',
      'CREATE UNIQUE INDEX uniq_track_match ON source_match_table (track_id, source_id, source_type)');
  late final Index uniqueBlacklist = Index('unique_blacklist',
      'CREATE UNIQUE INDEX unique_blacklist ON blacklist_table (element_type, element_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        preferencesTable,
        sourceMatchTable,
        skipSegmentTable,
        blacklistTable,
        uniqTrackMatch,
        uniqueBlacklist
      ];
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

typedef $$SourceMatchTableTableInsertCompanionBuilder
    = SourceMatchTableCompanion Function({
  Value<int> id,
  required String trackId,
  required String sourceId,
  Value<SourceType> sourceType,
  Value<DateTime> createdAt,
});
typedef $$SourceMatchTableTableUpdateCompanionBuilder
    = SourceMatchTableCompanion Function({
  Value<int> id,
  Value<String> trackId,
  Value<String> sourceId,
  Value<SourceType> sourceType,
  Value<DateTime> createdAt,
});

class $$SourceMatchTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SourceMatchTableTable,
    SourceMatchTableData,
    $$SourceMatchTableTableFilterComposer,
    $$SourceMatchTableTableOrderingComposer,
    $$SourceMatchTableTableProcessedTableManager,
    $$SourceMatchTableTableInsertCompanionBuilder,
    $$SourceMatchTableTableUpdateCompanionBuilder> {
  $$SourceMatchTableTableTableManager(
      _$AppDatabase db, $SourceMatchTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SourceMatchTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SourceMatchTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$SourceMatchTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> trackId = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<SourceType> sourceType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SourceMatchTableCompanion(
            id: id,
            trackId: trackId,
            sourceId: sourceId,
            sourceType: sourceType,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String trackId,
            required String sourceId,
            Value<SourceType> sourceType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SourceMatchTableCompanion.insert(
            id: id,
            trackId: trackId,
            sourceId: sourceId,
            sourceType: sourceType,
            createdAt: createdAt,
          ),
        ));
}

class $$SourceMatchTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $SourceMatchTableTable,
        SourceMatchTableData,
        $$SourceMatchTableTableFilterComposer,
        $$SourceMatchTableTableOrderingComposer,
        $$SourceMatchTableTableProcessedTableManager,
        $$SourceMatchTableTableInsertCompanionBuilder,
        $$SourceMatchTableTableUpdateCompanionBuilder> {
  $$SourceMatchTableTableProcessedTableManager(super.$state);
}

class $$SourceMatchTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SourceMatchTableTable> {
  $$SourceMatchTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get trackId => $state.composableBuilder(
      column: $state.table.trackId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sourceId => $state.composableBuilder(
      column: $state.table.sourceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SourceType, SourceType, String>
      get sourceType => $state.composableBuilder(
          column: $state.table.sourceType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SourceMatchTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SourceMatchTableTable> {
  $$SourceMatchTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get trackId => $state.composableBuilder(
      column: $state.table.trackId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceId => $state.composableBuilder(
      column: $state.table.sourceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceType => $state.composableBuilder(
      column: $state.table.sourceType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SkipSegmentTableTableInsertCompanionBuilder
    = SkipSegmentTableCompanion Function({
  Value<int> id,
  required int start,
  required int end,
  required String trackId,
  Value<DateTime> createdAt,
});
typedef $$SkipSegmentTableTableUpdateCompanionBuilder
    = SkipSegmentTableCompanion Function({
  Value<int> id,
  Value<int> start,
  Value<int> end,
  Value<String> trackId,
  Value<DateTime> createdAt,
});

class $$SkipSegmentTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SkipSegmentTableTable,
    SkipSegmentTableData,
    $$SkipSegmentTableTableFilterComposer,
    $$SkipSegmentTableTableOrderingComposer,
    $$SkipSegmentTableTableProcessedTableManager,
    $$SkipSegmentTableTableInsertCompanionBuilder,
    $$SkipSegmentTableTableUpdateCompanionBuilder> {
  $$SkipSegmentTableTableTableManager(
      _$AppDatabase db, $SkipSegmentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SkipSegmentTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SkipSegmentTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$SkipSegmentTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> start = const Value.absent(),
            Value<int> end = const Value.absent(),
            Value<String> trackId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SkipSegmentTableCompanion(
            id: id,
            start: start,
            end: end,
            trackId: trackId,
            createdAt: createdAt,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int start,
            required int end,
            required String trackId,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SkipSegmentTableCompanion.insert(
            id: id,
            start: start,
            end: end,
            trackId: trackId,
            createdAt: createdAt,
          ),
        ));
}

class $$SkipSegmentTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $SkipSegmentTableTable,
        SkipSegmentTableData,
        $$SkipSegmentTableTableFilterComposer,
        $$SkipSegmentTableTableOrderingComposer,
        $$SkipSegmentTableTableProcessedTableManager,
        $$SkipSegmentTableTableInsertCompanionBuilder,
        $$SkipSegmentTableTableUpdateCompanionBuilder> {
  $$SkipSegmentTableTableProcessedTableManager(super.$state);
}

class $$SkipSegmentTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SkipSegmentTableTable> {
  $$SkipSegmentTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get start => $state.composableBuilder(
      column: $state.table.start,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get end => $state.composableBuilder(
      column: $state.table.end,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get trackId => $state.composableBuilder(
      column: $state.table.trackId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SkipSegmentTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SkipSegmentTableTable> {
  $$SkipSegmentTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get start => $state.composableBuilder(
      column: $state.table.start,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get end => $state.composableBuilder(
      column: $state.table.end,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get trackId => $state.composableBuilder(
      column: $state.table.trackId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BlacklistTableTableInsertCompanionBuilder = BlacklistTableCompanion
    Function({
  Value<int> id,
  required String name,
  required BlacklistedType elementType,
  required String elementId,
});
typedef $$BlacklistTableTableUpdateCompanionBuilder = BlacklistTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<BlacklistedType> elementType,
  Value<String> elementId,
});

class $$BlacklistTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BlacklistTableTable,
    BlacklistTableData,
    $$BlacklistTableTableFilterComposer,
    $$BlacklistTableTableOrderingComposer,
    $$BlacklistTableTableProcessedTableManager,
    $$BlacklistTableTableInsertCompanionBuilder,
    $$BlacklistTableTableUpdateCompanionBuilder> {
  $$BlacklistTableTableTableManager(
      _$AppDatabase db, $BlacklistTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BlacklistTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BlacklistTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$BlacklistTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<BlacklistedType> elementType = const Value.absent(),
            Value<String> elementId = const Value.absent(),
          }) =>
              BlacklistTableCompanion(
            id: id,
            name: name,
            elementType: elementType,
            elementId: elementId,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            required BlacklistedType elementType,
            required String elementId,
          }) =>
              BlacklistTableCompanion.insert(
            id: id,
            name: name,
            elementType: elementType,
            elementId: elementId,
          ),
        ));
}

class $$BlacklistTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $BlacklistTableTable,
    BlacklistTableData,
    $$BlacklistTableTableFilterComposer,
    $$BlacklistTableTableOrderingComposer,
    $$BlacklistTableTableProcessedTableManager,
    $$BlacklistTableTableInsertCompanionBuilder,
    $$BlacklistTableTableUpdateCompanionBuilder> {
  $$BlacklistTableTableProcessedTableManager(super.$state);
}

class $$BlacklistTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BlacklistTableTable> {
  $$BlacklistTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<BlacklistedType, BlacklistedType, String>
      get elementType => $state.composableBuilder(
          column: $state.table.elementType,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get elementId => $state.composableBuilder(
      column: $state.table.elementId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BlacklistTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BlacklistTableTable> {
  $$BlacklistTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get elementType => $state.composableBuilder(
      column: $state.table.elementType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get elementId => $state.composableBuilder(
      column: $state.table.elementId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$PreferencesTableTableTableManager get preferencesTable =>
      $$PreferencesTableTableTableManager(_db, _db.preferencesTable);
  $$SourceMatchTableTableTableManager get sourceMatchTable =>
      $$SourceMatchTableTableTableManager(_db, _db.sourceMatchTable);
  $$SkipSegmentTableTableTableManager get skipSegmentTable =>
      $$SkipSegmentTableTableTableManager(_db, _db.skipSegmentTable);
  $$BlacklistTableTableTableManager get blacklistTable =>
      $$BlacklistTableTableTableManager(_db, _db.blacklistTable);
}
