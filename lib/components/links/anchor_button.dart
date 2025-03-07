import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AnchorButton<T> extends HookWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final void Function()? onTap;
  final int? maxLines;

  const AnchorButton(
    this.text, {
    super.key,
    this.onTap,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    var hover = useState(false);
    var tap = useState(false);

    return GestureDetector(
      onTapDown: (event) => tap.value = true,
      onTapUp: (event) => tap.value = false,
      onTap: onTap,
      child: MouseRegion(
        cursor: WidgetStateMouseCursor.clickable,
        child: Text(
          text,
          style: style.copyWith(
            decoration:
                hover.value || tap.value ? TextDecoration.underline : null,
          ),
          maxLines: maxLines,
          textAlign: textAlign,
          overflow: overflow,
        ),
        onEnter: (event) => hover.value = true,
        onExit: (event) => hover.value = false,
      ),
    );
  }
}
