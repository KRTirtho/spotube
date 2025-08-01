import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/markdown/markdown.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/metadata_plugins/plugin_update_available_dialog.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/core/support.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/updater/update_checker.dart';
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
    final isAuthenticatedSnapshot =
        ref.watch(metadataPluginAuthenticatedProvider);
    final pluginsNotifier = ref.watch(metadataPluginsProvider.notifier);
    final requiresAuth =
        isDefault && plugin.abilities.contains(PluginAbilities.authentication);
    final supportsScrobbling =
        isDefault && plugin.abilities.contains(PluginAbilities.scrobbling);
    final isAuthenticated = isAuthenticatedSnapshot.asData?.value == true;
    final updateAvailable =
        isDefault ? ref.watch(metadataPluginUpdateCheckerProvider) : null;
    final hasUpdate = isDefault && updateAvailable?.asData?.value != null;

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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
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
                            leading: const Icon(SpotubeIcons.connect),
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
          if ((requiresAuth && !isAuthenticated) ||
              hasUpdate ||
              supportsScrobbling)
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 12,
                children: [
                  if (requiresAuth && !isAuthenticated)
                    const Row(
                      spacing: 8,
                      children: [
                        Icon(SpotubeIcons.warning, color: Colors.yellow),
                        Text("Plugin requires authentication"),
                      ],
                    ),
                  if (hasUpdate)
                    SizedBox(
                      width: double.infinity,
                      child: Basic(
                        leading: const Icon(SpotubeIcons.update),
                        title: const Text("Update available"),
                        subtitle: Text(
                          updateAvailable!.asData!.value!.version,
                        ),
                        trailing: Button.primary(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  MetadataPluginUpdateAvailableDialog(
                                plugin: plugin,
                                update: updateAvailable.asData!.value!,
                              ),
                            );
                          },
                          child: const Text("Update"),
                        ),
                      ),
                    ),
                  if (supportsScrobbling)
                    const SizedBox(
                      width: double.infinity,
                      child: Basic(
                        leading: Icon(SpotubeIcons.info),
                        title: Text("Supports scrobbling"),
                        subtitle: Text(
                          "This plugin scrobbles your music to generate your listening history.",
                        ),
                      ),
                    )
                ],
              ),
            ),
          Row(
            spacing: 8,
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
              if (isDefault)
                Consumer(builder: (context, ref, _) {
                  final supportTextSnapshot =
                      ref.watch(metadataPluginSupportTextProvider);

                  if (supportTextSnapshot.hasValue &&
                      supportTextSnapshot.value == null) {
                    return const SizedBox.shrink();
                  }

                  final bgColor = context.theme.brightness == Brightness.dark
                      ? const Color.fromARGB(255, 255, 145, 175)
                      : Colors.pink[600];
                  final textColor = context.theme.brightness == Brightness.dark
                      ? Colors.pink[700]
                      : Colors.pink[50];

                  final mediaQuery = MediaQuery.sizeOf(context);

                  return Button(
                    style: ButtonVariance.secondary.copyWith(
                      decoration: (context, states, value) {
                        return value.copyWithIfBoxDecoration(
                          color: bgColor,
                        );
                      },
                      textStyle: (context, states, value) {
                        return value.copyWith(
                          color: textColor,
                        );
                      },
                      iconTheme: (context, states, value) {
                        return value.copyWith(
                          color: textColor,
                        );
                      },
                    ),
                    leading: const Icon(SpotubeIcons.heartFilled),
                    child: const Text("Support"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Support plugin development"),
                            content: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: mediaQuery.height * 0.8,
                                maxWidth: 720,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: AppMarkdown(
                                    data: supportTextSnapshot.value ?? "",
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              Button.secondary(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }),
              const Spacer(),
              if (isDefault && requiresAuth && !isAuthenticated)
                Button.primary(
                  onPressed: () async {
                    await metadataPlugin.asData?.value?.auth.authenticate();
                  },
                  leading: const Icon(SpotubeIcons.login),
                  child: const Text("Login"),
                )
              else if (isDefault && requiresAuth && isAuthenticated)
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
