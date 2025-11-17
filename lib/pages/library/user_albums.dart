import 'package:flutter/material.dart' as material;
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/fallbacks/error_box.dart';
import 'package:spotube/components/fallbacks/no_default_metadata_plugin.dart';
import 'package:spotube/components/playbutton_view/playbutton_view.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/fallbacks/anonymous_fallback.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/library/albums.dart';
import 'package:auto_route/auto_route.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';

@RoutePage()
class UserAlbumsPage extends HookConsumerWidget {
  static const name = 'user_albums';
  const UserAlbumsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authenticated = ref.watch(metadataPluginAuthenticatedProvider);
    final albumsQuery = ref.watch(metadataPluginSavedAlbumsProvider);
    final albumsQueryNotifier =
        ref.watch(metadataPluginSavedAlbumsProvider.notifier);

    final controller = useScrollController();

    final searchText = useState('');

    final albums = useMemoized(() {
      if (searchText.value.isEmpty) {
        return albumsQuery.asData?.value.items ?? [];
      }
      return albumsQuery.asData?.value.items
              .map((e) => (
                    weightedRatio(e.name, searchText.value),
                    e,
                  ))
              .sorted((a, b) => b.$1.compareTo(a.$1))
              .where((e) => e.$1 > 50)
              .map((e) => e.$2)
              .toList() ??
          [];
    }, [albumsQuery.asData?.value, searchText.value]);

    if (albumsQuery.error
        case MetadataPluginException(
          errorCode: MetadataPluginErrorCode.noDefaultMetadataPlugin,
          message: _,
        )) {
      return const Center(child: NoDefaultMetadataPlugin());
    }

    if (authenticated.asData?.value != true) {
      return const AnonymousFallback();
    }

    if (albumsQuery.hasError) {
      return ErrorBox(
        error: albumsQuery.error!,
        onRetry: () {
          ref.invalidate(metadataPluginSavedAlbumsProvider);
        },
      );
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        child: material.RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(metadataPluginSavedAlbumsProvider);
          },
          child: InterScrollbar(
            controller: controller,
            child: CustomScrollView(
              controller: controller,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  floating: true,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 48,
                      child: TextField(
                        onChanged: (value) => searchText.value = value,
                        features: const [
                          InputFeature.leading(Icon(SpotubeIcons.filter))
                        ],
                        placeholder: Text(context.l10n.filter_albums),
                      ),
                    ),
                  ),
                ),
                const SliverGap(10),
                if (albums.isEmpty &&
                    !albumsQuery.isLoading &&
                    searchText.value.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    sliver: SliverToBoxAdapter(
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
                            context.l10n.no_favorite_albums_yet,
                            textAlign: TextAlign.center,
                          ).muted().small()
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    sliver: PlaybuttonView(
                      controller: controller,
                      itemCount: albums.length,
                      hasMore: albumsQuery.asData?.value.hasMore == true,
                      isLoading: albumsQuery.isLoading,
                      onRequestMore: albumsQueryNotifier.fetchMore,
                      gridItemBuilder: (context, index) => AlbumCard(
                        albums[index],
                      ),
                      listItemBuilder: (context, index) =>
                          AlbumCard.tile(albums[index]),
                    ),
                  ),
                const SliverSafeArea(sliver: SliverGap(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
