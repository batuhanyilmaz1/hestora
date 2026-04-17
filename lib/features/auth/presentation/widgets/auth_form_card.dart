import 'package:flutter/material.dart';

import 'auth_ui_constants.dart';

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AuthUi.formCardDecoration(),
      child: child,
    );
  }
}
