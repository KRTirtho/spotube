import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/hyper_link.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_package_info.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_route/auto_route.dart';

final _licenseProvider = FutureProvider<String>((ref) async {
  return await rootBundle.loadString("LICENSE");
});

@RoutePage()
class AboutSpotubePage extends HookConsumerWidget {
  static const name = "about";

  const AboutSpotubePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final packageInfo = usePackageInfo();
    final license = ref.watch(_licenseProvider);
    final theme = Theme.of(context);

    const colon = TableCell(child: Text(":"));

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            leading: const [BackButton()],
            title: Text(context.l10n.about_spotube),
          )
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Assets.branding.spotubeLogoPng.image(
                  height: 200,
                  width: 200,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(context.l10n.spotube_description).semiBold().large(),
                      const SizedBox(height: 20),
                      Table(
                        columnWidths: const {
                          0: FixedTableSize(95),
                          1: FixedTableSize(10),
                          2: IntrinsicTableSize(),
                        },
                        defaultRowHeight: const FixedTableSize(40),
                        rows: [
                          TableRow(
                            cells: [
                              TableCell(child: Text(context.l10n.founder)),
                              colon,
                              TableCell(
                                child: Hyperlink(
                                  context.l10n.kingkor_roy_tirtho,
                                  "https://github.com/KRTirtho",
                                ),
                              )
                            ],
                          ),
                          TableRow(
                            cells: [
                              TableCell(child: Text(context.l10n.version)),
                              colon,
                              TableCell(child: Text("v${packageInfo.version}"))
                            ],
                          ),
                          TableRow(
                            cells: [
                              TableCell(child: Text(context.l10n.channel)),
                              colon,
                              TableCell(child: Text(Env.releaseChannel.name))
                            ],
                          ),
                          TableRow(
                            cells: [
                              TableCell(child: Text(context.l10n.build_number)),
                              colon,
                              TableCell(
                                child: Text(packageInfo.buildNumber
                                    .replaceAll(".", " ")),
                              )
                            ],
                          ),
                          const TableRow(
                            cells: [
                              TableCell(child: Text("Website")),
                              colon,
                              TableCell(
                                child: Hyperlink(
                                  "spotube.krtirtho.dev",
                                  "https://spotube.krtirtho.dev",
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            cells: [
                              TableCell(child: Text(context.l10n.repository)),
                              colon,
                              const TableCell(
                                child: Hyperlink(
                                  "github.com/KRTirtho/spotube",
                                  "https://github.com/KRTirtho/spotube",
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            cells: [
                              TableCell(child: Text(context.l10n.license)),
                              colon,
                              const TableCell(
                                child: Hyperlink(
                                  "BSD-4-Clause",
                                  "https://raw.githubusercontent.com/KRTirtho/spotube/master/LICENSE",
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            cells: [
                              TableCell(child: Text(context.l10n.bug_issues)),
                              colon,
                              const TableCell(
                                child: Hyperlink(
                                  "Discord#chat",
                                  "https://discord.gg/uJ94vxB6vg",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse("https://discord.gg/uJ94vxB6vg"),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: const UniversalImage(
                      path:
                          "https://discord.com/api/guilds/1012234096237350943/widget.png?style=banner2",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.l10n.made_with,
                  textAlign: TextAlign.center,
                  style: theme.typography.small,
                ),
                Text(
                  context.l10n.copyright(DateTime.now().year),
                  textAlign: TextAlign.center,
                  style: theme.typography.small,
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 750),
                  child: SafeArea(
                    child: license.when(
                      data: (data) {
                        return Text(
                          data,
                          style: theme.typography.small,
                        );
                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      error: (e, s) {
                        return Text(
                          e.toString(),
                          style: theme.typography.small,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
