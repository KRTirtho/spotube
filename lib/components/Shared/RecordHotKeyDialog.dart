import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class RecordHotKeyDialog extends HookWidget {
  final ValueChanged<HotKey> onHotKeyRecorded;

  const RecordHotKeyDialog({
    Key? key,
    required this.onHotKeyRecorded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _hotKey = useState(HotKey(null));
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Press the keys you want to use',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 10),
            const Text(
                "DO NOT Use only letters (e.g. k, g etc..)\nUse in combination with these"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeyCode.control,
                KeyCode.shift,
                KeyCode.alt,
                KeyCode.superKey,
                KeyCode.meta,
              ]
                  .map((key) => HotKeyVirtualView(
                        hotKey: HotKey(key),
                      ))
                  .toList(),
            ),
            Container(
              width: 100,
              height: 60,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  HotKeyRecorder(
                    onHotKeyRecorded: (hotKey) {
                      _hotKey.value = hotKey;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: !_hotKey.value.isSetted
              ? null
              : () {
                  onHotKeyRecorded(_hotKey.value);
                  GoRouter.of(context).pop();
                },
        ),
      ],
    );
  }
}
