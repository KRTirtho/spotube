import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/logs/logs_provider.dart';
import 'package:spotube/services/logger/logger.dart';

class LogsPage extends HookConsumerWidget {
  static const name = "logs";

  const LogsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();

    final logsQuery = ref.watch(logsProvider);

    return Scaffold(
      appBar: PageWindowTitleBar(
        title: Text(context.l10n.logs),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(SpotubeIcons.clipboard),
            iconSize: 16,
            onPressed: () async {
              final logsSnapshot = await ref.read(logsProvider.future);

              await Clipboard.setData(ClipboardData(text: logsSnapshot));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.copied_to_clipboard("")),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(SpotubeIcons.trash),
            iconSize: 16,
            onPressed: () async {
              ref.invalidate(logsProvider);

              final logsFile = await AppLogger.getLogsPath();

              await logsFile.writeAsString("");
            },
          )
        ],
      ),
      body: SafeArea(
        child: switch (logsQuery) {
          AsyncData(:final value) => Card(
              child: InterScrollbar(
                controller: controller,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Text(value),
                  ),
                ),
              ),
            ),
          AsyncError(:final error) => Center(child: Text(error.toString())),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
