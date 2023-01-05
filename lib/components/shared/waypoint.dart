import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Waypoint extends HookWidget {
  final FutureOr<void> Function()? onTouchEdge;
  final Widget? child;
  final ScrollController controller;
  final bool isGrid;

  const Waypoint({
    Key? key,
    required this.controller,
    this.isGrid = false,
    this.onTouchEdge,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();

    useEffect(() {
      if (isGrid) {
        return null;
      }
      Future<void> listener() async {
        // nextPageTrigger will have a value equivalent to 80% of the list size.
        final nextPageTrigger = 0.8 * controller.position.maxScrollExtent;

        // scrollController fetches the next paginated data when the current
        // position of the user on the screen has surpassed
        if (controller.position.pixels >= nextPageTrigger && isMounted()) {
          await onTouchEdge?.call();
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients && isMounted()) {
          listener();
          controller.addListener(listener);
        }
      });
      return () => controller.removeListener(listener);
    }, [controller, onTouchEdge, isMounted]);

    if (isGrid) {
      return VisibilityDetector(
        key: const Key("waypoint"),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0) {
            onTouchEdge?.call();
          }
        },
        child: child ?? Container(),
      );
    }

    return child ?? Container();
  }
}
