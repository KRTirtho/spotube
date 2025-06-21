import 'package:auto_route/auto_route.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/auth.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spotube/utils/platform.dart';

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
            const SliverGap(20),
            SliverList.separated(
              itemCount: plugins.asData?.value.plugins.length ?? 0,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final plugin = plugins.asData!.value.plugins[index];
                final isDefault = plugins.asData!.value.defaultPlugin == index;
                final requiresAuth = isDefault &&
                    plugin.abilities.contains(PluginAbilities.authentication);
                return Card(
                  child: Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Basic(
                        title: Text(plugin.name),
                        subtitle: Text(plugin.description),
                        trailing: Row(
                          spacing: 8,
                          children: [
                            Button.primary(
                              enabled: !isDefault,
                              onPressed: () async {
                                await pluginsNotifier.setDefaultPlugin(plugin);
                              },
                              child: isDefault
                                  ? const Text("Default")
                                  : const Text("Make default"),
                            ),
                            IconButton.destructive(
                              onPressed: () async {
                                await pluginsNotifier.removePlugin(plugin);
                              },
                              icon: const Icon(SpotubeIcons.trash),
                            ),
                          ],
                        ),
                      ),
                      if (requiresAuth)
                        Row(
                          children: [
                            const Text("Plugin requires authentication"),
                            const Spacer(),
                            if (isAuthenticated.asData?.value != true)
                              Button.primary(
                                onPressed: () async {
                                  await metadataPlugin.asData?.value?.auth
                                      .authenticate();
                                },
                                leading: const Icon(SpotubeIcons.login),
                                child: const Text("Login"),
                              )
                            else
                              Button.destructive(
                                onPressed: () async {
                                  await metadataPlugin.asData?.value?.auth
                                      .logout();
                                },
                                leading: const Icon(SpotubeIcons.logout),
                                child: const Text("Logout"),
                              ),
                          ],
                        )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
