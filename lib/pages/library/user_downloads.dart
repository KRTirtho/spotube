import 'package:auto_size_text/auto_size_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/modules/library/user_downloads/download_item.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class UserDownloadsPage extends HookConsumerWidget {
  static const name = 'user_downloads';
  const UserDownloadsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final downloadQueue = ref.watch(downloadManagerProvider);
    final downloadManagerNotifier = ref.watch(downloadManagerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  context.l10n.currently_downloading(downloadQueue.length),
                  maxLines: 1,
                ).semiBold(),
              ),
              const SizedBox(width: 10),
              Button.destructive(
                onPressed: downloadQueue.isEmpty
                    ? null
                    : downloadManagerNotifier.clearAll,
                child: Text(context.l10n.cancel_all),
              ),
            ],
          ),
        ),
        Expanded(
          child: SafeArea(
            child: ListView.builder(
              itemCount: downloadQueue.length,
              padding: const EdgeInsets.only(bottom: 200),
              itemBuilder: (context, index) {
                return DownloadItem(
                  task: downloadQueue.elementAt(index),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
