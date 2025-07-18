import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MetadataInstalledPluginItem extends HookConsumerWidget {
  final PluginConfiguration plugin;
  final bool isDefault;
  const MetadataInstalledPluginItem({
    super.key,
    required this.plugin,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context, ref) {
    final metadataPlugin = ref.watch(metadataPluginProvider);
    final isAuthenticated = ref.watch(metadataPluginAuthenticatedProvider);
    final pluginsNotifier = ref.watch(metadataPluginsProvider.notifier);
    final requiresAuth =
        isDefault && plugin.abilities.contains(PluginAbilities.authentication);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          FutureBuilder(
            future: pluginsNotifier.getLogoPath(plugin),
            builder: (context, snapshot) {
              final repoUrl = plugin.repository != null
                  ? Uri.tryParse(plugin.repository!)
                  : null;
              final repoOwner = repoUrl?.pathSegments.firstOrNull;

              final isOfficial =
                  repoUrl?.host == "github.com" && repoOwner == "KRTirtho";

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
                          color: context.theme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(SpotubeIcons.plugin),
                      ),
                title: Text(plugin.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(plugin.description),
                    if (repoUrl != null)
                      Row(
                        spacing: 8,
                        children: [
                          if (isOfficial)
                            const PrimaryBadge(
                              leading: Icon(SpotubeIcons.done),
                              child: Text("Official"),
                            )
                          else ...[
                            Text("Author: ${plugin.author}"),
                            const DestructiveBadge(
                              leading: Icon(SpotubeIcons.warning),
                              child: Text("Third-party"),
                            )
                          ],
                          SecondaryBadge(
                            leading: repoUrl.host == "github.com"
                                ? const Icon(SpotubeIcons.github)
                                : null,
                            child: Text(repoUrl.host),
                            onPressed: () {
                              launchUrl(repoUrl);
                            },
                          ),
                        ],
                      )
                  ],
                ),
                trailing: IconButton.ghost(
                  onPressed: () async {
                    await pluginsNotifier.removePlugin(plugin);
                  },
                  icon: const Icon(
                    SpotubeIcons.trash,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
          if (plugin.abilities.contains(PluginAbilities.authentication) &&
              isDefault)
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: const Row(
                spacing: 8,
                children: [
                  Icon(SpotubeIcons.warning, color: Colors.yellow),
                  Text("Plugin requires authentication"),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button.secondary(
                enabled: !isDefault,
                onPressed: () async {
                  await pluginsNotifier.setDefaultPlugin(plugin);
                },
                child: isDefault
                    ? const Text("Default")
                    : const Text("Set default"),
              ),
              if (isAuthenticated.asData?.value != true &&
                  requiresAuth &&
                  isDefault)
                Button.primary(
                  onPressed: () async {
                    await metadataPlugin.asData?.value?.auth.authenticate();
                  },
                  leading: const Icon(SpotubeIcons.login),
                  child: const Text("Login"),
                )
              else if (isAuthenticated.asData?.value == true &&
                  requiresAuth &&
                  isDefault)
                Button.destructive(
                  onPressed: () async {
                    await metadataPlugin.asData?.value?.auth.logout();
                  },
                  leading: const Icon(SpotubeIcons.logout),
                  child: const Text("Logout"),
                )
            ],
          )
        ],
      ),
    );
  }
}
