import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/pages/home/genres.dart';
import 'package:spotube/pages/home/personalized.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const PageWindowTitleBar(
          titleWidth: 347,
          centerTitle: true,
          title: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Genres'),
              Tab(text: 'Personalized'),
            ],
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1, 0),
                end: const Offset(0, 0),
              ),
            ),
            child: child,
          ),
          child: const TabBarView(
            children: [
              GenrePage(),
              PersonalizedPage(),
            ],
          ),
        ),
      ),
    );
  }
}
