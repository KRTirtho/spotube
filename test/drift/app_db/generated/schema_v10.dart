// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class AuthenticationTable extends Table
    with TableInfo<AuthenticationTable, AuthenticationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AuthenticationTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> cookie = GeneratedColumn<String>(
      'cookie', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
      'access_token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthenticationTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthenticationTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cookie: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cookie'])!,
      accessToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_token'])!,
      expiration: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiration'])!,
    );
  }

  @override
  AuthenticationTable createAlias(String alias) {
    return AuthenticationTable(attachedDatabase, alias);
  }
}

class AuthenticationTableData extends DataClass
    implements Insertable<AuthenticationTableData> {
  final int id;
  final String cookie;
  final String accessToken;
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
    map['cookie'] = Variable<String>(cookie);
    map['access_token'] = Variable<String>(accessToken);
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
      cookie: serializer.fromJson<String>(json['cookie']),
      accessToken: serializer.fromJson<String>(json['accessToken']),
      expiration: serializer.fromJson<DateTime>(json['expiration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cookie': serializer.toJson<String>(cookie),
      'accessToken': serializer.toJson<String>(accessToken),
      'expiration': serializer.toJson<DateTime>(expiration),
    };
  }

  AuthenticationTableData copyWith(
          {int? id,
          String? cookie,
          String? accessToken,
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
  final Value<String> cookie;
  final Value<String> accessToken;
  final Value<DateTime> expiration;
  const AuthenticationTableCompanion({
    this.id = const Value.absent(),
    this.cookie = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.expiration = const Value.absent(),
  });
  AuthenticationTableCompanion.insert({
    this.id = const Value.absent(),
    required String cookie,
    required String accessToken,
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
      Value<String>? cookie,
      Value<String>? accessToken,
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
      map['cookie'] = Variable<String>(cookie.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
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

class BlacklistTable extends Table
    with TableInfo<BlacklistTable, BlacklistTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  BlacklistTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> elementType = GeneratedColumn<String>(
      'element_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlacklistTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlacklistTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      elementType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}element_type'])!,
      elementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}element_id'])!,
    );
  }

  @override
  BlacklistTable createAlias(String alias) {
    return BlacklistTable(attachedDatabase, alias);
  }
}

class BlacklistTableData extends DataClass
    implements Insertable<BlacklistTableData> {
  final int id;
  final String name;
  final String elementType;
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
    map['element_type'] = Variable<String>(elementType);
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
      elementType: serializer.fromJson<String>(json['elementType']),
      elementId: serializer.fromJson<String>(json['elementId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'elementType': serializer.toJson<String>(elementType),
      'elementId': serializer.toJson<String>(elementId),
    };
  }

  BlacklistTableData copyWith(
          {int? id, String? name, String? elementType, String? elementId}) =>
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
  final Value<String> elementType;
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
    required String elementType,
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
      Value<String>? elementType,
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
      map['element_type'] = Variable<String>(elementType.value);
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

class PreferencesTable extends Table
    with TableInfo<PreferencesTable, PreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PreferencesTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<bool> albumColorSync = GeneratedColumn<bool>(
      'album_color_sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("album_color_sync" IN (0, 1))'),
      defaultValue: const Constant(true));
  late final GeneratedColumn<bool> amoledDarkTheme = GeneratedColumn<bool>(
      'amoled_dark_theme', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("amoled_dark_theme" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<bool> checkUpdate = GeneratedColumn<bool>(
      'check_update', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("check_update" IN (0, 1))'),
      defaultValue: const Constant(true));
  late final GeneratedColumn<bool> normalizeAudio = GeneratedColumn<bool>(
      'normalize_audio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("normalize_audio" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<bool> showSystemTrayIcon = GeneratedColumn<bool>(
      'show_system_tray_icon', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_system_tray_icon" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<bool> systemTitleBar = GeneratedColumn<bool>(
      'system_title_bar', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("system_title_bar" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<bool> skipNonMusic = GeneratedColumn<bool>(
      'skip_non_music', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("skip_non_music" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<String> closeBehavior = GeneratedColumn<String>(
      'close_behavior', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(CloseBehavior.close.name));
  late final GeneratedColumn<String> accentColorScheme =
      GeneratedColumn<String>('accent_color_scheme', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant("Slate:0xff64748b"));
  late final GeneratedColumn<String> layoutMode = GeneratedColumn<String>(
      'layout_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(LayoutMode.adaptive.name));
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
      'locale', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue:
          const Constant('{"languageCode":"system","countryCode":"system"}'));
  late final GeneratedColumn<String> market = GeneratedColumn<String>(
      'market', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(Market.US.name));
  late final GeneratedColumn<String> searchMode = GeneratedColumn<String>(
      'search_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(SearchMode.youtube.name));
  late final GeneratedColumn<String> downloadLocation = GeneratedColumn<String>(
      'download_location', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  late final GeneratedColumn<String> localLibraryLocation =
      GeneratedColumn<String>('local_library_location', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(""));
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(ThemeMode.system.name));
  late final GeneratedColumn<String> audioSourceId = GeneratedColumn<String>(
      'audio_source_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> youtubeClientEngine =
      GeneratedColumn<String>('youtube_client_engine', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: Constant(YoutubeClientEngine.youtubeExplode.name));
  late final GeneratedColumn<bool> discordPresence = GeneratedColumn<bool>(
      'discord_presence', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("discord_presence" IN (0, 1))'),
      defaultValue: const Constant(true));
  late final GeneratedColumn<bool> endlessPlayback = GeneratedColumn<bool>(
      'endless_playback', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("endless_playback" IN (0, 1))'),
      defaultValue: const Constant(true));
  late final GeneratedColumn<bool> enableConnect = GeneratedColumn<bool>(
      'enable_connect', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_connect" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<int> connectPort = GeneratedColumn<int>(
      'connect_port', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(-1));
  late final GeneratedColumn<bool> cacheMusic = GeneratedColumn<bool>(
      'cache_music', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cache_music" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
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
        themeMode,
        audioSourceId,
        youtubeClientEngine,
        discordPresence,
        endlessPlayback,
        enableConnect,
        connectPort,
        cacheMusic
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
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
      closeBehavior: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}close_behavior'])!,
      accentColorScheme: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}accent_color_scheme'])!,
      layoutMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}layout_mode'])!,
      locale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}locale'])!,
      market: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market'])!,
      searchMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}search_mode'])!,
      downloadLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}download_location'])!,
      localLibraryLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}local_library_location'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      audioSourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_source_id']),
      youtubeClientEngine: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}youtube_client_engine'])!,
      discordPresence: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}discord_presence'])!,
      endlessPlayback: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}endless_playback'])!,
      enableConnect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enable_connect'])!,
      connectPort: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connect_port'])!,
      cacheMusic: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cache_music'])!,
    );
  }

  @override
  PreferencesTable createAlias(String alias) {
    return PreferencesTable(attachedDatabase, alias);
  }
}

class PreferencesTableData extends DataClass
    implements Insertable<PreferencesTableData> {
  final int id;
  final bool albumColorSync;
  final bool amoledDarkTheme;
  final bool checkUpdate;
  final bool normalizeAudio;
  final bool showSystemTrayIcon;
  final bool systemTitleBar;
  final bool skipNonMusic;
  final String closeBehavior;
  final String accentColorScheme;
  final String layoutMode;
  final String locale;
  final String market;
  final String searchMode;
  final String downloadLocation;
  final String localLibraryLocation;
  final String themeMode;
  final String? audioSourceId;
  final String youtubeClientEngine;
  final bool discordPresence;
  final bool endlessPlayback;
  final bool enableConnect;
  final int connectPort;
  final bool cacheMusic;
  const PreferencesTableData(
      {required this.id,
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
      required this.themeMode,
      this.audioSourceId,
      required this.youtubeClientEngine,
      required this.discordPresence,
      required this.endlessPlayback,
      required this.enableConnect,
      required this.connectPort,
      required this.cacheMusic});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['album_color_sync'] = Variable<bool>(albumColorSync);
    map['amoled_dark_theme'] = Variable<bool>(amoledDarkTheme);
    map['check_update'] = Variable<bool>(checkUpdate);
    map['normalize_audio'] = Variable<bool>(normalizeAudio);
    map['show_system_tray_icon'] = Variable<bool>(showSystemTrayIcon);
    map['system_title_bar'] = Variable<bool>(systemTitleBar);
    map['skip_non_music'] = Variable<bool>(skipNonMusic);
    map['close_behavior'] = Variable<String>(closeBehavior);
    map['accent_color_scheme'] = Variable<String>(accentColorScheme);
    map['layout_mode'] = Variable<String>(layoutMode);
    map['locale'] = Variable<String>(locale);
    map['market'] = Variable<String>(market);
    map['search_mode'] = Variable<String>(searchMode);
    map['download_location'] = Variable<String>(downloadLocation);
    map['local_library_location'] = Variable<String>(localLibraryLocation);
    map['theme_mode'] = Variable<String>(themeMode);
    if (!nullToAbsent || audioSourceId != null) {
      map['audio_source_id'] = Variable<String>(audioSourceId);
    }
    map['youtube_client_engine'] = Variable<String>(youtubeClientEngine);
    map['discord_presence'] = Variable<bool>(discordPresence);
    map['endless_playback'] = Variable<bool>(endlessPlayback);
    map['enable_connect'] = Variable<bool>(enableConnect);
    map['connect_port'] = Variable<int>(connectPort);
    map['cache_music'] = Variable<bool>(cacheMusic);
    return map;
  }

  PreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return PreferencesTableCompanion(
      id: Value(id),
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
      themeMode: Value(themeMode),
      audioSourceId: audioSourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(audioSourceId),
      youtubeClientEngine: Value(youtubeClientEngine),
      discordPresence: Value(discordPresence),
      endlessPlayback: Value(endlessPlayback),
      enableConnect: Value(enableConnect),
      connectPort: Value(connectPort),
      cacheMusic: Value(cacheMusic),
    );
  }

  factory PreferencesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesTableData(
      id: serializer.fromJson<int>(json['id']),
      albumColorSync: serializer.fromJson<bool>(json['albumColorSync']),
      amoledDarkTheme: serializer.fromJson<bool>(json['amoledDarkTheme']),
      checkUpdate: serializer.fromJson<bool>(json['checkUpdate']),
      normalizeAudio: serializer.fromJson<bool>(json['normalizeAudio']),
      showSystemTrayIcon: serializer.fromJson<bool>(json['showSystemTrayIcon']),
      systemTitleBar: serializer.fromJson<bool>(json['systemTitleBar']),
      skipNonMusic: serializer.fromJson<bool>(json['skipNonMusic']),
      closeBehavior: serializer.fromJson<String>(json['closeBehavior']),
      accentColorScheme: serializer.fromJson<String>(json['accentColorScheme']),
      layoutMode: serializer.fromJson<String>(json['layoutMode']),
      locale: serializer.fromJson<String>(json['locale']),
      market: serializer.fromJson<String>(json['market']),
      searchMode: serializer.fromJson<String>(json['searchMode']),
      downloadLocation: serializer.fromJson<String>(json['downloadLocation']),
      localLibraryLocation:
          serializer.fromJson<String>(json['localLibraryLocation']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      audioSourceId: serializer.fromJson<String?>(json['audioSourceId']),
      youtubeClientEngine:
          serializer.fromJson<String>(json['youtubeClientEngine']),
      discordPresence: serializer.fromJson<bool>(json['discordPresence']),
      endlessPlayback: serializer.fromJson<bool>(json['endlessPlayback']),
      enableConnect: serializer.fromJson<bool>(json['enableConnect']),
      connectPort: serializer.fromJson<int>(json['connectPort']),
      cacheMusic: serializer.fromJson<bool>(json['cacheMusic']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'albumColorSync': serializer.toJson<bool>(albumColorSync),
      'amoledDarkTheme': serializer.toJson<bool>(amoledDarkTheme),
      'checkUpdate': serializer.toJson<bool>(checkUpdate),
      'normalizeAudio': serializer.toJson<bool>(normalizeAudio),
      'showSystemTrayIcon': serializer.toJson<bool>(showSystemTrayIcon),
      'systemTitleBar': serializer.toJson<bool>(systemTitleBar),
      'skipNonMusic': serializer.toJson<bool>(skipNonMusic),
      'closeBehavior': serializer.toJson<String>(closeBehavior),
      'accentColorScheme': serializer.toJson<String>(accentColorScheme),
      'layoutMode': serializer.toJson<String>(layoutMode),
      'locale': serializer.toJson<String>(locale),
      'market': serializer.toJson<String>(market),
      'searchMode': serializer.toJson<String>(searchMode),
      'downloadLocation': serializer.toJson<String>(downloadLocation),
      'localLibraryLocation': serializer.toJson<String>(localLibraryLocation),
      'themeMode': serializer.toJson<String>(themeMode),
      'audioSourceId': serializer.toJson<String?>(audioSourceId),
      'youtubeClientEngine': serializer.toJson<String>(youtubeClientEngine),
      'discordPresence': serializer.toJson<bool>(discordPresence),
      'endlessPlayback': serializer.toJson<bool>(endlessPlayback),
      'enableConnect': serializer.toJson<bool>(enableConnect),
      'connectPort': serializer.toJson<int>(connectPort),
      'cacheMusic': serializer.toJson<bool>(cacheMusic),
    };
  }

  PreferencesTableData copyWith(
          {int? id,
          bool? albumColorSync,
          bool? amoledDarkTheme,
          bool? checkUpdate,
          bool? normalizeAudio,
          bool? showSystemTrayIcon,
          bool? systemTitleBar,
          bool? skipNonMusic,
          String? closeBehavior,
          String? accentColorScheme,
          String? layoutMode,
          String? locale,
          String? market,
          String? searchMode,
          String? downloadLocation,
          String? localLibraryLocation,
          String? themeMode,
          Value<String?> audioSourceId = const Value.absent(),
          String? youtubeClientEngine,
          bool? discordPresence,
          bool? endlessPlayback,
          bool? enableConnect,
          int? connectPort,
          bool? cacheMusic}) =>
      PreferencesTableData(
        id: id ?? this.id,
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
        themeMode: themeMode ?? this.themeMode,
        audioSourceId:
            audioSourceId.present ? audioSourceId.value : this.audioSourceId,
        youtubeClientEngine: youtubeClientEngine ?? this.youtubeClientEngine,
        discordPresence: discordPresence ?? this.discordPresence,
        endlessPlayback: endlessPlayback ?? this.endlessPlayback,
        enableConnect: enableConnect ?? this.enableConnect,
        connectPort: connectPort ?? this.connectPort,
        cacheMusic: cacheMusic ?? this.cacheMusic,
      );
  PreferencesTableData copyWithCompanion(PreferencesTableCompanion data) {
    return PreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
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
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      audioSourceId: data.audioSourceId.present
          ? data.audioSourceId.value
          : this.audioSourceId,
      youtubeClientEngine: data.youtubeClientEngine.present
          ? data.youtubeClientEngine.value
          : this.youtubeClientEngine,
      discordPresence: data.discordPresence.present
          ? data.discordPresence.value
          : this.discordPresence,
      endlessPlayback: data.endlessPlayback.present
          ? data.endlessPlayback.value
          : this.endlessPlayback,
      enableConnect: data.enableConnect.present
          ? data.enableConnect.value
          : this.enableConnect,
      connectPort:
          data.connectPort.present ? data.connectPort.value : this.connectPort,
      cacheMusic:
          data.cacheMusic.present ? data.cacheMusic.value : this.cacheMusic,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesTableData(')
          ..write('id: $id, ')
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
          ..write('themeMode: $themeMode, ')
          ..write('audioSourceId: $audioSourceId, ')
          ..write('youtubeClientEngine: $youtubeClientEngine, ')
          ..write('discordPresence: $discordPresence, ')
          ..write('endlessPlayback: $endlessPlayback, ')
          ..write('enableConnect: $enableConnect, ')
          ..write('connectPort: $connectPort, ')
          ..write('cacheMusic: $cacheMusic')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
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
        themeMode,
        audioSourceId,
        youtubeClientEngine,
        discordPresence,
        endlessPlayback,
        enableConnect,
        connectPort,
        cacheMusic
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferencesTableData &&
          other.id == this.id &&
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
          other.themeMode == this.themeMode &&
          other.audioSourceId == this.audioSourceId &&
          other.youtubeClientEngine == this.youtubeClientEngine &&
          other.discordPresence == this.discordPresence &&
          other.endlessPlayback == this.endlessPlayback &&
          other.enableConnect == this.enableConnect &&
          other.connectPort == this.connectPort &&
          other.cacheMusic == this.cacheMusic);
}

class PreferencesTableCompanion extends UpdateCompanion<PreferencesTableData> {
  final Value<int> id;
  final Value<bool> albumColorSync;
  final Value<bool> amoledDarkTheme;
  final Value<bool> checkUpdate;
  final Value<bool> normalizeAudio;
  final Value<bool> showSystemTrayIcon;
  final Value<bool> systemTitleBar;
  final Value<bool> skipNonMusic;
  final Value<String> closeBehavior;
  final Value<String> accentColorScheme;
  final Value<String> layoutMode;
  final Value<String> locale;
  final Value<String> market;
  final Value<String> searchMode;
  final Value<String> downloadLocation;
  final Value<String> localLibraryLocation;
  final Value<String> themeMode;
  final Value<String?> audioSourceId;
  final Value<String> youtubeClientEngine;
  final Value<bool> discordPresence;
  final Value<bool> endlessPlayback;
  final Value<bool> enableConnect;
  final Value<int> connectPort;
  final Value<bool> cacheMusic;
  const PreferencesTableCompanion({
    this.id = const Value.absent(),
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
    this.themeMode = const Value.absent(),
    this.audioSourceId = const Value.absent(),
    this.youtubeClientEngine = const Value.absent(),
    this.discordPresence = const Value.absent(),
    this.endlessPlayback = const Value.absent(),
    this.enableConnect = const Value.absent(),
    this.connectPort = const Value.absent(),
    this.cacheMusic = const Value.absent(),
  });
  PreferencesTableCompanion.insert({
    this.id = const Value.absent(),
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
    this.themeMode = const Value.absent(),
    this.audioSourceId = const Value.absent(),
    this.youtubeClientEngine = const Value.absent(),
    this.discordPresence = const Value.absent(),
    this.endlessPlayback = const Value.absent(),
    this.enableConnect = const Value.absent(),
    this.connectPort = const Value.absent(),
    this.cacheMusic = const Value.absent(),
  });
  static Insertable<PreferencesTableData> custom({
    Expression<int>? id,
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
    Expression<String>? themeMode,
    Expression<String>? audioSourceId,
    Expression<String>? youtubeClientEngine,
    Expression<bool>? discordPresence,
    Expression<bool>? endlessPlayback,
    Expression<bool>? enableConnect,
    Expression<int>? connectPort,
    Expression<bool>? cacheMusic,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
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
      if (themeMode != null) 'theme_mode': themeMode,
      if (audioSourceId != null) 'audio_source_id': audioSourceId,
      if (youtubeClientEngine != null)
        'youtube_client_engine': youtubeClientEngine,
      if (discordPresence != null) 'discord_presence': discordPresence,
      if (endlessPlayback != null) 'endless_playback': endlessPlayback,
      if (enableConnect != null) 'enable_connect': enableConnect,
      if (connectPort != null) 'connect_port': connectPort,
      if (cacheMusic != null) 'cache_music': cacheMusic,
    });
  }

  PreferencesTableCompanion copyWith(
      {Value<int>? id,
      Value<bool>? albumColorSync,
      Value<bool>? amoledDarkTheme,
      Value<bool>? checkUpdate,
      Value<bool>? normalizeAudio,
      Value<bool>? showSystemTrayIcon,
      Value<bool>? systemTitleBar,
      Value<bool>? skipNonMusic,
      Value<String>? closeBehavior,
      Value<String>? accentColorScheme,
      Value<String>? layoutMode,
      Value<String>? locale,
      Value<String>? market,
      Value<String>? searchMode,
      Value<String>? downloadLocation,
      Value<String>? localLibraryLocation,
      Value<String>? themeMode,
      Value<String?>? audioSourceId,
      Value<String>? youtubeClientEngine,
      Value<bool>? discordPresence,
      Value<bool>? endlessPlayback,
      Value<bool>? enableConnect,
      Value<int>? connectPort,
      Value<bool>? cacheMusic}) {
    return PreferencesTableCompanion(
      id: id ?? this.id,
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
      themeMode: themeMode ?? this.themeMode,
      audioSourceId: audioSourceId ?? this.audioSourceId,
      youtubeClientEngine: youtubeClientEngine ?? this.youtubeClientEngine,
      discordPresence: discordPresence ?? this.discordPresence,
      endlessPlayback: endlessPlayback ?? this.endlessPlayback,
      enableConnect: enableConnect ?? this.enableConnect,
      connectPort: connectPort ?? this.connectPort,
      cacheMusic: cacheMusic ?? this.cacheMusic,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
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
      map['close_behavior'] = Variable<String>(closeBehavior.value);
    }
    if (accentColorScheme.present) {
      map['accent_color_scheme'] = Variable<String>(accentColorScheme.value);
    }
    if (layoutMode.present) {
      map['layout_mode'] = Variable<String>(layoutMode.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (market.present) {
      map['market'] = Variable<String>(market.value);
    }
    if (searchMode.present) {
      map['search_mode'] = Variable<String>(searchMode.value);
    }
    if (downloadLocation.present) {
      map['download_location'] = Variable<String>(downloadLocation.value);
    }
    if (localLibraryLocation.present) {
      map['local_library_location'] =
          Variable<String>(localLibraryLocation.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (audioSourceId.present) {
      map['audio_source_id'] = Variable<String>(audioSourceId.value);
    }
    if (youtubeClientEngine.present) {
      map['youtube_client_engine'] =
          Variable<String>(youtubeClientEngine.value);
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
    if (connectPort.present) {
      map['connect_port'] = Variable<int>(connectPort.value);
    }
    if (cacheMusic.present) {
      map['cache_music'] = Variable<bool>(cacheMusic.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesTableCompanion(')
          ..write('id: $id, ')
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
          ..write('themeMode: $themeMode, ')
          ..write('audioSourceId: $audioSourceId, ')
          ..write('youtubeClientEngine: $youtubeClientEngine, ')
          ..write('discordPresence: $discordPresence, ')
          ..write('endlessPlayback: $endlessPlayback, ')
          ..write('enableConnect: $enableConnect, ')
          ..write('connectPort: $connectPort, ')
          ..write('cacheMusic: $cacheMusic')
          ..write(')'))
        .toString();
  }
}

class ScrobblerTable extends Table
    with TableInfo<ScrobblerTable, ScrobblerTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ScrobblerTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, username, passwordHash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scrobbler_table';
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
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
    );
  }

  @override
  ScrobblerTable createAlias(String alias) {
    return ScrobblerTable(attachedDatabase, alias);
  }
}

class ScrobblerTableData extends DataClass
    implements Insertable<ScrobblerTableData> {
  final int id;
  final DateTime createdAt;
  final String username;
  final String passwordHash;
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
    map['password_hash'] = Variable<String>(passwordHash);
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
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
    };
  }

  ScrobblerTableData copyWith(
          {int? id,
          DateTime? createdAt,
          String? username,
          String? passwordHash}) =>
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
  final Value<String> passwordHash;
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
    required String passwordHash,
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
      Value<String>? passwordHash}) {
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
      map['password_hash'] = Variable<String>(passwordHash.value);
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

class SkipSegmentTable extends Table
    with TableInfo<SkipSegmentTable, SkipSegmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SkipSegmentTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> start = GeneratedColumn<int>(
      'start', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> end = GeneratedColumn<int>(
      'end', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
      'track_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  SkipSegmentTable createAlias(String alias) {
    return SkipSegmentTable(attachedDatabase, alias);
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

class SourceMatchTable extends Table
    with TableInfo<SourceMatchTable, SourceMatchTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SourceMatchTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
      'track_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> sourceInfo = GeneratedColumn<String>(
      'source_info', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("{}"));
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, trackId, sourceInfo, sourceType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_match_table';
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
      sourceInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_info'])!,
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  SourceMatchTable createAlias(String alias) {
    return SourceMatchTable(attachedDatabase, alias);
  }
}

class SourceMatchTableData extends DataClass
    implements Insertable<SourceMatchTableData> {
  final int id;
  final String trackId;
  final String sourceInfo;
  final String sourceType;
  final DateTime createdAt;
  const SourceMatchTableData(
      {required this.id,
      required this.trackId,
      required this.sourceInfo,
      required this.sourceType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<String>(trackId);
    map['source_info'] = Variable<String>(sourceInfo);
    map['source_type'] = Variable<String>(sourceType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SourceMatchTableCompanion toCompanion(bool nullToAbsent) {
    return SourceMatchTableCompanion(
      id: Value(id),
      trackId: Value(trackId),
      sourceInfo: Value(sourceInfo),
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
      sourceInfo: serializer.fromJson<String>(json['sourceInfo']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<String>(trackId),
      'sourceInfo': serializer.toJson<String>(sourceInfo),
      'sourceType': serializer.toJson<String>(sourceType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SourceMatchTableData copyWith(
          {int? id,
          String? trackId,
          String? sourceInfo,
          String? sourceType,
          DateTime? createdAt}) =>
      SourceMatchTableData(
        id: id ?? this.id,
        trackId: trackId ?? this.trackId,
        sourceInfo: sourceInfo ?? this.sourceInfo,
        sourceType: sourceType ?? this.sourceType,
        createdAt: createdAt ?? this.createdAt,
      );
  SourceMatchTableData copyWithCompanion(SourceMatchTableCompanion data) {
    return SourceMatchTableData(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      sourceInfo:
          data.sourceInfo.present ? data.sourceInfo.value : this.sourceInfo,
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
          ..write('sourceInfo: $sourceInfo, ')
          ..write('sourceType: $sourceType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackId, sourceInfo, sourceType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceMatchTableData &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.sourceInfo == this.sourceInfo &&
          other.sourceType == this.sourceType &&
          other.createdAt == this.createdAt);
}

class SourceMatchTableCompanion extends UpdateCompanion<SourceMatchTableData> {
  final Value<int> id;
  final Value<String> trackId;
  final Value<String> sourceInfo;
  final Value<String> sourceType;
  final Value<DateTime> createdAt;
  const SourceMatchTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.sourceInfo = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SourceMatchTableCompanion.insert({
    this.id = const Value.absent(),
    required String trackId,
    this.sourceInfo = const Value.absent(),
    required String sourceType,
    this.createdAt = const Value.absent(),
  })  : trackId = Value(trackId),
        sourceType = Value(sourceType);
  static Insertable<SourceMatchTableData> custom({
    Expression<int>? id,
    Expression<String>? trackId,
    Expression<String>? sourceInfo,
    Expression<String>? sourceType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (sourceInfo != null) 'source_info': sourceInfo,
      if (sourceType != null) 'source_type': sourceType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SourceMatchTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? trackId,
      Value<String>? sourceInfo,
      Value<String>? sourceType,
      Value<DateTime>? createdAt}) {
    return SourceMatchTableCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      sourceInfo: sourceInfo ?? this.sourceInfo,
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
    if (sourceInfo.present) {
      map['source_info'] = Variable<String>(sourceInfo.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
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
          ..write('sourceInfo: $sourceInfo, ')
          ..write('sourceType: $sourceType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class AudioPlayerStateTable extends Table
    with TableInfo<AudioPlayerStateTable, AudioPlayerStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AudioPlayerStateTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<bool> playing = GeneratedColumn<bool>(
      'playing', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("playing" IN (0, 1))'));
  late final GeneratedColumn<String> loopMode = GeneratedColumn<String>(
      'loop_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> shuffled = GeneratedColumn<bool>(
      'shuffled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("shuffled" IN (0, 1))'));
  late final GeneratedColumn<String> collections = GeneratedColumn<String>(
      'collections', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> tracks = GeneratedColumn<String>(
      'tracks', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("[]"));
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
      'current_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, playing, loopMode, shuffled, collections, tracks, currentIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_player_state_table';
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
      loopMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}loop_mode'])!,
      shuffled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}shuffled'])!,
      collections: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collections'])!,
      tracks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tracks'])!,
      currentIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_index'])!,
    );
  }

  @override
  AudioPlayerStateTable createAlias(String alias) {
    return AudioPlayerStateTable(attachedDatabase, alias);
  }
}

class AudioPlayerStateTableData extends DataClass
    implements Insertable<AudioPlayerStateTableData> {
  final int id;
  final bool playing;
  final String loopMode;
  final bool shuffled;
  final String collections;
  final String tracks;
  final int currentIndex;
  const AudioPlayerStateTableData(
      {required this.id,
      required this.playing,
      required this.loopMode,
      required this.shuffled,
      required this.collections,
      required this.tracks,
      required this.currentIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playing'] = Variable<bool>(playing);
    map['loop_mode'] = Variable<String>(loopMode);
    map['shuffled'] = Variable<bool>(shuffled);
    map['collections'] = Variable<String>(collections);
    map['tracks'] = Variable<String>(tracks);
    map['current_index'] = Variable<int>(currentIndex);
    return map;
  }

  AudioPlayerStateTableCompanion toCompanion(bool nullToAbsent) {
    return AudioPlayerStateTableCompanion(
      id: Value(id),
      playing: Value(playing),
      loopMode: Value(loopMode),
      shuffled: Value(shuffled),
      collections: Value(collections),
      tracks: Value(tracks),
      currentIndex: Value(currentIndex),
    );
  }

  factory AudioPlayerStateTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioPlayerStateTableData(
      id: serializer.fromJson<int>(json['id']),
      playing: serializer.fromJson<bool>(json['playing']),
      loopMode: serializer.fromJson<String>(json['loopMode']),
      shuffled: serializer.fromJson<bool>(json['shuffled']),
      collections: serializer.fromJson<String>(json['collections']),
      tracks: serializer.fromJson<String>(json['tracks']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playing': serializer.toJson<bool>(playing),
      'loopMode': serializer.toJson<String>(loopMode),
      'shuffled': serializer.toJson<bool>(shuffled),
      'collections': serializer.toJson<String>(collections),
      'tracks': serializer.toJson<String>(tracks),
      'currentIndex': serializer.toJson<int>(currentIndex),
    };
  }

  AudioPlayerStateTableData copyWith(
          {int? id,
          bool? playing,
          String? loopMode,
          bool? shuffled,
          String? collections,
          String? tracks,
          int? currentIndex}) =>
      AudioPlayerStateTableData(
        id: id ?? this.id,
        playing: playing ?? this.playing,
        loopMode: loopMode ?? this.loopMode,
        shuffled: shuffled ?? this.shuffled,
        collections: collections ?? this.collections,
        tracks: tracks ?? this.tracks,
        currentIndex: currentIndex ?? this.currentIndex,
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
      tracks: data.tracks.present ? data.tracks.value : this.tracks,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioPlayerStateTableData(')
          ..write('id: $id, ')
          ..write('playing: $playing, ')
          ..write('loopMode: $loopMode, ')
          ..write('shuffled: $shuffled, ')
          ..write('collections: $collections, ')
          ..write('tracks: $tracks, ')
          ..write('currentIndex: $currentIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, playing, loopMode, shuffled, collections, tracks, currentIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioPlayerStateTableData &&
          other.id == this.id &&
          other.playing == this.playing &&
          other.loopMode == this.loopMode &&
          other.shuffled == this.shuffled &&
          other.collections == this.collections &&
          other.tracks == this.tracks &&
          other.currentIndex == this.currentIndex);
}

class AudioPlayerStateTableCompanion
    extends UpdateCompanion<AudioPlayerStateTableData> {
  final Value<int> id;
  final Value<bool> playing;
  final Value<String> loopMode;
  final Value<bool> shuffled;
  final Value<String> collections;
  final Value<String> tracks;
  final Value<int> currentIndex;
  const AudioPlayerStateTableCompanion({
    this.id = const Value.absent(),
    this.playing = const Value.absent(),
    this.loopMode = const Value.absent(),
    this.shuffled = const Value.absent(),
    this.collections = const Value.absent(),
    this.tracks = const Value.absent(),
    this.currentIndex = const Value.absent(),
  });
  AudioPlayerStateTableCompanion.insert({
    this.id = const Value.absent(),
    required bool playing,
    required String loopMode,
    required bool shuffled,
    required String collections,
    this.tracks = const Value.absent(),
    this.currentIndex = const Value.absent(),
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
    Expression<String>? tracks,
    Expression<int>? currentIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playing != null) 'playing': playing,
      if (loopMode != null) 'loop_mode': loopMode,
      if (shuffled != null) 'shuffled': shuffled,
      if (collections != null) 'collections': collections,
      if (tracks != null) 'tracks': tracks,
      if (currentIndex != null) 'current_index': currentIndex,
    });
  }

  AudioPlayerStateTableCompanion copyWith(
      {Value<int>? id,
      Value<bool>? playing,
      Value<String>? loopMode,
      Value<bool>? shuffled,
      Value<String>? collections,
      Value<String>? tracks,
      Value<int>? currentIndex}) {
    return AudioPlayerStateTableCompanion(
      id: id ?? this.id,
      playing: playing ?? this.playing,
      loopMode: loopMode ?? this.loopMode,
      shuffled: shuffled ?? this.shuffled,
      collections: collections ?? this.collections,
      tracks: tracks ?? this.tracks,
      currentIndex: currentIndex ?? this.currentIndex,
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
      map['loop_mode'] = Variable<String>(loopMode.value);
    }
    if (shuffled.present) {
      map['shuffled'] = Variable<bool>(shuffled.value);
    }
    if (collections.present) {
      map['collections'] = Variable<String>(collections.value);
    }
    if (tracks.present) {
      map['tracks'] = Variable<String>(tracks.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
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
          ..write('collections: $collections, ')
          ..write('tracks: $tracks, ')
          ..write('currentIndex: $currentIndex')
          ..write(')'))
        .toString();
  }
}

class HistoryTable extends Table
    with TableInfo<HistoryTable, HistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HistoryTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, type, itemId, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_table';
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
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  HistoryTable createAlias(String alias) {
    return HistoryTable(attachedDatabase, alias);
  }
}

class HistoryTableData extends DataClass
    implements Insertable<HistoryTableData> {
  final int id;
  final DateTime createdAt;
  final String type;
  final String itemId;
  final String data;
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
    map['type'] = Variable<String>(type);
    map['item_id'] = Variable<String>(itemId);
    map['data'] = Variable<String>(data);
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
      type: serializer.fromJson<String>(json['type']),
      itemId: serializer.fromJson<String>(json['itemId']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'type': serializer.toJson<String>(type),
      'itemId': serializer.toJson<String>(itemId),
      'data': serializer.toJson<String>(data),
    };
  }

  HistoryTableData copyWith(
          {int? id,
          DateTime? createdAt,
          String? type,
          String? itemId,
          String? data}) =>
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
  final Value<String> type;
  final Value<String> itemId;
  final Value<String> data;
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
    required String type,
    required String itemId,
    required String data,
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
      Value<String>? type,
      Value<String>? itemId,
      Value<String>? data}) {
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
      map['type'] = Variable<String>(type.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
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

class LyricsTable extends Table with TableInfo<LyricsTable, LyricsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LyricsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
      'track_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, trackId, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lyrics_table';
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
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  LyricsTable createAlias(String alias) {
    return LyricsTable(attachedDatabase, alias);
  }
}

class LyricsTableData extends DataClass implements Insertable<LyricsTableData> {
  final int id;
  final String trackId;
  final String data;
  const LyricsTableData(
      {required this.id, required this.trackId, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<String>(trackId);
    map['data'] = Variable<String>(data);
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
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<String>(trackId),
      'data': serializer.toJson<String>(data),
    };
  }

  LyricsTableData copyWith({int? id, String? trackId, String? data}) =>
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
  final Value<String> data;
  const LyricsTableCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.data = const Value.absent(),
  });
  LyricsTableCompanion.insert({
    this.id = const Value.absent(),
    required String trackId,
    required String data,
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
      {Value<int>? id, Value<String>? trackId, Value<String>? data}) {
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
      map['data'] = Variable<String>(data.value);
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

class PluginsTable extends Table
    with TableInfo<PluginsTable, PluginsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PluginsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> entryPoint = GeneratedColumn<String>(
      'entry_point', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> apis = GeneratedColumn<String>(
      'apis', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> abilities = GeneratedColumn<String>(
      'abilities', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> selectedForMetadata = GeneratedColumn<bool>(
      'selected_for_metadata', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("selected_for_metadata" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<bool> selectedForAudioSource =
      GeneratedColumn<bool>('selected_for_audio_source', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("selected_for_audio_source" IN (0, 1))'),
          defaultValue: const Constant(false));
  late final GeneratedColumn<String> repository = GeneratedColumn<String>(
      'repository', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> pluginApiVersion = GeneratedColumn<String>(
      'plugin_api_version', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('2.0.0'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        version,
        author,
        entryPoint,
        apis,
        abilities,
        selectedForMetadata,
        selectedForAudioSource,
        repository,
        pluginApiVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plugins_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PluginsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PluginsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      entryPoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_point'])!,
      apis: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}apis'])!,
      abilities: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abilities'])!,
      selectedForMetadata: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}selected_for_metadata'])!,
      selectedForAudioSource: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}selected_for_audio_source'])!,
      repository: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repository']),
      pluginApiVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}plugin_api_version'])!,
    );
  }

  @override
  PluginsTable createAlias(String alias) {
    return PluginsTable(attachedDatabase, alias);
  }
}

class PluginsTableData extends DataClass
    implements Insertable<PluginsTableData> {
  final int id;
  final String name;
  final String description;
  final String version;
  final String author;
  final String entryPoint;
  final String apis;
  final String abilities;
  final bool selectedForMetadata;
  final bool selectedForAudioSource;
  final String? repository;
  final String pluginApiVersion;
  const PluginsTableData(
      {required this.id,
      required this.name,
      required this.description,
      required this.version,
      required this.author,
      required this.entryPoint,
      required this.apis,
      required this.abilities,
      required this.selectedForMetadata,
      required this.selectedForAudioSource,
      this.repository,
      required this.pluginApiVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['version'] = Variable<String>(version);
    map['author'] = Variable<String>(author);
    map['entry_point'] = Variable<String>(entryPoint);
    map['apis'] = Variable<String>(apis);
    map['abilities'] = Variable<String>(abilities);
    map['selected_for_metadata'] = Variable<bool>(selectedForMetadata);
    map['selected_for_audio_source'] = Variable<bool>(selectedForAudioSource);
    if (!nullToAbsent || repository != null) {
      map['repository'] = Variable<String>(repository);
    }
    map['plugin_api_version'] = Variable<String>(pluginApiVersion);
    return map;
  }

  PluginsTableCompanion toCompanion(bool nullToAbsent) {
    return PluginsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      version: Value(version),
      author: Value(author),
      entryPoint: Value(entryPoint),
      apis: Value(apis),
      abilities: Value(abilities),
      selectedForMetadata: Value(selectedForMetadata),
      selectedForAudioSource: Value(selectedForAudioSource),
      repository: repository == null && nullToAbsent
          ? const Value.absent()
          : Value(repository),
      pluginApiVersion: Value(pluginApiVersion),
    );
  }

  factory PluginsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PluginsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      version: serializer.fromJson<String>(json['version']),
      author: serializer.fromJson<String>(json['author']),
      entryPoint: serializer.fromJson<String>(json['entryPoint']),
      apis: serializer.fromJson<String>(json['apis']),
      abilities: serializer.fromJson<String>(json['abilities']),
      selectedForMetadata:
          serializer.fromJson<bool>(json['selectedForMetadata']),
      selectedForAudioSource:
          serializer.fromJson<bool>(json['selectedForAudioSource']),
      repository: serializer.fromJson<String?>(json['repository']),
      pluginApiVersion: serializer.fromJson<String>(json['pluginApiVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'version': serializer.toJson<String>(version),
      'author': serializer.toJson<String>(author),
      'entryPoint': serializer.toJson<String>(entryPoint),
      'apis': serializer.toJson<String>(apis),
      'abilities': serializer.toJson<String>(abilities),
      'selectedForMetadata': serializer.toJson<bool>(selectedForMetadata),
      'selectedForAudioSource': serializer.toJson<bool>(selectedForAudioSource),
      'repository': serializer.toJson<String?>(repository),
      'pluginApiVersion': serializer.toJson<String>(pluginApiVersion),
    };
  }

  PluginsTableData copyWith(
          {int? id,
          String? name,
          String? description,
          String? version,
          String? author,
          String? entryPoint,
          String? apis,
          String? abilities,
          bool? selectedForMetadata,
          bool? selectedForAudioSource,
          Value<String?> repository = const Value.absent(),
          String? pluginApiVersion}) =>
      PluginsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        version: version ?? this.version,
        author: author ?? this.author,
        entryPoint: entryPoint ?? this.entryPoint,
        apis: apis ?? this.apis,
        abilities: abilities ?? this.abilities,
        selectedForMetadata: selectedForMetadata ?? this.selectedForMetadata,
        selectedForAudioSource:
            selectedForAudioSource ?? this.selectedForAudioSource,
        repository: repository.present ? repository.value : this.repository,
        pluginApiVersion: pluginApiVersion ?? this.pluginApiVersion,
      );
  PluginsTableData copyWithCompanion(PluginsTableCompanion data) {
    return PluginsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      version: data.version.present ? data.version.value : this.version,
      author: data.author.present ? data.author.value : this.author,
      entryPoint:
          data.entryPoint.present ? data.entryPoint.value : this.entryPoint,
      apis: data.apis.present ? data.apis.value : this.apis,
      abilities: data.abilities.present ? data.abilities.value : this.abilities,
      selectedForMetadata: data.selectedForMetadata.present
          ? data.selectedForMetadata.value
          : this.selectedForMetadata,
      selectedForAudioSource: data.selectedForAudioSource.present
          ? data.selectedForAudioSource.value
          : this.selectedForAudioSource,
      repository:
          data.repository.present ? data.repository.value : this.repository,
      pluginApiVersion: data.pluginApiVersion.present
          ? data.pluginApiVersion.value
          : this.pluginApiVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PluginsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('version: $version, ')
          ..write('author: $author, ')
          ..write('entryPoint: $entryPoint, ')
          ..write('apis: $apis, ')
          ..write('abilities: $abilities, ')
          ..write('selectedForMetadata: $selectedForMetadata, ')
          ..write('selectedForAudioSource: $selectedForAudioSource, ')
          ..write('repository: $repository, ')
          ..write('pluginApiVersion: $pluginApiVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      version,
      author,
      entryPoint,
      apis,
      abilities,
      selectedForMetadata,
      selectedForAudioSource,
      repository,
      pluginApiVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PluginsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.version == this.version &&
          other.author == this.author &&
          other.entryPoint == this.entryPoint &&
          other.apis == this.apis &&
          other.abilities == this.abilities &&
          other.selectedForMetadata == this.selectedForMetadata &&
          other.selectedForAudioSource == this.selectedForAudioSource &&
          other.repository == this.repository &&
          other.pluginApiVersion == this.pluginApiVersion);
}

class PluginsTableCompanion extends UpdateCompanion<PluginsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> version;
  final Value<String> author;
  final Value<String> entryPoint;
  final Value<String> apis;
  final Value<String> abilities;
  final Value<bool> selectedForMetadata;
  final Value<bool> selectedForAudioSource;
  final Value<String?> repository;
  final Value<String> pluginApiVersion;
  const PluginsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.version = const Value.absent(),
    this.author = const Value.absent(),
    this.entryPoint = const Value.absent(),
    this.apis = const Value.absent(),
    this.abilities = const Value.absent(),
    this.selectedForMetadata = const Value.absent(),
    this.selectedForAudioSource = const Value.absent(),
    this.repository = const Value.absent(),
    this.pluginApiVersion = const Value.absent(),
  });
  PluginsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required String version,
    required String author,
    required String entryPoint,
    required String apis,
    required String abilities,
    this.selectedForMetadata = const Value.absent(),
    this.selectedForAudioSource = const Value.absent(),
    this.repository = const Value.absent(),
    this.pluginApiVersion = const Value.absent(),
  })  : name = Value(name),
        description = Value(description),
        version = Value(version),
        author = Value(author),
        entryPoint = Value(entryPoint),
        apis = Value(apis),
        abilities = Value(abilities);
  static Insertable<PluginsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? version,
    Expression<String>? author,
    Expression<String>? entryPoint,
    Expression<String>? apis,
    Expression<String>? abilities,
    Expression<bool>? selectedForMetadata,
    Expression<bool>? selectedForAudioSource,
    Expression<String>? repository,
    Expression<String>? pluginApiVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (version != null) 'version': version,
      if (author != null) 'author': author,
      if (entryPoint != null) 'entry_point': entryPoint,
      if (apis != null) 'apis': apis,
      if (abilities != null) 'abilities': abilities,
      if (selectedForMetadata != null)
        'selected_for_metadata': selectedForMetadata,
      if (selectedForAudioSource != null)
        'selected_for_audio_source': selectedForAudioSource,
      if (repository != null) 'repository': repository,
      if (pluginApiVersion != null) 'plugin_api_version': pluginApiVersion,
    });
  }

  PluginsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? version,
      Value<String>? author,
      Value<String>? entryPoint,
      Value<String>? apis,
      Value<String>? abilities,
      Value<bool>? selectedForMetadata,
      Value<bool>? selectedForAudioSource,
      Value<String?>? repository,
      Value<String>? pluginApiVersion}) {
    return PluginsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      author: author ?? this.author,
      entryPoint: entryPoint ?? this.entryPoint,
      apis: apis ?? this.apis,
      abilities: abilities ?? this.abilities,
      selectedForMetadata: selectedForMetadata ?? this.selectedForMetadata,
      selectedForAudioSource:
          selectedForAudioSource ?? this.selectedForAudioSource,
      repository: repository ?? this.repository,
      pluginApiVersion: pluginApiVersion ?? this.pluginApiVersion,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (entryPoint.present) {
      map['entry_point'] = Variable<String>(entryPoint.value);
    }
    if (apis.present) {
      map['apis'] = Variable<String>(apis.value);
    }
    if (abilities.present) {
      map['abilities'] = Variable<String>(abilities.value);
    }
    if (selectedForMetadata.present) {
      map['selected_for_metadata'] = Variable<bool>(selectedForMetadata.value);
    }
    if (selectedForAudioSource.present) {
      map['selected_for_audio_source'] =
          Variable<bool>(selectedForAudioSource.value);
    }
    if (repository.present) {
      map['repository'] = Variable<String>(repository.value);
    }
    if (pluginApiVersion.present) {
      map['plugin_api_version'] = Variable<String>(pluginApiVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PluginsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('version: $version, ')
          ..write('author: $author, ')
          ..write('entryPoint: $entryPoint, ')
          ..write('apis: $apis, ')
          ..write('abilities: $abilities, ')
          ..write('selectedForMetadata: $selectedForMetadata, ')
          ..write('selectedForAudioSource: $selectedForAudioSource, ')
          ..write('repository: $repository, ')
          ..write('pluginApiVersion: $pluginApiVersion')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV10 extends GeneratedDatabase {
  DatabaseAtV10(QueryExecutor e) : super(e);
  late final AuthenticationTable authenticationTable =
      AuthenticationTable(this);
  late final BlacklistTable blacklistTable = BlacklistTable(this);
  late final PreferencesTable preferencesTable = PreferencesTable(this);
  late final ScrobblerTable scrobblerTable = ScrobblerTable(this);
  late final SkipSegmentTable skipSegmentTable = SkipSegmentTable(this);
  late final SourceMatchTable sourceMatchTable = SourceMatchTable(this);
  late final AudioPlayerStateTable audioPlayerStateTable =
      AudioPlayerStateTable(this);
  late final HistoryTable historyTable = HistoryTable(this);
  late final LyricsTable lyricsTable = LyricsTable(this);
  late final PluginsTable pluginsTable = PluginsTable(this);
  late final Index uniqueBlacklist = Index('unique_blacklist',
      'CREATE UNIQUE INDEX unique_blacklist ON blacklist_table (element_type, element_id)');
  late final Index uniqTrackMatch = Index('uniq_track_match',
      'CREATE UNIQUE INDEX uniq_track_match ON source_match_table (track_id, source_info, source_type)');
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
        historyTable,
        lyricsTable,
        pluginsTable,
        uniqueBlacklist,
        uniqTrackMatch
      ];
  @override
  int get schemaVersion => 10;
}
