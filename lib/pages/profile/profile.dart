import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  static const name = "profile";

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final me = ref.watch(metadataPluginUserProvider);
    final meData = me.asData?.value ?? FakeData.user;

    // final userProperties = useMemoized(
    //   () => {
    //     context.l10n.email: meData.email ?? "N/A",
    //     context.l10n.profile_followers:
    //         meData.followers?.total.toString() ?? "N/A",
    //     context.l10n.birthday: meData.birthdate ?? context.l10n.not_born,
    //     context.l10n.country: markets
    //         .firstWhere((market) => market.$1 == meData.country)
    //         .$2,
    //     context.l10n.subscription: meData.product ?? context.l10n.hacker,
    //   },
    //   [meData],
    // );

    return SafeArea(
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.profile),
          )
        ],
        child: Skeletonizer(
          enabled: me.isLoading,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(600),
                      child: UniversalImage(
                        path: meData.images.asUrlString(
                          index: 1,
                          placeholder: ImagePlaceholder.artist,
                        ),
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SliverGap(10),
              SliverToBoxAdapter(
                child: Text(
                  meData.name,
                  textAlign: TextAlign.center,
                ).h4(),
              ),
              const SliverGap(20),
              SliverCrossAxisConstrained(
                maxCrossAxisExtent: 500,
                child: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button.text(
                        leading: const Icon(SpotubeIcons.edit),
                        onPressed: () {
                          launchUrlString(
                            meData.externalUri,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Text(context.l10n.edit),
                      ),
                    ],
                  ),
                ),
              ),
              // SliverCrossAxisConstrained(
              //   maxCrossAxisExtent: 500,
              //   child: SliverToBoxAdapter(
              //     child: Card(
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Table(
              //           columnWidths: const {
              //             0: FixedTableSize(120),
              //           },
              //           defaultRowHeight: const FixedTableSize(40),
              //           rows: [
              //             for (final MapEntry(:key, :value)
              //                 in userProperties.entries)
              //               TableRow(
              //                 cells: [
              //                   TableCell(
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(6),
              //                       child: Text(key).large(),
              //                     ),
              //                   ),
              //                   TableCell(
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(6),
              //                       child: Text(value),
              //                     ),
              //                   ),
              //                 ],
              //               )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SliverGap(200),
            ],
          ),
        ),
      ),
    );
  }
}
