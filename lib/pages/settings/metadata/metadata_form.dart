import 'package:auto_route/auto_route.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/components/markdown/markdown.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';

@RoutePage()
class SettingsMetadataProviderFormPage extends HookConsumerWidget {
  final String title;
  final List<MetadataFormFieldObject> fields;
  const SettingsMetadataProviderFormPage({
    super.key,
    required this.title,
    required this.fields,
  });

  @override
  Widget build(BuildContext context, ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(title),
          ),
        ],
        child: FormBuilder(
          key: formKey,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 600),
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.theme.typography.h2,
                    ),
                  ),
                  const SliverGap(24),
                  SliverList.separated(
                    itemCount: fields.length,
                    separatorBuilder: (context, index) => const Gap(12),
                    itemBuilder: (context, index) {
                      if (fields[index] is MetadataFormFieldTextObject) {
                        final field =
                            fields[index] as MetadataFormFieldTextObject;
                        return AppMarkdown(data: field.text);
                      }

                      final field =
                          fields[index] as MetadataFormFieldInputObject;
                      return FormBuilderField(
                        name: field.id,
                        initialValue: field.defaultValue,
                        validator: FormBuilderValidators.compose([
                          if (field.required == true)
                            FormBuilderValidators.required(
                              errorText: 'This field is required',
                            ),
                          if (field.regex != null)
                            FormBuilderValidators.match(
                              RegExp(field.regex!),
                              errorText:
                                  context.l10n.input_does_not_match_format,
                            ),
                        ]),
                        builder: (formField) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              TextField(
                                placeholder: field.placeholder == null
                                    ? null
                                    : Text(field.placeholder!),
                                initialValue: formField.value,
                                onChanged: (value) {
                                  formField.didChange(value);
                                },
                                obscureText:
                                    field.variant == FormFieldVariant.password,
                                keyboardType:
                                    field.variant == FormFieldVariant.number
                                        ? TextInputType.number
                                        : TextInputType.text,
                                features: [
                                  if (field.variant ==
                                      FormFieldVariant.password)
                                    const InputFeature.passwordToggle(),
                                ],
                              ),
                              if (formField.hasError)
                                Text(
                                  formField.errorText ?? '',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SliverGap(24),
                  SliverToBoxAdapter(
                    child: Button.primary(
                      onPressed: () {
                        if (formKey.currentState?.saveAndValidate() != true) {
                          return;
                        }

                        final data = formKey.currentState!.value.entries
                            .map((e) => <String, dynamic>{
                                  "id": e.key,
                                  "value": e.value,
                                })
                            .toList();

                        context.router.maybePop(data);
                      },
                      child: Text(context.l10n.submit),
                    ),
                  ),
                  const SliverGap(200)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
