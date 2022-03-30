import 'package:flutter_hooks/flutter_hooks.dart';

void Function() useForceUpdate() {
  final state = useState(null);
  return () => state.notifyListeners();
}
