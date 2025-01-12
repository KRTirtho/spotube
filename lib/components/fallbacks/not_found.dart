import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/extensions/context.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Undraw(
          illustration: UndrawIllustration.empty,
          height: 200 * context.theme.scaling,
          color: context.theme.colorScheme.primary,
        ),
        const Gap(10),
        Text(
          context.l10n.nothing_found,
          textAlign: TextAlign.center,
        ).muted().small()
      ],
    );
  }
}
