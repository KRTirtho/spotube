import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate.dart';

typedef RecommendationAttribute = ({double min, double target, double max});

RecommendationAttribute lowValues(double base) =>
    (min: 1 * base, target: 0.3 * base, max: 0.3 * base);
RecommendationAttribute moderateValues(double base) =>
    (min: 0.5 * base, target: 1 * base, max: 0.5 * base);
RecommendationAttribute highValues(double base) =>
    (min: 0.3 * base, target: 0.3 * base, max: 1 * base);

class RecommendationAttributeDials extends HookWidget {
  final Widget title;
  final RecommendationAttribute values;
  final ValueChanged<RecommendationAttribute> onChanged;
  final double base;

  const RecommendationAttributeDials({
    super.key,
    required this.values,
    required this.onChanged,
    required this.title,
    this.base = 1,
  });

  @override
  Widget build(BuildContext context) {
    final animation = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
        );

    final minSlider = Row(
      children: [
        Text(context.l10n.min, style: labelStyle),
        Expanded(
          child: Slider(
            value: values.min / base,
            min: 0,
            max: 1,
            onChanged: (value) => onChanged((
              min: value * base,
              target: values.target,
              max: values.max,
            )),
          ),
        ),
      ],
    );

    final targetSlider = Row(
      children: [
        Text(context.l10n.target, style: labelStyle),
        Expanded(
          child: Slider(
            value: values.target / base,
            min: 0,
            max: 1,
            onChanged: (value) => onChanged((
              min: values.min,
              target: value * base,
              max: values.max,
            )),
          ),
        ),
      ],
    );

    final maxSlider = Row(
      children: [
        Text(context.l10n.max, style: labelStyle),
        Expanded(
          child: Slider(
            value: values.max / base,
            min: 0,
            max: 1,
            onChanged: (value) => onChanged((
              min: values.min,
              target: values.target,
              max: value * base,
            )),
          ),
        ),
      ],
    );

    return LayoutBuilder(builder: (context, constrain) {
      return Card(
        child: ExpansionTile(
          title: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleSmall!,
            child: title,
          ),
          shape: const Border(),
          leading: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: (animation.value * 3.14) / 2,
                child: child,
              );
            },
            child: const Icon(Icons.chevron_right),
          ),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              textStyle: labelStyle,
              isSelected: [
                values == lowValues(base),
                values == moderateValues(base),
                values == highValues(base),
              ],
              onPressed: (index) {
                RecommendationAttribute newValues = zeroValues;
                switch (index) {
                  case 0:
                    newValues = lowValues(base);
                    break;
                  case 1:
                    newValues = moderateValues(base);
                    break;
                  case 2:
                    newValues = highValues(base);
                    break;
                }

                if (newValues == values) {
                  onChanged(zeroValues);
                } else {
                  onChanged(newValues);
                }
              },
              children: [
                Text(context.l10n.low),
                Text("  ${context.l10n.moderate}  "),
                Text(context.l10n.high),
              ],
            ),
          ),
          onExpansionChanged: (value) {
            if (value) {
              animation.forward();
            } else {
              animation.reverse();
            }
          },
          children: [
            if (constrain.mdAndUp)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: minSlider),
                  Expanded(child: targetSlider),
                  Expanded(child: maxSlider),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    minSlider,
                    targetSlider,
                    maxSlider,
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}
