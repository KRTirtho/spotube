import 'package:auto_route/auto_route.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/core/repositories.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/utils/platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

@RoutePage()
class SettingsMetadataProviderPage extends HookConsumerWidget {
  const SettingsMetadataProviderPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    final plugins = ref.watch(metadataPluginsProvider);
    final pluginsNotifier = ref.watch(metadataPluginsProvider.notifier);
    final metadataPlugin = ref.watch(metadataPluginProvider);
    final isAuthenticated = ref.watch(metadataPluginAuthenticatedProvider);

    final pluginReposSnapshot = ref.watch(metadataPluginRepositoriesProvider);
    final pluginReposNotifier =
        ref.watch(metadataPluginRepositoriesProvider.notifier);
    final pluginRepos = pluginReposSnapshot.asData?.value.items ?? [];

    return Scaffold(
      headers: const [
        TitleBar(
          title: Text("Metadata provider plugin"),
        )
      ],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: FormBuilder(
                      key: formKey,
                      child: TextFormBuilderField(
                        name: "plugin_url",
                        validator: FormBuilderValidators.url(
                            protocols: ["http", "https"]),
                        placeholder: const Text(
                          "Add GitHub/Codeberg URL to plugin repository "
                          "or direct link to .smplug file",
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    tooltip: const TooltipContainer(
                      child: Text("Download and install plugin from url"),
                    ).call,
                    child: IconButton.secondary(
                      icon: const Icon(SpotubeIcons.download),
                      onPressed: () async {
                        if (formKey.currentState?.saveAndValidate() ?? false) {
                          final url = formKey.currentState?.fields["plugin_url"]
                              ?.value as String;

                          if (url.isNotEmpty) {
                            final pluginConfig = await pluginsNotifier
                                .downloadAndCachePlugin(url);

                            await pluginsNotifier.addPlugin(pluginConfig);
                          }
                        }
                      },
                    ),
                  ),
                  Tooltip(
                    tooltip: const TooltipContainer(
                      child: Text("Upload plugin from file"),
                    ).call,
                    child: IconButton.primary(
                      icon: const Icon(SpotubeIcons.upload),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: kIsAndroid ? FileType.any : FileType.custom,
                          allowedExtensions: kIsAndroid ? [] : ["smplug"],
                          withData: true,
                        );

                        if (result == null) return;

                        final file = result.files.first;

                        if (file.bytes == null) return;

                        final pluginConfig = await pluginsNotifier
                            .extractPluginArchive(file.bytes!);
                        await pluginsNotifier.addPlugin(pluginConfig);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SliverGap(12),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  const Gap(8),
                  const Text("Installed").h4,
                  const Gap(8),
                  const Expanded(child: Divider()),
                  const Gap(8),
                ],
              ),
            ),
            const SliverGap(20),
            SliverList.separated(
              itemCount: plugins.asData?.value.plugins.length ?? 0,
              separatorBuilder: (context, index) => const Gap(12),
              itemBuilder: (context, index) {
                final plugin = plugins.asData!.value.plugins[index];
                final isDefault = plugins.asData!.value.defaultPlugin == index;
                final requiresAuth = isDefault &&
                    plugin.abilities.contains(PluginAbilities.authentication);

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      FutureBuilder(
                        future: pluginsNotifier.getLogoPath(plugin),
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
                                      color:
                                          context.theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(SpotubeIcons.plugin),
                                  ),
                            title: Text(plugin.name),
                            subtitle: Text(plugin.description),
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
                      if (plugin.abilities
                              .contains(PluginAbilities.authentication) &&
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
                                await metadataPlugin.asData?.value?.auth
                                    .authenticate();
                              },
                              leading: const Icon(SpotubeIcons.login),
                              child: const Text("Login"),
                            )
                          else if (isAuthenticated.asData?.value == true &&
                              requiresAuth &&
                              isDefault)
                            Button.destructive(
                              onPressed: () async {
                                await metadataPlugin.asData?.value?.auth
                                    .logout();
                              },
                              leading: const Icon(SpotubeIcons.logout),
                              child: const Text("Logout"),
                            )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            const SliverGap(12),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  const Gap(8),
                  const Text("Available plugins").h4,
                  const Gap(8),
                  const Expanded(child: Divider()),
                  const Gap(8),
                ],
              ),
            ),
            const SliverGap(12),
            Skeletonizer.sliver(
              enabled: pluginReposSnapshot.isLoading,
              child: SliverInfiniteList(
                isLoading: pluginReposSnapshot.isLoading &&
                    !pluginReposSnapshot.isLoadingNextPage,
                itemCount: pluginRepos.length,
                onFetchData: pluginReposNotifier.fetchMore,
                itemBuilder: (context, index) {
                  final pluginRepo = pluginRepos[index];
                  final host = Uri.parse(pluginRepo.repoUrl).host;

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
                        onPressed: () async {
                          final pluginConfig = await pluginsNotifier
                              .downloadAndCachePlugin(pluginRepo.repoUrl);

                          await pluginsNotifier.addPlugin(pluginConfig);
                        },
                        leading: const Icon(SpotubeIcons.add),
                        child: const Text("Install"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
