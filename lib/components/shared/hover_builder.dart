import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HoverBuilder extends HookWidget {
  final Widget Function(BuildContext context, bool isHovering) builder;
  const HoverBuilder({
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hovering = useState(false);

    return MouseRegion(
      onEnter: (_) {
        if (!hovering.value) hovering.value = true;
      },
      onExit: (_) {
        if (hovering.value) hovering.value = false;
      },
      child: builder(context, hovering.value),
    );
  }
}
