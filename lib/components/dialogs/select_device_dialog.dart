import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/connect/clients.dart';

class SelectDeviceDialog extends HookConsumerWidget {
  const SelectDeviceDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isRemoteService = useState(false);

    final connectClients = ref.watch(connectClientsProvider);
    final remoteService = connectClients.asData!.value.resolvedService!;

    return AlertDialog(
      title: const Text("Choose the device:"),
      insetPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "There are multiple device connected.\n"
            "Choose the device you want this action to take place",
          ),
          RadioListTile.adaptive(
            title: Text(remoteService.name),
            value: true,
            groupValue: isRemoteService.value,
            onChanged: (value) {
              isRemoteService.value = value!;
            },
          ),
          RadioListTile.adaptive(
            title: const Text("This Device"),
            value: false,
            groupValue: isRemoteService.value,
            onChanged: (value) {
              isRemoteService.value = !value!;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(isRemoteService.value);
          },
          child: Text(context.l10n.select),
        ),
      ],
    );
  }
}

Future<bool> showSelectDeviceDialog(BuildContext context, WidgetRef ref) async {
  final connectClients = ref.read(connectClientsProvider);

  if (connectClients.asData?.value.resolvedService == null) {
    return false;
  }

  final isRemote = await showDialog<bool>(
    context: context,
    builder: (context) => const SelectDeviceDialog(),
  );

  return isRemote ?? false;
}
