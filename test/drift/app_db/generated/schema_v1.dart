// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
//@dart=2.12
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:spotify/spotify.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/utils/migrations/adapters.dart';

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
  late final GeneratedColumn<String> audioQuality = GeneratedColumn<String>(
      'audio_quality', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(SourceQualities.high.name));
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
          defaultValue: const Constant("Blue:0xFF2196F3"));
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
  late final GeneratedColumn<String> pipedInstance = GeneratedColumn<String>(
      'piped_instance', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("https://pipedapi.kavin.rocks"));
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(ThemeMode.system.name));
  late final GeneratedColumn<String> audioSource = GeneratedColumn<String>(
      'audio_source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(AudioSource.youtube.name));
  late final GeneratedColumn<String> streamMusicCodec = GeneratedColumn<String>(
      'stream_music_codec', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(SourceCodecs.weba.name));
  late final GeneratedColumn<String> downloadMusicCodec =
      GeneratedColumn<String>('download_music_codec', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: Constant(SourceCodecs.m4a.name));
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      audioQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_quality'])!,
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
      pipedInstance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}piped_instance'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      audioSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_source'])!,
      streamMusicCodec: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}stream_music_codec'])!,
      downloadMusicCodec: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}download_music_codec'])!,
      discordPresence: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}discord_presence'])!,
      endlessPlayback: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}endless_playback'])!,
      enableConnect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enable_connect'])!,
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
  final String audioQuality;
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
  final String pipedInstance;
  final String themeMode;
  final String audioSource;
  final String streamMusicCodec;
  final String downloadMusicCodec;
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
    map['audio_quality'] = Variable<String>(audioQuality);
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
    map['piped_instance'] = Variable<String>(pipedInstance);
    map['theme_mode'] = Variable<String>(themeMode);
    map['audio_source'] = Variable<String>(audioSource);
    map['stream_music_codec'] = Variable<String>(streamMusicCodec);
    map['download_music_codec'] = Variable<String>(downloadMusicCodec);
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
      audioQuality: serializer.fromJson<String>(json['audioQuality']),
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
      pipedInstance: serializer.fromJson<String>(json['pipedInstance']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      audioSource: serializer.fromJson<String>(json['audioSource']),
      streamMusicCodec: serializer.fromJson<String>(json['streamMusicCodec']),
      downloadMusicCodec:
          serializer.fromJson<String>(json['downloadMusicCodec']),
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
      'audioQuality': serializer.toJson<String>(audioQuality),
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
      'pipedInstance': serializer.toJson<String>(pipedInstance),
      'themeMode': serializer.toJson<String>(themeMode),
      'audioSource': serializer.toJson<String>(audioSource),
      'streamMusicCodec': serializer.toJson<String>(streamMusicCodec),
      'downloadMusicCodec': serializer.toJson<String>(downloadMusicCodec),
      'discordPresence': serializer.toJson<bool>(discordPresence),
      'endlessPlayback': serializer.toJson<bool>(endlessPlayback),
      'enableConnect': serializer.toJson<bool>(enableConnect),
    };
  }

  PreferencesTableData copyWith(
          {int? id,
          String? audioQuality,
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
          String? pipedInstance,
          String? themeMode,
          String? audioSource,
          String? streamMusicCodec,
          String? downloadMusicCodec,
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
  final Value<String> audioQuality;
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
  final Value<String> pipedInstance;
  final Value<String> themeMode;
  final Value<String> audioSource;
  final Value<String> streamMusicCodec;
  final Value<String> downloadMusicCodec;
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
      Value<String>? audioQuality,
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
      Value<String>? pipedInstance,
      Value<String>? themeMode,
      Value<String>? audioSource,
      Value<String>? streamMusicCodec,
      Value<String>? downloadMusicCodec,
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
      map['audio_quality'] = Variable<String>(audioQuality.value);
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
    if (pipedInstance.present) {
      map['piped_instance'] = Variable<String>(pipedInstance.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (audioSource.present) {
      map['audio_source'] = Variable<String>(audioSource.value);
    }
    if (streamMusicCodec.present) {
      map['stream_music_codec'] = Variable<String>(streamMusicCodec.value);
    }
    if (downloadMusicCodec.present) {
      map['download_music_codec'] = Variable<String>(downloadMusicCodec.value);
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
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(SourceType.youtube.name));
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
  final String sourceId;
  final String sourceType;
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
    map['source_type'] = Variable<String>(sourceType);
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
      'sourceId': serializer.toJson<String>(sourceId),
      'sourceType': serializer.toJson<String>(sourceType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SourceMatchTableData copyWith(
          {int? id,
          String? trackId,
          String? sourceId,
          String? sourceType,
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
  final Value<String> sourceType;
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
      Value<String>? sourceType,
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
          ..write('sourceId: $sourceId, ')
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, playing, loopMode, shuffled, collections];
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
    map['loop_mode'] = Variable<String>(loopMode);
    map['shuffled'] = Variable<bool>(shuffled);
    map['collections'] = Variable<String>(collections);
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
      loopMode: serializer.fromJson<String>(json['loopMode']),
      shuffled: serializer.fromJson<bool>(json['shuffled']),
      collections: serializer.fromJson<String>(json['collections']),
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
    };
  }

  AudioPlayerStateTableData copyWith(
          {int? id,
          bool? playing,
          String? loopMode,
          bool? shuffled,
          String? collections}) =>
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
  final Value<String> loopMode;
  final Value<bool> shuffled;
  final Value<String> collections;
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
    required String loopMode,
    required bool shuffled,
    required String collections,
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
      Value<String>? loopMode,
      Value<bool>? shuffled,
      Value<String>? collections}) {
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
      map['loop_mode'] = Variable<String>(loopMode.value);
    }
    if (shuffled.present) {
      map['shuffled'] = Variable<bool>(shuffled.value);
    }
    if (collections.present) {
      map['collections'] = Variable<String>(collections.value);
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

class PlaylistTable extends Table
    with TableInfo<PlaylistTable, PlaylistTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PlaylistTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> audioPlayerStateId = GeneratedColumn<int>(
      'audio_player_state_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES audio_player_state_table (id)'));
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
  PlaylistTable createAlias(String alias) {
    return PlaylistTable(attachedDatabase, alias);
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

class PlaylistMediaTable extends Table
    with TableInfo<PlaylistMediaTable, PlaylistMediaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PlaylistMediaTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
      'playlist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES playlist_table (id)'));
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> extras = GeneratedColumn<String>(
      'extras', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> httpHeaders = GeneratedColumn<String>(
      'http_headers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, playlistId, uri, extras, httpHeaders];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_media_table';
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
      extras: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extras']),
      httpHeaders: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}http_headers']),
    );
  }

  @override
  PlaylistMediaTable createAlias(String alias) {
    return PlaylistMediaTable(attachedDatabase, alias);
  }
}

class PlaylistMediaTableData extends DataClass
    implements Insertable<PlaylistMediaTableData> {
  final int id;
  final int playlistId;
  final String uri;
  final String? extras;
  final String? httpHeaders;
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
      map['extras'] = Variable<String>(extras);
    }
    if (!nullToAbsent || httpHeaders != null) {
      map['http_headers'] = Variable<String>(httpHeaders);
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
      extras: serializer.fromJson<String?>(json['extras']),
      httpHeaders: serializer.fromJson<String?>(json['httpHeaders']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'uri': serializer.toJson<String>(uri),
      'extras': serializer.toJson<String?>(extras),
      'httpHeaders': serializer.toJson<String?>(httpHeaders),
    };
  }

  PlaylistMediaTableData copyWith(
          {int? id,
          int? playlistId,
          String? uri,
          Value<String?> extras = const Value.absent(),
          Value<String?> httpHeaders = const Value.absent()}) =>
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
  final Value<String?> extras;
  final Value<String?> httpHeaders;
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
      Value<String?>? extras,
      Value<String?>? httpHeaders}) {
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
      map['extras'] = Variable<String>(extras.value);
    }
    if (httpHeaders.present) {
      map['http_headers'] = Variable<String>(httpHeaders.value);
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

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final AuthenticationTable authenticationTable =
      AuthenticationTable(this);
  late final BlacklistTable blacklistTable = BlacklistTable(this);
  late final PreferencesTable preferencesTable = PreferencesTable(this);
  late final ScrobblerTable scrobblerTable = ScrobblerTable(this);
  late final SkipSegmentTable skipSegmentTable = SkipSegmentTable(this);
  late final SourceMatchTable sourceMatchTable = SourceMatchTable(this);
  late final AudioPlayerStateTable audioPlayerStateTable =
      AudioPlayerStateTable(this);
  late final PlaylistTable playlistTable = PlaylistTable(this);
  late final PlaylistMediaTable playlistMediaTable = PlaylistMediaTable(this);
  late final HistoryTable historyTable = HistoryTable(this);
  late final LyricsTable lyricsTable = LyricsTable(this);
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
  @override
  int get schemaVersion => 1;
}
