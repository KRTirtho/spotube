import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MetadataPluginRepositoryItem extends HookConsumerWidget {
  final MetadataPluginRepository pluginRepo;
  const MetadataPluginRepositoryItem({
    super.key,
    required this.pluginRepo,
  });

  @override
  Widget build(BuildContext context, ref) {
    final pluginsNotifier = ref.watch(metadataPluginsProvider.notifier);
    final host = useMemoized(
      () => Uri.parse(pluginRepo.repoUrl).host,
      [pluginRepo.repoUrl],
    );
    final isInstalling = useState(false);

    return Card(
      child: Basic(
        title: Text(pluginRepo.name),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(pluginRepo.description),
            Row(
              spacing: 8,
              children: [
                if (pluginRepo.owner == "KRTirtho") ...[
                  const PrimaryBadge(
                    leading: Icon(SpotubeIcons.done),
                    child: Text("Official"),
                  ),
                  SecondaryBadge(
                    leading: host == "github.com"
                        ? const Icon(SpotubeIcons.github)
                        : null,
                    child: Text(host),
                    onPressed: () {
                      launchUrlString(pluginRepo.repoUrl);
                    },
                  ),
                ] else ...[
                  Text("Author: ${pluginRepo.owner}"),
                  const DestructiveBadge(
                    leading: Icon(SpotubeIcons.warning),
                    child: Text("Third-party"),
                  )
                ]
              ],
            ),
          ],
        ),
        trailing: Button.primary(
          enabled: !isInstalling.value,
          onPressed: () async {
            try {
              isInstalling.value = true;
              final pluginConfig = await pluginsNotifier
                  .downloadAndCachePlugin(pluginRepo.repoUrl);

              if (!context.mounted) return;
              final isOfficialPlugin = pluginRepo.owner == "KRTirtho";

              final isAllowed = isOfficialPlugin
                  ? true
                  : await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        final pluginAbilities = pluginConfig.apis
                            .map((e) => "- Can access **${e.name}** API")
                            .join("\n\n");

                        return AlertDialog(
                          title:
                              const Text("Do you want to install this plugin?"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "This plugin is from a third-party repository. "
                                "Please ensure you trust the source before installing.",
                              ),
                              const Gap(8),
                              FutureBuilder(
                                future:
                                    pluginsNotifier.getLogoPath(pluginConfig),
                                builder: (context, snapshot) {
                                  return Basic(
                                    leading: snapshot.hasData
                                        ? Image.file(
                                            snapshot.data!,
                                            width: 36,
                                            height: 36,
                                          )
                                        : Container(
                                            height: 36,
                                            width: 36,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: context
                                                  .theme.colorScheme.secondary,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child:
                                                const Icon(SpotubeIcons.plugin),
                                          ),
                                    title: Text(pluginConfig.name),
                                    subtitle: Text(pluginConfig.description),
                                  );
                                },
                              ),
                              const Gap(8),
                              MarkdownBody(
                                data: "**Author**: ${pluginConfig.author}\n\n"
                                    "**Repository**: [${pluginConfig.repository ?? 'N/A'}](${pluginConfig.repository})\n\n\n\n"
                                    "This plugin can do following:\n\n"
                                    "$pluginAbilities",
                                onTapLink: (text, href, title) {
                                  if (href != null) {
                                    launchUrlString(href);
                                  }
                                },
                              ),
                            ],
                          ),
                          actions: [
                            Button.secondary(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text("Deny"),
                            ),
                            Button.primary(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Allow"),
                            ),
                          ],
                        );
                      },
                    );

              if (isAllowed != true) return;
              await pluginsNotifier.addPlugin(pluginConfig);
            } finally {
              if (context.mounted) {
                isInstalling.value = false;
              }
            }
          },
          leading: isInstalling.value
              ? const CircularProgressIndicator()
              : const Icon(SpotubeIcons.add),
          child: const Text("Install"),
        ),
      ),
    );
  }
}
