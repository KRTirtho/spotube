import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:spotube/extensions/ShimmerColorTheme.dart';

class ShimmerPlaybuttonCard extends StatelessWidget {
  final int count;
  const ShimmerPlaybuttonCard({Key? key, this.count = 4}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shimmerColor =
        Theme.of(context).extension<ShimmerColorTheme>()?.shimmerColor ??
            Colors.white;
    final shimmerBackgroundColor = Theme.of(context)
            .extension<ShimmerColorTheme>()
            ?.shimmerBackgroundColor ??
        Colors.grey;

    final card = Stack(
      children: [
        SkeletonAnimation(
          shimmerColor: shimmerColor,
          borderRadius: BorderRadius.circular(20),
          shimmerDuration: 1000,
          child: Container(
            width: 200,
            height: 220,
            decoration: BoxDecoration(
              color: shimmerBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(top: 10),
          ),
        ),
        Column(
          children: [
            SkeletonAnimation(
              shimmerColor: shimmerBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              shimmerDuration: 1000,
              child: Container(
                width: 200,
                height: 180,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 10),
              ),
            ),
            const SizedBox(height: 5),
            SkeletonAnimation(
              shimmerColor: shimmerBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              shimmerDuration: 1000,
              child: Container(
                width: 150,
                height: 10,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 10),
              ),
            ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Row(
            children: List.generate(
              count,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: card,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
