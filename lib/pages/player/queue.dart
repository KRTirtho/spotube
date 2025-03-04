import 'package:auto_route/annotations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/extensions/context.dart';
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
      headers: [
        AppBar(
          title: Text(context.l10n.queue),
          trailing: const [
            BackButton(icon: SpotubeIcons.close),
          ],
        ),
      ],
      child: PlayerQueue.fromAudioPlayerNotifier(
        floating: false,
        playlist: playlist,
        notifier: playlistNotifier,
      ),
    );
  }
}
