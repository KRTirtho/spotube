import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfilePage extends HookConsumerWidget {
  static const name = "profile";

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme) = Theme.of(context);

    final me = ref.watch(meProvider);
    final meData = me.asData?.value ?? FakeData.user;

    final userProperties = useMemoized(
      () => {
        context.l10n.email: meData.email ?? "N/A",
        context.l10n.profile_followers:
            meData.followers?.total.toString() ?? "N/A",
        context.l10n.birthday: meData.birthdate ?? context.l10n.not_born,
        context.l10n.country: spotifyMarkets
            .firstWhere((market) => market.$1 == meData.country)
            .$2,
        context.l10n.subscription: meData.product ?? context.l10n.hacker,
      },
      [meData],
    );

    return SafeArea(
      child: Scaffold(
        appBar: PageWindowTitleBar(
          title: Text(context.l10n.profile),
          titleSpacing: 0,
          automaticallyImplyLeading: true,
          centerTitle: false,
        ),
        body: Skeletonizer(
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
                  meData.displayName ?? context.l10n.no_name,
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SliverGap(20),
              SliverCrossAxisConstrained(
                maxCrossAxisExtent: 500,
                child: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        label: Text(context.l10n.edit),
                        icon: const Icon(SpotubeIcons.edit),
                        onPressed: () {
                          launchUrlString(
                            "https://www.spotify.com/account/profile/",
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverCrossAxisConstrained(
                maxCrossAxisExtent: 500,
                child: SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(110),
                        },
                        children: [
                          for (final MapEntry(:key, :value)
                              in userProperties.entries)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      key,
                                      style: textTheme.titleSmall,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(value),
                                  ),
                                ),
                              ],
                            )
                        ],
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
