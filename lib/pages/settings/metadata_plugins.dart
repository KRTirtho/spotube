import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/metadata_plugins/installed_plugin.dart';
import 'package:spotube/modules/metadata_plugins/plugin_repository.dart';
import 'package:spotube/provider/metadata_plugin/core/repositories.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/platform.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class SettingsMetadataProviderPage extends HookConsumerWidget {
  const SettingsMetadataProviderPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tabState = useState<int>(0);
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
        final availablePlugins = pluginRepos
            .whereNot((repo) => installedPluginIds.contains(repo.repoUrl))
            .toList();

        if (tabState.value != 0) {
          // metadata only plugins
          return availablePlugins.where(
            (d) {
              return d.topics.contains(
                tabState.value == 1
                    ? "spotube-metadata-plugin"
                    : "spotube-audio-source-plugin",
              );
            },
          ).toList();
        }

        return availablePlugins; // all plugins
      },
      [
        plugins.asData?.value.plugins,
        pluginReposSnapshot.asData?.value,
        tabState.value,
      ],
    );

    final installedPlugins = useMemoized<List<PluginConfiguration>?>(() {
      if (tabState.value == 0) return plugins.asData?.value.plugins;

      return plugins.asData?.value.plugins.where((d) {
        return d.abilities.contains(
          tabState.value == 1
              ? PluginAbilities.metadata
              : PluginAbilities.audioSource,
        );
      }).toList();
    }, [tabState.value, plugins.asData?.value]);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.plugins),
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
                          placeholder:
                              Text(context.l10n.paste_plugin_download_url),
                        ),
                      ),
                    ),
                    HookBuilder(builder: (context) {
                      final isLoading = useState(false);

                      return Tooltip(
                        tooltip: TooltipContainer(
                          child: Text(context
                              .l10n.download_and_install_plugin_from_url),
                        ).call,
                        child: IconButton.secondary(
                          icon: isLoading.value
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(SpotubeIcons.download),
                          enabled: !isLoading.value,
                          onPressed: () async {
                            try {
                              if (formKey.currentState?.saveAndValidate() ??
                                  false) {
                                final url = formKey.currentState
                                    ?.fields["plugin_url"]?.value as String;

                                if (url.isNotEmpty) {
                                  isLoading.value = true;
                                  final pluginConfig = await pluginsNotifier
                                      .downloadAndCachePlugin(url);

                                  await pluginsNotifier.addPlugin(pluginConfig);

                                  formKey.currentState?.fields["plugin_url"]
                                      ?.reset();
                                }
                              }
                            } catch (e, stackTrace) {
                              AppLogger.reportError(e, stackTrace);
                              if (context.mounted) {
                                showToast(
                                  showDuration: const Duration(seconds: 5),
                                  context: context,
                                  builder: (context, overlay) {
                                    return SurfaceCard(
                                      child: Basic(
                                        leading: const Icon(
                                          SpotubeIcons.error,
                                          color: Colors.red,
                                        ),
                                        title: Text(
                                          context.l10n
                                              .failed_to_add_plugin_error(
                                                  e.toString()),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } finally {
                              isLoading.value = false;
                            }
                          },
                        ),
                      );
                    }),
                    Tooltip(
                      tooltip: TooltipContainer(
                        child: Text(context.l10n.upload_plugin_from_file),
                      ).call,
                      child: IconButton.primary(
                        icon: const Icon(SpotubeIcons.upload),
                        onPressed: () async {
                          Uint8List bytes;

                          if (kIsFlatpak) {
                            final result = await openFile(
                              acceptedTypeGroups: [
                                const XTypeGroup(
                                  label: 'Spotube Metadata Plugin',
                                  extensions: ['smplug'],
                                ),
                              ],
                            );
                            if (result == null) return;
                            bytes = await result.readAsBytes();
                          } else {
                            final result = await FilePicker.platform.pickFiles(
                              type: kIsAndroid ? FileType.any : FileType.custom,
                              allowedExtensions: kIsAndroid ? [] : ["smplug"],
                              withData: true,
                            );

                            if (result == null) return;

                            final file = result.files.first;
                            if (file.bytes == null) return;
                            bytes = file.bytes!;
                          }

                          final pluginConfig =
                              await pluginsNotifier.extractPluginArchive(bytes);
                          await pluginsNotifier.addPlugin(pluginConfig);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SliverGap(12),
              SliverToBoxAdapter(
                child: TabList(
                  index: tabState.value,
                  onChanged: (value) {
                    tabState.value = value;
                  },
                  children: const [
                    TabItem(child: Text("All")),
                    TabItem(child: Text("Metadata")),
                    TabItem(child: Text("Audio Source")),
                  ],
                ),
              ),
              const SliverGap(12),
              if (plugins.asData?.value.plugins.isNotEmpty ?? false)
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Gap(8),
                      Text(context.l10n.installed).h4,
                      const Gap(8),
                      const Expanded(child: Divider()),
                      const Gap(8),
                    ],
                  ),
                ),
              const SliverGap(20),
              SliverList.separated(
                itemCount: installedPlugins?.length ?? 0,
                separatorBuilder: (context, index) => const Gap(12),
                itemBuilder: (context, index) {
                  final plugin = installedPlugins![index];
                  final isDefaultMetadata =
                      plugins.asData!.value.defaultMetadataPluginConfig?.slug ==
                          plugin.slug;
                  final isDefaultAudioSource = plugins
                          .asData!.value.defaultAudioSourcePluginConfig?.slug ==
                      plugin.slug;
                  return MetadataInstalledPluginItem(
                    plugin: plugin,
                    isDefaultMetadata: isDefaultMetadata,
                    isDefaultAudioSource: isDefaultAudioSource,
                  );
                },
              ),
              const SliverGap(12),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Gap(8),
                    Text(context.l10n.available_plugins).h4,
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
                separatorBuilder: (context, index) {
                  return const Gap(12);
                },
                loadingBuilder: (context) {
                  return Skeletonizer(
                    enabled: true,
                    child: MetadataPluginRepositoryItem(
                      pluginRepo: MetadataPluginRepository(
                        name: "Loading...",
                        description: "Loading...",
                        repoUrl: "",
                        owner: "",
                        topics: [],
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
              const SliverGap(20),
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
                                Text(
                                  context.l10n.disclaimer,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ).bold,
                              ],
                            ),
                            Text(context.l10n.third_party_plugin_dmca_notice)
                                .muted
                                .xSmall,
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
      ),
    );
  }
}
