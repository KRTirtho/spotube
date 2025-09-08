import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/links/anchor_button.dart';

class LinkText<T> extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final PageRouteInfo route;
  final int? maxLines;

  final bool push;
  const LinkText(
    this.text,
    this.route, {
    super.key,
    this.textAlign,
    this.overflow,
    this.style = const TextStyle(),
    this.maxLines,
    this.push = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnchorButton(
      text,
      onTap: () {
        if (push) {
          context.navigateTo(route);
        } else {
          context.navigateTo(route);
        }
      },
      key: key,
      overflow: overflow,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
