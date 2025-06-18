import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/gradients.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class GenrePage extends HookConsumerWidget {
  static const name = "genre";
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final categories = ref.watch(categoriesProvider);

    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.explore_genres),
          )
        ],
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
          itemCount: categories.asData!.value.length,
          itemBuilder: (context, index) {
            final category = categories.asData!.value[index];
            final gradient = gradients[Random().nextInt(gradients.length)];
            return CardImage(
              onPressed: () {
                context.navigateTo(
                  GenrePlaylistsRoute(
                    id: category.id!,
                    category: category,
                  ),
                );
              },
              image: Stack(
                children: [
                  Container(
                    height: 300,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(category.icons!.first.url!),
                        fit: BoxFit.cover,
                      ),
                      gradient: gradient,
                    ),
                  ),
                  Positioned.fill(
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        category.name!,
                        style: context.theme.typography.h3.copyWith(
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
                        maxFontSize: context.theme.typography.h3.fontSize!,
                        minFontSize: context.theme.typography.large.fontSize!,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
