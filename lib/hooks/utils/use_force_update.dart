import 'package:flutter_hooks/flutter_hooks.dart';

void Function() useForceUpdate() {
  final state = useState(null);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  return () => state.notifyListeners();
}
