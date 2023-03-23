import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:skeleton_text/skeleton_text.dart';
import 'package:spotube/components/shared/shimmers/shimmer_track_tile.dart';
import 'package:spotube/extensions/theme.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';

class ShimmerArtistProfile extends HookWidget {
  const ShimmerArtistProfile({Key? key}) : super(key: key);

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

    final avatarWidth = useBreakpointValue(
          sm: MediaQuery.of(context).size.width * 0.80,
          md: MediaQuery.of(context).size.width * 0.50,
          lg: MediaQuery.of(context).size.width * 0.30,
          xl: MediaQuery.of(context).size.width * 0.30,
          xxl: MediaQuery.of(context).size.width * 0.30,
        ) ??
        0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: SkeletonAnimation(
            shimmerColor: shimmerColor,
            borderRadius: BorderRadius.circular(avatarWidth),
            shimmerDuration: 1000,
            child: Container(
              width: avatarWidth,
              height: avatarWidth,
              decoration: BoxDecoration(
                color: shimmerBackgroundColor,
                borderRadius: BorderRadius.circular(avatarWidth),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Flexible(child: ShimmerTrackTile(noSliver: true)),
      ],
    );
  }
}
