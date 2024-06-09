import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/tracks_view/sections/header/flexible_header.dart';
import 'package:spotube/components/tracks_view/sections/body/track_view_body.dart';
import 'package:spotube/components/tracks_view/track_view_props.dart';
import 'package:spotube/utils/platform.dart';

class TrackView extends HookConsumerWidget {
  const TrackView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final props = InheritedTrackView.of(context);
    final controller = useScrollController();

    return Scaffold(
      appBar: kIsDesktop
          ? const PageWindowTitleBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              leadingWidth: 400,
              leading: Align(
                alignment: Alignment.centerLeft,
                child: BackButton(color: Colors.white),
              ),
            )
          : null,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: props.pagination.onRefresh,
        child: InterScrollbar(
          controller: controller,
          child: CustomScrollView(
            controller: controller,
            slivers: const [
              TrackViewFlexHeader(),
              SliverAnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: TrackViewBodySection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
