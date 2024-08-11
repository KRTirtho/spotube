import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/summary/summary.dart';
import 'package:spotube/modules/stats/top/top.dart';
import 'package:spotube/utils/platform.dart';

class StatsPage extends HookConsumerWidget {
  static const name = "stats";

  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: kIsMacOS || kIsMobile ? null : const PageWindowTitleBar(),
        body: CustomScrollView(
          slivers: [
            if (kIsMacOS) const SliverGap(20),
            const StatsPageSummarySection(),
            const StatsPageTopSection(),
            const SliverToBoxAdapter(
              child: SafeArea(
                child: SizedBox(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
