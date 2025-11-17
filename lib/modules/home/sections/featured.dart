import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';

@Deprecated(
    "Later a featured playlists API will be added for metadata plugins.")
class HomeFeaturedSection extends HookConsumerWidget {
  const HomeFeaturedSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return const SizedBox.shrink();
    // final featuredPlaylists = ref.watch(featuredPlaylistsProvider);
    // final featuredPlaylistsNotifier =
    //     ref.watch(featuredPlaylistsProvider.notifier);

    // if (featuredPlaylists.hasError) {
    //   return Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Undraw(
    //         illustration: UndrawIllustration.fixingBugs,
    //         height: 200 * context.theme.scaling,
    //         color: context.theme.colorScheme.primary,
    //       ),
    //       Text(context.l10n.something_went_wrong).small().muted(),
    //       const Gap(8),
    //     ],
    //   );
    // }

    // return Skeletonizer(
    //   enabled: featuredPlaylists.isLoading,
    //   child: HorizontalPlaybuttonCardView<PlaylistSimple>(
    //     items: featuredPlaylists.asData?.value.items ?? [],
    //     title: Text(context.l10n.featured),
    //     isLoadingNextPage: featuredPlaylists.isLoadingNextPage,
    //     hasNextPage: featuredPlaylists.asData?.value.hasMore ?? false,
    //     onFetchMore: featuredPlaylistsNotifier.fetchMore,
    //   ),
    // );
  }
}
