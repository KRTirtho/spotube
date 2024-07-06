// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adapters.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkipSegmentAdapter extends TypeAdapter<SkipSegment> {
  @override
  final int typeId = 2;

  @override
  SkipSegment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkipSegment(
      fields[0] as int,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SkipSegment obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkipSegmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SourceMatchAdapter extends TypeAdapter<SourceMatch> {
  @override
  final int typeId = 6;

  @override
  SourceMatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SourceMatch(
      id: fields[0] as String,
      sourceId: fields[1] as String,
      sourceType: fields[2] as SourceType,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SourceMatch obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceId)
      ..writeByte(2)
      ..write(obj.sourceType)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceMatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SourceTypeAdapter extends TypeAdapter<SourceType> {
  @override
  final int typeId = 5;

  @override
  SourceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SourceType.youtube;
      case 1:
        return SourceType.youtubeMusic;
      case 2:
        return SourceType.jiosaavn;
      default:
        return SourceType.youtube;
    }
  }

  @override
  void write(BinaryWriter writer, SourceType obj) {
    switch (obj) {
      case SourceType.youtube:
        writer.writeByte(0);
        break;
      case SourceType.youtubeMusic:
        writer.writeByte(1);
        break;
      case SourceType.jiosaavn:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceMatch _$SourceMatchFromJson(Map json) => SourceMatch(
      id: json['id'] as String,
      sourceId: json['sourceId'] as String,
      sourceType: $enumDecode(_$SourceTypeEnumMap, json['sourceType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SourceMatchToJson(SourceMatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
      'sourceType': _$SourceTypeEnumMap[instance.sourceType]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SourceTypeEnumMap = {
  SourceType.youtube: 'youtube',
  SourceType.youtubeMusic: 'youtubeMusic',
  SourceType.jiosaavn: 'jiosaavn',
};

AuthenticationCredentials _$AuthenticationCredentialsFromJson(Map json) =>
    AuthenticationCredentials(
      cookie: json['cookie'] as String,
      accessToken: json['accessToken'] as String,
      expiration: DateTime.parse(json['expiration'] as String),
    );

Map<String, dynamic> _$AuthenticationCredentialsToJson(
        AuthenticationCredentials instance) =>
    <String, dynamic>{
      'cookie': instance.cookie,
      'accessToken': instance.accessToken,
      'expiration': instance.expiration.toIso8601String(),
    };

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(Map json) =>
    _$UserPreferencesImpl(
      audioQuality:
          $enumDecodeNullable(_$SourceQualitiesEnumMap, json['audioQuality']) ??
              SourceQualities.high,
      albumColorSync: json['albumColorSync'] as bool? ?? true,
      amoledDarkTheme: json['amoledDarkTheme'] as bool? ?? false,
      checkUpdate: json['checkUpdate'] as bool? ?? true,
      normalizeAudio: json['normalizeAudio'] as bool? ?? false,
      showSystemTrayIcon: json['showSystemTrayIcon'] as bool? ?? false,
      skipNonMusic: json['skipNonMusic'] as bool? ?? false,
      systemTitleBar: json['systemTitleBar'] as bool? ?? false,
      closeBehavior:
          $enumDecodeNullable(_$CloseBehaviorEnumMap, json['closeBehavior']) ??
              CloseBehavior.close,
      accentColorScheme: UserPreferences._accentColorSchemeReadValue(
                  json, 'accentColorScheme') ==
              null
          ? const SpotubeColor(0xFF2196F3, name: "Blue")
          : UserPreferences._accentColorSchemeFromJson(
              UserPreferences._accentColorSchemeReadValue(
                  json, 'accentColorScheme') as Map<String, dynamic>),
      layoutMode:
          $enumDecodeNullable(_$LayoutModeEnumMap, json['layoutMode']) ??
              LayoutMode.adaptive,
      locale: UserPreferences._localeReadValue(json, 'locale') == null
          ? const Locale("system", "system")
          : UserPreferences._localeFromJson(
              UserPreferences._localeReadValue(json, 'locale')
                  as Map<String, dynamic>),
      recommendationMarket:
          $enumDecodeNullable(_$MarketEnumMap, json['recommendationMarket']) ??
              Market.US,
      searchMode:
          $enumDecodeNullable(_$SearchModeEnumMap, json['searchMode']) ??
              SearchMode.youtube,
      downloadLocation: json['downloadLocation'] as String? ?? "",
      localLibraryLocation: (json['localLibraryLocation'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pipedInstance:
          json['pipedInstance'] as String? ?? "https://pipedapi.kavin.rocks",
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      audioSource:
          $enumDecodeNullable(_$AudioSourceEnumMap, json['audioSource']) ??
              AudioSource.youtube,
      streamMusicCodec: $enumDecodeNullable(
              _$SourceCodecsEnumMap, json['streamMusicCodec']) ??
          SourceCodecs.weba,
      downloadMusicCodec: $enumDecodeNullable(
              _$SourceCodecsEnumMap, json['downloadMusicCodec']) ??
          SourceCodecs.m4a,
      discordPresence: json['discordPresence'] as bool? ?? true,
      endlessPlayback: json['endlessPlayback'] as bool? ?? true,
      enableConnect: json['enableConnect'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'audioQuality': _$SourceQualitiesEnumMap[instance.audioQuality]!,
      'albumColorSync': instance.albumColorSync,
      'amoledDarkTheme': instance.amoledDarkTheme,
      'checkUpdate': instance.checkUpdate,
      'normalizeAudio': instance.normalizeAudio,
      'showSystemTrayIcon': instance.showSystemTrayIcon,
      'skipNonMusic': instance.skipNonMusic,
      'systemTitleBar': instance.systemTitleBar,
      'closeBehavior': _$CloseBehaviorEnumMap[instance.closeBehavior]!,
      'accentColorScheme':
          UserPreferences._accentColorSchemeToJson(instance.accentColorScheme),
      'layoutMode': _$LayoutModeEnumMap[instance.layoutMode]!,
      'locale': UserPreferences._localeToJson(instance.locale),
      'recommendationMarket': _$MarketEnumMap[instance.recommendationMarket]!,
      'searchMode': _$SearchModeEnumMap[instance.searchMode]!,
      'downloadLocation': instance.downloadLocation,
      'localLibraryLocation': instance.localLibraryLocation,
      'pipedInstance': instance.pipedInstance,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'audioSource': _$AudioSourceEnumMap[instance.audioSource]!,
      'streamMusicCodec': _$SourceCodecsEnumMap[instance.streamMusicCodec]!,
      'downloadMusicCodec': _$SourceCodecsEnumMap[instance.downloadMusicCodec]!,
      'discordPresence': instance.discordPresence,
      'endlessPlayback': instance.endlessPlayback,
      'enableConnect': instance.enableConnect,
    };

const _$SourceQualitiesEnumMap = {
  SourceQualities.high: 'high',
  SourceQualities.medium: 'medium',
  SourceQualities.low: 'low',
};

const _$CloseBehaviorEnumMap = {
  CloseBehavior.minimizeToTray: 'minimizeToTray',
  CloseBehavior.close: 'close',
};

const _$LayoutModeEnumMap = {
  LayoutMode.compact: 'compact',
  LayoutMode.extended: 'extended',
  LayoutMode.adaptive: 'adaptive',
};

const _$MarketEnumMap = {
  Market.AD: 'AD',
  Market.AE: 'AE',
  Market.AF: 'AF',
  Market.AG: 'AG',
  Market.AI: 'AI',
  Market.AL: 'AL',
  Market.AM: 'AM',
  Market.AO: 'AO',
  Market.AQ: 'AQ',
  Market.AR: 'AR',
  Market.AS: 'AS',
  Market.AT: 'AT',
  Market.AU: 'AU',
  Market.AW: 'AW',
  Market.AX: 'AX',
  Market.AZ: 'AZ',
  Market.BA: 'BA',
  Market.BB: 'BB',
  Market.BD: 'BD',
  Market.BE: 'BE',
  Market.BF: 'BF',
  Market.BG: 'BG',
  Market.BH: 'BH',
  Market.BI: 'BI',
  Market.BJ: 'BJ',
  Market.BL: 'BL',
  Market.BM: 'BM',
  Market.BN: 'BN',
  Market.BO: 'BO',
  Market.BQ: 'BQ',
  Market.BR: 'BR',
  Market.BS: 'BS',
  Market.BT: 'BT',
  Market.BV: 'BV',
  Market.BW: 'BW',
  Market.BY: 'BY',
  Market.BZ: 'BZ',
  Market.CA: 'CA',
  Market.CC: 'CC',
  Market.CD: 'CD',
  Market.CF: 'CF',
  Market.CG: 'CG',
  Market.CH: 'CH',
  Market.CI: 'CI',
  Market.CK: 'CK',
  Market.CL: 'CL',
  Market.CM: 'CM',
  Market.CN: 'CN',
  Market.CO: 'CO',
  Market.CR: 'CR',
  Market.CU: 'CU',
  Market.CV: 'CV',
  Market.CW: 'CW',
  Market.CX: 'CX',
  Market.CY: 'CY',
  Market.CZ: 'CZ',
  Market.DE: 'DE',
  Market.DJ: 'DJ',
  Market.DK: 'DK',
  Market.DM: 'DM',
  Market.DO: 'DO',
  Market.DZ: 'DZ',
  Market.EC: 'EC',
  Market.EE: 'EE',
  Market.EG: 'EG',
  Market.EH: 'EH',
  Market.ER: 'ER',
  Market.ES: 'ES',
  Market.ET: 'ET',
  Market.FI: 'FI',
  Market.FJ: 'FJ',
  Market.FK: 'FK',
  Market.FM: 'FM',
  Market.FO: 'FO',
  Market.FR: 'FR',
  Market.GA: 'GA',
  Market.GB: 'GB',
  Market.GD: 'GD',
  Market.GE: 'GE',
  Market.GF: 'GF',
  Market.GG: 'GG',
  Market.GH: 'GH',
  Market.GI: 'GI',
  Market.GL: 'GL',
  Market.GM: 'GM',
  Market.GN: 'GN',
  Market.GP: 'GP',
  Market.GQ: 'GQ',
  Market.GR: 'GR',
  Market.GS: 'GS',
  Market.GT: 'GT',
  Market.GU: 'GU',
  Market.GW: 'GW',
  Market.GY: 'GY',
  Market.HK: 'HK',
  Market.HM: 'HM',
  Market.HN: 'HN',
  Market.HR: 'HR',
  Market.HT: 'HT',
  Market.HU: 'HU',
  Market.ID: 'ID',
  Market.IE: 'IE',
  Market.IL: 'IL',
  Market.IM: 'IM',
  Market.IN: 'IN',
  Market.IO: 'IO',
  Market.IQ: 'IQ',
  Market.IR: 'IR',
  Market.IS: 'IS',
  Market.IT: 'IT',
  Market.JE: 'JE',
  Market.JM: 'JM',
  Market.JO: 'JO',
  Market.JP: 'JP',
  Market.KE: 'KE',
  Market.KG: 'KG',
  Market.KH: 'KH',
  Market.KI: 'KI',
  Market.KM: 'KM',
  Market.KN: 'KN',
  Market.KP: 'KP',
  Market.KR: 'KR',
  Market.KW: 'KW',
  Market.KY: 'KY',
  Market.KZ: 'KZ',
  Market.LA: 'LA',
  Market.LB: 'LB',
  Market.LC: 'LC',
  Market.LI: 'LI',
  Market.LK: 'LK',
  Market.LR: 'LR',
  Market.LS: 'LS',
  Market.LT: 'LT',
  Market.LU: 'LU',
  Market.LV: 'LV',
  Market.LY: 'LY',
  Market.MA: 'MA',
  Market.MC: 'MC',
  Market.MD: 'MD',
  Market.ME: 'ME',
  Market.MF: 'MF',
  Market.MG: 'MG',
  Market.MH: 'MH',
  Market.MK: 'MK',
  Market.ML: 'ML',
  Market.MM: 'MM',
  Market.MN: 'MN',
  Market.MO: 'MO',
  Market.MP: 'MP',
  Market.MQ: 'MQ',
  Market.MR: 'MR',
  Market.MS: 'MS',
  Market.MT: 'MT',
  Market.MU: 'MU',
  Market.MV: 'MV',
  Market.MW: 'MW',
  Market.MX: 'MX',
  Market.MY: 'MY',
  Market.MZ: 'MZ',
  Market.NA: 'NA',
  Market.NC: 'NC',
  Market.NE: 'NE',
  Market.NF: 'NF',
  Market.NG: 'NG',
  Market.NI: 'NI',
  Market.NL: 'NL',
  Market.NO: 'NO',
  Market.NP: 'NP',
  Market.NR: 'NR',
  Market.NU: 'NU',
  Market.NZ: 'NZ',
  Market.OM: 'OM',
  Market.PA: 'PA',
  Market.PE: 'PE',
  Market.PF: 'PF',
  Market.PG: 'PG',
  Market.PH: 'PH',
  Market.PK: 'PK',
  Market.PL: 'PL',
  Market.PM: 'PM',
  Market.PN: 'PN',
  Market.PR: 'PR',
  Market.PS: 'PS',
  Market.PT: 'PT',
  Market.PW: 'PW',
  Market.PY: 'PY',
  Market.QA: 'QA',
  Market.RE: 'RE',
  Market.RO: 'RO',
  Market.RS: 'RS',
  Market.RU: 'RU',
  Market.RW: 'RW',
  Market.SA: 'SA',
  Market.SB: 'SB',
  Market.SC: 'SC',
  Market.SD: 'SD',
  Market.SE: 'SE',
  Market.SG: 'SG',
  Market.SH: 'SH',
  Market.SI: 'SI',
  Market.SJ: 'SJ',
  Market.SK: 'SK',
  Market.SL: 'SL',
  Market.SM: 'SM',
  Market.SN: 'SN',
  Market.SO: 'SO',
  Market.SR: 'SR',
  Market.SS: 'SS',
  Market.ST: 'ST',
  Market.SV: 'SV',
  Market.SX: 'SX',
  Market.SY: 'SY',
  Market.SZ: 'SZ',
  Market.TC: 'TC',
  Market.TD: 'TD',
  Market.TF: 'TF',
  Market.TG: 'TG',
  Market.TH: 'TH',
  Market.TJ: 'TJ',
  Market.TK: 'TK',
  Market.TL: 'TL',
  Market.TM: 'TM',
  Market.TN: 'TN',
  Market.TO: 'TO',
  Market.TR: 'TR',
  Market.TT: 'TT',
  Market.TV: 'TV',
  Market.TW: 'TW',
  Market.TZ: 'TZ',
  Market.UA: 'UA',
  Market.UG: 'UG',
  Market.UM: 'UM',
  Market.US: 'US',
  Market.UY: 'UY',
  Market.UZ: 'UZ',
  Market.VA: 'VA',
  Market.VC: 'VC',
  Market.VE: 'VE',
  Market.VG: 'VG',
  Market.VI: 'VI',
  Market.VN: 'VN',
  Market.VU: 'VU',
  Market.WF: 'WF',
  Market.WS: 'WS',
  Market.XK: 'XK',
  Market.YE: 'YE',
  Market.YT: 'YT',
  Market.ZA: 'ZA',
  Market.ZM: 'ZM',
  Market.ZW: 'ZW',
};

const _$SearchModeEnumMap = {
  SearchMode.youtube: 'youtube',
  SearchMode.youtubeMusic: 'youtubeMusic',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$AudioSourceEnumMap = {
  AudioSource.youtube: 'youtube',
  AudioSource.piped: 'piped',
  AudioSource.jiosaavn: 'jiosaavn',
};

const _$SourceCodecsEnumMap = {
  SourceCodecs.m4a: 'm4a',
  SourceCodecs.weba: 'weba',
};

_$PlaybackHistoryPlaylistImpl _$$PlaybackHistoryPlaylistImplFromJson(
        Map json) =>
    _$PlaybackHistoryPlaylistImpl(
      date: DateTime.parse(json['date'] as String),
      playlist: PlaylistSimple.fromJson(
          Map<String, dynamic>.from(json['playlist'] as Map)),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PlaybackHistoryPlaylistImplToJson(
        _$PlaybackHistoryPlaylistImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'playlist': instance.playlist.toJson(),
      'runtimeType': instance.$type,
    };

_$PlaybackHistoryAlbumImpl _$$PlaybackHistoryAlbumImplFromJson(Map json) =>
    _$PlaybackHistoryAlbumImpl(
      date: DateTime.parse(json['date'] as String),
      album:
          AlbumSimple.fromJson(Map<String, dynamic>.from(json['album'] as Map)),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PlaybackHistoryAlbumImplToJson(
        _$PlaybackHistoryAlbumImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'album': instance.album.toJson(),
      'runtimeType': instance.$type,
    };

_$PlaybackHistoryTrackImpl _$$PlaybackHistoryTrackImplFromJson(Map json) =>
    _$PlaybackHistoryTrackImpl(
      date: DateTime.parse(json['date'] as String),
      track: Track.fromJson(Map<String, dynamic>.from(json['track'] as Map)),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PlaybackHistoryTrackImplToJson(
        _$PlaybackHistoryTrackImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'track': instance.track.toJson(),
      'runtimeType': instance.$type,
    };
