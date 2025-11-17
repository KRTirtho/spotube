import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class TextFormBuilderField extends StatelessWidget {
  final String name;
  final FormFieldValidator<String>? validator;
  final Widget? label;

  final TextEditingController? controller;
  final bool filled;
  final Widget? placeholder;
  // final AlignmentGeometry? placeholderAlignment;
  // final AlignmentGeometry? leadingAlignment;
  // final AlignmentGeometry? trailingAlignment;
  final Border? border;
  final List<InputFeature> features;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final String obscuringCharacter;
  final String? initialValue;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final BorderRadiusGeometry? borderRadius;
  final TextAlign textAlign;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final UndoHistoryController? undoController;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final void Function(PointerDownEvent event)? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  // final EditableTextContextMenuBuilder? contextMenuBuilder;
  // final bool useNativeContextMenu;
  // final bool? isCollapsed;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Clip clipBehavior;
  final bool autofocus;
  final WidgetStatesController? statesController;

  const TextFormBuilderField({
    super.key,
    required this.name,
    this.label,
    this.validator,
    this.controller,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.filled = false,
    this.placeholder,
    this.border,
    this.padding,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.initialValue,
    this.borderRadius,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.expands = false,
    this.textAlignVertical = TextAlignVertical.center,
    this.autofillHints,
    this.undoController,
    this.onChanged,
    this.onTapOutside,
    this.inputFormatters,
    this.style,
    // this.contextMenuBuilder = TextField.defaultContextMenuBuilder,
    // this.useNativeContextMenu = false,
    // this.isCollapsed,
    this.textInputAction,
    this.clipBehavior = Clip.hardEdge,
    this.autofocus = false,
    // this.placeholderAlignment,
    // this.leadingAlignment,
    // this.trailingAlignment,
    this.statesController,
    this.features = const [],
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: name,
      validator: validator,
      onChanged: (value) {
        if (value == null) return;
        onChanged?.call(value);
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          if (label != null)
            DefaultTextStyle(
              style: context.theme.typography.semiBold.copyWith(
                color: field.hasError
                    ? context.theme.colorScheme.destructive
                    : context.theme.colorScheme.foreground,
              ),
              child: label!,
            ),
          TextField(
            controller: controller,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            maxLines: maxLines,
            minLines: minLines,
            filled: filled,
            placeholder: placeholder,
            border: border,
            features: features,
            padding: padding,
            onSubmitted: (value) {
              field.validate();
              field.save();
              onSubmitted?.call(value);
            },
            onEditingComplete: () {
              field.save();
              onEditingComplete?.call();
            },
            focusNode: focusNode,
            onTap: onTap,
            enabled: enabled,
            readOnly: readOnly,
            obscureText: obscureText,
            obscuringCharacter: obscuringCharacter,
            initialValue: field.value,
            borderRadius: borderRadius,
            textAlign: textAlign,
            expands: expands,
            textAlignVertical: textAlignVertical,
            autofillHints: autofillHints,
            undoController: undoController,
            onChanged: (value) {
              field.didChange(value);
            },
            onTapOutside: onTapOutside,
            inputFormatters: inputFormatters,
            style: style,
            // contextMenuBuilder: contextMenuBuilder,
            // useNativeContextMenu: useNativeContextMenu,
            // isCollapsed: isCollapsed,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            clipBehavior: clipBehavior,
            autofocus: autofocus,
            // placeholderAlignment: placeholderAlignment,
            // leadingAlignment: leadingAlignment,
            // trailingAlignment: trailingAlignment,
            statesController: statesController,
          ),
          if (field.hasError)
            Text(
              field.errorText ?? "",
              style: TextStyle(
                color: context.theme.colorScheme.destructive,
              ),
            ),
        ],
      ),
    );
  }
}
