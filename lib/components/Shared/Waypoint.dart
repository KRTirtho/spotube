import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Waypoint extends StatelessWidget {
  final void Function()? onEnter;
  final void Function()? onLeave;
  final Widget? child;
  const Waypoint({
    Key? key,
    this.onEnter,
    this.onLeave,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key("waypoint"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          onLeave?.call();
        } else if (info.visibleFraction > 0) {
          onEnter?.call();
        }
      },
      child: child ?? Container(),
    );
  }
}
