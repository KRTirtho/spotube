import 'package:flutter/material.dart' as material;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/fallbacks/error_box.dart';
import 'package:spotube/components/fallbacks/no_default_metadata_plugin.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/waypoint.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/library/artists.dart';
import 'package:auto_route/auto_route.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';

@RoutePage()
class UserArtistsPage extends HookConsumerWidget {
  static const name = 'user_artists';
  const UserArtistsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authenticated = ref.watch(metadataPluginAuthenticatedProvider);

    final artistQuery = ref.watch(metadataPluginSavedArtistsProvider);
    final artistQueryNotifier =
        ref.watch(metadataPluginSavedArtistsProvider.notifier);

    final searchText = useState('');

    final filteredArtists = useMemoized(() {
      final artists = artistQuery.asData?.value.items ?? [];

      if (searchText.value.isEmpty) {
        return artists.toList();
      }
      return artists
          .map((e) => (
                weightedRatio(e.name, searchText.value),
                e,
              ))
          .sorted((a, b) => b.$1.compareTo(a.$1))
          .where((e) => e.$1 > 50)
          .map((e) => e.$2)
          .toList();
    }, [artistQuery.asData?.value.items, searchText.value]);

    final controller = useScrollController();

    if (artistQuery.error
        case MetadataPluginException(
          errorCode: MetadataPluginErrorCode.noDefaultMetadataPlugin,
          message: _,
        )) {
      return const Center(child: NoDefaultMetadataPlugin());
    }

    if (authenticated.asData?.value != true) {
      return const AnonymousFallback();
    }

    if (artistQuery.hasError) {
      return ErrorBox(
        error: artistQuery.error!,
        onRetry: () {
          ref.invalidate(metadataPluginSavedArtistsProvider);
        },
      );
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        child: material.RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(metadataPluginSavedArtistsProvider);
          },
          child: InterScrollbar(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    floating: true,
                    flexibleSpace: SizedBox(
                      height: 48,
                      child: TextField(
                        onChanged: (value) => searchText.value = value,
                        features: const [
                          InputFeature.leading(Icon(SpotubeIcons.filter)),
                        ],
                        placeholder: Text(context.l10n.filter_artist),
                      ),
                    ),
                  ),
                  const SliverGap(10),
                  if (filteredArtists.isNotEmpty || artistQuery.isLoading)
                    SliverLayoutBuilder(builder: (context, constrains) {
                      return SliverGrid.builder(
                        itemCount: filteredArtists.length + 1,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisExtent: constrains.smAndDown ? 225 : 250,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          if (filteredArtists.isNotEmpty &&
                              index == filteredArtists.length) {
                            if (artistQuery.asData?.value.hasMore != true) {
                              return const SizedBox.shrink();
                            }

                            return Waypoint(
                              controller: controller,
                              isGrid: true,
                              onTouchEdge: artistQueryNotifier.fetchMore,
                              child: Skeletonizer(
                                enabled: true,
                                child: ArtistCard(FakeData.artist),
                              ),
                            );
                          }

                          return Skeletonizer(
                            enabled: artistQuery.isLoading,
                            child: ArtistCard(
                              filteredArtists.elementAtOrNull(index) ??
                                  FakeData.artist,
                            ),
                          );
                        },
                      );
                    })
                  else if (filteredArtists.isEmpty &&
                      searchText.value.isEmpty &&
                      !artistQuery.isLoading)
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Undraw(
                            height: 200 * context.theme.scaling,
                            illustration: UndrawIllustration.followMeDrone,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            context.l10n.not_following_artists,
                            textAlign: TextAlign.center,
                          ).muted().small()
                        ],
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Undraw(
                            height: 200 * context.theme.scaling,
                            illustration: UndrawIllustration.taken,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            context.l10n.nothing_found,
                            textAlign: TextAlign.center,
                          ).muted().small()
                        ],
                      ),
                    ),
                  const SliverSafeArea(sliver: SliverGap(10)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
