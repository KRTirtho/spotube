import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/artist/albums.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';

class ArtistAlbumList extends HookConsumerWidget {
  final String artistId;

  const ArtistAlbumList(
    this.artistId, {
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final albumsQuery = ref.watch(metadataPluginArtistAlbumsProvider(artistId));
    final albumsQueryNotifier =
        ref.watch(metadataPluginArtistAlbumsProvider(artistId).notifier);

    final albums = albumsQuery.asData?.value.items ?? [];

    final theme = Theme.of(context);

    return HorizontalPlaybuttonCardView<SpotubeSimpleAlbumObject>(
      isLoadingNextPage: albumsQuery.isLoadingNextPage,
      hasNextPage: albumsQuery.asData?.value.hasMore ?? false,
      items: albums,
      onFetchMore: albumsQueryNotifier.fetchMore,
      title: Text(
        context.l10n.albums,
        style: theme.typography.h4,
      ),
    );
  }
}
