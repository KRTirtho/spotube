import 'package:flutter/material.dart' show ListTile;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/track_presentation/presentation_list.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/presentation_top.dart';
import 'package:spotube/components/track_presentation/presentation_modifiers.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';

class TrackPresentation extends HookConsumerWidget {
  final TrackPresentationOptions options;
  const TrackPresentation({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context, ref) {
    final headerTextStyle = context.theme.typography.small.copyWith(
      color: context.theme.colorScheme.mutedForeground,
    );

    return Data<TrackPresentationOptions>.inherit(
      data: options,
      child: SafeArea(
        child: Scaffold(
          headers: const [TitleBar()],
          child: CustomScrollView(
            slivers: [
              const TrackPresentationTopSection(),
              const SliverGap(16),
              SliverLayoutBuilder(
                builder: (context, constrains) {
                  return SliverList.list(
                    children: [
                      const TrackPresentationModifiersSection(),
                      ListTile(
                        titleTextStyle: headerTextStyle,
                        subtitleTextStyle: headerTextStyle,
                        leadingAndTrailingTextStyle: headerTextStyle,
                        leading: constrains.mdAndUp ? const Text("  #") : null,
                        title: Row(
                          children: [
                            Expanded(
                              flex: constrains.lgAndUp ? 5 : 6,
                              child: Text(context.l10n.title),
                            ),
                            if (constrains.mdAndUp)
                              Expanded(
                                flex: 3,
                                child: Text(context.l10n.album),
                              ),
                            Text(context.l10n.duration),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const PresentationListSection(),
              const SliverGap(200),
            ],
          ),
        ),
      ),
    );
  }
}
