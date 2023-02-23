import 'package:flutter/material.dart';

import '/widgets.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key, required this.child, this.extra});

  final Widget child;
  final Object? extra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: appBar(title: extra, context: context),
      backgroundColor: Colors.white,
    );
  }
}
