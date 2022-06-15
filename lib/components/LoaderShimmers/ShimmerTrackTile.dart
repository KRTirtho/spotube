import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:spotube/extensions/ShimmerColorTheme.dart';

class ShimmerTrackTile extends StatelessWidget {
  final bool noSliver;

  const ShimmerTrackTile({
    Key? key,
    this.noSliver = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shimmerColor =
        Theme.of(context).extension<ShimmerColorTheme>()!.shimmerColor!;
    final shimmerBackgroundColor = Theme.of(context)
        .extension<ShimmerColorTheme>()!
        .shimmerBackgroundColor!;

    final single = Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SkeletonAnimation(
            shimmerColor: shimmerColor,
            borderRadius: BorderRadius.circular(20),
            shimmerDuration: 1000,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: shimmerBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 10),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonAnimation(
                  shimmerColor: shimmerColor,
                  borderRadius: BorderRadius.circular(20),
                  shimmerDuration: 1000,
                  child: Container(
                    height: 15,
                    decoration: BoxDecoration(
                      color: shimmerBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(top: 10),
                  ),
                ),
                SkeletonAnimation(
                  shimmerColor: shimmerColor,
                  borderRadius: BorderRadius.circular(20),
                  shimmerDuration: 1000,
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .8),
                    height: 10,
                    decoration: BoxDecoration(
                      color: shimmerBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(top: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (noSliver) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, _) => single,
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => single,
        childCount: 5,
      ),
    );
  }
}
