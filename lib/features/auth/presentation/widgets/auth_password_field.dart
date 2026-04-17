import 'package:flutter/material.dart';

import 'auth_caps_field.dart';

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.validator,
    this.autofillHints,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AuthCapsField(
      label: widget.label,
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: _obscure,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.white54,
        ),
      ),
    );
  }
}
