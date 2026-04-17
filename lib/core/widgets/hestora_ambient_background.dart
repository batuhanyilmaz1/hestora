import 'package:flutter/material.dart';

import '../theme/home_shell_theme.dart';

/// Reference Emlaklar mockup: deep black base + soft blue radial glows.
class HestoraAmbientBackground extends StatelessWidget {
  const HestoraAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: HomeShellTheme.scaffold),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0.82),
                radius: 1.05,
                colors: [
                  HomeShellTheme.primaryBlue.withValues(alpha: 0.26),
                  HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.28),
                radius: 0.95,
                colors: [
                  HomeShellTheme.borderBlue.withValues(alpha: 0.14),
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
                center: const Alignment(0.85, 0.35),
                radius: 0.75,
                colors: [
                  HomeShellTheme.primaryBlue.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
