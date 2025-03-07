import 'package:auto_route/annotations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/modules/player/player_queue.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';

@RoutePage()
class PlayerQueuePage extends HookConsumerWidget {
  const PlayerQueuePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(
      audioPlayerProvider,
    );
    final playlistNotifier = ref.read(audioPlayerProvider.notifier);
    return Scaffold(
      child: SafeArea(
        bottom: false,
        child: PlayerQueue.fromAudioPlayerNotifier(
          floating: false,
          playlist: playlist,
          notifier: playlistNotifier,
        ),
      ),
    );
  }
}
