import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';

class BackButton extends StatelessWidget {
  final Color? color;
  final IconData icon;
  const BackButton({
    super.key,
    this.color,
    this.icon = SpotubeIcons.angleLeft,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.ghost(
      size: const ButtonSize(1.2),
      icon: Icon(icon, color: color),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
