import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class HomeNewReleasesSection extends HookConsumerWidget {
  const HomeNewReleasesSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authenticationProvider);

    final newReleases = ref.watch(albumReleasesProvider);
    final newReleasesNotifier = ref.read(albumReleasesProvider.notifier);

    final albums = ref.watch(userArtistAlbumReleasesProvider);

    if (auth.asData?.value == null ||
        newReleases.isLoading ||
        newReleases.asData?.value.items.isEmpty == true) {
      return const SizedBox.shrink();
    }

    return HorizontalPlaybuttonCardView<Album>(
      items: albums,
      title: Text(context.l10n.new_releases),
      isLoadingNextPage: newReleases.isLoadingNextPage,
      hasNextPage: newReleases.asData?.value.hasMore ?? false,
      onFetchMore: newReleasesNotifier.fetchMore,
    );
  }
}
