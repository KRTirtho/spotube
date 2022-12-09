import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/extensions/theme.dart';

class ShimmerCategories extends StatelessWidget {
  const ShimmerCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = PlatformTheme.of(context).brightness == Brightness.dark;
    final shimmerTheme = ShimmerColorTheme(
      shimmerBackgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
    );
    final shimmerBackgroundColor =
        shimmerTheme.shimmerBackgroundColor ?? Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            height: 10,
            width: 100,
            decoration: BoxDecoration(
              color: shimmerBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.topCenter,
            child: ShimmerPlaybuttonCard(count: 7),
          ),
        ],
      ),
    );
  }
}
