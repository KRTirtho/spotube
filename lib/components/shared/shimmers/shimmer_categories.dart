import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/extensions/theme.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';

class ShimmerCategories extends HookWidget {
  const ShimmerCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerTheme = ShimmerColorTheme(
      shimmerBackgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
    );
    final shimmerBackgroundColor =
        shimmerTheme.shimmerBackgroundColor ?? Colors.grey;

    final shimmerCount = useBreakpointValue(
      xs: 2,
      sm: 2,
      md: 3,
      lg: 3,
      xl: 6,
      xxl: 8,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
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
          Align(
            alignment: Alignment.topLeft,
            child: ShimmerPlaybuttonCard(count: shimmerCount),
          ),
        ],
      ),
    );
  }
}
