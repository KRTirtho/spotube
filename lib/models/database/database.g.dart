// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AuthenticationTableTable extends AuthenticationTable
    with TableInfo<$AuthenticationTableTable, AuthenticationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthenticationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cookieMeta = const VerificationMeta('cookie');
  @override
  late final GeneratedColumnWithTypeConverter<DecryptedText, String> cookie =
      GeneratedColumn<String>('cookie', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DecryptedText>(
              $AuthenticationTableTable.$convertercookie);
  static const VerificationMeta _accessTokenMeta =
      const VerificationMeta('accessToken');
  @override
  late final GeneratedColumnWithTypeConverter<DecryptedText, String>
      accessToken = GeneratedColumn<String>('access_token', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DecryptedText>(
              $AuthenticationTableTable.$converteraccessToken);
  static const VerificationMeta _expirationMeta =
      const VerificationMeta('expiration');
  @override
  late final GeneratedColumn<DateTime> expiration = GeneratedColumn<DateTime>(
      'expiration', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, cookie, accessToken, expiration];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'authentication_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AuthenticationTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_cookieMeta, const VerificationResult.success());
    context.handle(_accessTokenMeta, const VerificationResult.success());
    if (data.containsKey('expiration')) {
      context.handle(
          _expirationMeta,
          expiration.isAcceptableOrUnknown(
              data['expiration']!, _expirationMeta));
    } else if (isInserting) {
      context.missing(_expirationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthenticationTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthenticationTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cookie: $AuthenticationTableTable.$convertercookie.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}cookie'])!),
      accessToken: $AuthenticationTableTable.$converteraccessToken.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}access_token'])!),
      expiration: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiration'])!,
    );
  }

  @override
  $AuthenticationTableTable createAlias(String alias) {
    return $AuthenticationTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DecryptedText, String> $convertercookie =
      EncryptedTextConverter();
  static TypeConverter<DecryptedText, String> $converteraccessToken =
      EncryptedTextConverter();
}

class AuthenticationTableData extends DataClass
    implements Insertable<AuthenticationTableData> {
  final int id;
  final DecryptedText cookie;
  final DecryptedText accessToken;
  final DateTime expiration;
  const AuthenticationTableData(
      {required this.id,
      required this.cookie,
      required this.accessToken,
      required this.expiration});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['cookie'] = Variable<String>(
          $AuthenticationTableTable.$convertercookie.toSql(cookie));
    }
    {
      map['access_token'] = Variable<String>(
          $AuthenticationTableTable.$converteraccessToken.toSql(accessToken));
    }
    map['expiration'] = Variable<DateTime>(expiration);
    return map;
  }

  AuthenticationTableCompanion toCompanion(bool nullToAbsent) {
    return AuthenticationTableCompanion(
      id: Value(id),
      cookie: Value(cookie),
      accessToken: Value(accessToken),
      expiration: Value(expiration),
    );
  }

  factory AuthenticationTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthenticationTableData(
      id: serializer.fromJson<int>(json['id']),
      cookie: serializer.fromJson<DecryptedText>(json['cookie']),
      accessToken: serializer.fromJson<DecryptedText>(json['accessToken']),
      expiration: serializer.fromJson<DateTime>(json['expiration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cookie': serializer.toJson<DecryptedText>(cookie),
      'accessToken': serializer.toJson<DecryptedText>(accessToken),
      'expiration': serializer.toJson<DateTime>(expiration),
    };
  }

  AuthenticationTableData copyWith(
          {int? id,
          DecryptedText? cookie,
          DecryptedText? accessToken,
          DateTime? expiration}) =>
      AuthenticationTableData(
        id: id ?? this.id,
        cookie: cookie ?? this.cookie,
        accessToken: accessToken ?? this.accessToken,
        expiration: expiration ?? this.expiration,
      );
  @override
  String toString() {
    return (StringBuffer('AuthenticationTableData(')
          ..write('id: $id, ')
          ..write('cookie: $cookie, ')
          ..write('accessToken: $accessToken, ')
          ..write('expiration: $expiration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cookie, accessToken, expiration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthenticationTableData &&
          other.id == this.id &&
          other.cookie == this.cookie &&
          other.accessToken == this.accessToken &&
          other.expiration == this.expiration);
}

class AuthenticationTableCompanion
    extends UpdateCompanion<AuthenticationTableData> {
  final Value<int> id;
  final Value<DecryptedText> cookie;
  final Value<DecryptedText> accessToken;
  final Value<DateTime> expiration;
  const AuthenticationTableCompanion({
    this.id = const Value.absent(),
    this.cookie = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.expiration = const Value.absent(),
  });
  AuthenticationTableCompanion.insert({
    this.id = const Value.absent(),
    required DecryptedText cookie,
    required DecryptedText accessToken,
    required DateTime expiration,
  })  : cookie = Value(cookie),
        accessToken = Value(accessToken),
        expiration = Value(expiration);
  static Insertable<AuthenticationTableData> custom({
    Expression<int>? id,
    Expression<String>? cookie,
    Expression<String>? accessToken,
    Expression<DateTime>? expiration,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cookie != null) 'cookie': cookie,
      if (accessToken != null) 'access_token': accessToken,
      if (expiration != null) 'expiration': expiration,
    });
  }

  AuthenticationTableCompanion copyWith(
      {Value<int>? id,
      Value<DecryptedText>? cookie,
      Value<DecryptedText>? accessToken,
      Value<DateTime>? expiration}) {
    return AuthenticationTableCompanion(
      id: id ?? this.id,
      cookie: cookie ?? this.cookie,
      accessToken: accessToken ?? this.accessToken,
      expiration: expiration ?? this.expiration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cookie.present) {
      map['cookie'] = Variable<String>(
          $AuthenticationTableTable.$convertercookie.toSql(cookie.value));
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>($AuthenticationTableTable
          .$converteraccessToken
          .toSql(accessToken.value));
    }
    if (expiration.present) {
      map['expiration'] = Variable<DateTime>(expiration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthenticationTableCompanion(')
          ..write('id: $id, ')
          ..write('cookie: $cookie, ')
          ..write('accessToken: $accessToken, ')
          ..write('expiration: $expiration')
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

class $ScrobblerTableTable extends ScrobblerTable
    with TableInfo<$ScrobblerTableTable, ScrobblerTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScrobblerTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumnWithTypeConverter<DecryptedText, String>
      passwordHash = GeneratedColumn<String>(
              'password_hash', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DecryptedText>(
              $ScrobblerTableTable.$converterpasswordHash);
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, username, passwordHash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scrobbler_table';
  @override
  VerificationContext validateIntegrity(Insertable<ScrobblerTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    context.handle(_passwordHashMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScrobblerTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScrobblerTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordHash: $ScrobblerTableTable.$converterpasswordHash.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}password_hash'])!),
    );
  }

  @override
  $ScrobblerTableTable createAlias(String alias) {
    return $ScrobblerTableTable(attachedDatabase, alias);
  }

  static TypeConverter<DecryptedText, String> $converterpasswordHash =
      EncryptedTextConverter();
}

class ScrobblerTableData extends DataClass
    implements Insertable<ScrobblerTableData> {
  final int id;
  final DateTime createdAt;
  final String username;
  final DecryptedText passwordHash;
  const ScrobblerTableData(
      {required this.id,
      required this.createdAt,
      required this.username,
      required this.passwordHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['username'] = Variable<String>(username);
    {
      map['password_hash'] = Variable<String>(
          $ScrobblerTableTable.$converterpasswordHash.toSql(passwordHash));
    }
    return map;
  }

  ScrobblerTableCompanion toCompanion(bool nullToAbsent) {
    return ScrobblerTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      username: Value(username),
      passwordHash: Value(passwordHash),
    );
  }

  factory ScrobblerTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScrobblerTableData(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<DecryptedText>(json['passwordHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<DecryptedText>(passwordHash),
    };
  }

  ScrobblerTableData copyWith(
          {int? id,
          DateTime? createdAt,
          String? username,
          DecryptedText? passwordHash}) =>
      ScrobblerTableData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        username: username ?? this.username,
        passwordHash: passwordHash ?? this.passwordHash,
      );
  @override
  String toString() {
    return (StringBuffer('ScrobblerTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, username, passwordHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScrobblerTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash);
}

class ScrobblerTableCompanion extends UpdateCompanion<ScrobblerTableData> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> username;
  final Value<DecryptedText> passwordHash;
  const ScrobblerTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
  });
  ScrobblerTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String username,
    required DecryptedText passwordHash,
  })  : username = Value(username),
        passwordHash = Value(passwordHash);
  static Insertable<ScrobblerTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? username,
    Expression<String>? passwordHash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
    });
  }

  ScrobblerTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<String>? username,
      Value<DecryptedText>? passwordHash}) {
    return ScrobblerTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>($ScrobblerTableTable
          .$converterpasswordHash
          .toSql(passwordHash.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScrobblerTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash')
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

class $AudioPlayerStateTableTable extends AudioPlayerStateTable
    with TableInfo<$AudioPlayerStateTableTable, AudioPlayerStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioPlayerStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _playingMeta =
      const VerificationMeta('playing');
  @override
  late final GeneratedColumn<bool> playing = GeneratedColumn<bool>(
      'playing', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("playing" IN (0, 1))'));
  static const VerificationMeta _loopModeMeta =
      const VerificationMeta('loopMode');
  @override
  late final GeneratedColumnWithTypeConverter<PlaylistMode, String> loopMode =
      GeneratedColumn<String>('loop_mode', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<PlaylistMode>(
              $AudioPlayerStateTableTable.$converterloopMode);
  static const VerificationMeta _shuffledMeta =
      const VerificationMeta('shuffled');
  @override
  late final GeneratedColumn<bool> shuffled = GeneratedColumn<bool>(
      'shuffled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("shuffled" IN (0, 1))'));
  static const VerificationMeta _collectionsMeta =
      const VerificationMeta('collections');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      collections = GeneratedColumn<String>('collections', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $AudioPlayerStateTableTable.$convertercollections);
  @override
  List<GeneratedColumn> get $columns =>
      [id, playing, loopMode, shuffled, collections];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_player_state_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AudioPlayerStateTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playing')) {
      context.handle(_playingMeta,
          playing.isAcceptableOrUnknown(data['playing']!, _playingMeta));
    } else if (isInserting) {
      context.missing(_playingMeta);
    }
    context.handle(_loopModeMeta, const VerificationResult.success());
    if (data.containsKey('shuffled')) {
      context.handle(_shuffledMeta,
          shuffled.isAcceptableOrUnknown(data['shuffled']!, _shuffledMeta));
    } else if (isInserting) {
      context.missing(_shuffledMeta);
    }
    context.handle(_collectionsMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioPlayerStateTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioPlayerStateTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      playing: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}playing'])!,
      loopMode: $AudioPlayerStateTableTable.$converterloopMode.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}loop_mode'])!),
      shuffled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}shuffled'])!,
      collections: $AudioPlayerStateTableTable.$convertercollections.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}collections'])!),
    );
  }

  @override
  $AudioPlayerStateTableTable createAlias(String alias) {
    return $AudioPlayerStateTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlaylistMode, String, String> $converterloopMode =
      const EnumNameConverter<PlaylistMode>(PlaylistMode.values);
  static TypeConverter<List<String>, String> $convertercollections =
      const StringListConverter();
}

class AudioPlayerStateTableData extends DataClass
    implements Insertable<AudioPlayerStateTableData> {
  final int id;
  final bool playing;
  final PlaylistMode loopMode;
  final bool shuffled;
  final List<String> collections;
  const AudioPlayerStateTableData(
      {required this.id,
      required this.playing,
      required this.loopMode,
      required this.shuffled,
      required this.collections});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playing'] = Variable<bool>(playing);
    {
      map['loop_mode'] = Variable<String>(
          $AudioPlayerStateTableTable.$converterloopMode.toSql(loopMode));
    }
    map['shuffled'] = Variable<bool>(shuffled);
    {
      map['collections'] = Variable<String>(
          $AudioPlayerStateTableTable.$convertercollections.toSql(collections));
    }
    return map;
  }

  AudioPlayerStateTableCompanion toCompanion(bool nullToAbsent) {
    return AudioPlayerStateTableCompanion(
      id: Value(id),
      playing: Value(playing),
      loopMode: Value(loopMode),
      shuffled: Value(shuffled),
      collections: Value(collections),
    );
  }

  factory AudioPlayerStateTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioPlayerStateTableData(
      id: serializer.fromJson<int>(json['id']),
      playing: serializer.fromJson<bool>(json['playing']),
      loopMode: $AudioPlayerStateTableTable.$converterloopMode
          .fromJson(serializer.fromJson<String>(json['loopMode'])),
      shuffled: serializer.fromJson<bool>(json['shuffled']),
      collections: serializer.fromJson<List<String>>(json['collections']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playing': serializer.toJson<bool>(playing),
      'loopMode': serializer.toJson<String>(
          $AudioPlayerStateTableTable.$converterloopMode.toJson(loopMode)),
      'shuffled': serializer.toJson<bool>(shuffled),
      'collections': serializer.toJson<List<String>>(collections),
    };
  }

  AudioPlayerStateTableData copyWith(
          {int? id,
          bool? playing,
          PlaylistMode? loopMode,
          bool? shuffled,
          List<String>? collections}) =>
      AudioPlayerStateTableData(
        id: id ?? this.id,
        playing: playing ?? this.playing,
        loopMode: loopMode ?? this.loopMode,
        shuffled: shuffled ?? this.shuffled,
        collections: collections ?? this.collections,
      );
  @override
  String toString() {
    return (StringBuffer('AudioPlayerStateTableData(')
          ..write('id: $id, ')
          ..write('playing: $playing, ')
          ..write('loopMode: $loopMode, ')
          ..write('shuffled: $shuffled, ')
          ..write('collections: $collections')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playing, loopMode, shuffled, collections);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioPlayerStateTableData &&
          other.id == this.id &&
          other.playing == this.playing &&
          other.loopMode == this.loopMode &&
          other.shuffled == this.shuffled &&
          other.collections == this.collections);
}

class AudioPlayerStateTableCompanion
    extends UpdateCompanion<AudioPlayerStateTableData> {
  final Value<int> id;
  final Value<bool> playing;
  final Value<PlaylistMode> loopMode;
  final Value<bool> shuffled;
  final Value<List<String>> collections;
  const AudioPlayerStateTableCompanion({
    this.id = const Value.absent(),
    this.playing = const Value.absent(),
    this.loopMode = const Value.absent(),
    this.shuffled = const Value.absent(),
    this.collections = const Value.absent(),
  });
  AudioPlayerStateTableCompanion.insert({
    this.id = const Value.absent(),
    required bool playing,
    required PlaylistMode loopMode,
    required bool shuffled,
    required List<String> collections,
  })  : playing = Value(playing),
        loopMode = Value(loopMode),
        shuffled = Value(shuffled),
        collections = Value(collections);
  static Insertable<AudioPlayerStateTableData> custom({
    Expression<int>? id,
    Expression<bool>? playing,
    Expression<String>? loopMode,
    Expression<bool>? shuffled,
    Expression<String>? collections,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playing != null) 'playing': playing,
      if (loopMode != null) 'loop_mode': loopMode,
      if (shuffled != null) 'shuffled': shuffled,
      if (collections != null) 'collections': collections,
    });
  }

  AudioPlayerStateTableCompanion copyWith(
      {Value<int>? id,
      Value<bool>? playing,
      Value<PlaylistMode>? loopMode,
      Value<bool>? shuffled,
      Value<List<String>>? collections}) {
    return AudioPlayerStateTableCompanion(
      id: id ?? this.id,
      playing: playing ?? this.playing,
      loopMode: loopMode ?? this.loopMode,
      shuffled: shuffled ?? this.shuffled,
      collections: collections ?? this.collections,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playing.present) {
      map['playing'] = Variable<bool>(playing.value);
    }
    if (loopMode.present) {
      map['loop_mode'] = Variable<String>(
          $AudioPlayerStateTableTable.$converterloopMode.toSql(loopMode.value));
    }
    if (shuffled.present) {
      map['shuffled'] = Variable<bool>(shuffled.value);
    }
    if (collections.present) {
      map['collections'] = Variable<String>($AudioPlayerStateTableTable
          .$convertercollections
          .toSql(collections.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioPlayerStateTableCompanion(')
          ..write('id: $id, ')
          ..write('playing: $playing, ')
          ..write('loopMode: $loopMode, ')
          ..write('shuffled: $shuffled, ')
          ..write('collections: $collections')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTableTable extends PlaylistTable
    with TableInfo<$PlaylistTableTable, PlaylistTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _audioPlayerStateIdMeta =
      const VerificationMeta('audioPlayerStateId');
  @override
  late final GeneratedColumn<int> audioPlayerStateId = GeneratedColumn<int>(
      'audio_player_state_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES audio_player_state_table (id)'));
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, audioPlayerStateId, index];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_table';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('audio_player_state_id')) {
      context.handle(
          _audioPlayerStateIdMeta,
          audioPlayerStateId.isAcceptableOrUnknown(
              data['audio_player_state_id']!, _audioPlayerStateIdMeta));
    } else if (isInserting) {
      context.missing(_audioPlayerStateIdMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      audioPlayerStateId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}audio_player_state_id'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
    );
  }

  @override
  $PlaylistTableTable createAlias(String alias) {
    return $PlaylistTableTable(attachedDatabase, alias);
  }
}

class PlaylistTableData extends DataClass
    implements Insertable<PlaylistTableData> {
  final int id;
  final int audioPlayerStateId;
  final int index;
  const PlaylistTableData(
      {required this.id,
      required this.audioPlayerStateId,
      required this.index});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['audio_player_state_id'] = Variable<int>(audioPlayerStateId);
    map['index'] = Variable<int>(index);
    return map;
  }

  PlaylistTableCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTableCompanion(
      id: Value(id),
      audioPlayerStateId: Value(audioPlayerStateId),
      index: Value(index),
    );
  }

  factory PlaylistTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistTableData(
      id: serializer.fromJson<int>(json['id']),
      audioPlayerStateId: serializer.fromJson<int>(json['audioPlayerStateId']),
      index: serializer.fromJson<int>(json['index']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'audioPlayerStateId': serializer.toJson<int>(audioPlayerStateId),
      'index': serializer.toJson<int>(index),
    };
  }

  PlaylistTableData copyWith({int? id, int? audioPlayerStateId, int? index}) =>
      PlaylistTableData(
        id: id ?? this.id,
        audioPlayerStateId: audioPlayerStateId ?? this.audioPlayerStateId,
        index: index ?? this.index,
      );
  @override
  String toString() {
    return (StringBuffer('PlaylistTableData(')
          ..write('id: $id, ')
          ..write('audioPlayerStateId: $audioPlayerStateId, ')
          ..write('index: $index')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, audioPlayerStateId, index);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistTableData &&
          other.id == this.id &&
          other.audioPlayerStateId == this.audioPlayerStateId &&
          other.index == this.index);
}

class PlaylistTableCompanion extends UpdateCompanion<PlaylistTableData> {
  final Value<int> id;
  final Value<int> audioPlayerStateId;
  final Value<int> index;
  const PlaylistTableCompanion({
    this.id = const Value.absent(),
    this.audioPlayerStateId = const Value.absent(),
    this.index = const Value.absent(),
  });
  PlaylistTableCompanion.insert({
    this.id = const Value.absent(),
    required int audioPlayerStateId,
    required int index,
  })  : audioPlayerStateId = Value(audioPlayerStateId),
        index = Value(index);
  static Insertable<PlaylistTableData> custom({
    Expression<int>? id,
    Expression<int>? audioPlayerStateId,
    Expression<int>? index,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (audioPlayerStateId != null)
        'audio_player_state_id': audioPlayerStateId,
      if (index != null) 'index': index,
    });
  }

  PlaylistTableCompanion copyWith(
      {Value<int>? id, Value<int>? audioPlayerStateId, Value<int>? index}) {
    return PlaylistTableCompanion(
      id: id ?? this.id,
      audioPlayerStateId: audioPlayerStateId ?? this.audioPlayerStateId,
      index: index ?? this.index,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (audioPlayerStateId.present) {
      map['audio_player_state_id'] = Variable<int>(audioPlayerStateId.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTableCompanion(')
          ..write('id: $id, ')
          ..write('audioPlayerStateId: $audioPlayerStateId, ')
          ..write('index: $index')
          ..write(')'))
        .toString();
  }
}

class $PlaylistMediaTableTable extends PlaylistMediaTable
    with TableInfo<$PlaylistMediaTableTable, PlaylistMediaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistMediaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _playlistIdMeta =
      const VerificationMeta('playlistId');
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
      'playlist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES playlist_table (id)'));
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _extrasMeta = const VerificationMeta('extras');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      extras = GeneratedColumn<String>('extras', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $PlaylistMediaTableTable.$converterextrasn);
  static const VerificationMeta _httpHeadersMeta =
      const VerificationMeta('httpHeaders');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>?, String>
      httpHeaders = GeneratedColumn<String>('http_headers', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, String>?>(
              $PlaylistMediaTableTable.$converterhttpHeadersn);
  @override
  List<GeneratedColumn> get $columns =>
      [id, playlistId, uri, extras, httpHeaders];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_media_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PlaylistMediaTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
          _playlistIdMeta,
          playlistId.isAcceptableOrUnknown(
              data['playlist_id']!, _playlistIdMeta));
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    context.handle(_extrasMeta, const VerificationResult.success());
    context.handle(_httpHeadersMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistMediaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistMediaTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      playlistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}playlist_id'])!,
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri'])!,
      extras: $PlaylistMediaTableTable.$converterextrasn.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}extras'])),
      httpHeaders: $PlaylistMediaTableTable.$converterhttpHeadersn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}http_headers'])),
    );
  }

  @override
  $PlaylistMediaTableTable createAlias(String alias) {
    return $PlaylistMediaTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterextras =
      const MapTypeConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextrasn =
      NullAwareTypeConverter.wrap($converterextras);
  static TypeConverter<Map<String, String>, String> $converterhttpHeaders =
      const MapTypeConverter();
  static TypeConverter<Map<String, String>?, String?> $converterhttpHeadersn =
      NullAwareTypeConverter.wrap($converterhttpHeaders);
}

class PlaylistMediaTableData extends DataClass
    implements Insertable<PlaylistMediaTableData> {
  final int id;
  final int playlistId;
  final String uri;
  final Map<String, dynamic>? extras;
  final Map<String, String>? httpHeaders;
  const PlaylistMediaTableData(
      {required this.id,
      required this.playlistId,
      required this.uri,
      this.extras,
      this.httpHeaders});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    map['uri'] = Variable<String>(uri);
    if (!nullToAbsent || extras != null) {
      map['extras'] = Variable<String>(
          $PlaylistMediaTableTable.$converterextrasn.toSql(extras));
    }
    if (!nullToAbsent || httpHeaders != null) {
      map['http_headers'] = Variable<String>(
          $PlaylistMediaTableTable.$converterhttpHeadersn.toSql(httpHeaders));
    }
    return map;
  }

  PlaylistMediaTableCompanion toCompanion(bool nullToAbsent) {
    return PlaylistMediaTableCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      uri: Value(uri),
      extras:
          extras == null && nullToAbsent ? const Value.absent() : Value(extras),
      httpHeaders: httpHeaders == null && nullToAbsent
          ? const Value.absent()
          : Value(httpHeaders),
    );
  }

  factory PlaylistMediaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistMediaTableData(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      uri: serializer.fromJson<String>(json['uri']),
      extras: serializer.fromJson<Map<String, dynamic>?>(json['extras']),
      httpHeaders:
          serializer.fromJson<Map<String, String>?>(json['httpHeaders']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'uri': serializer.toJson<String>(uri),
      'extras': serializer.toJson<Map<String, dynamic>?>(extras),
      'httpHeaders': serializer.toJson<Map<String, String>?>(httpHeaders),
    };
  }

  PlaylistMediaTableData copyWith(
          {int? id,
          int? playlistId,
          String? uri,
          Value<Map<String, dynamic>?> extras = const Value.absent(),
          Value<Map<String, String>?> httpHeaders = const Value.absent()}) =>
      PlaylistMediaTableData(
        id: id ?? this.id,
        playlistId: playlistId ?? this.playlistId,
        uri: uri ?? this.uri,
        extras: extras.present ? extras.value : this.extras,
        httpHeaders: httpHeaders.present ? httpHeaders.value : this.httpHeaders,
      );
  @override
  String toString() {
    return (StringBuffer('PlaylistMediaTableData(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('uri: $uri, ')
          ..write('extras: $extras, ')
          ..write('httpHeaders: $httpHeaders')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, uri, extras, httpHeaders);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistMediaTableData &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.uri == this.uri &&
          other.extras == this.extras &&
          other.httpHeaders == this.httpHeaders);
}

class PlaylistMediaTableCompanion
    extends UpdateCompanion<PlaylistMediaTableData> {
  final Value<int> id;
  final Value<int> playlistId;
  final Value<String> uri;
  final Value<Map<String, dynamic>?> extras;
  final Value<Map<String, String>?> httpHeaders;
  const PlaylistMediaTableCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.uri = const Value.absent(),
    this.extras = const Value.absent(),
    this.httpHeaders = const Value.absent(),
  });
  PlaylistMediaTableCompanion.insert({
    this.id = const Value.absent(),
    required int playlistId,
    required String uri,
    this.extras = const Value.absent(),
    this.httpHeaders = const Value.absent(),
  })  : playlistId = Value(playlistId),
        uri = Value(uri);
  static Insertable<PlaylistMediaTableData> custom({
    Expression<int>? id,
    Expression<int>? playlistId,
    Expression<String>? uri,
    Expression<String>? extras,
    Expression<String>? httpHeaders,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (uri != null) 'uri': uri,
      if (extras != null) 'extras': extras,
      if (httpHeaders != null) 'http_headers': httpHeaders,
    });
  }

  PlaylistMediaTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? playlistId,
      Value<String>? uri,
      Value<Map<String, dynamic>?>? extras,
      Value<Map<String, String>?>? httpHeaders}) {
    return PlaylistMediaTableCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      uri: uri ?? this.uri,
      extras: extras ?? this.extras,
      httpHeaders: httpHeaders ?? this.httpHeaders,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (extras.present) {
      map['extras'] = Variable<String>(
          $PlaylistMediaTableTable.$converterextrasn.toSql(extras.value));
    }
    if (httpHeaders.present) {
      map['http_headers'] = Variable<String>($PlaylistMediaTableTable
          .$converterhttpHeadersn
          .toSql(httpHeaders.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistMediaTableCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('uri: $uri, ')
          ..write('extras: $extras, ')
          ..write('httpHeaders: $httpHeaders')
          ..write(')'))
        .toString();
  }
}

class $HistoryTableTable extends HistoryTable
    with TableInfo<$HistoryTableTable, HistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<HistoryEntryType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<HistoryEntryType>($HistoryTableTable.$convertertype);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      data = GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $HistoryTableTable.$converterdata);
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, type, itemId, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_table';
  @override
  VerificationContext validateIntegrity(Insertable<HistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    context.handle(_dataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      type: $HistoryTableTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      data: $HistoryTableTable.$converterdata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
    );
  }

  @override
  $HistoryTableTable createAlias(String alias) {
    return $HistoryTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HistoryEntryType, String, String> $convertertype =
      const EnumNameConverter<HistoryEntryType>(HistoryEntryType.values);
  static TypeConverter<Map<String, dynamic>, String> $converterdata =
      const MapTypeConverter();
}

class HistoryTableData extends DataClass
    implements Insertable<HistoryTableData> {
  final int id;
  final DateTime createdAt;
  final HistoryEntryType type;
  final String itemId;
  final Map<String, dynamic> data;
  const HistoryTableData(
      {required this.id,
      required this.createdAt,
      required this.type,
      required this.itemId,
      required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['type'] =
          Variable<String>($HistoryTableTable.$convertertype.toSql(type));
    }
    map['item_id'] = Variable<String>(itemId);
    {
      map['data'] =
          Variable<String>($HistoryTableTable.$converterdata.toSql(data));
    }
    return map;
  }

  HistoryTableCompanion toCompanion(bool nullToAbsent) {
    return HistoryTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      type: Value(type),
      itemId: Value(itemId),
      data: Value(data),
    );
  }

  factory HistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryTableData(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      type: $HistoryTableTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      itemId: serializer.fromJson<String>(json['itemId']),
      data: serializer.fromJson<Map<String, dynamic>>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'type': serializer
          .toJson<String>($HistoryTableTable.$convertertype.toJson(type)),
      'itemId': serializer.toJson<String>(itemId),
      'data': serializer.toJson<Map<String, dynamic>>(data),
    };
  }

  HistoryTableData copyWith(
          {int? id,
          DateTime? createdAt,
          HistoryEntryType? type,
          String? itemId,
          Map<String, dynamic>? data}) =>
      HistoryTableData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        type: type ?? this.type,
        itemId: itemId ?? this.itemId,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('HistoryTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('itemId: $itemId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, type, itemId, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.type == this.type &&
          other.itemId == this.itemId &&
          other.data == this.data);
}

class HistoryTableCompanion extends UpdateCompanion<HistoryTableData> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<HistoryEntryType> type;
  final Value<String> itemId;
  final Value<Map<String, dynamic>> data;
  const HistoryTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.type = const Value.absent(),
    this.itemId = const Value.absent(),
    this.data = const Value.absent(),
  });
  HistoryTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    required HistoryEntryType type,
    required String itemId,
    required Map<String, dynamic> data,
  })  : type = Value(type),
        itemId = Value(itemId),
        data = Value(data);
  static Insertable<HistoryTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? type,
    Expression<String>? itemId,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (type != null) 'type': type,
      if (itemId != null) 'item_id': itemId,
      if (data != null) 'data': data,
    });
  }

  HistoryTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<HistoryEntryType>? type,
      Value<String>? itemId,
      Value<Map<String, dynamic>>? data}) {
    return HistoryTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      itemId: itemId ?? this.itemId,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($HistoryTableTable.$convertertype.toSql(type.value));
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (data.present) {
      map['data'] =
          Variable<String>($HistoryTableTable.$converterdata.toSql(data.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('itemId: $itemId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $LyricsTableTable extends LyricsTable
    with TableInfo<$LyricsTableTable, LyricsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LyricsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<SubtitleSimple, String> data =
      GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SubtitleSimple>($LyricsTableTable.$converterdata);
  @override
  List<GeneratedColumn> get $columns => [id, trackId, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lyrics_table';
  @override
  VerificationContext validateIntegrity(Insertable<LyricsTableData> instance,
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
    context.handle(_dataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LyricsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LyricsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      trackId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track_id'])!,
      data: $LyricsTableTable.$converterdata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
    );
  }

  @override
  $LyricsTableTable createAlias(String alias) {
    return $LyricsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<SubtitleSimple, String> $converterdata =
      SubtitleTypeConverter();
}

class LyricsTableData extends DataClass implements Insertable<LyricsTableData> {
  final int id;
  final String trackId;
  final SubtitleSimple data;
  const LyricsTableData(
      {required this.id, required this.trackId, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<String>(trackId);
    {
      map['data'] =
          Variable<String>($LyricsTableTable.$converterdata.toSql(data));
    }
    return map;
  }

  LyricsTableCompanion toCompanion(bool nullToAbsent) {
    return LyricsTableCompanion(
      id: Value(id),
      trackId: Value(trackId),
      data: Value(data),
    );
  }

  factory LyricsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LyricsTableData(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<String>(json['trackId']),
      data: serializer.fromJson<SubtitleSimple>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<String>(trackId),
      'data': serializer.toJson<SubtitleSimple>(data),
    };
  }

  LyricsTableData copyWith({int? id, String? trackId, SubtitleSimple? data}) =>
      LyricsTableData(
        id: id ?? this.id,
        trackId: trackId ?? this.trackId,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('LyricsTableData(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LyricsTableData &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.data == this.data);
}

class LyricsTableCompanion extends UpdateCompanion<LyricsTableData> {
  final Value<int> id;
  final Value<String> trackId;
  final Value<SubtitleSimple> data;
  const LyricsTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.data = const Value.absent(),
  });
  LyricsTableCompanion.insert({
    this.id = const Value.absent(),
    required String trackId,
    required SubtitleSimple data,
  })  : trackId = Value(trackId),
        data = Value(data);
  static Insertable<LyricsTableData> custom({
    Expression<int>? id,
    Expression<String>? trackId,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (data != null) 'data': data,
    });
  }

  LyricsTableCompanion copyWith(
      {Value<int>? id, Value<String>? trackId, Value<SubtitleSimple>? data}) {
    return LyricsTableCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      data: data ?? this.data,
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
    if (data.present) {
      map['data'] =
          Variable<String>($LyricsTableTable.$converterdata.toSql(data.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LyricsTableCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $AuthenticationTableTable authenticationTable =
      $AuthenticationTableTable(this);
  late final $BlacklistTableTable blacklistTable = $BlacklistTableTable(this);
  late final $PreferencesTableTable preferencesTable =
      $PreferencesTableTable(this);
  late final $ScrobblerTableTable scrobblerTable = $ScrobblerTableTable(this);
  late final $SkipSegmentTableTable skipSegmentTable =
      $SkipSegmentTableTable(this);
  late final $SourceMatchTableTable sourceMatchTable =
      $SourceMatchTableTable(this);
  late final $AudioPlayerStateTableTable audioPlayerStateTable =
      $AudioPlayerStateTableTable(this);
  late final $PlaylistTableTable playlistTable = $PlaylistTableTable(this);
  late final $PlaylistMediaTableTable playlistMediaTable =
      $PlaylistMediaTableTable(this);
  late final $HistoryTableTable historyTable = $HistoryTableTable(this);
  late final $LyricsTableTable lyricsTable = $LyricsTableTable(this);
  late final Index uniqueBlacklist = Index('unique_blacklist',
      'CREATE UNIQUE INDEX unique_blacklist ON blacklist_table (element_type, element_id)');
  late final Index uniqTrackMatch = Index('uniq_track_match',
      'CREATE UNIQUE INDEX uniq_track_match ON source_match_table (track_id, source_id, source_type)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        authenticationTable,
        blacklistTable,
        preferencesTable,
        scrobblerTable,
        skipSegmentTable,
        sourceMatchTable,
        audioPlayerStateTable,
        playlistTable,
        playlistMediaTable,
        historyTable,
        lyricsTable,
        uniqueBlacklist,
        uniqTrackMatch
      ];
}

typedef $$AuthenticationTableTableInsertCompanionBuilder
    = AuthenticationTableCompanion Function({
  Value<int> id,
  required DecryptedText cookie,
  required DecryptedText accessToken,
  required DateTime expiration,
});
typedef $$AuthenticationTableTableUpdateCompanionBuilder
    = AuthenticationTableCompanion Function({
  Value<int> id,
  Value<DecryptedText> cookie,
  Value<DecryptedText> accessToken,
  Value<DateTime> expiration,
});

class $$AuthenticationTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthenticationTableTable,
    AuthenticationTableData,
    $$AuthenticationTableTableFilterComposer,
    $$AuthenticationTableTableOrderingComposer,
    $$AuthenticationTableTableProcessedTableManager,
    $$AuthenticationTableTableInsertCompanionBuilder,
    $$AuthenticationTableTableUpdateCompanionBuilder> {
  $$AuthenticationTableTableTableManager(
      _$AppDatabase db, $AuthenticationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$AuthenticationTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$AuthenticationTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$AuthenticationTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<DecryptedText> cookie = const Value.absent(),
            Value<DecryptedText> accessToken = const Value.absent(),
            Value<DateTime> expiration = const Value.absent(),
          }) =>
              AuthenticationTableCompanion(
            id: id,
            cookie: cookie,
            accessToken: accessToken,
            expiration: expiration,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required DecryptedText cookie,
            required DecryptedText accessToken,
            required DateTime expiration,
          }) =>
              AuthenticationTableCompanion.insert(
            id: id,
            cookie: cookie,
            accessToken: accessToken,
            expiration: expiration,
          ),
        ));
}

class $$AuthenticationTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $AuthenticationTableTable,
        AuthenticationTableData,
        $$AuthenticationTableTableFilterComposer,
        $$AuthenticationTableTableOrderingComposer,
        $$AuthenticationTableTableProcessedTableManager,
        $$AuthenticationTableTableInsertCompanionBuilder,
        $$AuthenticationTableTableUpdateCompanionBuilder> {
  $$AuthenticationTableTableProcessedTableManager(super.$state);
}

class $$AuthenticationTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AuthenticationTableTable> {
  $$AuthenticationTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<DecryptedText, DecryptedText, String>
      get cookie => $state.composableBuilder(
          column: $state.table.cookie,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<DecryptedText, DecryptedText, String>
      get accessToken => $state.composableBuilder(
          column: $state.table.accessToken,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expiration => $state.composableBuilder(
      column: $state.table.expiration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AuthenticationTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AuthenticationTableTable> {
  $$AuthenticationTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cookie => $state.composableBuilder(
      column: $state.table.cookie,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accessToken => $state.composableBuilder(
      column: $state.table.accessToken,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expiration => $state.composableBuilder(
      column: $state.table.expiration,
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

typedef $$ScrobblerTableTableInsertCompanionBuilder = ScrobblerTableCompanion
    Function({
  Value<int> id,
  Value<DateTime> createdAt,
  required String username,
  required DecryptedText passwordHash,
});
typedef $$ScrobblerTableTableUpdateCompanionBuilder = ScrobblerTableCompanion
    Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<String> username,
  Value<DecryptedText> passwordHash,
});

class $$ScrobblerTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScrobblerTableTable,
    ScrobblerTableData,
    $$ScrobblerTableTableFilterComposer,
    $$ScrobblerTableTableOrderingComposer,
    $$ScrobblerTableTableProcessedTableManager,
    $$ScrobblerTableTableInsertCompanionBuilder,
    $$ScrobblerTableTableUpdateCompanionBuilder> {
  $$ScrobblerTableTableTableManager(
      _$AppDatabase db, $ScrobblerTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ScrobblerTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ScrobblerTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ScrobblerTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<DecryptedText> passwordHash = const Value.absent(),
          }) =>
              ScrobblerTableCompanion(
            id: id,
            createdAt: createdAt,
            username: username,
            passwordHash: passwordHash,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            required String username,
            required DecryptedText passwordHash,
          }) =>
              ScrobblerTableCompanion.insert(
            id: id,
            createdAt: createdAt,
            username: username,
            passwordHash: passwordHash,
          ),
        ));
}

class $$ScrobblerTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $ScrobblerTableTable,
    ScrobblerTableData,
    $$ScrobblerTableTableFilterComposer,
    $$ScrobblerTableTableOrderingComposer,
    $$ScrobblerTableTableProcessedTableManager,
    $$ScrobblerTableTableInsertCompanionBuilder,
    $$ScrobblerTableTableUpdateCompanionBuilder> {
  $$ScrobblerTableTableProcessedTableManager(super.$state);
}

class $$ScrobblerTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ScrobblerTableTable> {
  $$ScrobblerTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<DecryptedText, DecryptedText, String>
      get passwordHash => $state.composableBuilder(
          column: $state.table.passwordHash,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));
}

class $$ScrobblerTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ScrobblerTableTable> {
  $$ScrobblerTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get passwordHash => $state.composableBuilder(
      column: $state.table.passwordHash,
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

typedef $$AudioPlayerStateTableTableInsertCompanionBuilder
    = AudioPlayerStateTableCompanion Function({
  Value<int> id,
  required bool playing,
  required PlaylistMode loopMode,
  required bool shuffled,
  required List<String> collections,
});
typedef $$AudioPlayerStateTableTableUpdateCompanionBuilder
    = AudioPlayerStateTableCompanion Function({
  Value<int> id,
  Value<bool> playing,
  Value<PlaylistMode> loopMode,
  Value<bool> shuffled,
  Value<List<String>> collections,
});

class $$AudioPlayerStateTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AudioPlayerStateTableTable,
    AudioPlayerStateTableData,
    $$AudioPlayerStateTableTableFilterComposer,
    $$AudioPlayerStateTableTableOrderingComposer,
    $$AudioPlayerStateTableTableProcessedTableManager,
    $$AudioPlayerStateTableTableInsertCompanionBuilder,
    $$AudioPlayerStateTableTableUpdateCompanionBuilder> {
  $$AudioPlayerStateTableTableTableManager(
      _$AppDatabase db, $AudioPlayerStateTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$AudioPlayerStateTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$AudioPlayerStateTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$AudioPlayerStateTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<bool> playing = const Value.absent(),
            Value<PlaylistMode> loopMode = const Value.absent(),
            Value<bool> shuffled = const Value.absent(),
            Value<List<String>> collections = const Value.absent(),
          }) =>
              AudioPlayerStateTableCompanion(
            id: id,
            playing: playing,
            loopMode: loopMode,
            shuffled: shuffled,
            collections: collections,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required bool playing,
            required PlaylistMode loopMode,
            required bool shuffled,
            required List<String> collections,
          }) =>
              AudioPlayerStateTableCompanion.insert(
            id: id,
            playing: playing,
            loopMode: loopMode,
            shuffled: shuffled,
            collections: collections,
          ),
        ));
}

class $$AudioPlayerStateTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $AudioPlayerStateTableTable,
        AudioPlayerStateTableData,
        $$AudioPlayerStateTableTableFilterComposer,
        $$AudioPlayerStateTableTableOrderingComposer,
        $$AudioPlayerStateTableTableProcessedTableManager,
        $$AudioPlayerStateTableTableInsertCompanionBuilder,
        $$AudioPlayerStateTableTableUpdateCompanionBuilder> {
  $$AudioPlayerStateTableTableProcessedTableManager(super.$state);
}

class $$AudioPlayerStateTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AudioPlayerStateTableTable> {
  $$AudioPlayerStateTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get playing => $state.composableBuilder(
      column: $state.table.playing,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<PlaylistMode, PlaylistMode, String>
      get loopMode => $state.composableBuilder(
          column: $state.table.loopMode,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<bool> get shuffled => $state.composableBuilder(
      column: $state.table.shuffled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get collections => $state.composableBuilder(
          column: $state.table.collections,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ComposableFilter playlistTableRefs(
      ComposableFilter Function($$PlaylistTableTableFilterComposer f) f) {
    final $$PlaylistTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.playlistTable,
        getReferencedColumn: (t) => t.audioPlayerStateId,
        builder: (joinBuilder, parentComposers) =>
            $$PlaylistTableTableFilterComposer(ComposerState($state.db,
                $state.db.playlistTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$AudioPlayerStateTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AudioPlayerStateTableTable> {
  $$AudioPlayerStateTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get playing => $state.composableBuilder(
      column: $state.table.playing,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get loopMode => $state.composableBuilder(
      column: $state.table.loopMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get shuffled => $state.composableBuilder(
      column: $state.table.shuffled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get collections => $state.composableBuilder(
      column: $state.table.collections,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PlaylistTableTableInsertCompanionBuilder = PlaylistTableCompanion
    Function({
  Value<int> id,
  required int audioPlayerStateId,
  required int index,
});
typedef $$PlaylistTableTableUpdateCompanionBuilder = PlaylistTableCompanion
    Function({
  Value<int> id,
  Value<int> audioPlayerStateId,
  Value<int> index,
});

class $$PlaylistTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistTableTable,
    PlaylistTableData,
    $$PlaylistTableTableFilterComposer,
    $$PlaylistTableTableOrderingComposer,
    $$PlaylistTableTableProcessedTableManager,
    $$PlaylistTableTableInsertCompanionBuilder,
    $$PlaylistTableTableUpdateCompanionBuilder> {
  $$PlaylistTableTableTableManager(_$AppDatabase db, $PlaylistTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PlaylistTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PlaylistTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PlaylistTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> audioPlayerStateId = const Value.absent(),
            Value<int> index = const Value.absent(),
          }) =>
              PlaylistTableCompanion(
            id: id,
            audioPlayerStateId: audioPlayerStateId,
            index: index,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int audioPlayerStateId,
            required int index,
          }) =>
              PlaylistTableCompanion.insert(
            id: id,
            audioPlayerStateId: audioPlayerStateId,
            index: index,
          ),
        ));
}

class $$PlaylistTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $PlaylistTableTable,
    PlaylistTableData,
    $$PlaylistTableTableFilterComposer,
    $$PlaylistTableTableOrderingComposer,
    $$PlaylistTableTableProcessedTableManager,
    $$PlaylistTableTableInsertCompanionBuilder,
    $$PlaylistTableTableUpdateCompanionBuilder> {
  $$PlaylistTableTableProcessedTableManager(super.$state);
}

class $$PlaylistTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get index => $state.composableBuilder(
      column: $state.table.index,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$AudioPlayerStateTableTableFilterComposer get audioPlayerStateId {
    final $$AudioPlayerStateTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.audioPlayerStateId,
            referencedTable: $state.db.audioPlayerStateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$AudioPlayerStateTableTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.audioPlayerStateTable,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  ComposableFilter playlistMediaTableRefs(
      ComposableFilter Function($$PlaylistMediaTableTableFilterComposer f) f) {
    final $$PlaylistMediaTableTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.playlistMediaTable,
            getReferencedColumn: (t) => t.playlistId,
            builder: (joinBuilder, parentComposers) =>
                $$PlaylistMediaTableTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.playlistMediaTable,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$PlaylistTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get index => $state.composableBuilder(
      column: $state.table.index,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$AudioPlayerStateTableTableOrderingComposer get audioPlayerStateId {
    final $$AudioPlayerStateTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.audioPlayerStateId,
            referencedTable: $state.db.audioPlayerStateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$AudioPlayerStateTableTableOrderingComposer(ComposerState(
                    $state.db,
                    $state.db.audioPlayerStateTable,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

typedef $$PlaylistMediaTableTableInsertCompanionBuilder
    = PlaylistMediaTableCompanion Function({
  Value<int> id,
  required int playlistId,
  required String uri,
  Value<Map<String, dynamic>?> extras,
  Value<Map<String, String>?> httpHeaders,
});
typedef $$PlaylistMediaTableTableUpdateCompanionBuilder
    = PlaylistMediaTableCompanion Function({
  Value<int> id,
  Value<int> playlistId,
  Value<String> uri,
  Value<Map<String, dynamic>?> extras,
  Value<Map<String, String>?> httpHeaders,
});

class $$PlaylistMediaTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistMediaTableTable,
    PlaylistMediaTableData,
    $$PlaylistMediaTableTableFilterComposer,
    $$PlaylistMediaTableTableOrderingComposer,
    $$PlaylistMediaTableTableProcessedTableManager,
    $$PlaylistMediaTableTableInsertCompanionBuilder,
    $$PlaylistMediaTableTableUpdateCompanionBuilder> {
  $$PlaylistMediaTableTableTableManager(
      _$AppDatabase db, $PlaylistMediaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PlaylistMediaTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$PlaylistMediaTableTableOrderingComposer(
              ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PlaylistMediaTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> playlistId = const Value.absent(),
            Value<String> uri = const Value.absent(),
            Value<Map<String, dynamic>?> extras = const Value.absent(),
            Value<Map<String, String>?> httpHeaders = const Value.absent(),
          }) =>
              PlaylistMediaTableCompanion(
            id: id,
            playlistId: playlistId,
            uri: uri,
            extras: extras,
            httpHeaders: httpHeaders,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int playlistId,
            required String uri,
            Value<Map<String, dynamic>?> extras = const Value.absent(),
            Value<Map<String, String>?> httpHeaders = const Value.absent(),
          }) =>
              PlaylistMediaTableCompanion.insert(
            id: id,
            playlistId: playlistId,
            uri: uri,
            extras: extras,
            httpHeaders: httpHeaders,
          ),
        ));
}

class $$PlaylistMediaTableTableProcessedTableManager
    extends ProcessedTableManager<
        _$AppDatabase,
        $PlaylistMediaTableTable,
        PlaylistMediaTableData,
        $$PlaylistMediaTableTableFilterComposer,
        $$PlaylistMediaTableTableOrderingComposer,
        $$PlaylistMediaTableTableProcessedTableManager,
        $$PlaylistMediaTableTableInsertCompanionBuilder,
        $$PlaylistMediaTableTableUpdateCompanionBuilder> {
  $$PlaylistMediaTableTableProcessedTableManager(super.$state);
}

class $$PlaylistMediaTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PlaylistMediaTableTable> {
  $$PlaylistMediaTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get uri => $state.composableBuilder(
      column: $state.table.uri,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extras => $state.composableBuilder(
          column: $state.table.extras,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<String, String>?, Map<String, String>,
          String>
      get httpHeaders => $state.composableBuilder(
          column: $state.table.httpHeaders,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  $$PlaylistTableTableFilterComposer get playlistId {
    final $$PlaylistTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $state.db.playlistTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PlaylistTableTableFilterComposer(ComposerState($state.db,
                $state.db.playlistTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PlaylistMediaTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PlaylistMediaTableTable> {
  $$PlaylistMediaTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get uri => $state.composableBuilder(
      column: $state.table.uri,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get extras => $state.composableBuilder(
      column: $state.table.extras,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get httpHeaders => $state.composableBuilder(
      column: $state.table.httpHeaders,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PlaylistTableTableOrderingComposer get playlistId {
    final $$PlaylistTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.playlistId,
            referencedTable: $state.db.playlistTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$PlaylistTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.playlistTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$HistoryTableTableInsertCompanionBuilder = HistoryTableCompanion
    Function({
  Value<int> id,
  Value<DateTime> createdAt,
  required HistoryEntryType type,
  required String itemId,
  required Map<String, dynamic> data,
});
typedef $$HistoryTableTableUpdateCompanionBuilder = HistoryTableCompanion
    Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<HistoryEntryType> type,
  Value<String> itemId,
  Value<Map<String, dynamic>> data,
});

class $$HistoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoryTableTable,
    HistoryTableData,
    $$HistoryTableTableFilterComposer,
    $$HistoryTableTableOrderingComposer,
    $$HistoryTableTableProcessedTableManager,
    $$HistoryTableTableInsertCompanionBuilder,
    $$HistoryTableTableUpdateCompanionBuilder> {
  $$HistoryTableTableTableManager(_$AppDatabase db, $HistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HistoryTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HistoryTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$HistoryTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<HistoryEntryType> type = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<Map<String, dynamic>> data = const Value.absent(),
          }) =>
              HistoryTableCompanion(
            id: id,
            createdAt: createdAt,
            type: type,
            itemId: itemId,
            data: data,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            required HistoryEntryType type,
            required String itemId,
            required Map<String, dynamic> data,
          }) =>
              HistoryTableCompanion.insert(
            id: id,
            createdAt: createdAt,
            type: type,
            itemId: itemId,
            data: data,
          ),
        ));
}

class $$HistoryTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $HistoryTableTable,
    HistoryTableData,
    $$HistoryTableTableFilterComposer,
    $$HistoryTableTableOrderingComposer,
    $$HistoryTableTableProcessedTableManager,
    $$HistoryTableTableInsertCompanionBuilder,
    $$HistoryTableTableUpdateCompanionBuilder> {
  $$HistoryTableTableProcessedTableManager(super.$state);
}

class $$HistoryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HistoryTableTable> {
  $$HistoryTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<HistoryEntryType, HistoryEntryType, String>
      get type => $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get data => $state.composableBuilder(
          column: $state.table.data,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));
}

class $$HistoryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HistoryTableTable> {
  $$HistoryTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LyricsTableTableInsertCompanionBuilder = LyricsTableCompanion
    Function({
  Value<int> id,
  required String trackId,
  required SubtitleSimple data,
});
typedef $$LyricsTableTableUpdateCompanionBuilder = LyricsTableCompanion
    Function({
  Value<int> id,
  Value<String> trackId,
  Value<SubtitleSimple> data,
});

class $$LyricsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LyricsTableTable,
    LyricsTableData,
    $$LyricsTableTableFilterComposer,
    $$LyricsTableTableOrderingComposer,
    $$LyricsTableTableProcessedTableManager,
    $$LyricsTableTableInsertCompanionBuilder,
    $$LyricsTableTableUpdateCompanionBuilder> {
  $$LyricsTableTableTableManager(_$AppDatabase db, $LyricsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LyricsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LyricsTableTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$LyricsTableTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> trackId = const Value.absent(),
            Value<SubtitleSimple> data = const Value.absent(),
          }) =>
              LyricsTableCompanion(
            id: id,
            trackId: trackId,
            data: data,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String trackId,
            required SubtitleSimple data,
          }) =>
              LyricsTableCompanion.insert(
            id: id,
            trackId: trackId,
            data: data,
          ),
        ));
}

class $$LyricsTableTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $LyricsTableTable,
    LyricsTableData,
    $$LyricsTableTableFilterComposer,
    $$LyricsTableTableOrderingComposer,
    $$LyricsTableTableProcessedTableManager,
    $$LyricsTableTableInsertCompanionBuilder,
    $$LyricsTableTableUpdateCompanionBuilder> {
  $$LyricsTableTableProcessedTableManager(super.$state);
}

class $$LyricsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get trackId => $state.composableBuilder(
      column: $state.table.trackId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<SubtitleSimple, SubtitleSimple, String>
      get data => $state.composableBuilder(
          column: $state.table.data,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));
}

class $$LyricsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get trackId => $state.composableBuilder(
      column: $state.table.trackId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$AuthenticationTableTableTableManager get authenticationTable =>
      $$AuthenticationTableTableTableManager(_db, _db.authenticationTable);
  $$BlacklistTableTableTableManager get blacklistTable =>
      $$BlacklistTableTableTableManager(_db, _db.blacklistTable);
  $$PreferencesTableTableTableManager get preferencesTable =>
      $$PreferencesTableTableTableManager(_db, _db.preferencesTable);
  $$ScrobblerTableTableTableManager get scrobblerTable =>
      $$ScrobblerTableTableTableManager(_db, _db.scrobblerTable);
  $$SkipSegmentTableTableTableManager get skipSegmentTable =>
      $$SkipSegmentTableTableTableManager(_db, _db.skipSegmentTable);
  $$SourceMatchTableTableTableManager get sourceMatchTable =>
      $$SourceMatchTableTableTableManager(_db, _db.sourceMatchTable);
  $$AudioPlayerStateTableTableTableManager get audioPlayerStateTable =>
      $$AudioPlayerStateTableTableTableManager(_db, _db.audioPlayerStateTable);
  $$PlaylistTableTableTableManager get playlistTable =>
      $$PlaylistTableTableTableManager(_db, _db.playlistTable);
  $$PlaylistMediaTableTableTableManager get playlistMediaTable =>
      $$PlaylistMediaTableTableTableManager(_db, _db.playlistMediaTable);
  $$HistoryTableTableTableManager get historyTable =>
      $$HistoryTableTableTableManager(_db, _db.historyTable);
  $$LyricsTableTableTableManager get lyricsTable =>
      $$LyricsTableTableTableManager(_db, _db.lyricsTable);
}
