import 'package:flutter/material.dart';

class HeartButton extends StatelessWidget {
  final bool isLiked;
  final void Function() onPressed;
  final IconData? icon;
  const HeartButton({
    required this.isLiked,
    required this.onPressed,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon ??
            (!isLiked
                ? Icons.favorite_outline_rounded
                : Icons.favorite_rounded),
        color: isLiked ? Colors.green : null,
      ),
      onPressed: onPressed,
    );
  }
}
