import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimateGradient extends HookWidget {
  const AnimateGradient({
    super.key,
    required this.primaryColors,
    required this.secondaryColors,
    this.child,
    this.primaryBegin,
    this.primaryEnd,
    this.secondaryBegin,
    this.secondaryEnd,
    AnimationController? controller,
    this.duration = const Duration(seconds: 4),
    this.animateAlignments = true,
    this.reverse = true,
  })  : assert(primaryColors.length >= 2),
        assert(primaryColors.length == secondaryColors.length),
        _controller = controller;

  /// [controller]: pass this to have a fine control over the [Animation]
  final AnimationController? _controller;

  /// [duration]: Time to switch between [Gradient].
  /// By default its value is [Duration(seconds:4)]
  final Duration duration;

  /// [primaryColors]: These will be the starting colors of the [Animation].
  final List<Color> primaryColors;

  /// [secondaryColors]: These Colors are those in which the [primaryColors] will transition into.
  final List<Color> secondaryColors;

  /// [primaryBegin]: This is begin [Alignment] for [primaryColors].
  /// By default its value is [Alignment.topLeft]
  final Alignment? primaryBegin;

  /// [primaryBegin]: This is end [Alignment] for [primaryColors].
  /// By default its value is [Alignment.topRight]
  final Alignment? primaryEnd;

  /// [secondaryBegin]: This is begin [Alignment] for [secondaryColors].
  /// By default its value is [Alignment.bottomLeft]
  final Alignment? secondaryBegin;

  /// [secondaryEnd]: This is end [Alignment] for [secondaryColors].
  /// By default its value is [Alignment.bottomRight]
  final Alignment? secondaryEnd;

  /// [animateAlignments]: set to false if you don't want to animate the alignments.
  /// This can provide you way cooler animations
  final bool animateAlignments;

  /// [reverse]: set it to false if you don't want to reverse the animation.
  /// using that it will go into one direction only
  final bool reverse;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final __controller = useAnimationController(
      duration: duration,
    )..repeat(reverse: reverse);

    final controller = _controller ?? __controller;

    final animation = useMemoized(
        () => CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ),
        [controller]);

    final colorTween = useMemoized(
        () => primaryColors.map((color) {
              return ColorTween(
                begin: color,
                end: color,
              );
            }).toList(),
        [primaryColors]);
    final colors = useMemoized(
        () => colorTween.map((color) {
              return color.evaluate(animation)!;
            }).toList(),
        [colorTween, animation]);

    final begin = useMemoized(
        () => AlignmentTween(
              begin: primaryBegin ?? Alignment.topLeft,
              end: primaryEnd ?? Alignment.topRight,
            ),
        [primaryBegin, primaryEnd]);

    final end = useMemoized(
        () => AlignmentTween(
              begin: secondaryBegin ?? Alignment.bottomLeft,
              end: secondaryEnd ?? Alignment.bottomRight,
            ),
        [secondaryBegin, secondaryEnd]);

    return AnimatedBuilder(
      animation: animation,
      child: useMemoized(() => child, [child]),
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: animateAlignments
                  ? begin.evaluate(animation)
                  : (primaryBegin as Alignment),
              end: animateAlignments
                  ? end.evaluate(animation)
                  : primaryEnd as Alignment,
              colors: colors,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
