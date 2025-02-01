import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/summary/summary.dart';
import 'package:spotube/modules/stats/top/top.dart';
import 'package:spotube/utils/platform.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class StatsPage extends HookConsumerWidget {
  static const name = "stats";

  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.navigateTo(const HomeRoute());
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          headers: [
            if (kTitlebarVisible)
              const TitleBar(automaticallyImplyLeading: false),
          ],
          child: CustomScrollView(
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
      ),
    );
  }
}
