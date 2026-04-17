import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProfileSupportPage extends StatelessWidget {
  const ProfileSupportPage({super.key});

  Future<void> _openEmail(BuildContext context, AppLocalizations l10n) async {
    final email = l10n.profileSupportEmailAddress;
    final subject = Uri.encodeComponent(l10n.profileSupportEmailSubject);
    final uri = Uri.parse('mailto:$email?subject=$subject');
    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.profileSupportTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l10n.profileSupportSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => _openEmail(context, l10n),
            icon: const Icon(Icons.email_outlined),
            label: Text(l10n.profileSupportEmailCta),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.profileSupportFaqHeading,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.08,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _FaqTile(
            title: l10n.profileSupportFaq1Title,
            body: l10n.profileSupportFaq1Body,
          ),
          const SizedBox(height: AppSpacing.sm),
          _FaqTile(
            title: l10n.profileSupportFaq2Title,
            body: l10n.profileSupportFaq2Body,
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      backgroundColor: AppColors.surface.withValues(alpha: 0.45),
      collapsedBackgroundColor: AppColors.surface.withValues(alpha: 0.45),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
