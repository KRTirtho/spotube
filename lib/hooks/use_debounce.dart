import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

T useDebounce<T>(
  T value, [
  Duration delay = const Duration(milliseconds: 500),
]) {
  final state = useState<T>(value);

  useEffect(() {
    final timer = Timer(delay, () => state.value = value);
    return timer.cancel;
  }, [value, delay]);

  return state.value;
}
