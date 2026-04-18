import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// **Inter** + el kitapçığı tipografi ölçeği (Display … Micro).
abstract final class AppTypography {
  static TextTheme textTheme(TextTheme base) {
    final inter = GoogleFonts.inter();
    final themed = GoogleFonts.interTextTheme(base).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return themed.copyWith(
      // Display 28 / 800
      displayMedium: inter.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
      // Heading 1: 22 / ~750 → w800
      headlineLarge: inter.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      // Heading 2: 18 / 700
      headlineMedium: inter.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.textPrimary,
      ),
      // Title: 15 / 700
      titleLarge: inter.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      // Body large: 14 / 600
      bodyLarge: inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      // Body: 13 / 500
      bodyMedium: inter.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
      // Caption: 11.5 / 500, muted
      bodySmall: inter.copyWith(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: AppColors.textMuted,
      ),
      // Label / tag: 10.5 / 600, info mavisi
      labelMedium: inter.copyWith(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.15,
        color: AppColors.info,
      ),
      // Micro: 10 / 500, muted
      labelSmall: inter.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}
