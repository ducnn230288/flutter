import 'package:flutter/material.dart';

class WButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final Type? type;

  const WButton({super.key, required this.onPressed,required this.child, this.style, this.type = ElevatedButton});

  @override
  Widget build(BuildContext context) {
    switch(type) {
      case const (TextButton):
        return TextButton(
          style: style,
          onPressed: onPressed,
          child: child,
        );
      default:
        return ElevatedButton(
          style: style,
          onPressed: onPressed,
          child: child,
        );
    }

  }
}
