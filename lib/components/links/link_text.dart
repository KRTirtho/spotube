import 'package:flutter/material.dart';
import 'package:spotube/components/links/anchor_button.dart';
import 'package:spotube/utils/service_utils.dart';

class LinkText<T> extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final String route;
  final int? maxLines;
  final T? extra;

  final bool push;
  const LinkText(
    this.text,
    this.route, {
    super.key,
    this.textAlign,
    this.extra,
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
          ServiceUtils.push(context, route, extra: extra);
        } else {
          ServiceUtils.navigate(context, route, extra: extra);
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
