import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:marquee/marquee.dart';
import 'package:spotube/utils/platform.dart';

class SpotubeMarqueeText extends HookWidget {
  final int? minStartLength;
  final bool? isHovering;
  const SpotubeMarqueeText({
    Key? key,
    required this.text,
    this.style,
    this.minStartLength,
    this.isHovering,
  }) : super(key: key);
  final TextStyle? style;
  final String text;

  @override
  Widget build(BuildContext context) {
    final hovering = useState(false);
    final isInitial = useState(true);

    useEffect(() {
      if (isHovering != null && isHovering != hovering.value) {
        hovering.value = isHovering!;
      }
      return null;
    }, [isHovering]);

    if ((!isInitial.value && !hovering.value && kIsDesktop) ||
        minStartLength != null && text.length <= minStartLength!) {
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Marquee(
      text: text,
      style: style,
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 40.0,
      velocity: 30.0,
      accelerationDuration: const Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: const Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
      fadingEdgeStartFraction: 0.15,
      fadingEdgeEndFraction: 0.15,
      showFadingOnlyWhenScrolling: true,
      onDone: () {
        if (isInitial.value) {
          isInitial.value = false;
          hovering.value = false;
        }
      },
      numberOfRounds: hovering.value ? null : 1,
    );
  }
}
