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
  AuthenticationTableData copyWithCompanion(AuthenticationTableCompanion data) {
    return AuthenticationTableData(
      id: data.id.present ? data.id.value : this.id,
      cookie: data.cookie.present ? data.cookie.value : this.cookie,
      accessToken:
          data.accessToken.present ? data.accessToken.value : this.accessToken,
      expiration:
          data.expiration.present ? data.expiration.value : this.expiration,
    );
  }

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
  BlacklistTableData copyWithCompanion(BlacklistTableCompanion data) {
    return BlacklistTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      elementType:
          data.elementType.present ? data.elementType.value : this.elementType,
      elementId: data.elementId.present ? data.elementId.value : this.elementId,
    );
  }

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
  static const VerificationMeta _invidiousInstanceMeta =
      const VerificationMeta('invidiousInstance');
  @override
  late final GeneratedColumn<String> invidiousInstance =
      GeneratedColumn<String>('invidious_instance', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant("https://inv.nadeko.net"));
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
        invidiousInstance,
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
    if (data.containsKey('invidious_instance')) {
      context.handle(
          _invidiousInstanceMeta,
          invidiousInstance.isAcceptableOrUnknown(
              data['invidious_instance']!, _invidiousInstanceMeta));
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
      invidiousInstance: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}invidious_instance'])!,
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
  final String invidiousInstance;
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
      required this.invidiousInstance,
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
    map['invidious_instance'] = Variable<String>(invidiousInstance);
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
      invidiousInstance: Value(invidiousInstance),
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
      invidiousInstance: serializer.fromJson<String>(json['invidiousInstance']),
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
      'invidiousInstance': serializer.toJson<String>(invidiousInstance),
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
          String? invidiousInstance,
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
        invidiousInstance: invidiousInstance ?? this.invidiousInstance,
        themeMode: themeMode ?? this.themeMode,
        audioSource: audioSource ?? this.audioSource,
        streamMusicCodec: streamMusicCodec ?? this.streamMusicCodec,
        downloadMusicCodec: downloadMusicCodec ?? this.downloadMusicCodec,
        discordPresence: discordPresence ?? this.discordPresence,
        endlessPlayback: endlessPlayback ?? this.endlessPlayback,
        enableConnect: enableConnect ?? this.enableConnect,
      );
  PreferencesTableData copyWithCompanion(PreferencesTableCompanion data) {
    return PreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      audioQuality: data.audioQuality.present
          ? data.audioQuality.value
          : this.audioQuality,
      albumColorSync: data.albumColorSync.present
          ? data.albumColorSync.value
          : this.albumColorSync,
      amoledDarkTheme: data.amoledDarkTheme.present
          ? data.amoledDarkTheme.value
          : this.amoledDarkTheme,
      checkUpdate:
          data.checkUpdate.present ? data.checkUpdate.value : this.checkUpdate,
      normalizeAudio: data.normalizeAudio.present
          ? data.normalizeAudio.value
          : this.normalizeAudio,
      showSystemTrayIcon: data.showSystemTrayIcon.present
          ? data.showSystemTrayIcon.value
          : this.showSystemTrayIcon,
      systemTitleBar: data.systemTitleBar.present
          ? data.systemTitleBar.value
          : this.systemTitleBar,
      skipNonMusic: data.skipNonMusic.present
          ? data.skipNonMusic.value
          : this.skipNonMusic,
      closeBehavior: data.closeBehavior.present
          ? data.closeBehavior.value
          : this.closeBehavior,
      accentColorScheme: data.accentColorScheme.present
          ? data.accentColorScheme.value
          : this.accentColorScheme,
      layoutMode:
          data.layoutMode.present ? data.layoutMode.value : this.layoutMode,
      locale: data.locale.present ? data.locale.value : this.locale,
      market: data.market.present ? data.market.value : this.market,
      searchMode:
          data.searchMode.present ? data.searchMode.value : this.searchMode,
      downloadLocation: data.downloadLocation.present
          ? data.downloadLocation.value
          : this.downloadLocation,
      localLibraryLocation: data.localLibraryLocation.present
          ? data.localLibraryLocation.value
          : this.localLibraryLocation,
      pipedInstance: data.pipedInstance.present
          ? data.pipedInstance.value
          : this.pipedInstance,
      invidiousInstance: data.invidiousInstance.present
          ? data.invidiousInstance.value
          : this.invidiousInstance,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      audioSource:
          data.audioSource.present ? data.audioSource.value : this.audioSource,
      streamMusicCodec: data.streamMusicCodec.present
          ? data.streamMusicCodec.value
          : this.streamMusicCodec,
      downloadMusicCodec: data.downloadMusicCodec.present
          ? data.downloadMusicCodec.value
          : this.downloadMusicCodec,
      discordPresence: data.discordPresence.present
          ? data.discordPresence.value
          : this.discordPresence,
      endlessPlayback: data.endlessPlayback.present
          ? data.endlessPlayback.value
          : this.endlessPlayback,
      enableConnect: data.enableConnect.present
          ? data.enableConnect.value
          : this.enableConnect,
    );
  }

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
          ..write('invidiousInstance: $invidiousInstance, ')
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
        invidiousInstance,
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
          other.invidiousInstance == this.invidiousInstance &&
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
  final Value<String> invidiousInstance;
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
    this.invidiousInstance = const Value.absent(),
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
    this.invidiousInstance = const Value.absent(),
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
    Expression<String>? invidiousInstance,
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
      if (invidiousInstance != null) 'invidious_instance': invidiousInstance,
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
      Value<String>? invidiousInstance,
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
      invidiousInstance: invidiousInstance ?? this.invidiousInstance,
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
    if (invidiousInstance.present) {
      map['invidious_instance'] = Variable<String>(invidiousInstance.value);
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
          ..write('invidiousInstance: $invidiousInstance, ')
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
  ScrobblerTableData copyWithCompanion(ScrobblerTableCompanion data) {
    return ScrobblerTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
    );
  }

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
  SkipSegmentTableData copyWithCompanion(SkipSegmentTableCompanion data) {
    return SkipSegmentTableData(
      id: data.id.present ? data.id.value : this.id,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

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
  SourceMatchTableData copyWithCompanion(SourceMatchTableCompanion data) {
    return SourceMatchTableData(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

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
  AudioPlayerStateTableData copyWithCompanion(
      AudioPlayerStateTableCompanion data) {
    return AudioPlayerStateTableData(
      id: data.id.present ? data.id.value : this.id,
      playing: data.playing.present ? data.playing.value : this.playing,
      loopMode: data.loopMode.present ? data.loopMode.value : this.loopMode,
      shuffled: data.shuffled.present ? data.shuffled.value : this.shuffled,
      collections:
          data.collections.present ? data.collections.value : this.collections,
    );
  }

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
  PlaylistTableData copyWithCompanion(PlaylistTableCompanion data) {
    return PlaylistTableData(
      id: data.id.present ? data.id.value : this.id,
      audioPlayerStateId: data.audioPlayerStateId.present
          ? data.audioPlayerStateId.value
          : this.audioPlayerStateId,
      index: data.index.present ? data.index.value : this.index,
    );
  }

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
      const MapTypeConverter<String, dynamic>();
  static TypeConverter<Map<String, dynamic>?, String?> $converterextrasn =
      NullAwareTypeConverter.wrap($converterextras);
  static TypeConverter<Map<String, String>, String> $converterhttpHeaders =
      const MapTypeConverter<String, String>();
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
  PlaylistMediaTableData copyWithCompanion(PlaylistMediaTableCompanion data) {
    return PlaylistMediaTableData(
      id: data.id.present ? data.id.value : this.id,
      playlistId:
          data.playlistId.present ? data.playlistId.value : this.playlistId,
      uri: data.uri.present ? data.uri.value : this.uri,
      extras: data.extras.present ? data.extras.value : this.extras,
      httpHeaders:
          data.httpHeaders.present ? data.httpHeaders.value : this.httpHeaders,
    );
  }

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
      const MapTypeConverter<String, dynamic>();
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
  HistoryTableData copyWithCompanion(HistoryTableCompanion data) {
    return HistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      type: data.type.present ? data.type.value : this.type,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      data: data.data.present ? data.data.value : this.data,
    );
  }

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
  LyricsTableData copyWithCompanion(LyricsTableCompanion data) {
    return LyricsTableData(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      data: data.data.present ? data.data.value : this.data,
    );
  }

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
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
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

typedef $$AuthenticationTableTableCreateCompanionBuilder
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

class $$AuthenticationTableTableFilterComposer
    extends Composer<_$AppDatabase, $AuthenticationTableTable> {
  $$AuthenticationTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DecryptedText, DecryptedText, String>
      get cookie => $composableBuilder(
          column: $table.cookie,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<DecryptedText, DecryptedText, String>
      get accessToken => $composableBuilder(
          column: $table.accessToken,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get expiration => $composableBuilder(
      column: $table.expiration, builder: (column) => ColumnFilters(column));
}

class $$AuthenticationTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthenticationTableTable> {
  $$AuthenticationTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cookie => $composableBuilder(
      column: $table.cookie, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiration => $composableBuilder(
      column: $table.expiration, builder: (column) => ColumnOrderings(column));
}

class $$AuthenticationTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthenticationTableTable> {
  $$AuthenticationTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DecryptedText, String> get cookie =>
      $composableBuilder(column: $table.cookie, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DecryptedText, String> get accessToken =>
      $composableBuilder(
          column: $table.accessToken, builder: (column) => column);

  GeneratedColumn<DateTime> get expiration => $composableBuilder(
      column: $table.expiration, builder: (column) => column);
}

class $$AuthenticationTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthenticationTableTable,
    AuthenticationTableData,
    $$AuthenticationTableTableFilterComposer,
    $$AuthenticationTableTableOrderingComposer,
    $$AuthenticationTableTableAnnotationComposer,
    $$AuthenticationTableTableCreateCompanionBuilder,
    $$AuthenticationTableTableUpdateCompanionBuilder,
    (
      AuthenticationTableData,
      BaseReferences<_$AppDatabase, $AuthenticationTableTable,
          AuthenticationTableData>
    ),
    AuthenticationTableData,
    PrefetchHooks Function()> {
  $$AuthenticationTableTableTableManager(
      _$AppDatabase db, $AuthenticationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthenticationTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthenticationTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthenticationTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthenticationTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuthenticationTableTable,
    AuthenticationTableData,
    $$AuthenticationTableTableFilterComposer,
    $$AuthenticationTableTableOrderingComposer,
    $$AuthenticationTableTableAnnotationComposer,
    $$AuthenticationTableTableCreateCompanionBuilder,
    $$AuthenticationTableTableUpdateCompanionBuilder,
    (
      AuthenticationTableData,
      BaseReferences<_$AppDatabase, $AuthenticationTableTable,
          AuthenticationTableData>
    ),
    AuthenticationTableData,
    PrefetchHooks Function()>;
typedef $$BlacklistTableTableCreateCompanionBuilder = BlacklistTableCompanion
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

class $$BlacklistTableTableFilterComposer
    extends Composer<_$AppDatabase, $BlacklistTableTable> {
  $$BlacklistTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<BlacklistedType, BlacklistedType, String>
      get elementType => $composableBuilder(
          column: $table.elementType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get elementId => $composableBuilder(
      column: $table.elementId, builder: (column) => ColumnFilters(column));
}

class $$BlacklistTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BlacklistTableTable> {
  $$BlacklistTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get elementType => $composableBuilder(
      column: $table.elementType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get elementId => $composableBuilder(
      column: $table.elementId, builder: (column) => ColumnOrderings(column));
}

class $$BlacklistTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlacklistTableTable> {
  $$BlacklistTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BlacklistedType, String> get elementType =>
      $composableBuilder(
          column: $table.elementType, builder: (column) => column);

  GeneratedColumn<String> get elementId =>
      $composableBuilder(column: $table.elementId, builder: (column) => column);
}

class $$BlacklistTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BlacklistTableTable,
    BlacklistTableData,
    $$BlacklistTableTableFilterComposer,
    $$BlacklistTableTableOrderingComposer,
    $$BlacklistTableTableAnnotationComposer,
    $$BlacklistTableTableCreateCompanionBuilder,
    $$BlacklistTableTableUpdateCompanionBuilder,
    (
      BlacklistTableData,
      BaseReferences<_$AppDatabase, $BlacklistTableTable, BlacklistTableData>
    ),
    BlacklistTableData,
    PrefetchHooks Function()> {
  $$BlacklistTableTableTableManager(
      _$AppDatabase db, $BlacklistTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlacklistTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlacklistTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlacklistTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BlacklistTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BlacklistTableTable,
    BlacklistTableData,
    $$BlacklistTableTableFilterComposer,
    $$BlacklistTableTableOrderingComposer,
    $$BlacklistTableTableAnnotationComposer,
    $$BlacklistTableTableCreateCompanionBuilder,
    $$BlacklistTableTableUpdateCompanionBuilder,
    (
      BlacklistTableData,
      BaseReferences<_$AppDatabase, $BlacklistTableTable, BlacklistTableData>
    ),
    BlacklistTableData,
    PrefetchHooks Function()>;
typedef $$PreferencesTableTableCreateCompanionBuilder
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
  Value<String> invidiousInstance,
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
  Value<String> invidiousInstance,
  Value<ThemeMode> themeMode,
  Value<AudioSource> audioSource,
  Value<SourceCodecs> streamMusicCodec,
  Value<SourceCodecs> downloadMusicCodec,
  Value<bool> discordPresence,
  Value<bool> endlessPlayback,
  Value<bool> enableConnect,
});

class $$PreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SourceQualities, SourceQualities, String>
      get audioQuality => $composableBuilder(
          column: $table.audioQuality,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get albumColorSync => $composableBuilder(
      column: $table.albumColorSync,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get amoledDarkTheme => $composableBuilder(
      column: $table.amoledDarkTheme,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get checkUpdate => $composableBuilder(
      column: $table.checkUpdate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get normalizeAudio => $composableBuilder(
      column: $table.normalizeAudio,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showSystemTrayIcon => $composableBuilder(
      column: $table.showSystemTrayIcon,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get systemTitleBar => $composableBuilder(
      column: $table.systemTitleBar,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get skipNonMusic => $composableBuilder(
      column: $table.skipNonMusic, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<CloseBehavior, CloseBehavior, String>
      get closeBehavior => $composableBuilder(
          column: $table.closeBehavior,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<SpotubeColor, SpotubeColor, String>
      get accentColorScheme => $composableBuilder(
          column: $table.accentColorScheme,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<LayoutMode, LayoutMode, String>
      get layoutMode => $composableBuilder(
          column: $table.layoutMode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Locale, Locale, String> get locale =>
      $composableBuilder(
          column: $table.locale,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Market, Market, String> get market =>
      $composableBuilder(
          column: $table.market,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<SearchMode, SearchMode, String>
      get searchMode => $composableBuilder(
          column: $table.searchMode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get downloadLocation => $composableBuilder(
      column: $table.downloadLocation,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get localLibraryLocation => $composableBuilder(
          column: $table.localLibraryLocation,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get pipedInstance => $composableBuilder(
      column: $table.pipedInstance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invidiousInstance => $composableBuilder(
      column: $table.invidiousInstance,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ThemeMode, ThemeMode, String> get themeMode =>
      $composableBuilder(
          column: $table.themeMode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<AudioSource, AudioSource, String>
      get audioSource => $composableBuilder(
          column: $table.audioSource,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<SourceCodecs, SourceCodecs, String>
      get streamMusicCodec => $composableBuilder(
          column: $table.streamMusicCodec,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<SourceCodecs, SourceCodecs, String>
      get downloadMusicCodec => $composableBuilder(
          column: $table.downloadMusicCodec,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get discordPresence => $composableBuilder(
      column: $table.discordPresence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get endlessPlayback => $composableBuilder(
      column: $table.endlessPlayback,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableConnect => $composableBuilder(
      column: $table.enableConnect, builder: (column) => ColumnFilters(column));
}

class $$PreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioQuality => $composableBuilder(
      column: $table.audioQuality,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get albumColorSync => $composableBuilder(
      column: $table.albumColorSync,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get amoledDarkTheme => $composableBuilder(
      column: $table.amoledDarkTheme,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get checkUpdate => $composableBuilder(
      column: $table.checkUpdate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get normalizeAudio => $composableBuilder(
      column: $table.normalizeAudio,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showSystemTrayIcon => $composableBuilder(
      column: $table.showSystemTrayIcon,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get systemTitleBar => $composableBuilder(
      column: $table.systemTitleBar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get skipNonMusic => $composableBuilder(
      column: $table.skipNonMusic,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closeBehavior => $composableBuilder(
      column: $table.closeBehavior,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accentColorScheme => $composableBuilder(
      column: $table.accentColorScheme,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get layoutMode => $composableBuilder(
      column: $table.layoutMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locale => $composableBuilder(
      column: $table.locale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get market => $composableBuilder(
      column: $table.market, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchMode => $composableBuilder(
      column: $table.searchMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadLocation => $composableBuilder(
      column: $table.downloadLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localLibraryLocation => $composableBuilder(
      column: $table.localLibraryLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pipedInstance => $composableBuilder(
      column: $table.pipedInstance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invidiousInstance => $composableBuilder(
      column: $table.invidiousInstance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioSource => $composableBuilder(
      column: $table.audioSource, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get streamMusicCodec => $composableBuilder(
      column: $table.streamMusicCodec,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadMusicCodec => $composableBuilder(
      column: $table.downloadMusicCodec,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get discordPresence => $composableBuilder(
      column: $table.discordPresence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get endlessPlayback => $composableBuilder(
      column: $table.endlessPlayback,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableConnect => $composableBuilder(
      column: $table.enableConnect,
      builder: (column) => ColumnOrderings(column));
}

class $$PreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceQualities, String> get audioQuality =>
      $composableBuilder(
          column: $table.audioQuality, builder: (column) => column);

  GeneratedColumn<bool> get albumColorSync => $composableBuilder(
      column: $table.albumColorSync, builder: (column) => column);

  GeneratedColumn<bool> get amoledDarkTheme => $composableBuilder(
      column: $table.amoledDarkTheme, builder: (column) => column);

  GeneratedColumn<bool> get checkUpdate => $composableBuilder(
      column: $table.checkUpdate, builder: (column) => column);

  GeneratedColumn<bool> get normalizeAudio => $composableBuilder(
      column: $table.normalizeAudio, builder: (column) => column);

  GeneratedColumn<bool> get showSystemTrayIcon => $composableBuilder(
      column: $table.showSystemTrayIcon, builder: (column) => column);

  GeneratedColumn<bool> get systemTitleBar => $composableBuilder(
      column: $table.systemTitleBar, builder: (column) => column);

  GeneratedColumn<bool> get skipNonMusic => $composableBuilder(
      column: $table.skipNonMusic, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CloseBehavior, String> get closeBehavior =>
      $composableBuilder(
          column: $table.closeBehavior, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpotubeColor, String>
      get accentColorScheme => $composableBuilder(
          column: $table.accentColorScheme, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LayoutMode, String> get layoutMode =>
      $composableBuilder(
          column: $table.layoutMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Locale, String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Market, String> get market =>
      $composableBuilder(column: $table.market, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SearchMode, String> get searchMode =>
      $composableBuilder(
          column: $table.searchMode, builder: (column) => column);

  GeneratedColumn<String> get downloadLocation => $composableBuilder(
      column: $table.downloadLocation, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String>
      get localLibraryLocation => $composableBuilder(
          column: $table.localLibraryLocation, builder: (column) => column);

  GeneratedColumn<String> get pipedInstance => $composableBuilder(
      column: $table.pipedInstance, builder: (column) => column);

  GeneratedColumn<String> get invidiousInstance => $composableBuilder(
      column: $table.invidiousInstance, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ThemeMode, String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AudioSource, String> get audioSource =>
      $composableBuilder(
          column: $table.audioSource, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceCodecs, String> get streamMusicCodec =>
      $composableBuilder(
          column: $table.streamMusicCodec, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceCodecs, String>
      get downloadMusicCodec => $composableBuilder(
          column: $table.downloadMusicCodec, builder: (column) => column);

  GeneratedColumn<bool> get discordPresence => $composableBuilder(
      column: $table.discordPresence, builder: (column) => column);

  GeneratedColumn<bool> get endlessPlayback => $composableBuilder(
      column: $table.endlessPlayback, builder: (column) => column);

  GeneratedColumn<bool> get enableConnect => $composableBuilder(
      column: $table.enableConnect, builder: (column) => column);
}

class $$PreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PreferencesTableTable,
    PreferencesTableData,
    $$PreferencesTableTableFilterComposer,
    $$PreferencesTableTableOrderingComposer,
    $$PreferencesTableTableAnnotationComposer,
    $$PreferencesTableTableCreateCompanionBuilder,
    $$PreferencesTableTableUpdateCompanionBuilder,
    (
      PreferencesTableData,
      BaseReferences<_$AppDatabase, $PreferencesTableTable,
          PreferencesTableData>
    ),
    PreferencesTableData,
    PrefetchHooks Function()> {
  $$PreferencesTableTableTableManager(
      _$AppDatabase db, $PreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
            Value<String> invidiousInstance = const Value.absent(),
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
            invidiousInstance: invidiousInstance,
            themeMode: themeMode,
            audioSource: audioSource,
            streamMusicCodec: streamMusicCodec,
            downloadMusicCodec: downloadMusicCodec,
            discordPresence: discordPresence,
            endlessPlayback: endlessPlayback,
            enableConnect: enableConnect,
          ),
          createCompanionCallback: ({
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
            Value<String> invidiousInstance = const Value.absent(),
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
            invidiousInstance: invidiousInstance,
            themeMode: themeMode,
            audioSource: audioSource,
            streamMusicCodec: streamMusicCodec,
            downloadMusicCodec: downloadMusicCodec,
            discordPresence: discordPresence,
            endlessPlayback: endlessPlayback,
            enableConnect: enableConnect,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PreferencesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PreferencesTableTable,
    PreferencesTableData,
    $$PreferencesTableTableFilterComposer,
    $$PreferencesTableTableOrderingComposer,
    $$PreferencesTableTableAnnotationComposer,
    $$PreferencesTableTableCreateCompanionBuilder,
    $$PreferencesTableTableUpdateCompanionBuilder,
    (
      PreferencesTableData,
      BaseReferences<_$AppDatabase, $PreferencesTableTable,
          PreferencesTableData>
    ),
    PreferencesTableData,
    PrefetchHooks Function()>;
typedef $$ScrobblerTableTableCreateCompanionBuilder = ScrobblerTableCompanion
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

class $$ScrobblerTableTableFilterComposer
    extends Composer<_$AppDatabase, $ScrobblerTableTable> {
  $$ScrobblerTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DecryptedText, DecryptedText, String>
      get passwordHash => $composableBuilder(
          column: $table.passwordHash,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$ScrobblerTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ScrobblerTableTable> {
  $$ScrobblerTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));
}

class $$ScrobblerTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScrobblerTableTable> {
  $$ScrobblerTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DecryptedText, String> get passwordHash =>
      $composableBuilder(
          column: $table.passwordHash, builder: (column) => column);
}

class $$ScrobblerTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScrobblerTableTable,
    ScrobblerTableData,
    $$ScrobblerTableTableFilterComposer,
    $$ScrobblerTableTableOrderingComposer,
    $$ScrobblerTableTableAnnotationComposer,
    $$ScrobblerTableTableCreateCompanionBuilder,
    $$ScrobblerTableTableUpdateCompanionBuilder,
    (
      ScrobblerTableData,
      BaseReferences<_$AppDatabase, $ScrobblerTableTable, ScrobblerTableData>
    ),
    ScrobblerTableData,
    PrefetchHooks Function()> {
  $$ScrobblerTableTableTableManager(
      _$AppDatabase db, $ScrobblerTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScrobblerTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScrobblerTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScrobblerTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScrobblerTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScrobblerTableTable,
    ScrobblerTableData,
    $$ScrobblerTableTableFilterComposer,
    $$ScrobblerTableTableOrderingComposer,
    $$ScrobblerTableTableAnnotationComposer,
    $$ScrobblerTableTableCreateCompanionBuilder,
    $$ScrobblerTableTableUpdateCompanionBuilder,
    (
      ScrobblerTableData,
      BaseReferences<_$AppDatabase, $ScrobblerTableTable, ScrobblerTableData>
    ),
    ScrobblerTableData,
    PrefetchHooks Function()>;
typedef $$SkipSegmentTableTableCreateCompanionBuilder
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

class $$SkipSegmentTableTableFilterComposer
    extends Composer<_$AppDatabase, $SkipSegmentTableTable> {
  $$SkipSegmentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get start => $composableBuilder(
      column: $table.start, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get end => $composableBuilder(
      column: $table.end, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackId => $composableBuilder(
      column: $table.trackId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SkipSegmentTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SkipSegmentTableTable> {
  $$SkipSegmentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get start => $composableBuilder(
      column: $table.start, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get end => $composableBuilder(
      column: $table.end, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackId => $composableBuilder(
      column: $table.trackId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SkipSegmentTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkipSegmentTableTable> {
  $$SkipSegmentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<int> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SkipSegmentTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SkipSegmentTableTable,
    SkipSegmentTableData,
    $$SkipSegmentTableTableFilterComposer,
    $$SkipSegmentTableTableOrderingComposer,
    $$SkipSegmentTableTableAnnotationComposer,
    $$SkipSegmentTableTableCreateCompanionBuilder,
    $$SkipSegmentTableTableUpdateCompanionBuilder,
    (
      SkipSegmentTableData,
      BaseReferences<_$AppDatabase, $SkipSegmentTableTable,
          SkipSegmentTableData>
    ),
    SkipSegmentTableData,
    PrefetchHooks Function()> {
  $$SkipSegmentTableTableTableManager(
      _$AppDatabase db, $SkipSegmentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkipSegmentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkipSegmentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkipSegmentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SkipSegmentTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SkipSegmentTableTable,
    SkipSegmentTableData,
    $$SkipSegmentTableTableFilterComposer,
    $$SkipSegmentTableTableOrderingComposer,
    $$SkipSegmentTableTableAnnotationComposer,
    $$SkipSegmentTableTableCreateCompanionBuilder,
    $$SkipSegmentTableTableUpdateCompanionBuilder,
    (
      SkipSegmentTableData,
      BaseReferences<_$AppDatabase, $SkipSegmentTableTable,
          SkipSegmentTableData>
    ),
    SkipSegmentTableData,
    PrefetchHooks Function()>;
typedef $$SourceMatchTableTableCreateCompanionBuilder
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

class $$SourceMatchTableTableFilterComposer
    extends Composer<_$AppDatabase, $SourceMatchTableTable> {
  $$SourceMatchTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackId => $composableBuilder(
      column: $table.trackId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SourceType, SourceType, String>
      get sourceType => $composableBuilder(
          column: $table.sourceType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SourceMatchTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceMatchTableTable> {
  $$SourceMatchTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackId => $composableBuilder(
      column: $table.trackId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SourceMatchTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceMatchTableTable> {
  $$SourceMatchTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceType, String> get sourceType =>
      $composableBuilder(
          column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SourceMatchTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SourceMatchTableTable,
    SourceMatchTableData,
    $$SourceMatchTableTableFilterComposer,
    $$SourceMatchTableTableOrderingComposer,
    $$SourceMatchTableTableAnnotationComposer,
    $$SourceMatchTableTableCreateCompanionBuilder,
    $$SourceMatchTableTableUpdateCompanionBuilder,
    (
      SourceMatchTableData,
      BaseReferences<_$AppDatabase, $SourceMatchTableTable,
          SourceMatchTableData>
    ),
    SourceMatchTableData,
    PrefetchHooks Function()> {
  $$SourceMatchTableTableTableManager(
      _$AppDatabase db, $SourceMatchTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceMatchTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceMatchTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceMatchTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SourceMatchTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SourceMatchTableTable,
    SourceMatchTableData,
    $$SourceMatchTableTableFilterComposer,
    $$SourceMatchTableTableOrderingComposer,
    $$SourceMatchTableTableAnnotationComposer,
    $$SourceMatchTableTableCreateCompanionBuilder,
    $$SourceMatchTableTableUpdateCompanionBuilder,
    (
      SourceMatchTableData,
      BaseReferences<_$AppDatabase, $SourceMatchTableTable,
          SourceMatchTableData>
    ),
    SourceMatchTableData,
    PrefetchHooks Function()>;
typedef $$AudioPlayerStateTableTableCreateCompanionBuilder
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

final class $$AudioPlayerStateTableTableReferences extends BaseReferences<
    _$AppDatabase, $AudioPlayerStateTableTable, AudioPlayerStateTableData> {
  $$AudioPlayerStateTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistTableTable, List<PlaylistTableData>>
      _playlistTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.playlistTable,
              aliasName: $_aliasNameGenerator(db.audioPlayerStateTable.id,
                  db.playlistTable.audioPlayerStateId));

  $$PlaylistTableTableProcessedTableManager get playlistTableRefs {
    final manager = $$PlaylistTableTableTableManager($_db, $_db.playlistTable)
        .filter((f) => f.audioPlayerStateId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_playlistTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AudioPlayerStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $AudioPlayerStateTableTable> {
  $$AudioPlayerStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get playing => $composableBuilder(
      column: $table.playing, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<PlaylistMode, PlaylistMode, String>
      get loopMode => $composableBuilder(
          column: $table.loopMode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get shuffled => $composableBuilder(
      column: $table.shuffled, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get collections => $composableBuilder(
          column: $table.collections,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> playlistTableRefs(
      Expression<bool> Function($$PlaylistTableTableFilterComposer f) f) {
    final $$PlaylistTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistTable,
        getReferencedColumn: (t) => t.audioPlayerStateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistTableTableFilterComposer(
              $db: $db,
              $table: $db.playlistTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AudioPlayerStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioPlayerStateTableTable> {
  $$AudioPlayerStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get playing => $composableBuilder(
      column: $table.playing, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loopMode => $composableBuilder(
      column: $table.loopMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get shuffled => $composableBuilder(
      column: $table.shuffled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collections => $composableBuilder(
      column: $table.collections, builder: (column) => ColumnOrderings(column));
}

class $$AudioPlayerStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioPlayerStateTableTable> {
  $$AudioPlayerStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get playing =>
      $composableBuilder(column: $table.playing, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlaylistMode, String> get loopMode =>
      $composableBuilder(column: $table.loopMode, builder: (column) => column);

  GeneratedColumn<bool> get shuffled =>
      $composableBuilder(column: $table.shuffled, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get collections =>
      $composableBuilder(
          column: $table.collections, builder: (column) => column);

  Expression<T> playlistTableRefs<T extends Object>(
      Expression<T> Function($$PlaylistTableTableAnnotationComposer a) f) {
    final $$PlaylistTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistTable,
        getReferencedColumn: (t) => t.audioPlayerStateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistTableTableAnnotationComposer(
              $db: $db,
              $table: $db.playlistTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AudioPlayerStateTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AudioPlayerStateTableTable,
    AudioPlayerStateTableData,
    $$AudioPlayerStateTableTableFilterComposer,
    $$AudioPlayerStateTableTableOrderingComposer,
    $$AudioPlayerStateTableTableAnnotationComposer,
    $$AudioPlayerStateTableTableCreateCompanionBuilder,
    $$AudioPlayerStateTableTableUpdateCompanionBuilder,
    (AudioPlayerStateTableData, $$AudioPlayerStateTableTableReferences),
    AudioPlayerStateTableData,
    PrefetchHooks Function({bool playlistTableRefs})> {
  $$AudioPlayerStateTableTableTableManager(
      _$AppDatabase db, $AudioPlayerStateTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioPlayerStateTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioPlayerStateTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioPlayerStateTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AudioPlayerStateTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({playlistTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistTableRefs) db.playlistTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AudioPlayerStateTableTableReferences
                            ._playlistTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AudioPlayerStateTableTableReferences(
                                    db, table, p0)
                                .playlistTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.audioPlayerStateId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AudioPlayerStateTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $AudioPlayerStateTableTable,
        AudioPlayerStateTableData,
        $$AudioPlayerStateTableTableFilterComposer,
        $$AudioPlayerStateTableTableOrderingComposer,
        $$AudioPlayerStateTableTableAnnotationComposer,
        $$AudioPlayerStateTableTableCreateCompanionBuilder,
        $$AudioPlayerStateTableTableUpdateCompanionBuilder,
        (AudioPlayerStateTableData, $$AudioPlayerStateTableTableReferences),
        AudioPlayerStateTableData,
        PrefetchHooks Function({bool playlistTableRefs})>;
typedef $$PlaylistTableTableCreateCompanionBuilder = PlaylistTableCompanion
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

final class $$PlaylistTableTableReferences extends BaseReferences<_$AppDatabase,
    $PlaylistTableTable, PlaylistTableData> {
  $$PlaylistTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AudioPlayerStateTableTable _audioPlayerStateIdTable(
          _$AppDatabase db) =>
      db.audioPlayerStateTable.createAlias($_aliasNameGenerator(
          db.playlistTable.audioPlayerStateId, db.audioPlayerStateTable.id));

  $$AudioPlayerStateTableTableProcessedTableManager? get audioPlayerStateId {
    if ($_item.audioPlayerStateId == null) return null;
    final manager = $$AudioPlayerStateTableTableTableManager(
            $_db, $_db.audioPlayerStateTable)
        .filter((f) => f.id($_item.audioPlayerStateId!));
    final item = $_typedResult.readTableOrNull(_audioPlayerStateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PlaylistMediaTableTable,
      List<PlaylistMediaTableData>> _playlistMediaTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.playlistMediaTable,
          aliasName: $_aliasNameGenerator(
              db.playlistTable.id, db.playlistMediaTable.playlistId));

  $$PlaylistMediaTableTableProcessedTableManager get playlistMediaTableRefs {
    final manager =
        $$PlaylistMediaTableTableTableManager($_db, $_db.playlistMediaTable)
            .filter((f) => f.playlistId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_playlistMediaTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlaylistTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get index => $composableBuilder(
      column: $table.index, builder: (column) => ColumnFilters(column));

  $$AudioPlayerStateTableTableFilterComposer get audioPlayerStateId {
    final $$AudioPlayerStateTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.audioPlayerStateId,
            referencedTable: $db.audioPlayerStateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$AudioPlayerStateTableTableFilterComposer(
                  $db: $db,
                  $table: $db.audioPlayerStateTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<bool> playlistMediaTableRefs(
      Expression<bool> Function($$PlaylistMediaTableTableFilterComposer f) f) {
    final $$PlaylistMediaTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistMediaTable,
        getReferencedColumn: (t) => t.playlistId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistMediaTableTableFilterComposer(
              $db: $db,
              $table: $db.playlistMediaTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlaylistTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get index => $composableBuilder(
      column: $table.index, builder: (column) => ColumnOrderings(column));

  $$AudioPlayerStateTableTableOrderingComposer get audioPlayerStateId {
    final $$AudioPlayerStateTableTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.audioPlayerStateId,
            referencedTable: $db.audioPlayerStateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$AudioPlayerStateTableTableOrderingComposer(
                  $db: $db,
                  $table: $db.audioPlayerStateTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PlaylistTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistTableTable> {
  $$PlaylistTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get index =>
      $composableBuilder(column: $table.index, builder: (column) => column);

  $$AudioPlayerStateTableTableAnnotationComposer get audioPlayerStateId {
    final $$AudioPlayerStateTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.audioPlayerStateId,
            referencedTable: $db.audioPlayerStateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$AudioPlayerStateTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.audioPlayerStateTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> playlistMediaTableRefs<T extends Object>(
      Expression<T> Function($$PlaylistMediaTableTableAnnotationComposer a) f) {
    final $$PlaylistMediaTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.playlistMediaTable,
            getReferencedColumn: (t) => t.playlistId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PlaylistMediaTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.playlistMediaTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PlaylistTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistTableTable,
    PlaylistTableData,
    $$PlaylistTableTableFilterComposer,
    $$PlaylistTableTableOrderingComposer,
    $$PlaylistTableTableAnnotationComposer,
    $$PlaylistTableTableCreateCompanionBuilder,
    $$PlaylistTableTableUpdateCompanionBuilder,
    (PlaylistTableData, $$PlaylistTableTableReferences),
    PlaylistTableData,
    PrefetchHooks Function(
        {bool audioPlayerStateId, bool playlistMediaTableRefs})> {
  $$PlaylistTableTableTableManager(_$AppDatabase db, $PlaylistTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> audioPlayerStateId = const Value.absent(),
            Value<int> index = const Value.absent(),
          }) =>
              PlaylistTableCompanion(
            id: id,
            audioPlayerStateId: audioPlayerStateId,
            index: index,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int audioPlayerStateId,
            required int index,
          }) =>
              PlaylistTableCompanion.insert(
            id: id,
            audioPlayerStateId: audioPlayerStateId,
            index: index,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlaylistTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {audioPlayerStateId = false, playlistMediaTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistMediaTableRefs) db.playlistMediaTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (audioPlayerStateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.audioPlayerStateId,
                    referencedTable: $$PlaylistTableTableReferences
                        ._audioPlayerStateIdTable(db),
                    referencedColumn: $$PlaylistTableTableReferences
                        ._audioPlayerStateIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistMediaTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PlaylistTableTableReferences
                            ._playlistMediaTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlaylistTableTableReferences(db, table, p0)
                                .playlistMediaTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.playlistId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlaylistTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistTableTable,
    PlaylistTableData,
    $$PlaylistTableTableFilterComposer,
    $$PlaylistTableTableOrderingComposer,
    $$PlaylistTableTableAnnotationComposer,
    $$PlaylistTableTableCreateCompanionBuilder,
    $$PlaylistTableTableUpdateCompanionBuilder,
    (PlaylistTableData, $$PlaylistTableTableReferences),
    PlaylistTableData,
    PrefetchHooks Function(
        {bool audioPlayerStateId, bool playlistMediaTableRefs})>;
typedef $$PlaylistMediaTableTableCreateCompanionBuilder
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

final class $$PlaylistMediaTableTableReferences extends BaseReferences<
    _$AppDatabase, $PlaylistMediaTableTable, PlaylistMediaTableData> {
  $$PlaylistMediaTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PlaylistTableTable _playlistIdTable(_$AppDatabase db) =>
      db.playlistTable.createAlias($_aliasNameGenerator(
          db.playlistMediaTable.playlistId, db.playlistTable.id));

  $$PlaylistTableTableProcessedTableManager? get playlistId {
    if ($_item.playlistId == null) return null;
    final manager = $$PlaylistTableTableTableManager($_db, $_db.playlistTable)
        .filter((f) => f.id($_item.playlistId!));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlaylistMediaTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistMediaTableTable> {
  $$PlaylistMediaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get extras => $composableBuilder(
          column: $table.extras,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, String>?, Map<String, String>,
          String>
      get httpHeaders => $composableBuilder(
          column: $table.httpHeaders,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$PlaylistTableTableFilterComposer get playlistId {
    final $$PlaylistTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlistTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistTableTableFilterComposer(
              $db: $db,
              $table: $db.playlistTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistMediaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistMediaTableTable> {
  $$PlaylistMediaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extras => $composableBuilder(
      column: $table.extras, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get httpHeaders => $composableBuilder(
      column: $table.httpHeaders, builder: (column) => ColumnOrderings(column));

  $$PlaylistTableTableOrderingComposer get playlistId {
    final $$PlaylistTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlistTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistTableTableOrderingComposer(
              $db: $db,
              $table: $db.playlistTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistMediaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistMediaTableTable> {
  $$PlaylistMediaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get extras =>
      $composableBuilder(column: $table.extras, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>?, String>
      get httpHeaders => $composableBuilder(
          column: $table.httpHeaders, builder: (column) => column);

  $$PlaylistTableTableAnnotationComposer get playlistId {
    final $$PlaylistTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlistTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistTableTableAnnotationComposer(
              $db: $db,
              $table: $db.playlistTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistMediaTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistMediaTableTable,
    PlaylistMediaTableData,
    $$PlaylistMediaTableTableFilterComposer,
    $$PlaylistMediaTableTableOrderingComposer,
    $$PlaylistMediaTableTableAnnotationComposer,
    $$PlaylistMediaTableTableCreateCompanionBuilder,
    $$PlaylistMediaTableTableUpdateCompanionBuilder,
    (PlaylistMediaTableData, $$PlaylistMediaTableTableReferences),
    PlaylistMediaTableData,
    PrefetchHooks Function({bool playlistId})> {
  $$PlaylistMediaTableTableTableManager(
      _$AppDatabase db, $PlaylistMediaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistMediaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistMediaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistMediaTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlaylistMediaTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({playlistId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (playlistId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.playlistId,
                    referencedTable: $$PlaylistMediaTableTableReferences
                        ._playlistIdTable(db),
                    referencedColumn: $$PlaylistMediaTableTableReferences
                        ._playlistIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlaylistMediaTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistMediaTableTable,
    PlaylistMediaTableData,
    $$PlaylistMediaTableTableFilterComposer,
    $$PlaylistMediaTableTableOrderingComposer,
    $$PlaylistMediaTableTableAnnotationComposer,
    $$PlaylistMediaTableTableCreateCompanionBuilder,
    $$PlaylistMediaTableTableUpdateCompanionBuilder,
    (PlaylistMediaTableData, $$PlaylistMediaTableTableReferences),
    PlaylistMediaTableData,
    PrefetchHooks Function({bool playlistId})>;
typedef $$HistoryTableTableCreateCompanionBuilder = HistoryTableCompanion
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

class $$HistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryTableTable> {
  $$HistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<HistoryEntryType, HistoryEntryType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get data => $composableBuilder(
          column: $table.data,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$HistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryTableTable> {
  $$HistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$HistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryTableTable> {
  $$HistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HistoryEntryType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$HistoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoryTableTable,
    HistoryTableData,
    $$HistoryTableTableFilterComposer,
    $$HistoryTableTableOrderingComposer,
    $$HistoryTableTableAnnotationComposer,
    $$HistoryTableTableCreateCompanionBuilder,
    $$HistoryTableTableUpdateCompanionBuilder,
    (
      HistoryTableData,
      BaseReferences<_$AppDatabase, $HistoryTableTable, HistoryTableData>
    ),
    HistoryTableData,
    PrefetchHooks Function()> {
  $$HistoryTableTableTableManager(_$AppDatabase db, $HistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HistoryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistoryTableTable,
    HistoryTableData,
    $$HistoryTableTableFilterComposer,
    $$HistoryTableTableOrderingComposer,
    $$HistoryTableTableAnnotationComposer,
    $$HistoryTableTableCreateCompanionBuilder,
    $$HistoryTableTableUpdateCompanionBuilder,
    (
      HistoryTableData,
      BaseReferences<_$AppDatabase, $HistoryTableTable, HistoryTableData>
    ),
    HistoryTableData,
    PrefetchHooks Function()>;
typedef $$LyricsTableTableCreateCompanionBuilder = LyricsTableCompanion
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

class $$LyricsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackId => $composableBuilder(
      column: $table.trackId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SubtitleSimple, SubtitleSimple, String>
      get data => $composableBuilder(
          column: $table.data,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$LyricsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackId => $composableBuilder(
      column: $table.trackId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$LyricsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SubtitleSimple, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$LyricsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LyricsTableTable,
    LyricsTableData,
    $$LyricsTableTableFilterComposer,
    $$LyricsTableTableOrderingComposer,
    $$LyricsTableTableAnnotationComposer,
    $$LyricsTableTableCreateCompanionBuilder,
    $$LyricsTableTableUpdateCompanionBuilder,
    (
      LyricsTableData,
      BaseReferences<_$AppDatabase, $LyricsTableTable, LyricsTableData>
    ),
    LyricsTableData,
    PrefetchHooks Function()> {
  $$LyricsTableTableTableManager(_$AppDatabase db, $LyricsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LyricsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LyricsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LyricsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> trackId = const Value.absent(),
            Value<SubtitleSimple> data = const Value.absent(),
          }) =>
              LyricsTableCompanion(
            id: id,
            trackId: trackId,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String trackId,
            required SubtitleSimple data,
          }) =>
              LyricsTableCompanion.insert(
            id: id,
            trackId: trackId,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LyricsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LyricsTableTable,
    LyricsTableData,
    $$LyricsTableTableFilterComposer,
    $$LyricsTableTableOrderingComposer,
    $$LyricsTableTableAnnotationComposer,
    $$LyricsTableTableCreateCompanionBuilder,
    $$LyricsTableTableUpdateCompanionBuilder,
    (
      LyricsTableData,
      BaseReferences<_$AppDatabase, $LyricsTableTable, LyricsTableData>
    ),
    LyricsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
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
