part of '../database.dart';

class AudioPlayerStateTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get playing => boolean()();
  TextColumn get loopMode => textEnum<PlaylistMode>()();
  BoolColumn get shuffled => boolean()();
  TextColumn get collections => text().map(const StringListConverter())();
  TextColumn get tracks =>
      text().map(const SpotubeTrackObjectListConverter())();
  IntColumn get currentIndex => integer()();
}

class SpotubeTrackObjectListConverter
    extends TypeConverter<List<SpotubeTrackObject>, String> {
  const SpotubeTrackObjectListConverter();

  @override
  List<SpotubeTrackObject> fromSql(String fromDb) {
    return fromDb
        .split(",")
        .where((e) => e.isNotEmpty)
        .map(
          (e) => SpotubeTrackObject.fromJson(
            json.decode(e) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  String toSql(List<SpotubeTrackObject> value) {
    return value.map((e) => json.encode(e)).join(",");
  }
}
