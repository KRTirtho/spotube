part of '../database.dart';

enum LayoutMode {
  compact,
  extended,
  adaptive,
}

enum CloseBehavior {
  minimizeToTray,
  close,
}

enum AudioSource {
  youtube,
  piped,
  jiosaavn;

  String get label => name[0].toUpperCase() + name.substring(1);
}

enum MusicCodec {
  m4a._("M4a (Best for downloaded music)"),
  weba._("WebA (Best for streamed music)\nDoesn't support audio metadata");

  final String label;
  const MusicCodec._(this.label);
}

enum SearchMode {
  youtube._("YouTube"),
  youtubeMusic._("YouTube Music");

  final String label;

  const SearchMode._(this.label);

  factory SearchMode.fromString(String key) {
    return SearchMode.values.firstWhere((e) => e.name == key);
  }
}

class PreferencesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get audioQuality => textEnum<SourceQualities>()
      .withDefault(Constant(SourceQualities.high.name))();
  BoolColumn get albumColorSync =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get amoledDarkTheme =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get checkUpdate => boolean().withDefault(const Constant(true))();
  BoolColumn get normalizeAudio =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get showSystemTrayIcon =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get systemTitleBar =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get skipNonMusic => boolean().withDefault(const Constant(false))();
  TextColumn get closeBehavior => textEnum<CloseBehavior>()
      .withDefault(Constant(CloseBehavior.close.name))();
  TextColumn get accentColorScheme => text()
      .withDefault(const Constant("Blue:0xFF2196F3"))
      .map(const SpotubeColorConverter())();
  TextColumn get layoutMode =>
      textEnum<LayoutMode>().withDefault(Constant(LayoutMode.adaptive.name))();
  TextColumn get locale => text()
      .withDefault(
        const Constant('{"languageCode":"system","countryCode":"system"}'),
      )
      .map(const LocaleConverter())();
  TextColumn get market =>
      textEnum<Market>().withDefault(Constant(Market.US.name))();
  TextColumn get searchMode =>
      textEnum<SearchMode>().withDefault(Constant(SearchMode.youtube.name))();
  TextColumn get downloadLocation => text().withDefault(const Constant(""))();
  TextColumn get localLibraryLocation =>
      text().withDefault(const Constant("")).map(const StringListConverter())();
  TextColumn get pipedInstance =>
      text().withDefault(const Constant("https://pipedapi.kavin.rocks"))();
  TextColumn get themeMode =>
      textEnum<ThemeMode>().withDefault(Constant(ThemeMode.system.name))();
  TextColumn get audioSource =>
      textEnum<AudioSource>().withDefault(Constant(AudioSource.youtube.name))();
  TextColumn get streamMusicCodec =>
      textEnum<SourceCodecs>().withDefault(Constant(SourceCodecs.weba.name))();
  TextColumn get downloadMusicCodec =>
      textEnum<SourceCodecs>().withDefault(Constant(SourceCodecs.m4a.name))();
  BoolColumn get discordPresence =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get endlessPlayback =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableConnect =>
      boolean().withDefault(const Constant(false))();

  // Default values as PreferencesTableData
  static PreferencesTableData defaults() {
    return PreferencesTableData(
      id: 0,
      audioQuality: SourceQualities.high,
      albumColorSync: true,
      amoledDarkTheme: false,
      checkUpdate: true,
      normalizeAudio: false,
      showSystemTrayIcon: false,
      systemTitleBar: false,
      skipNonMusic: false,
      closeBehavior: CloseBehavior.close,
      accentColorScheme: SpotubeColor(Colors.blue.value, name: "Blue"),
      layoutMode: LayoutMode.adaptive,
      locale: const Locale("system", "system"),
      market: Market.US,
      searchMode: SearchMode.youtube,
      downloadLocation: "",
      localLibraryLocation: [],
      pipedInstance: "https://pipedapi.kavin.rocks",
      themeMode: ThemeMode.system,
      audioSource: AudioSource.youtube,
      streamMusicCodec: SourceCodecs.weba,
      downloadMusicCodec: SourceCodecs.m4a,
      discordPresence: true,
      endlessPlayback: true,
      enableConnect: false,
    );
  }
}
