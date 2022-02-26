import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

PagingController<PageKeyType, ItemType>
    usePagingController<PageKeyType, ItemType>({
  required final PageKeyType firstPageKey,
  final int? invisibleItemsThreshold,
  List<Object?>? keys,
}) {
  return use(
    _PagingControllerHook<PageKeyType, ItemType>(
      firstPageKey: firstPageKey,
      invisibleItemsThreshold: invisibleItemsThreshold,
      keys: keys,
    ),
  );
}

class _PagingControllerHook<PageKeyType, ItemType>
    extends Hook<PagingController<PageKeyType, ItemType>> {
  const _PagingControllerHook({
    required this.firstPageKey,
    this.invisibleItemsThreshold,
    List<Object?>? keys,
  }) : super(keys: keys);

  final PageKeyType firstPageKey;
  final int? invisibleItemsThreshold;

  @override
  HookState<PagingController<PageKeyType, ItemType>,
          Hook<PagingController<PageKeyType, ItemType>>>
      createState() => _PagingControllerHookState<PageKeyType, ItemType>();
}

class _PagingControllerHookState<PageKeyType, ItemType> extends HookState<
    PagingController<PageKeyType, ItemType>,
    _PagingControllerHook<PageKeyType, ItemType>> {
  late final controller = PagingController<PageKeyType, ItemType>(
      firstPageKey: hook.firstPageKey,
      invisibleItemsThreshold: hook.invisibleItemsThreshold);

  @override
  PagingController<PageKeyType, ItemType> build(BuildContext context) =>
      controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'usePagingController';
}
