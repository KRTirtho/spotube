import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';

class PlaylistShuffleButton extends StatelessWidget {
  final onPressed;

  const PlaylistShuffleButton({
    Key? key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      tooltip: "Shuffle",
      icon: const Icon(Icons.shuffle),
      onPressed: this.onPressed,
    );
  }
}
