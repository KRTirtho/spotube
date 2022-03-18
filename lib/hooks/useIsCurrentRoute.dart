import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

bool? useIsCurrentRoute([String matcher = "/"]) {
  final isCurrentRoute = useState<bool?>(null);
  final context = useContext();
  useEffect(() {
    WidgetsBinding.instance?.addPostFrameCallback((timer) {
      final isCurrent = GoRouter.of(context).location == matcher;
      if (isCurrent != isCurrentRoute.value) {
        isCurrentRoute.value = isCurrent;
      }
    });
    return null;
  });
  return isCurrentRoute.value;
}
