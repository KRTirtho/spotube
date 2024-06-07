import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/extensions/context.dart';

class SettingsDevelopersSection extends HookWidget {
  const SettingsDevelopersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCardWithHeading(
      heading: context.l10n.developers,
      children: [
        ListTile(
          leading: const Icon(SpotubeIcons.logs),
          title: Text(context.l10n.logs),
          trailing: const Icon(SpotubeIcons.angleRight),
          onTap: () {
            GoRouter.of(context).push("/settings/logs");
          },
        )
      ],
    );
  }
}
