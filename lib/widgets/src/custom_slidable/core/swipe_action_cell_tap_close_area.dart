import 'package:flutter/cupertino.dart';

import 'controller.dart';

///This widget maybe not compatible with nested action...
class SwipeActionCellTapCloseArea extends StatelessWidget {
  final Widget child;

  final SwipeActionController _controller = SwipeActionController();

  SwipeActionCellTapCloseArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _controller.closeAllOpenCell();
      },
      child: child,
    );
  }
}
