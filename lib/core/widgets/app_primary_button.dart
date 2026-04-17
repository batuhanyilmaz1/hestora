import 'package:flutter/material.dart';

import 'hestora_gradient_filled_button.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return HestoraGradientFilledButton(
      onPressed: onPressed,
      icon: icon,
      label: Text(label, textAlign: TextAlign.center),
    );
  }
}
