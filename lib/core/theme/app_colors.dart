import 'package:flutter/material.dart';

/// Hestora **el kitapçığı** — arka plan, marka, metin ve durum renkleri.
/// Uygulama genelinde `AppColors.*` ve türetilen tema kullanılmalıdır.
abstract final class AppColors {
  // --- Background ---
  static const Color bgBase = Color(0xFF05080E);
  static const Color bgSurface = Color(0xFF0A1020);
  static const Color bgElevated = Color(0xFF101828);
  static const Color bgOverlay = Color(0xFF162030);

  // --- Brand ---
  static const Color brandPrimary = Color(0xFF3070E0);
  static const Color brandLight = Color(0xFF5A9AEE);
  static const Color brandDim = Color(0xFF1A52C0);

  /// rgba(30, 80, 200, 0.32) — glow / halo.
  static Color get brandGlow => Color.fromRGBO(30, 80, 200, 0.32);

  // --- Text ---
  static const Color textPrimary = Color(0xFFEEF4FF);
  static const Color textSecondary = Color(0xFFB8D0EC);
  static const Color textMuted = Color(0xFF3A5272);
  static const Color textDisabled = Color(0xFF1E3050);

  // --- Status ---
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color statusPurple = Color(0xFF8B5CF6);
  static const Color cyan = Color(0xFF0891B2);

  /// Input alanları (spec ~#121821).
  static const Color inputFill = Color(0xFF121821);

  // --- Semantic aliases (Material / mevcut kod uyumu) ---
  static const Color primary = brandPrimary;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color background = bgBase;
  static const Color surface = bgSurface;
  static const Color surfaceElevated = bgElevated;
  static const Color surfaceMuted = bgOverlay;

  static const Color border = Color(0xFF2A3F5C);
  static const Color borderFocus = brandLight;

  static const Color accentPurple = statusPurple;
  static const Color accentTeal = cyan;
  static const Color accentGold = Color(0xFFE8C547);

  /// Shell sayfaları şeffaf scaffold + [HestoraAmbientBackground].
  static const Color profileScaffold = Color(0x00000000);

  /// Standart kart gölgesi (el kitapçığı — kart).
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.38),
          blurRadius: 22,
          offset: const Offset(0, 10),
          spreadRadius: -4,
        ),
      ];
}
