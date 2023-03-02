extension CastDeepMaps on Map {
  Map<K2, dynamic> castKeyDeep<K2>() {
    return cast<K2, dynamic>().map((key, value) {
      if (value is Map) {
        return MapEntry(key, value.castKeyDeep<K2>());
      } else if (value is List) {
        return MapEntry(
          key,
          value.map((e) => e is Map ? e.castKeyDeep<K2>() : e).toList(),
        );
      }
      return MapEntry(key, value);
    });
  }
}
