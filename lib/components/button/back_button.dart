import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.ghost(
      icon: const Icon(SpotubeIcons.angleLeft),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
