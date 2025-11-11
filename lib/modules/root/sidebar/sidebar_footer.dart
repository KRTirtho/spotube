import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show Badge;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/connect/connect_device.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';

class SidebarFooter extends HookConsumerWidget implements NavigationBarItem {
  const SidebarFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final router = AutoRouter.of(context, watch: true);
    final mediaQuery = MediaQuery.of(context);
    final downloadCount = ref
        .watch(downloadManagerProvider)
        .where((e) =>
            e.status == DownloadStatus.downloading ||
            e.status == DownloadStatus.queued)
        .length;
    final userSnapshot = ref.watch(metadataPluginUserProvider);
    final data = userSnapshot.asData?.value;

    final avatarImg = (data?.images).asUrlString(
      index: (data?.images.length ?? 1) - 1,
      placeholder: ImagePlaceholder.artist,
    );

    final authenticated = ref.watch(metadataPluginAuthenticatedProvider);

    if (mediaQuery.mdAndDown) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Badge(
            isLabelVisible: downloadCount > 0,
            label: Text(downloadCount.toString()),
            child: IconButton(
              variance: router.topRoute.name == UserDownloadsRoute.name
                  ? ButtonVariance.secondary
                  : ButtonVariance.ghost,
              icon: const Icon(SpotubeIcons.download),
              onPressed: () => context.navigateTo(const UserDownloadsRoute()),
            ),
          ),
          const ConnectDeviceButton.sidebar(),
          IconButton(
            variance: ButtonVariance.ghost,
            icon: const Icon(SpotubeIcons.settings),
            onPressed: () => context.navigateTo(const SettingsRoute()),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 12),
      width: 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          SizedBox(
            width: double.infinity,
            child: Button(
              style: router.topRoute.name == UserDownloadsRoute.name
                  ? ButtonVariance.secondary
                  : ButtonVariance.outline,
              onPressed: () {
                context.navigateTo(const UserDownloadsRoute());
              },
              leading: const Icon(SpotubeIcons.download),
              trailing: downloadCount > 0
                  ? PrimaryBadge(
                      child: Text(downloadCount.toString()),
                    )
                  : null,
              child: Text(context.l10n.downloads),
            ),
          ),
          const ConnectDeviceButton.sidebar(),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (authenticated.asData?.value == true && data == null)
                const CircularProgressIndicator()
              else if (data != null)
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      context.navigateTo(const ProfileRoute());
                    },
                    child: Row(
                      children: [
                        Avatar(
                          initials: Avatar.getInitials(data.name),
                          provider: UniversalImage.imageProvider(avatarImg),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            data.name,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: theme.typography.normal
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              IconButton(
                variance: ButtonVariance.ghost,
                icon: const Icon(SpotubeIcons.settings),
                onPressed: () {
                  context.navigateTo(const SettingsRoute());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get selectable => false;
}
