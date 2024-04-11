import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HoverBuilder extends HookWidget {
  final bool? permanentState;
  final Widget Function(BuildContext context, bool isHovering) builder;
  const HoverBuilder({
    required this.builder,
    this.permanentState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hovering = useState(false);

    if (permanentState != null) {
      return builder(context, permanentState!);
    }

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
