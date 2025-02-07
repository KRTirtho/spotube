import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/database/database.dart';
import 'package:url_launcher/url_launcher.dart';

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
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
        ],
      ),
      actions: [
        Button.secondary(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}
