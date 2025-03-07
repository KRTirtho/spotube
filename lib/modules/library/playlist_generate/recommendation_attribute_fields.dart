import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
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
    final minController =
        useShadcnTextEditingController(text: values.min.toString());
    final targetController =
        useShadcnTextEditingController(text: values.target.toString());
    final maxController =
        useShadcnTextEditingController(text: values.max.toString());

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

    final minField = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(context.l10n.min).semiBold(),
        NumberInput(
          controller: minController,
          allowDecimals: false,
        ),
      ],
    );

    final targetField = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(context.l10n.target).semiBold(),
        NumberInput(
          controller: targetController,
          allowDecimals: false,
        ),
      ],
    );

    final maxField = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(context.l10n.max).semiBold(),
        NumberInput(
          controller: maxController,
          allowDecimals: false,
        ),
      ],
    );

    void onSelected(int index) {
      RecommendationAttribute newValues = presets!.values.elementAt(index);
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
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Accordion(
        items: [
          AccordionItem(
            trigger: AccordionTrigger(
              child: SizedBox(
                width: double.infinity,
                child: Basic(
                  title: title.semiBold(),
                  trailing: presets == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            spacing: 5,
                            children: [
                              for (final presetEntry in presets?.entries
                                      .toList() ??
                                  <MapEntry<String, RecommendationAttribute>>[])
                                Toggle(
                                  value: presetEntry.value == values,
                                  style: const ButtonStyle.outline(
                                    size: ButtonSize.small,
                                  ),
                                  onChanged: (value) {
                                    onSelected(
                                      presets!.entries.toList().indexWhere(
                                          (s) => s.key == presetEntry.key),
                                    );
                                  },
                                  child: Text(presetEntry.key),
                                ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                if (constraints.mdAndUp)
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
          ),
        ],
      );
    });
  }
}
