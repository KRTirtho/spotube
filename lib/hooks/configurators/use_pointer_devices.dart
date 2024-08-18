import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/utils/platform.dart';

Set<PointerDeviceKind> usePointerDevices() {
  final devices = useState<Set<PointerDeviceKind>>({
    if (kIsMobile) PointerDeviceKind.touch,
    if (kIsDesktop || kIsWeb) PointerDeviceKind.mouse,
  });

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GestureBinding.instance.pointerRouter
          .addGlobalRoute((PointerEvent event) {
        if (devices.value.contains(event.kind)) return;
        devices.value = {
          ...devices.value,
          event.kind,
        };
      });
    });

    return null;
  }, []);

  return devices.value;
}
