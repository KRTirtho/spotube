import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:spotube/components/Shared/RecordHotKeyDialog.dart';

class SettingsHotKeyTile extends StatelessWidget {
  final String title;
  final HotKey? currentHotKey;
  final ValueChanged<HotKey> onHotKeyRecorded;
  const SettingsHotKeyTile({
    required this.onHotKeyRecorded,
    required this.title,
    Key? key,
    this.currentHotKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentHotKey != null) HotKeyVirtualView(hotKey: currentHotKey!),
          const SizedBox(width: 10),
          ElevatedButton(
            child: const Text("Set Shortcut"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return RecordHotKeyDialog(
                    onHotKeyRecorded: onHotKeyRecorded,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
