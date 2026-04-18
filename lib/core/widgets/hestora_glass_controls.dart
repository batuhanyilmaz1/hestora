import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// İkon container (el kitapçığı — hafif yükseltme, ince çerçeve, marka mavisi + glow).
abstract final class HestoraGlassControls {
  static const Color surfaceHighlight = Color(0xFF15263D);
  static const Color surfaceDeep = AppColors.bgBase;
  static const Color rim = AppColors.border;
  static const Color icon = AppColors.brandLight;
  static const Color iconGlow = AppColors.brandPrimary;

  static BoxDecoration circleDecoration({bool pressed = false}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        center: const Alignment(-0.42, -0.42),
        radius: 1.05,
        colors: [
          surfaceHighlight,
          pressed ? AppColors.bgSurface : surfaceDeep,
        ],
      ),
      border: Border.all(
        color: pressed ? iconGlow.withValues(alpha: 0.55) : rim.withValues(alpha: 0.85),
        width: pressed ? 1.25 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.55),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.brandGlow.withValues(alpha: 0.65),
          blurRadius: 14,
          spreadRadius: -2,
        ),
      ],
    );
  }

  /// İkincil pill (GHOST / dolu küçük aksiyon).
  static BoxDecoration pillDecoration({
    required bool filled,
    bool pressed = false,
  }) {
    final gradient = filled
        ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.brandDim,
              AppColors.bgSurface,
            ],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              surfaceHighlight.withValues(alpha: 0.92),
              surfaceDeep,
            ],
          );

    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadii.md),
      gradient: gradient,
      border: Border.all(
        color: filled
            ? AppColors.brandPrimary.withValues(alpha: pressed ? 0.95 : 0.7)
            : rim.withValues(alpha: pressed ? 0.95 : 0.75),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.45),
          blurRadius: pressed ? 6 : 12,
          offset: const Offset(0, 4),
        ),
        if (filled)
          BoxShadow(
            color: AppColors.brandGlow.withValues(alpha: 0.8),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
      ],
    );
  }
}

/// Dairesel glass ikon düğmesi (geri ok vb.).
class HestoraGlassIconButton extends StatefulWidget {
  const HestoraGlassIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 44,
    this.iconSize = 19,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final double iconSize;
  final String? tooltip;

  @override
  State<HestoraGlassIconButton> createState() => _HestoraGlassIconButtonState();
}

class _HestoraGlassIconButtonState extends State<HestoraGlassIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final child = SizedBox(
      width: widget.size,
      height: widget.size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: enabled ? widget.onPressed : null,
          child: Ink(
            decoration: HestoraGlassControls.circleDecoration(pressed: _pressed),
            child: Center(
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: enabled ? HestoraGlassControls.icon : HestoraGlassControls.icon.withValues(alpha: 0.35),
                shadows: enabled
                    ? [
                        Shadow(
                          color: HestoraGlassControls.iconGlow.withValues(alpha: 0.45),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      return Tooltip(message: widget.tooltip!, child: child);
    }
    return child;
  }
}
