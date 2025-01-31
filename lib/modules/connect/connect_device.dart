import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/connect/clients.dart';

class ConnectDeviceButton extends HookConsumerWidget {
  final bool _sidebar;
  const ConnectDeviceButton({super.key}) : _sidebar = false;
  const ConnectDeviceButton.sidebar({super.key}) : _sidebar = true;

  @override
  Widget build(BuildContext context, ref) {
    final connectClients = ref.watch(connectClientsProvider);

    final hasServices =
        connectClients.asData?.value.services.isNotEmpty == true;

    if (_sidebar) {
      final mediaQuery = MediaQuery.sizeOf(context);

      if (mediaQuery.mdAndDown) {
        return IconButton.ghost(
          icon: const Icon(SpotubeIcons.speaker),
          onPressed: () {
            context.navigateTo(const ConnectRoute());
          },
        );
      }

      return SizedBox(
        width: double.infinity,
        child: Button.primary(
          onPressed: () {
            context.navigateTo(const ConnectRoute());
          },
          trailing: const Icon(SpotubeIcons.speaker),
          child: Text(
            "${context.l10n.devices}"
            "${hasServices ? " (${connectClients.asData?.value.services.length})" : ""}",
          ),
        ),
      );
    }

    return Row(
      children: [
        SecondaryBadge(
          onPressed: () {
            context.navigateTo(const ConnectRoute());
          },
          style: const ButtonStyle.secondary(size: ButtonSize(.8)),
          leading: connectClients.asData?.value.resolvedService != null
              ? const Center(
                  child: DotItem(
                    size: 6,
                    borderRadius: 10,
                    color: Colors.green,
                  ),
                )
              : null,
          child: Text(
            "${context.l10n.devices}"
            "${hasServices ? " (${connectClients.asData?.value.services.length})" : ""}",
          ),
        ),
        IconButton.primary(
          icon: const Icon(SpotubeIcons.speaker),
          onPressed: () {
            context.navigateTo(const ConnectRoute());
          },
        )
      ],
    );
  }
}
