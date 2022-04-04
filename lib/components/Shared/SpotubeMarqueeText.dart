import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class SpotubeMarqueeText extends StatelessWidget {
  const SpotubeMarqueeText(
      {Key? key, required this.text, required this.textStyle})
      : super(key: key);
  final TextStyle textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text: text,
      style: textStyle,
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 60.0,
      velocity: 30.0,
      startAfter: const Duration(seconds: 2),
      pauseAfterRound: const Duration(seconds: 2),
      accelerationDuration: const Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: const Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
      fadingEdgeStartFraction: 0.15,
      fadingEdgeEndFraction: 0.15,
    );
  }
}
