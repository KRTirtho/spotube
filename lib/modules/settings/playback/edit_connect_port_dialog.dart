import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/form/text_form_field.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class SettingsPlaybackEditConnectPortDialog extends HookConsumerWidget {
  const SettingsPlaybackEditConnectPortDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final connectPort = ref.watch(
      userPreferencesProvider.select((s) => s.connectPort),
    );
    final controller = useShadcnTextEditingController(
      text: connectPort.toString(),
    );
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Alert(
        title: Text(context.l10n.edit_port).h4(),
        content: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              const Gap(10),
              TextFormBuilderField(
                name: "port",
                controller: controller,
                placeholder: const Text("3000"),
                validator: FormBuilderValidators.integer(radix: 10),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  // Allow only signed integers
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      if (newValue.text.isEmpty) {
                        return const TextEditingValue();
                      }
                      if (newValue.text.length == 1 && newValue.text == "-") {
                        return newValue;
                      }

                      final intValue = int.tryParse(newValue.text);
                      if (intValue == null) {
                        return oldValue;
                      }
                      return newValue;
                    },
                  ),
                ],
              ),
              const Gap(5),
              Text(context.l10n.port_helper_msg).small.muted,
              const Gap(20),
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
                        final port = int.parse(controller.text);
                        ref
                            .read(userPreferencesProvider.notifier)
                            .setConnectPort(port);
                        Navigator.of(context).pop();
                      },
                      child: Text(context.l10n.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
