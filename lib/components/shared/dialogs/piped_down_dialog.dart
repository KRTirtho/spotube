import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class PipedDownDialog extends HookConsumerWidget {
  const PipedDownDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final pipedInstance =
        ref.watch(userPreferencesProvider.select((s) => s.pipedInstance));
    final ThemeData(:colorScheme) = Theme.of(context);

    return AlertDialog(
      insetPadding: const EdgeInsets.all(6),
      contentPadding: const EdgeInsets.all(6),
      icon: Icon(
        SpotubeIcons.error,
        color: colorScheme.error,
      ),
      title: Text(
        context.l10n.piped_api_down,
        style: TextStyle(color: colorScheme.error),
      ),
      content: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(context.l10n.piped_down_error_instructions(pipedInstance)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.ok),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.settings),
        ),
      ],
    );
  }
}
