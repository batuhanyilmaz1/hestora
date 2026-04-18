import 'package:flutter/material.dart';

import '../theme/app_radii.dart';

/// Compact brand thumb that does not depend on optional SVG assets.
class HestoraBrandThumb extends StatelessWidget {
  const HestoraBrandThumb({super.key, this.height = 44});

  /// Logo height; width scales with aspect (~3:1 wordmark).
  final double height;

  @override
  Widget build(BuildContext context) {
    final w = height * 2.6;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.xs),
      child: Container(
        width: w,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: height * 0.24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
          ),
          borderRadius: BorderRadius.circular(AppRadii.xs),
          border: Border.all(color: const Color(0x3347B5FF)),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: height * 0.6,
              height: height * 0.6,
              decoration: BoxDecoration(
                color: const Color(0xFF1D4ED8).withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(height * 0.18),
              ),
              alignment: Alignment.center,
              child: Text(
                'H',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFFBFDBFE),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            SizedBox(width: height * 0.18),
            Flexible(
              child: Text(
                'Hestora',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFFF8FAFC),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
