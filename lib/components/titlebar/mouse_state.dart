import 'package:flutter/material.dart';

typedef MouseStateBuilderCB = Widget Function(
    BuildContext context, MouseState mouseState);

class MouseState {
  bool isMouseOver = false;
  bool isMouseDown = false;
  MouseState();
  @override
  String toString() {
    return "isMouseDown: $isMouseDown - isMouseOver: $isMouseOver";
  }
}

T? _ambiguate<T>(T? value) => value;

class MouseStateBuilder extends StatefulWidget {
  final MouseStateBuilderCB builder;
  final VoidCallback? onPressed;
  const MouseStateBuilder({super.key, required this.builder, this.onPressed});
  @override
  // ignore: library_private_types_in_public_api
  _MouseStateBuilderState createState() => _MouseStateBuilderState();
}

class _MouseStateBuilderState extends State<MouseStateBuilder> {
  late MouseState _mouseState;
  _MouseStateBuilderState() {
    _mouseState = MouseState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _mouseState.isMouseOver = true;
        });
      },
      onExit: (event) {
        setState(() {
          _mouseState.isMouseOver = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _mouseState.isMouseDown = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _mouseState.isMouseDown = false;
          });
        },
        onTap: () {
          setState(() {
            _mouseState.isMouseDown = false;
            _mouseState.isMouseOver = false;
          });
          _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
            if (widget.onPressed != null) {
              widget.onPressed!();
            }
          });
        },
        onTapUp: (_) {},
        child: widget.builder(context, _mouseState),
      ),
    );
  }
}
