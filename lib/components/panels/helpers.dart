part of "sliding_up_panel.dart";

/// if you want to prevent the panel from being dragged using the widget,
/// wrap the widget with this
class IgnoreDraggableWidget extends SingleChildRenderObjectWidget {
  const IgnoreDraggableWidget({
    super.key,
    required super.child,
  });

  @override
  IgnoreDraggableWidgetWidgetRenderBox createRenderObject(
    BuildContext context,
  ) {
    return IgnoreDraggableWidgetWidgetRenderBox();
  }
}

class IgnoreDraggableWidgetWidgetRenderBox extends RenderPointerListener {
  @override
  HitTestBehavior get behavior => HitTestBehavior.opaque;
}

/// if you want to force the panel to be dragged using the widget,
/// wrap the widget with this
/// For example, use [Scrollable] inside to allow the panel to be dragged
///  even if the scroll is not at position 0.
class ForceDraggableWidget extends SingleChildRenderObjectWidget {
  const ForceDraggableWidget({
    super.key,
    required super.child,
  });

  @override
  ForceDraggableWidgetRenderBox createRenderObject(
    BuildContext context,
  ) {
    return ForceDraggableWidgetRenderBox();
  }
}

class ForceDraggableWidgetRenderBox extends RenderPointerListener {
  @override
  HitTestBehavior get behavior => HitTestBehavior.opaque;
}

/// To make [ForceDraggableWidget] work in [Scrollable] widgets
class PanelScrollPhysics extends ScrollPhysics {
  final PanelController controller;
  const PanelScrollPhysics({required this.controller, super.parent});
  @override
  PanelScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PanelScrollPhysics(
        controller: controller, parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (controller._nowTargetForceDraggable) return 0.0;
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (controller._nowTargetForceDraggable) {
      return super.createBallisticSimulation(position, 0);
    }
    return super.createBallisticSimulation(position, velocity);
  }

  @override
  bool get allowImplicitScrolling => false;
}

/// if you want to prevent unwanted panel dragging when scrolling widgets [Scrollable] with horizontal axis
/// wrap the widget with this
class HorizontalScrollableWidget extends SingleChildRenderObjectWidget {
  const HorizontalScrollableWidget({
    super.key,
    required super.child,
  });

  @override
  HorizontalScrollableWidgetRenderBox createRenderObject(
    BuildContext context,
  ) {
    return HorizontalScrollableWidgetRenderBox();
  }
}

class HorizontalScrollableWidgetRenderBox extends RenderPointerListener {
  @override
  HitTestBehavior get behavior => HitTestBehavior.opaque;
}
