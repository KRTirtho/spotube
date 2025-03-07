import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class ArtistAlbumList extends HookConsumerWidget {
  final String artistId;

  const ArtistAlbumList(
    this.artistId, {
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final albumsQuery = ref.watch(artistAlbumsProvider(artistId));
    final albumsQueryNotifier =
        ref.watch(artistAlbumsProvider(artistId).notifier);

    final albums = albumsQuery.asData?.value.items ?? [];

    final theme = Theme.of(context);

    return HorizontalPlaybuttonCardView<Album>(
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
