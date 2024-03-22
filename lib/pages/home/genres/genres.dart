import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart' hide Offset;
import 'package:spotube/collections/gradients.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';

class GenrePage extends HookConsumerWidget {
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme) = Theme.of(context);
    final scrollController = useScrollController();
    final recommendationMarket = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    final categoriesQuery =
        useQueries.category.listAll(ref, recommendationMarket);

    final categories = categoriesQuery.data ?? <Category>[];

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: PageWindowTitleBar(
        title: Text(context.l10n.explore_genres),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        top: false,
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 9 / 18,
            maxCrossAxisExtent: mediaQuery.smAndDown ? 200 : 300,
            mainAxisExtent: 200,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final gradient = gradients[Random().nextInt(gradients.length)];
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                context.push("/genre/${category.id}", extra: category);
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(category.icons!.first.url!),
                    fit: BoxFit.cover,
                  ),
                  gradient: gradient,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AutoSizeText(
                    category.name!,
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      shadows: [
                        // stroke shadow
                        const Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    maxFontSize: textTheme.titleLarge!.fontSize!,
                    minFontSize: textTheme.titleMedium!.fontSize!,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
