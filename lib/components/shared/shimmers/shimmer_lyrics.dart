import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:skeleton_text/skeleton_text.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/theme.dart';

const widths = [20, 56, 89, 60, 25, 69];

class ShimmerLyrics extends HookWidget {
  const ShimmerLyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerTheme = ShimmerColorTheme(
      shimmerBackgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
      shimmerColor: isDark ? Colors.grey[800] : Colors.grey[300],
    );
    final shimmerColor = shimmerTheme.shimmerColor ?? Colors.white;
    final shimmerBackgroundColor =
        shimmerTheme.shimmerBackgroundColor ?? Colors.grey;

    final mediaQuery = MediaQuery.of(context);

    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final widthsCp = [...widths];
        if (mediaQuery.isMd) {
          widthsCp.removeLast();
        }
        if (mediaQuery.isSm) {
          widthsCp.removeLast();
          widthsCp.removeLast();
        }
        widthsCp.shuffle();
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widthsCp.map(
              (width) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SkeletonAnimation(
                    shimmerColor: shimmerColor,
                    shimmerDuration: 1000,
                    child: Container(
                      height: 10,
                      width: width.toDouble(),
                      decoration: BoxDecoration(
                        color: shimmerBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(top: 10),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
