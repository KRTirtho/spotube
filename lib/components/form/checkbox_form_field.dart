import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CheckboxFormBuilderField extends StatelessWidget {
  final String name;
  final FormFieldValidator<bool>? validator;

  final ValueChanged<CheckboxState>? onChanged;
  final Widget? leading;
  final Widget? trailing;
  final bool tristate;
  const CheckboxFormBuilderField({
    super.key,
    required this.name,
    this.validator,
    this.onChanged,
    this.leading,
    this.trailing,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: name,
      validator: validator,
      builder: (field) {
        return Checkbox(
          state: tristate && field.value == null
              ? CheckboxState.indeterminate
              : field.value == true
                  ? CheckboxState.checked
                  : CheckboxState.unchecked,
          onChanged: (state) {
            field.didChange(state == CheckboxState.checked);
            onChanged?.call(state);
          },
          leading: leading,
          trailing: trailing,
          tristate: tristate,
        );
      },
    );
  }
}
