part of '../spotify.dart';

// ignore: invalid_use_of_internal_member
mixin Persistence<T> on BuildlessAsyncNotifier<T> {
  LazyBox get store => Hive.lazyBox("spotube_cache");

  FutureOr<T> fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T data);

  FutureOr<void> onInit() {}

  Future<void> load() async {
    final json = await store.get(runtimeType.toString());
    if (json != null ||
        (json is Map && json.entries.isNotEmpty) ||
        (json is List && json.isNotEmpty)) {
      state = AsyncData(
        await fromJson(
          castNestedJson(json),
        ),
      );
    }

    await onInit();
  }

  Future<void> save() async {
    await store.put(
      runtimeType.toString(),
      state.value == null ? null : toJson(state.value as T),
    );
  }

  @override
  set state(AsyncValue<T> value) {
    if (state == value) return;
    super.state = value;
    save();
  }
}
