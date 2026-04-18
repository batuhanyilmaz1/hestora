import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';

/// Auth akışı — [AppColors] el kitapçığı ile hizalı.
abstract final class AuthUi {
  static const Color scaffold = AppColors.background;
  static const Color labelCaps = AppColors.textSecondary;
  static const Color subline = AppColors.brandLight;
  static const Color inputFill = AppColors.inputFill;
  static const Color inputBorder = AppColors.border;
  static const Color cardTint = AppColors.bgSurface;

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.brandLight,
      AppColors.brandPrimary,
      AppColors.brandDim,
    ],
  );

  static BoxDecoration scaffoldDecoration() {
    return BoxDecoration(
      gradient: RadialGradient(
        center: const Alignment(0.0, -0.45),
        radius: 1.15,
        colors: [
          AppColors.bgSurface,
          scaffold,
        ],
      ),
    );
  }

  static BoxDecoration formCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadii.xl),
      color: cardTint.withValues(alpha: 0.94),
      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      boxShadow: [
        BoxShadow(
          color: AppColors.brandGlow.withValues(alpha: 0.5),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}
