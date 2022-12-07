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
