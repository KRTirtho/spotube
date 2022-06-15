import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerTrackTile.dart';
import 'package:spotube/extensions/ShimmerColorTheme.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';

class ShimmerArtistProfile extends HookWidget {
  const ShimmerArtistProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shimmerColor =
        Theme.of(context).extension<ShimmerColorTheme>()!.shimmerColor!;
    final shimmerBackgroundColor = Theme.of(context)
        .extension<ShimmerColorTheme>()!
        .shimmerBackgroundColor!;

    final avatarWidth = useBreakpointValue(
      sm: MediaQuery.of(context).size.width * 0.80,
      md: MediaQuery.of(context).size.width * 0.50,
      lg: MediaQuery.of(context).size.width * 0.30,
      xl: MediaQuery.of(context).size.width * 0.30,
      xxl: MediaQuery.of(context).size.width * 0.30,
    );

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
