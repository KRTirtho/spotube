import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:marquee/marquee.dart';

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
    final uKey = useState(UniqueKey());

    useEffect(() {
      uKey.value = UniqueKey();
      return;
    }, [isHovering]);

    return AutoSizeText(
      text,
      minFontSize: 13,
      style: style,
      overflowReplacement: Marquee(
        key: uKey.value,
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
        showFadingOnlyWhenScrolling: true,
        numberOfRounds: isHovering == true ? null : 1,
      ),
    );
  }
}
