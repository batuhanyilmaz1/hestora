import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shell / ana sayfa — [AppColors] el kitapçığı ile hizalı türetilmiş tonlar.
abstract final class HomeShellTheme {
  static const Color scaffold = AppColors.background;
  static const Color navBar = Color(0xFF03060B);
  static const Color card = AppColors.surfaceElevated;
  static const Color primaryBlue = AppColors.brandPrimary;
  static const Color primaryBlueGlow = AppColors.brandLight;
  static const Color borderBlue = AppColors.info;
  static const Color textLightBlue = AppColors.brandLight;
  static const Color welcomeCyan = AppColors.cyan;
  static const Color gold = AppColors.accentGold;
  static const Color secondaryButtonFill = AppColors.surface;
  static const Color tipBarFill = AppColors.bgOverlay;
}
