import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spotube/modules/player/player_overlay_collapsed.dart';

import 'package:spotube/modules/root/spotube_navigation_bar.dart';
import 'package:spotube/modules/player/player.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';

final playerOverlayControllerProvider = StateProvider<PanelController>((ref) {
  return PanelController();
});

class PlayerOverlay extends HookConsumerWidget {
  final String albumArt;

  const PlayerOverlay({
    required this.albumArt,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(audioPlayerProvider);
    final canShow = playlist.activeTrack != null;

    final screenSize = MediaQuery.sizeOf(context);

    final panelController = ref.watch(playerOverlayControllerProvider);

    return SlidingUpPanel(
      maxHeight: screenSize.height,
      backdropEnabled: false,
      minHeight: canShow ? 63 : 0,
      onPanelSlide: (position) {
        final invertedPosition = 1 - position;
        ref.read(navigationPanelHeight.notifier).state = 50 * invertedPosition;
      },
      controller: panelController,
      color: Colors.transparent,
      parallaxEnabled: true,
      renderPanelSheet: false,
      header: SizedBox(
        height: 63,
        width: screenSize.width,
        child: PlayerOverlayCollapsedSection(panelController: panelController),
      ),
      panelBuilder: (scrollController) => PlayerView(
        panelController: panelController,
        scrollController: scrollController,
      ),
    );
  }
}
