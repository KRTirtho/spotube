import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool selected;
  final AbstractButtonStyle style;
  final EdgeInsets? padding;

  const ButtonTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.selected = false,
    this.padding,
    this.style = ButtonVariance.outline,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData(:colorScheme, :typography) = Theme.of(context);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Button(
        enabled: enabled,
        onPressed: onPressed,
        style: style.copyWith(
          padding:
              padding != null ? (context, states, value) => padding! : null,
          decoration: (context, states, value) {
            final decoration =
                style.decoration(context, states) as BoxDecoration;

            if (selected) {
              return switch (style) {
                ButtonVariance.outline => decoration.copyWith(
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 1.0,
                    ),
                    color: colorScheme.primary.withAlpha(25),
                  ),
                ButtonVariance.ghost || _ => decoration.copyWith(
                    color: colorScheme.primary.withAlpha(25),
                  ),
              };
            }

            return decoration;
          },
          iconTheme: (context, states, value) {
            final iconTheme = style.iconTheme(context, states);

            if (selected && style == ButtonVariance.outline) {
              return iconTheme.copyWith(
                color: colorScheme.primary,
              );
            }

            return iconTheme;
          },
          textStyle: (context, states, value) {
            final textStyle = style.textStyle(context, states);

            if (selected && style == ButtonVariance.outline) {
              return textStyle.copyWith(
                color: colorScheme.primary,
              );
            }

            return textStyle;
          },
        ),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Basic(
            padding: EdgeInsets.zero,
            leadingAlignment: Alignment.center,
            trailingAlignment: Alignment.center,
            leading: leading,
            title: title,
            subtitle:
                style == ButtonVariance.outline && selected && subtitle != null
                    ? DefaultTextStyle(
                        style: typography.xSmall.copyWith(
                          color: colorScheme.primary,
                        ),
                        child: subtitle!,
                      )
                    : subtitle,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}
