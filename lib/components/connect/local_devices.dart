import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

class ConnectPageLocalDevices extends HookWidget {
  const ConnectPageLocalDevices({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData(:textTheme) = Theme.of(context);
    final devicesFuture = useFuture(audioPlayer.devices);
    final devicesStream = useStream(audioPlayer.devicesStream);
    final selectedDeviceFuture = useFuture(audioPlayer.selectedDevice);
    final selectedDeviceStream = useStream(audioPlayer.selectedDeviceStream);

    final devices = devicesStream.data ?? devicesFuture.data;
    final selectedDevice =
        selectedDeviceStream.data ?? selectedDeviceFuture.data;

    if (devices == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverMainAxisGroup(
      slivers: [
        const SliverGap(10),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: SliverToBoxAdapter(
            child: Text(
              context.l10n.this_device,
              style: textTheme.titleMedium,
            ),
          ),
        ),
        const SliverGap(10),
        SliverList.separated(
          itemCount: devices.length,
          separatorBuilder: (context, index) => const Gap(10),
          itemBuilder: (context, index) {
            final device = devices[index];

            return Card(
              child: ListTile(
                leading: const Icon(SpotubeIcons.speaker),
                title: Text(device.description),
                subtitle: Text(device.name),
                selected: selectedDevice == device,
                onTap: () => audioPlayer.setAudioDevice(device),
              ),
            );
          },
        ),
      ],
    );
  }
}
