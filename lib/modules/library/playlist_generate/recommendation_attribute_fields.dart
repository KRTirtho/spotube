import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/modules/library/playlist_generate/recommendation_attribute_dials.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate.dart';

class RecommendationAttributeFields extends HookWidget {
  final Widget title;
  final RecommendationAttribute values;
  final ValueChanged<RecommendationAttribute> onChanged;
  final Map<String, RecommendationAttribute>? presets;

  const RecommendationAttributeFields({
    super.key,
    required this.values,
    required this.onChanged,
    required this.title,
    this.presets,
  });

  @override
  Widget build(BuildContext context) {
    final animation = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
        );

    final minController = useTextEditingController(text: values.min.toString());
    final targetController =
        useTextEditingController(text: values.target.toString());
    final maxController = useTextEditingController(text: values.max.toString());

    useEffect(() {
      listener() {
        onChanged((
          min: double.tryParse(minController.text) ?? 0,
          target: double.tryParse(targetController.text) ?? 0,
          max: double.tryParse(maxController.text) ?? 0,
        ));
      }

      minController.addListener(listener);
      targetController.addListener(listener);
      maxController.addListener(listener);

      return () {
        minController.removeListener(listener);
        targetController.removeListener(listener);
        maxController.removeListener(listener);
      };
    }, [values]);

    final minField = TextField(
      controller: minController,
      decoration: InputDecoration(
        labelText: context.l10n.min,
        isDense: true,
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: true,
      ),
    );

    final targetField = TextField(
      controller: targetController,
      decoration: InputDecoration(
        labelText: context.l10n.target,
        isDense: true,
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: true,
      ),
    );

    final maxField = TextField(
      controller: maxController,
      decoration: InputDecoration(
        labelText: context.l10n.max,
        isDense: true,
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: true,
      ),
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
          trailing: presets == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    textStyle: labelStyle,
                    isSelected: presets!.values
                        .map((value) => value == values)
                        .toList(),
                    onPressed: (index) {
                      RecommendationAttribute newValues =
                          presets!.values.elementAt(index);
                      if (newValues == values) {
                        onChanged(zeroValues);
                        minController.text = zeroValues.min.toString();
                        targetController.text = zeroValues.target.toString();
                        maxController.text = zeroValues.max.toString();
                      } else {
                        onChanged(newValues);
                        minController.text = newValues.min.toString();
                        targetController.text = newValues.target.toString();
                        maxController.text = newValues.max.toString();
                      }
                    },
                    children: presets!.keys.map((key) => Text(key)).toList(),
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
            const SizedBox(height: 8),
            if (constrain.mdAndUp)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: minField),
                  const SizedBox(width: 16),
                  Expanded(child: targetField),
                  const SizedBox(width: 16),
                  Expanded(child: maxField),
                  const SizedBox(width: 16),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    minField,
                    const SizedBox(height: 16),
                    targetField,
                    const SizedBox(height: 16),
                    maxField,
                  ],
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    });
  }
}
