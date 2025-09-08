Map<String, dynamic> castNestedJson(Map map) {
  return Map.castFrom<dynamic, dynamic, String, dynamic>(
    map.map((key, value) {
      if (value is Map) {
        return MapEntry(
          key,
          castNestedJson(value),
        );
      } else if (value is Iterable) {
        return MapEntry(
          key,
          value.map((e) {
            if (e is Map) return castNestedJson(e);
            return e;
          }).toList(),
        );
      }
      return MapEntry(key, value);
    }),
  );
}
