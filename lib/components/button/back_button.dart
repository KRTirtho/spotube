import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';

class BackButton extends StatelessWidget {
  final Color? color;
  const BackButton({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.ghost(
      size: const ButtonSize(.9),
      icon: color != null
          ? Icon(SpotubeIcons.angleLeft, color: color)
          : const Icon(SpotubeIcons.angleLeft),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
