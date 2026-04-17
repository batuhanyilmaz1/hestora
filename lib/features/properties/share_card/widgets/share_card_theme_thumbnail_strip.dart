import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/share_card_layout_data.dart';
import '../models/share_card_theme_definition.dart';
import '../share_card_themes.dart';
import 'property_share_card_template_view.dart';

/// Horizontal önizleme: her tema [ShareCardLayoutData.mockSample] ile küçük kart olarak gösterilir.
class ShareCardThemeThumbnailStrip extends StatelessWidget {
  const ShareCardThemeThumbnailStrip({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.title,
  });

  final ShareCardThemeDefinition selected;
  final ValueChanged<ShareCardThemeDefinition> onSelect;
  final String title;

  static const double _thumbW = 72;

  @override
  Widget build(BuildContext context) {
    final stripH = shareCardThemes.fold<double>(
      96,
      (m, t) => math.max(m, _thumbW / t.aspectRatio + 12),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: stripH,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: shareCardThemes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final t = shareCardThemes[index];
              final th = _thumbW / t.aspectRatio;
              final isSel = t.id == selected.id;
              return Semantics(
                button: true,
                label: t.label,
                selected: isSel,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelect(t),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: _thumbW + 6,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(
                          color: isSel ? AppColors.primary : AppColors.border,
                          width: isSel ? 2.5 : 1,
                        ),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                        child: SizedBox(
                          width: _thumbW,
                          height: th,
                          child: PropertyShareCardTemplateView(
                            theme: t,
                            data: ShareCardLayoutData.mockSample(),
                            width: _thumbW,
                            height: th,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
