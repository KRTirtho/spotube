import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnchorButton<T> extends HookWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final void Function()? onTap;

  const AnchorButton(
    this.text, {
    Key? key,
    this.onTap,
    this.textAlign,
    this.overflow,
    this.style = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hover = useState(false);
    var tap = useState(false);

    return GestureDetector(
      child: MouseRegion(
        cursor: MaterialStateMouseCursor.clickable,
        child: Text(
          text,
          style: style.copyWith(
            decoration:
                hover.value || tap.value ? TextDecoration.underline : null,
          ),
          textAlign: textAlign,
          overflow: overflow,
        ),
        onEnter: (event) => hover.value = true,
        onExit: (event) => hover.value = false,
      ),
      onTapDown: (event) => tap.value = true,
      onTapUp: (event) => tap.value = false,
      onTap: onTap,
    );
  }
}
