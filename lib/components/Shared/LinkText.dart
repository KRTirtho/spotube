import 'package:flutter/material.dart';

class LinkText<T> extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAign;
  final TextOverflow? overflow;
  final Route<T> route;

  const LinkText(
    this.text,
    this.route, {
    Key? key,
    this.textAign,
    this.overflow,
    this.style = const TextStyle(),
  }) : super(key: key);

  @override
  State<LinkText<T>> createState() => _LinkTextState<T>();
}

class _LinkTextState<T> extends State<LinkText<T>> {
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
          textAlign: widget.textAign,
          overflow: widget.overflow,
        ),
        onEnter: (event) => setState(() => _hover = true),
        onExit: (event) => setState(() => _hover = false),
      ),
      onTapDown: (event) => setState(() => _tap = true),
      onTapUp: (event) => setState(() => _tap = false),
      onTap: () {
        Navigator.of(context).push(widget.route);
      },
    );
  }
}
