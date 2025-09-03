import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/markdown/markdown.dart';
import 'package:spotube/extensions/context.dart';
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
        title: Text(
            "${pluginRepo.owner == "KRTirtho" ? "" : "${pluginRepo.owner}/"}${pluginRepo.name}"),
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
                  PrimaryBadge(
                    leading: Icon(SpotubeIcons.done),
                    child: Text(context.l10n.official),
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
                  Text(context.l10n.author_name(pluginRepo.owner)),
                  DestructiveBadge(
                    leading: const Icon(SpotubeIcons.warning),
                    child: Text(context.l10n.third_party),
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
                            .map(
                                (e) => context.l10n.can_access_name_api(e.name))
                            .join("\n\n");

                        return AlertDialog(
                          title: Text(
                              context.l10n.do_you_want_to_install_this_plugin),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.l10n.third_party_plugin_warning),
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
                              AppMarkdown(
                                data:
                                    "**${context.l10n.author}**: ${pluginConfig.author}\n\n"
                                    "**${context.l10n.repository}**: [${pluginConfig.repository ?? 'N/A'}](${pluginConfig.repository})\n\n\n\n"
                                    "${context.l10n.this_plugin_can_do_following}:\n\n"
                                    "$pluginAbilities",
                              ),
                            ],
                          ),
                          actions: [
                            Button.secondary(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(context.l10n.decline),
                            ),
                            Button.primary(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(context.l10n.accept),
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
          child: Text(context.l10n.install),
        ),
      ),
    );
  }
}
