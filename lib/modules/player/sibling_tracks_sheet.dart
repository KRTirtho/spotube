import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/server/active_track_sources.dart';

class SiblingTracksSheet extends HookConsumerWidget {
  final bool floating;
  const SiblingTracksSheet({
    super.key,
    this.floating = true,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();

    final isFetchingActiveTrack = ref.watch(queryingTrackInfoProvider);
    final activeTrackSources = ref.watch(activeTrackSourcesProvider);
    final activeTrackNotifier = activeTrackSources.asData?.value?.notifier;
    final activeTrack = activeTrackSources.asData?.value?.track;
    final activeTrackSource = activeTrackSources.asData?.value?.source;

    final siblings = useMemoized<List<SpotubeAudioSourceMatchObject>>(
      () => !isFetchingActiveTrack
          ? [
              if (activeTrackSource != null) activeTrackSource.info,
              ...?activeTrackSource?.siblings,
            ]
          : <SpotubeAudioSourceMatchObject>[],
      [activeTrackSource, isFetchingActiveTrack],
    );

    final previousActiveTrack = usePrevious(activeTrack);
    useEffect(() {
      /// Populate sibling when active track changes
      if (previousActiveTrack?.id == activeTrack?.id) return;
      if (activeTrackSource != null && activeTrackSource.siblings.isEmpty) {
        activeTrackNotifier?.copyWithSibling();
      }
      return null;
    }, [activeTrack, previousActiveTrack]);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Row(
              spacing: 5,
              children: [
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      context.l10n.alternative_track_sources,
                    ).bold()),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: activeTrackSources.isLoading
                ? const SizedBox(
                    width: double.infinity,
                    child: LinearProgressIndicator(),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: InterScrollbar(
                controller: controller,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  controller: controller,
                  itemCount: siblings.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final sourceInfo = siblings[index];

                    return ButtonTile(
                      style: ButtonVariance.ghost,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        sourceInfo.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: sourceInfo.thumbnail != null
                          ? UniversalImage(
                              path: sourceInfo.thumbnail!,
                              height: 60,
                              width: 60,
                            )
                          : null,
                      trailing:
                          Text(sourceInfo.duration.toHumanReadableString()),
                      subtitle: Flexible(
                        child: Text(
                          sourceInfo.artists.join(", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      enabled: !isFetchingActiveTrack,
                      selected: !isFetchingActiveTrack &&
                          sourceInfo.id == activeTrackSource?.info.id,
                      onPressed: () async {
                        if (!isFetchingActiveTrack &&
                            sourceInfo.id != activeTrackSource?.info.id) {
                          await activeTrackNotifier
                              ?.swapWithSibling(sourceInfo);
                          await ref
                              .read(audioPlayerProvider.notifier)
                              .swapActiveSource();

                          if (context.mounted) {
                            if (MediaQuery.sizeOf(context).mdAndUp) {
                              closeOverlay(context);
                            } else {
                              closeDrawer(context);
                            }
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
