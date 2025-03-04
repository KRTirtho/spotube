import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/modules/player/sibling_tracks_sheet.dart';

@RoutePage()
class PlayerTrackSourcesPage extends StatelessWidget {
  const PlayerTrackSourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      child: SiblingTracksSheet(floating: false),
    );
  }
}
