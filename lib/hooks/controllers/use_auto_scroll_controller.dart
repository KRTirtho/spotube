import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// Creates [AutoScrollController] that will be disposed automatically.
///
/// See also:
/// - [AutoScrollController]
AutoScrollController useAutoScrollController({
  double initialScrollOffset = 0.0,
  bool keepScrollOffset = true,
  String? debugLabel,
  Axis? axis,
  AutoScrollController? copyTagsFrom,
  double? suggestedRowHeight,
  Rect Function() viewportBoundaryGetter = defaultViewportBoundaryGetter,
  List<Object?>? keys,
}) {
  return use(
    _AutoScrollControllerHook(
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      debugLabel: debugLabel,
      axis: axis,
      copyTagsFrom: copyTagsFrom,
      suggestedRowHeight: suggestedRowHeight,
      viewportBoundaryGetter: viewportBoundaryGetter,
      keys: keys,
    ),
  );
}

class _AutoScrollControllerHook extends Hook<AutoScrollController> {
  const _AutoScrollControllerHook({
    required this.initialScrollOffset,
    required this.keepScrollOffset,
    required this.viewportBoundaryGetter,
    this.axis,
    this.copyTagsFrom,
    this.suggestedRowHeight,
    this.debugLabel,
    super.keys,
  });

  final double initialScrollOffset;
  final bool keepScrollOffset;
  final String? debugLabel;
  final Axis? axis;
  final AutoScrollController? copyTagsFrom;
  final double? suggestedRowHeight;
  final Rect Function() viewportBoundaryGetter;

  @override
  HookState<AutoScrollController, Hook<AutoScrollController>> createState() =>
      _AutoScrollControllerHookState();
}

class _AutoScrollControllerHookState
    extends HookState<AutoScrollController, _AutoScrollControllerHook> {
  late final AutoScrollController controller;

  @override
  void initHook() {
    super.initHook();
    controller = AutoScrollController(
      initialScrollOffset: hook.initialScrollOffset,
      keepScrollOffset: hook.keepScrollOffset,
      debugLabel: hook.debugLabel,
      axis: hook.axis,
      copyTagsFrom: hook.copyTagsFrom,
      suggestedRowHeight: hook.suggestedRowHeight,
      viewportBoundaryGetter: hook.viewportBoundaryGetter,
    );
  }

  @override
  AutoScrollController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useAutoScrollController';
}
