import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class HomeNewReleasesSection extends HookConsumerWidget {
  const HomeNewReleasesSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(AuthenticationNotifier.provider);

    final newReleases = ref.watch(albumReleasesProvider);
    final newReleasesNotifier = ref.read(albumReleasesProvider.notifier);

    final albums = ref.watch(userArtistAlbumReleasesProvider);

    if (auth == null ||
        newReleases.isLoading ||
        newReleases.value?.items.isEmpty == true) {
      return const SizedBox.shrink();
    }

    return HorizontalPlaybuttonCardView<Album>(
      items: albums,
      title: Text(context.l10n.new_releases),
      isLoadingNextPage: newReleases.isLoadingNextPage,
      hasNextPage: newReleases.value?.hasMore ?? false,
      onFetchMore: newReleasesNotifier.fetchMore,
    );
  }
}
