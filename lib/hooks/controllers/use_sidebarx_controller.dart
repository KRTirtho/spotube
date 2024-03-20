import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sidebarx/sidebarx.dart';

/// Creates [SidebarXController] that will be disposed automatically.
///
/// See also:
/// - [SidebarXController]
SidebarXController useSidebarXController({
  required int selectedIndex,
  bool? extended,
  List<Object?>? keys,
}) {
  return use(
    _SidebarXControllerHook(
      selectedIndex: selectedIndex,
      extended: extended,
      keys: keys,
    ),
  );
}

class _SidebarXControllerHook extends Hook<SidebarXController> {
  const _SidebarXControllerHook({
    required this.selectedIndex,
    this.extended,
    super.keys,
  });

  final int selectedIndex;
  final bool? extended;

  @override
  HookState<SidebarXController, Hook<SidebarXController>> createState() =>
      _SidebarXControllerHookState();
}

class _SidebarXControllerHookState
    extends HookState<SidebarXController, _SidebarXControllerHook> {
  late final SidebarXController controller;

  @override
  void initHook() {
    super.initHook();
    controller = SidebarXController(
      selectedIndex: hook.selectedIndex,
      extended: hook.extended,
    );
  }

  @override
  SidebarXController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useSidebarXController';
}
