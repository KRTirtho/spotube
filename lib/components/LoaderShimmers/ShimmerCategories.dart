import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerPlaybuttonCard.dart';
import 'package:spotube/extensions/ShimmerColorTheme.dart';

class ShimmerCategories extends StatelessWidget {
  const ShimmerCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shimmerColor =
        Theme.of(context).extension<ShimmerColorTheme>()?.shimmerColor ??
            Colors.white;
    final shimmerBackgroundColor = Theme.of(context)
            .extension<ShimmerColorTheme>()
            ?.shimmerBackgroundColor ??
        Colors.grey;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SkeletonAnimation(
              shimmerColor: shimmerBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              shimmerDuration: 1000,
              child: Container(
                width: 150,
                height: 15,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 10),
              ),
            ),
          ),
          const ShimmerPlaybuttonCard(count: 7),
        ],
      ),
    );
  }
}
