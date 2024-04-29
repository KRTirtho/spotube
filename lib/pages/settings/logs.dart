import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/settings/section_card_with_heading.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/logger.dart';

class LogsPage extends HookWidget {
  static const name = "logs";

  const LogsPage({super.key});

  List<({DateTime? date, String body})> parseLogs(String raw) {
    return raw
        .split(
          "======================================================================",
        )
        .map(
          (line) {
            DateTime? date;
            line = line
                .replaceAll(
                  "============================== CATCHER LOG ==============================",
                  "",
                )
                .split("\n")
                .map((l) {
                  if (l.startsWith("Crash occurred on")) {
                    date = DateTime.parse(
                      l.split("Crash occurred on")[1].trim(),
                    );
                    return "";
                  }
                  return l;
                })
                .where((l) => l.replaceAll("\n", "").trim().isNotEmpty)
                .join("\n");

            return (
              date: date,
              body: line,
            );
          },
        )
        .where((e) => e.date != null && e.body.isNotEmpty)
        .toList()
      ..sort((a, b) => b.date!.compareTo(a.date!));
  }

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();
    final logs = useState<List<({DateTime? date, String body})>>([]);
    final rawLogs = useRef<String>("");
    final path = useRef<File?>(null);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 5), (t) async {
        path.value ??= await getLogsPath();
        final raw = await path.value!.readAsString();
        final hasChanged = rawLogs.value != raw;
        rawLogs.value = raw;
        if (hasChanged) logs.value = parseLogs(rawLogs.value);
      });

      return () {
        timer.cancel();
      };
    }, []);

    return Scaffold(
      appBar: PageWindowTitleBar(
        title: Text(context.l10n.logs),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(SpotubeIcons.clipboard),
            iconSize: 16,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: rawLogs.value));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.copied_to_clipboard("")),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: InterScrollbar(
          controller: controller,
          child: ListView.builder(
            controller: controller,
            itemCount: logs.value.length,
            itemBuilder: (context, index) {
              final log = logs.value[index];
              return Stack(
                children: [
                  SectionCardWithHeading(
                    heading: log.date.toString(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SelectableText(log.body),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(SpotubeIcons.clipboard),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: log.body),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.l10n.copied_to_clipboard(
                                  log.date.toString(),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
