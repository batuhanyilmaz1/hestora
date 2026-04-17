import 'package:flutter/material.dart';

/// Hestora dark design system palette (CRM handoff).
abstract final class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFF05070A);
  /// Shell pages use transparent scaffold so [HestoraAmbientBackground] shows through.
  static const Color profileScaffold = Color(0x00000000);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF141D2E);
  static const Color surfaceMuted = Color(0xFF1E293B);

  static const Color border = Color(0xFF273449);
  static const Color borderFocus = primary;

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF06B6D4);

  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentTeal = Color(0xFF14B8A6);
  /// Brand gold (wordmark / highlights in CRM mockups).
  static const Color accentGold = Color(0xFFE8C547);
}
