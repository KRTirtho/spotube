import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/utils/service_utils.dart';

class ConnectDeviceButton extends HookConsumerWidget {
  const ConnectDeviceButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:colorScheme) = Theme.of(context);
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final connectClients = ref.watch(connectClientsProvider);

    return SizedBox(
      height: 40 * pixelRatio,
      child: Stack(
        alignment: Alignment.centerRight,
        fit: StackFit.loose,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                ServiceUtils.push(context, "/connect");
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
                          color:
                              colorScheme.onPrimaryContainer.withOpacity(0.5),
                        ),
                      ),
                    const Gap(35),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton.filled(
              icon: const Icon(SpotubeIcons.speaker),
              style: IconButton.styleFrom(
                visualDensity: VisualDensity.standard,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () {
                ServiceUtils.push(context, "/connect");
              },
            ),
          ),
        ],
      ),
    );
  }
}
