import 'dart:io';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:spotube/utils/platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yt_dlp_dart/yt_dlp_dart.dart';

const engineDownloadUrls = {
  YoutubeClientEngine.ytDlp:
      "https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#installation",
};

class YouTubeEngineNotInstalledDialog extends HookConsumerWidget {
  final YoutubeClientEngine engine;
  const YouTubeEngineNotInstalledDialog({
    super.key,
    required this.engine,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = useShadcnTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    return AlertDialog(
      title: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(SpotubeIcons.error, color: Colors.red),
          Text(
            context.l10n.youtube_engine_not_installed_title(engine.label),
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              context.l10n.youtube_engine_not_installed_message(engine.label),
            ),
            if (engineDownloadUrls[engine] != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${context.l10n.download}:"),
                  Button.link(
                    child: Text(engineDownloadUrls[engine]!.split("?").first),
                    onPressed: () async {
                      launchUrl(Uri.parse(engineDownloadUrls[engine]!));
                    },
                  ),
                ],
              ),
            Text(context.l10n.youtube_engine_set_path(engine.label)),
            const Gap(8),
            FormBuilder(
              key: formKey,
              child: TextFormBuilderField(
                name: "path",
                controller: controller,
                placeholder: Text(switch (context.theme.platform) {
                  TargetPlatform.macOS => "e.g. /opt/homebrew/bin/yt-dlp",
                  TargetPlatform.windows =>
                    r"e.g. C:\Program Files\yt-dlp\yt-dlp.exe",
                  _ => "e.g. /home/user/.local/bin/yt-dlp",
                }),
              ),
            ),
            if (kIsMacOS || kIsLinux)
              Text(context.l10n.youtube_engine_unix_issue_message),
          ],
        ),
      ),
      actions: [
        Button.text(
          onPressed: () {
            if (!context.mounted) return;
            Navigator.of(context).pop(false);
          },
          child: Text(context.l10n.cancel),
        ),
        Button.secondary(
          onPressed: () async {
            if (controller.text.isNotEmpty) {
              if (!await File(controller.text).exists() && context.mounted) {
                formKey.currentState?.fields["path"]
                    ?.invalidate(context.l10n.file_not_found);
                return;
              }
              await KVStoreService.setYoutubeEnginePath(
                engine,
                controller.text,
              );
              if (engine == YoutubeClientEngine.ytDlp) {
                await YtDlp.instance.setBinaryLocation(controller.text);
              }
            }
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          },
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}
