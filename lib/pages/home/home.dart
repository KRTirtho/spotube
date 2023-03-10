import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/themed_button_tab_bar.dart';
import 'package:spotube/pages/home/genres.dart';
import 'package:spotube/pages/home/personalized.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PageWindowTitleBar(
          centerTitle: true,
          leadingWidth: double.infinity,
          leading: ThemedButtonsTabBar(
            tabs: ["Genres", "Personalized"],
          ),
        ),
        body: TabBarView(
          children: [
            GenrePage(),
            PersonalizedPage(),
          ],
        ),
      ),
    );
  }
}
