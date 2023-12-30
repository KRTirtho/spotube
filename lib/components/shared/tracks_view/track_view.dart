import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/tracks_view/sections/header/flexible_header.dart';
import 'package:spotube/components/shared/tracks_view/sections/body/track_view_body.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';

class TrackView extends HookConsumerWidget {
  const TrackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final props = InheritedTrackView.of(context);

    return Scaffold(
      appBar: DesktopTools.platform.isDesktop
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
        child: const CustomScrollView(
          slivers: [
            TrackViewFlexHeader(),
            SliverAnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: TrackViewBodySection(),
            ),
          ],
        ),
      ),
    );
  }
}
