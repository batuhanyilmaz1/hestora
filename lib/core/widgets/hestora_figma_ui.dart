import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import 'hestora_glass_controls.dart';

/// Profil / ödeme ekranları — [AppColors] ile aynı tokenlar (const uyumu).
abstract final class HestoraFigma {
  static const Color sheetBg = AppColors.bgOverlay;
  static const Color cardFill = AppColors.surfaceElevated;
  static const Color mutedText = AppColors.textSecondary;
  static const Color divider = AppColors.border;
  static const double sheetTopRadius = 28;
}

class HestoraFigmaHeader extends StatelessWidget {
  const HestoraFigmaHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            HestoraGlassIconButton(
              onPressed: onBack,
              icon: Icons.arrow_back_ios_new_rounded,
              iconSize: 17,
            ),
          if (onBack != null) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HestoraFigma.mutedText,
                          height: 1.35,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class HestoraFigmaCard extends StatelessWidget {
  const HestoraFigmaCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: HestoraFigma.cardFill,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: AppColors.cardShadow,
      ),
      child: child,
    );
  }
}

Future<T?> showHestoraBottomSheet<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required Widget Function(BuildContext context, ScrollController scrollController) body,
  double initialChildSize = 0.55,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialChildSize,
        minChildSize: 0.35,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          final sheetSubtitle = subtitle;
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: HestoraFigma.sheetBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(HestoraFigma.sheetTopRadius)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            if (sheetSubtitle != null && sheetSubtitle.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                sheetSubtitle,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: HestoraFigma.mutedText,
                                      height: 1.35,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      HestoraGlassIconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icons.close_rounded,
                        size: 40,
                        iconSize: 22,
                        tooltip: MaterialLocalizations.of(ctx).closeButtonTooltip,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: HestoraFigma.divider),
                Expanded(child: body(context, scrollController)),
              ],
            ),
          );
        },
      );
    },
  );
}
