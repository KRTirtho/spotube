// Web stub implementation - tray manager not available on web

class TrayManager {
  static TrayManager get instance => TrayManager._();
  TrayManager._();
  
  Future<void> setIcon(String path, {bool isTemplate = false}) async {}
  Future<void> setToolTip(String toolTip) async {}
  Future<void> setContextMenu(dynamic menu) async {}
  Future<void> destroy() async {}
}

TrayManager get trayManager => TrayManager.instance;

mixin class TrayListener {}

class Menu {
  List<MenuItem> items;
  Menu({required this.items});
}

class MenuItem {
  String? label;
  String? key;
  bool? disabled;
  bool? checked;
  dynamic onClick;
  dynamic click;
  List<MenuItem>? submenu;
  
  MenuItem({
    this.label,
    this.key,
    this.disabled,
    this.checked,
    this.onClick,
    this.click,
  });
  
  MenuItem.separator() : label = null, key = null, disabled = null, checked = null, onClick = null, click = null;
  
  MenuItem.submenu({
    this.label,
    this.key,
    required this.submenu,
  }) : disabled = null, checked = null, onClick = null, click = null;
}