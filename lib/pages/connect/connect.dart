import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/utils/service_utils.dart';

class ConnectPage extends HookConsumerWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:colorScheme) = Theme.of(context);

    final connectClients = ref.watch(connectClientsProvider);
    final connectClientsNotifier = ref.read(connectClientsProvider.notifier);
    final discoveredDevices = connectClients.asData?.value.services;

    return Scaffold(
      appBar: PageWindowTitleBar(
        automaticallyImplyLeading: true,
        title: Text(context.l10n.devices),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: discoveredDevices?.length ?? 0,
        separatorBuilder: (context, index) => const Gap(10),
        itemBuilder: (context, index) {
          final device = discoveredDevices![index];
          final selected =
              connectClients.asData?.value.resolvedService?.name == device.name;
          return Card(
            child: ListTile(
              leading: const Icon(SpotubeIcons.monitor),
              title: Text(device.name),
              subtitle: selected
                  ? Text(
                      "${connectClients.asData?.value.resolvedService?.host}"
                      ":${connectClients.asData?.value.resolvedService?.port}",
                    )
                  : null,
              selected: selected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              selectedTileColor: colorScheme.secondary.withOpacity(0.1),
              onTap: () {
                if (selected) {
                  ServiceUtils.push(
                    context,
                    "/connect/control",
                  );
                } else {
                  connectClientsNotifier.resolveService(device);
                }
              },
              trailing: selected
                  ? IconButton(
                      icon: const Icon(SpotubeIcons.power),
                      onPressed: () =>
                          connectClientsNotifier.clearResolvedService(),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
