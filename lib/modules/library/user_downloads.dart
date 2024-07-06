import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/modules/library/user_downloads/download_item.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';

class UserDownloads extends HookConsumerWidget {
  const UserDownloads({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final downloadManager = ref.watch(downloadManagerProvider);

    final history = [
      ...downloadManager.$history,
      ...downloadManager.$backHistory,
    ];

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
                  context.l10n
                      .currently_downloading(downloadManager.$downloadCount),
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[400],
                ),
                onPressed: downloadManager.$downloadCount == 0
                    ? null
                    : downloadManager.cancelAll,
                child: Text(context.l10n.cancel_all),
              ),
            ],
          ),
        ),
        Expanded(
          child: SafeArea(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return DownloadItem(track: history[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
