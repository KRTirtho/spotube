import 'package:flutter/material.dart';
import 'package:spotube/collections/assets.gen.dart';

class NotFound extends StatelessWidget {
  final bool vertical;
  const NotFound({super.key, this.vertical = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widgets = [
      SizedBox(
        height: 150,
        width: 150,
        child: Assets.emptyBox.image(),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Nothing found", style: theme.textTheme.titleLarge),
          Text(
            "The box is empty",
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    ];
    return vertical ? Column(children: widgets) : Row(children: widgets);
  }
}
