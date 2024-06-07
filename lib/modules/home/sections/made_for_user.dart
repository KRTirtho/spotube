import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class HomeMadeForUserSection extends HookConsumerWidget {
  const HomeMadeForUserSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final madeForUser = ref.watch(viewProvider("made-for-x-hub"));

    return SliverList.builder(
      itemCount: madeForUser.asData?.value["content"]?["items"]?.length ?? 0,
      itemBuilder: (context, index) {
        final item = madeForUser.asData?.value["content"]?["items"]?[index];
        final playlists = item["content"]?["items"]
                ?.where((itemL2) => itemL2["type"] == "playlist")
                .map((itemL2) => PlaylistSimple.fromJson(itemL2))
                .toList()
                .cast<PlaylistSimple>() ??
            <PlaylistSimple>[];
        if (playlists.isEmpty) return const SizedBox.shrink();
        return HorizontalPlaybuttonCardView<PlaylistSimple>(
          items: playlists,
          title: Text(item["name"] ?? ""),
          hasNextPage: false,
          isLoadingNextPage: false,
          onFetchMore: () {},
        );
      },
    );
  }
}
