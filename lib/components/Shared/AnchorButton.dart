import 'package:flutter/material.dart';

class AnchorButton<T> extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final void Function()? onTap;

  const AnchorButton(
    this.text, {
    Key? key,
    this.onTap,
    this.textAlign,
    this.overflow,
    this.style = const TextStyle(),
  }) : super(key: key);

  @override
  State<AnchorButton<T>> createState() => _AnchorButtonState<T>();
}

class _AnchorButtonState<T> extends State<AnchorButton<T>> {
  bool _hover = false;
  bool _tap = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        cursor: MaterialStateMouseCursor.clickable,
        child: Text(
          widget.text,
          style: widget.style.copyWith(
            decoration: _hover || _tap ? TextDecoration.underline : null,
          ),
          textAlign: widget.textAlign,
          overflow: widget.overflow,
        ),
        onEnter: (event) => setState(() => _hover = true),
        onExit: (event) => setState(() => _hover = false),
      ),
      onTapDown: (event) => setState(() => _tap = true),
      onTapUp: (event) => setState(() => _tap = false),
      onTap: widget.onTap,
    );
  }
}
