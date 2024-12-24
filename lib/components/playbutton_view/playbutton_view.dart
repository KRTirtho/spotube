import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/playbutton_view/playbutton_card.dart';
import 'package:spotube/components/playbutton_view/playbutton_tile.dart';
import 'package:spotube/components/waypoint.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

const _dummyPlaybuttonCard = PlaybuttonCard(
  imageUrl: 'https://placehold.co/150x150.png',
  isLoading: false,
  isPlaying: false,
  title: "Playbutton",
  description: "A really cool playbutton",
  isOwner: false,
);

const _dummyPlaybuttonTile = PlaybuttonTile(
  imageUrl: 'https://placehold.co/150x150.png',
  isLoading: false,
  isPlaying: false,
  title: "Playbutton",
  description: "A really cool playbutton",
  isOwner: false,
);

/// A [PlaybuttonCard] grid/list view (selectable) sliver widget
/// with support for infinite scrolling
class PlaybuttonView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) gridItemBuilder;
  final Widget Function(BuildContext context, int index) listItemBuilder;
  final bool hasMore;
  final bool isLoading;
  final VoidCallback onRequestMore;
  final ScrollController controller;

  const PlaybuttonView({
    super.key,
    required this.itemCount,
    required this.gridItemBuilder,
    required this.listItemBuilder,
    required this.hasMore,
    required this.isLoading,
    required this.onRequestMore,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constrains) => HookBuilder(builder: (context) {
        final isGrid = useState(constrains.mdAndUp);
        final hasUserInteracted = useRef(false);

        useEffect(() {
          if (hasUserInteracted.value) return null;
          if (isGrid.value != constrains.mdAndUp) {
            isGrid.value = constrains.mdAndUp;
          }
          return null;
        }, [constrains]);

        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Toggle(
                    value: isGrid.value,
                    style:
                        const ButtonStyle.outline(density: ButtonDensity.icon),
                    onChanged: (value) {
                      isGrid.value = value;
                      hasUserInteracted.value = true;
                    },
                    child: const Icon(SpotubeIcons.grid),
                  ),
                  const SizedBox(width: 8),
                  Toggle(
                    value: !isGrid.value,
                    style:
                        const ButtonStyle.outline(density: ButtonDensity.icon),
                    onChanged: (value) {
                      isGrid.value = !value;
                      hasUserInteracted.value = true;
                    },
                    child: const Icon(SpotubeIcons.list),
                  ),
                ],
              ),
            ),
            const SliverGap(10),
            // Toggle between grid and list view
            switch ((isGrid.value, isLoading)) {
              (true, _) => SliverGrid.builder(
                  itemCount: isLoading ? 6 : itemCount + 1,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150 * context.theme.scaling,
                    mainAxisExtent: 225 * context.theme.scaling,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    if (isLoading) {
                      return const Skeletonizer(
                        enabled: true,
                        child: _dummyPlaybuttonCard,
                      );
                    }

                    if (index == itemCount) {
                      if (!hasMore) return const SizedBox.shrink();
                      return Waypoint(
                        controller: controller,
                        isGrid: true,
                        onTouchEdge: onRequestMore,
                        child: const Skeletonizer(
                          enabled: true,
                          child: _dummyPlaybuttonCard,
                        ),
                      );
                    }

                    return gridItemBuilder(context, index);
                  },
                ),
              (false, true) => Skeletonizer.sliver(
                  enabled: true,
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _dummyPlaybuttonTile,
                      childCount: 6,
                    ),
                  ),
                ),
              (false, false) => SliverInfiniteList(
                  itemCount: itemCount,
                  loadingBuilder: (context) => const Skeletonizer(
                    enabled: true,
                    child: _dummyPlaybuttonTile,
                  ),
                  itemBuilder: listItemBuilder,
                  onFetchData: onRequestMore,
                  hasReachedMax: !hasMore,
                  isLoading: isLoading,
                ),
            }
          ],
        );
      }),
    );
  }
}