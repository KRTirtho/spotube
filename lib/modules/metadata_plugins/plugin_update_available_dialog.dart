import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MetadataPluginUpdateAvailableDialog extends HookConsumerWidget {
  final PluginConfiguration plugin;
  final PluginUpdateAvailable update;
  const MetadataPluginUpdateAvailableDialog({
    super.key,
    required this.plugin,
    required this.update,
  });

  @override
  Widget build(BuildContext context, ref) {
    final isUpdating = useState(false);

    final showErrorSnackbar = useCallback(
      (BuildContext context, String message) {
        showToast(
            context: context,
            builder: (context, overlay) {
              return SurfaceCard(
                child: Basic(
                  leading: const Icon(SpotubeIcons.error, color: Colors.red),
                  title: Text(message),
                  leadingAlignment: Alignment.center,
                  trailing: IconButton.ghost(
                    size: ButtonSize.small,
                    icon: const Icon(SpotubeIcons.close),
                    onPressed: () {
                      overlay.close();
                    },
                  ),
                ),
              );
            });
      },
      [],
    );

    return AlertDialog(
      title: const Text('Plugin update available'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('${plugin.name} (${update.version}) available.'),
          if (update.changelog != null && update.changelog!.isNotEmpty)
            MarkdownBody(
              data: '### Changelog: \n\n${update.changelog}',
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrlString(href);
                }
              },
            ),
        ],
      ),
      actions: [
        SecondaryButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Dismiss'),
        ),
        PrimaryButton(
          enabled: !isUpdating.value,
          onPressed: () async {
            isUpdating.value = true;
            try {
              await ref
                  .read(metadataPluginsProvider.notifier)
                  .updatePlugin(plugin, update);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              if (context.mounted) {
                showErrorSnackbar(context, e.toString());
              }
            } finally {
              if (context.mounted) {
                isUpdating.value = false;
              }
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
