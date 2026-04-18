import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Referans: Destek / Yardım — KVKK, SSS, Bize Ulaşın kartı.
class ProfileSupportPage extends StatelessWidget {
  const ProfileSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
              child: HestoraFigmaHeader(
                title: l10n.profileSupportTitle,
                subtitle: l10n.profileSupportSubtitle,
                onBack: () => context.pop(),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
                children: [
                  HestoraFigmaCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _SupportTile(
                          icon: Icons.shield_outlined,
                          iconColor: const Color(0xFFA78BFA),
                          iconBg: const Color(0xFF4C1D95).withValues(alpha: 0.35),
                          title: l10n.supportTileKvkkTitle,
                          subtitle: l10n.supportTileKvkkSubtitle,
                          onTap: () => context.push('/profile/kvkk'),
                        ),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.85)),
                        _SupportTile(
                          icon: Icons.forum_outlined,
                          iconColor: const Color(0xFF2DD4BF),
                          iconBg: const Color(0xFF134E4A).withValues(alpha: 0.45),
                          title: l10n.supportTileFaqTitle,
                          subtitle: l10n.supportTileFaqSubtitle,
                          onTap: () => context.push('/profile/faq'),
                        ),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.85)),
                        _SupportTile(
                          icon: Icons.headset_mic_outlined,
                          iconColor: HomeShellTheme.textLightBlue,
                          iconBg: HomeShellTheme.primaryBlue.withValues(alpha: 0.22),
                          title: l10n.supportTileContactTitle,
                          subtitle: l10n.supportTileContactSubtitle,
                          onTap: () => context.push('/profile/contact'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: Text(
                      l10n.supportRightsFooter,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: HestoraFigma.mutedText.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: HestoraFigma.mutedText,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.28)),
            ],
          ),
        ),
      ),
    );
  }
}
