import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/album/releases.dart';
import 'package:spotube/provider/metadata_plugin/auth.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';

class HomeNewReleasesSection extends HookConsumerWidget {
  const HomeNewReleasesSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authenticated = ref.watch(metadataPluginAuthenticatedProvider);

    final newReleases = ref.watch(metadataPluginAlbumReleasesProvider);
    final newReleasesNotifier =
        ref.read(metadataPluginAlbumReleasesProvider.notifier);

    if (authenticated.asData?.value != true ||
        newReleases.isLoading ||
        newReleases.asData?.value.items.isEmpty == true) {
      return const SizedBox.shrink();
    }

    return HorizontalPlaybuttonCardView<SpotubeSimpleAlbumObject>(
      items: newReleases.asData?.value.items ?? [],
      title: Text(context.l10n.new_releases),
      isLoadingNextPage: newReleases.isLoadingNextPage,
      hasNextPage: newReleases.asData?.value.hasMore ?? false,
      onFetchMore: newReleasesNotifier.fetchMore,
    );
  }
}
