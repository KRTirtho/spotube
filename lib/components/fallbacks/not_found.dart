import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/extensions/context.dart';

class NotFound extends StatelessWidget {
  final bool vertical;
  const NotFound({super.key, this.vertical = false});

  @override
  Widget build(BuildContext context) {
    final widgets = [
      SizedBox(
        height: 150,
        width: 150,
        child: Assets.emptyBox.image(),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.nothing_found).large().semiBold(),
          Text(
            context.l10n.the_box_is_empty,
          ).semiBold(),
        ],
      ),
    ];
    return vertical ? Column(children: widgets) : Row(children: widgets);
  }
}
