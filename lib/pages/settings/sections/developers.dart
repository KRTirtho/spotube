import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show ListTile;
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
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
            context.navigateTo(const LogsRoute());
          },
        )
      ],
    );
  }
}
