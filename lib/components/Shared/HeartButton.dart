import 'package:flutter/material.dart';

class HeartButton extends StatelessWidget {
  final bool isLiked;
  final void Function() onPressed;
  const HeartButton({
    required this.isLiked,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        !isLiked ? Icons.favorite_outline_rounded : Icons.favorite_rounded,
        color: isLiked ? Colors.green : null,
      ),
      onPressed: onPressed,
    );
  }
}
