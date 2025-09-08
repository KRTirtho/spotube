import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
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
    final labelStyle = Theme.of(context).typography.small.copyWith(
          fontWeight: FontWeight.w500,
        );

    final minSlider = Row(
      spacing: 5,
      children: [
        Text(context.l10n.min, style: labelStyle),
        Expanded(
          child: Slider(
            value: SliderValue.single(values.min / base),
            min: 0,
            max: 1,
            onChanged: (value) => onChanged((
              min: value.value * base,
              target: values.target,
              max: values.max,
            )),
          ),
        ),
      ],
    );

    final targetSlider = Row(
      spacing: 5,
      children: [
        Text(context.l10n.target, style: labelStyle),
        Expanded(
          child: Slider(
            value: SliderValue.single(values.target / base),
            min: 0,
            max: 1,
            onChanged: (value) => onChanged((
              min: values.min,
              target: value.value * base,
              max: values.max,
            )),
          ),
        ),
      ],
    );

    final maxSlider = Row(
      spacing: 5,
      children: [
        Text(context.l10n.max, style: labelStyle),
        Expanded(
          child: Slider(
            value: SliderValue.single(values.max / base),
            min: 0,
            max: 1,
            onChanged: (value) => onChanged((
              min: values.min,
              target: values.target,
              max: value.value * base,
            )),
          ),
        ),
      ],
    );

    void onSelected(int index) {
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
    }

    return LayoutBuilder(builder: (context, constrain) {
      return Accordion(
        items: [
          AccordionItem(
            trigger: AccordionTrigger(
              child: SizedBox(
                width: double.infinity,
                child: Basic(
                  title: title.semiBold(),
                  trailing: Row(
                    spacing: 5,
                    children: [
                      Toggle(
                        value: values == lowValues(base),
                        onChanged: (value) => onSelected(0),
                        style:
                            const ButtonStyle.outline(size: ButtonSize.small),
                        child: Text(context.l10n.low),
                      ),
                      Toggle(
                        value: values == moderateValues(base),
                        onChanged: (value) => onSelected(1),
                        style:
                            const ButtonStyle.outline(size: ButtonSize.small),
                        child: Text(context.l10n.moderate),
                      ),
                      Toggle(
                        value: values == highValues(base),
                        onChanged: (value) => onSelected(2),
                        style:
                            const ButtonStyle.outline(size: ButtonSize.small),
                        child: Text(context.l10n.high),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
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
          ),
        ],
      );
    });
  }
}
