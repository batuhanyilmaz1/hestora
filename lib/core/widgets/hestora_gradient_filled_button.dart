import 'package:flutter/material.dart';

import '../theme/home_shell_theme.dart';

/// Shiny blue primary CTA (reference handoff).
class HestoraGradientFilledButton extends StatelessWidget {
  const HestoraGradientFilledButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    this.borderRadius = 16,
    this.expandWidth = true,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool expandWidth;

  static const List<Color> _gradientColors = [
    Color(0xFF60A5FA),
    Color(0xFF2563EB),
    Color(0xFF1D4ED8),
    Color(0xFF172554),
  ];

  static const List<double> _stops = [0.0, 0.28, 0.58, 1.0];

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Colors.white.withValues(alpha: 0.22),
        highlightColor: Colors.white.withValues(alpha: 0.06),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: expandWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 10),
              ],
              if (expandWidth)
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    child: label,
                  ),
                )
              else
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  child: label,
                ),
            ],
          ),
        ),
      ),
    );

    final gradientBox = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _gradientColors,
          stops: _stops,
        ),
        boxShadow: [
          BoxShadow(
            color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.55),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: HomeShellTheme.primaryBlue.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: content,
    );

    final wrapped = Opacity(
      opacity: enabled ? 1 : 0.5,
      child: gradientBox,
    );

    if (expandWidth) {
      return SizedBox(width: double.infinity, child: wrapped);
    }
    return wrapped;
  }
}
