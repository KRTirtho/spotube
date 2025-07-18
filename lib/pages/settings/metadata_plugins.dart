import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/metadata_plugins/installed_plugin.dart';
import 'package:spotube/modules/metadata_plugins/plugin_repository.dart';
import 'package:spotube/provider/metadata_plugin/core/repositories.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/utils/platform.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class SettingsMetadataProviderPage extends HookConsumerWidget {
  const SettingsMetadataProviderPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    final plugins = ref.watch(metadataPluginsProvider);
    final pluginsNotifier = ref.watch(metadataPluginsProvider.notifier);

    final pluginReposSnapshot = ref.watch(metadataPluginRepositoriesProvider);
    final pluginReposNotifier =
        ref.watch(metadataPluginRepositoriesProvider.notifier);

    final pluginRepos = useMemoized(
      () {
        final installedPluginIds = plugins.asData?.value.plugins
                .map((e) => e.repository)
                .nonNulls
                .toList() ??
            [];

        final pluginRepos = pluginReposSnapshot.asData?.value.items ?? [];
        if (installedPluginIds.isEmpty) return pluginRepos;
        return pluginRepos
            .whereNot((repo) => installedPluginIds.contains(repo.repoUrl))
            .toList();
      },
      [plugins.asData?.value.plugins, pluginReposSnapshot.asData?.value],
    );

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
            if (plugins.asData?.value.plugins.isNotEmpty ?? false)
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
                return MetadataInstalledPluginItem(
                  plugin: plugin,
                  isDefault: isDefault,
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
            SliverInfiniteList(
              isLoading: pluginReposSnapshot.isLoading &&
                  !pluginReposSnapshot.isLoadingNextPage,
              itemCount: pluginRepos.length,
              onFetchData: pluginReposNotifier.fetchMore,
              loadingBuilder: (context) {
                return Skeletonizer(
                  enabled: true,
                  child: MetadataPluginRepositoryItem(
                    pluginRepo: MetadataPluginRepository(
                      name: "Loading...",
                      description: "Loading...",
                      repoUrl: "",
                      owner: "",
                    ),
                  ),
                );
              },
              itemBuilder: (context, index) {
                final pluginRepo = pluginRepos[index];

                return MetadataPluginRepositoryItem(
                  pluginRepo: pluginRepo,
                );
              },
            ),
            SliverCrossAxisConstrained(
              maxCrossAxisExtent: 720,
              child: SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: SafeArea(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              const Icon(SpotubeIcons.warning, size: 16),
                              const Text(
                                "Disclaimer",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).bold,
                            ],
                          ),
                          const Text(
                            "The Spotube team does not hold any responsibility (including legal) for any \"Third-party\" plugins.\n"
                            "Please use them at your own risk. For any bugs/issues, please report them to the plugin repository."
                            "\n\n"
                            "If any \"Third-party\" plugin is breaking ToS/DMCA of any service/legal entity, "
                            "please ask the \"Third-party\" plugin author or the hosting platform .e.g GitHub/Codeberg to take action. "
                            "Above listed (\"Third-party\" labelled) are all public/community maintained plugins. We're not curating them, "
                            "so we cannot take any action on them.\n\n",
                          ).muted.xSmall,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
