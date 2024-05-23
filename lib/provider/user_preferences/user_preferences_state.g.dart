// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
