import 'package:flutter/material.dart';

/// Auth flow (giriş / kayıt) — referans mockup renkleri.
abstract final class AuthUi {
  static const Color scaffold = Color(0xFF050A18);
  static const Color labelCaps = Color(0xFF7DD3FC);
  static const Color subline = Color(0xFF93C5FD);
  static const Color inputFill = Color(0xFF0F172A);
  static const Color inputBorder = Color(0xFF1E3A5F);
  static const Color cardTint = Color(0xFF0B1224);

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2563EB),
      Color(0xFF1D4ED8),
      Color(0xFF1E3A8A),
    ],
  );

  static BoxDecoration scaffoldDecoration() {
    return const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment(0.0, -0.45),
        radius: 1.15,
        colors: [
          Color(0xFF0F172A),
          scaffold,
        ],
      ),
    );
  }

  static BoxDecoration formCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: cardTint.withValues(alpha: 0.92),
      border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF2563EB).withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}
