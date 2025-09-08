import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';

class SettingsPlaybackEditInstanceUrlDialog extends HookConsumerWidget {
  final String title;
  final String? initialValue;
  final ValueChanged<String> onSave;

  const SettingsPlaybackEditInstanceUrlDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = useShadcnTextEditingController(
      text: initialValue,
    );
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    return Alert(
      title: Text(title).h4(),
      content: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            const Gap(10),
            TextFormBuilderField(
              name: "url",
              controller: controller,
              placeholder: Text(title),
              validator: FormBuilderValidators.url(),
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: Button.secondary(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(context.l10n.cancel),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Button.primary(
                    onPressed: () {
                      if (!formKey.currentState!.saveAndValidate()) {
                        return;
                      }
                      onSave(
                        controller.text,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(context.l10n.save),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
