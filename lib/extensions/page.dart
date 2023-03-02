import 'package:spotify/spotify.dart';

extension CursorPageJson<T> on CursorPage<T> {
  static CursorPage<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(dynamic json) itemFromJson,
  ) {
    final metadata = Paging.fromJson(json["metadata"]);
    final paging = CursorPaging<T>();
    paging.cursors = Cursor.fromJson(json["metadata"])..after = json["after"];
    paging.href = metadata.href;
    paging.itemsNative = paging.itemsNative;
    paging.limit = metadata.limit;
    paging.next = metadata.next;
    return CursorPage<T>(
      paging,
      itemFromJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "after": after,
      "metadata": metadata.toJson(),
    };
  }
}

extension PagingToJson<T> on Paging<T> {
  Map<String, dynamic> toJson() {
    return {
      "items": itemsNative,
      "total": total,
      "next": next,
      "previous": previous,
      "limit": limit,
      "offset": offset,
      "href": href,
    };
  }
}

extension PageJson<T> on Page<T> {
  static Page<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(dynamic json) itemFromJson,
  ) {
    return Page<T>(
      Paging<T>.fromJson(
        Map.castFrom<dynamic, dynamic, String, dynamic>(json["metadata"]),
      ),
      itemFromJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "metadata": metadata.toJson(),
    };
  }
}
