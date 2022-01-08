import 'package:hotkey_manager/hotkey_manager.dart';

class GlobalKeyActions {
  late final HotKey hotKey;
  late final Function(HotKey hotKey) onKeyDown;
  GlobalKeyActions(this.hotKey, this.onKeyDown);
}
