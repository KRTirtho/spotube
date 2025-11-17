import 'package:flutter/gestures.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/utils/platform.dart';

bool useHasTouch() {
  final hasTouch = useState(kIsMobile);

  useEffect(() {
    void globalRoute(PointerEvent event) {
      if (hasTouch.value) return;
      hasTouch.value = event.kind == PointerDeviceKind.touch ||
          event.kind == PointerDeviceKind.stylus ||
          event.kind == PointerDeviceKind.invertedStylus;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(globalRoute);
    });

    return () {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(globalRoute);
    };
  }, []);

  return hasTouch.value;
}
