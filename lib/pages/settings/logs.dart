import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/logs/logs_provider.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class LogsPage extends HookConsumerWidget {
  static const name = "logs";

  const LogsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();

    final logsQuery = ref.watch(logsProvider);

    return Scaffold(
      headers: [
        SafeArea(
          bottom: false,
          child: TitleBar(
            title: Text(context.l10n.logs),
            leading: const [BackButton()],
            trailing: [
              IconButton.ghost(
                icon: const Icon(SpotubeIcons.clipboard, size: 16),
                onPressed: () async {
                  final logsSnapshot = await ref.read(logsProvider.future);

                  await Clipboard.setData(ClipboardData(text: logsSnapshot));
                  if (context.mounted) {
                    showToast(
                      context: context,
                      location: ToastLocation.topRight,
                      builder: (context, overlay) {
                        return SurfaceCard(
                          child: Basic(
                            title: Text(context.l10n.copied_to_clipboard("")),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              IconButton.ghost(
                icon: const Icon(
                  SpotubeIcons.trash,
                  size: 16,
                ),
                onPressed: () async {
                  ref.invalidate(logsProvider);

                  final logsFile = await AppLogger.getLogsPath();

                  await logsFile.writeAsString("");
                },
              )
            ],
          ),
        )
      ],
      child: SafeArea(
        child: switch (logsQuery) {
          AsyncData(:final value) => InterScrollbar(
              controller: controller,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                controller: controller,
                child: Card(child: SelectableText(value)),
              ),
            ),
          AsyncError(:final error) => switch (error) {
              StateError() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Undraw(
                      illustration: UndrawIllustration.noData,
                      height: 200 * context.theme.scaling,
                      width: 200 * context.theme.scaling,
                      color: context.theme.colorScheme.primary,
                    ),
                    Text(context.l10n.no_logs_found).muted().small(),
                  ],
                ),
              _ => Center(child: Text(error.toString())),
            },
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
