import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// El kitapçığı: koyu zemin + üst sol / üst sağ / alt ambient mavi parlamalar.
class HestoraAmbientBackground extends StatelessWidget {
  const HestoraAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.background),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.85, -0.9),
                radius: 1.0,
                colors: [
                  AppColors.brandPrimary.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.9, -0.75),
                radius: 0.95,
                colors: [
                  AppColors.brandLight.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0.82),
                radius: 1.05,
                colors: [
                  AppColors.brandPrimary.withValues(alpha: 0.2),
                  AppColors.brandLight.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.42, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
