import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/connect/connect.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/utils/service_utils.dart';

class ConnectDeviceButton extends HookConsumerWidget {
  final bool _sidebar;
  const ConnectDeviceButton({super.key}) : _sidebar = false;
  const ConnectDeviceButton.sidebar({super.key}) : _sidebar = true;

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:colorScheme) = Theme.of(context);
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final connectClients = ref.watch(connectClientsProvider);

    if (_sidebar) {
      return SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            ServiceUtils.pushNamed(context, ConnectPage.name);
          },
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(5),
          ),
          child: Row(
            children: [
              Text(context.l10n.devices),
              if (connectClients.asData?.value.services.isNotEmpty == true)
                Text(
                  " (${connectClients.asData?.value.services.length})",
                ),
              const Spacer(),
              const Icon(SpotubeIcons.speaker),
              const Gap(5),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 40 * pixelRatio,
      child: Stack(
        alignment: Alignment.centerRight,
        fit: StackFit.loose,
        children: [
          Material(
            type: MaterialType.transparency,
            child: Center(
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {
                    ServiceUtils.pushNamed(context, ConnectPage.name);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: colorScheme.primaryContainer,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (connectClients.asData?.value.resolvedService !=
                            null) ...[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          const Gap(5),
                        ],
                        Text(context.l10n.devices),
                        if (connectClients.asData?.value.services.isNotEmpty ==
                            true)
                          Text(
                            " (${connectClients.asData?.value.services.length})",
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer
                                  .withOpacity(0.5),
                            ),
                          ),
                        const Gap(35),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -3,
            child: IconButton.filled(
              icon: const Icon(SpotubeIcons.speaker),
              style: IconButton.styleFrom(
                visualDensity: VisualDensity.standard,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () {
                ServiceUtils.pushNamed(context, ConnectPage.name);
              },
            ),
          ),
        ],
      ),
    );
  }
}
