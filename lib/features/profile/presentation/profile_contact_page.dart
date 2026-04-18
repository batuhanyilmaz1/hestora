import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Referans: Bize Ulaşın — iletişim kanalları + çalışma saatleri.
class ProfileContactPage extends StatelessWidget {
  const ProfileContactPage({super.key});

  static String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  Future<void> _launchMail(BuildContext context, AppLocalizations l10n) async {
    final email = l10n.contactSupportEmailValue;
    final subject = Uri.encodeComponent(l10n.profileSupportEmailSubject);
    final uri = Uri.parse('mailto:$email?subject=$subject');
    final ok = await launchUrl(uri);
    if (!context.mounted || ok) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(email)));
  }

  Future<void> _launchPhone(BuildContext context, String raw) async {
    final uri = Uri.parse('tel:${_digitsOnly(raw)}');
    final ok = await launchUrl(uri);
    if (!context.mounted || ok) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(raw)));
  }

  Future<void> _launchWhatsapp(BuildContext context, String raw) async {
    final d = _digitsOnly(raw);
    if (d.isEmpty) {
      return;
    }
    final uri = Uri.parse('https://wa.me/$d');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted || ok) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(raw)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final phone = l10n.contactSupportPhoneValue;

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
              child: HestoraFigmaHeader(
                title: l10n.contactUsTitle,
                subtitle: l10n.contactUsSubtitle,
                onBack: () => context.pop(),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
                children: [
                  Text(
                    l10n.contactChannelsTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: HomeShellTheme.textLightBlue,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  HestoraFigmaCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _ChannelRow(
                          icon: Icons.mail_outline_rounded,
                          iconBg: HomeShellTheme.primaryBlue.withValues(alpha: 0.2),
                          iconColor: HomeShellTheme.textLightBlue,
                          label: l10n.contactEmailSupport,
                          value: l10n.contactSupportEmailValue,
                          onTap: () => _launchMail(context, l10n),
                        ),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.85)),
                        _ChannelRow(
                          icon: Icons.chat_rounded,
                          iconBg: const Color(0xFF14532D).withValues(alpha: 0.55),
                          iconColor: const Color(0xFF4ADE80),
                          label: l10n.contactWhatsapp,
                          value: phone,
                          onTap: () => _launchWhatsapp(context, phone),
                        ),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.85)),
                        _ChannelRow(
                          icon: Icons.phone_in_talk_outlined,
                          iconBg: const Color(0xFF134E4A).withValues(alpha: 0.5),
                          iconColor: const Color(0xFF2DD4BF),
                          label: l10n.contactPhone,
                          value: phone,
                          onTap: () => _launchPhone(context, phone),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HestoraFigmaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.contactHoursTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.contactHoursSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: HestoraFigma.mutedText,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _HoursRow(l10n.contactHoursWeekday, l10n.contactHoursWeekdayValue, highlight: false),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.85)),
                        _HoursRow(l10n.contactHoursSaturday, l10n.contactHoursSaturdayValue, highlight: false),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.85)),
                        _HoursRow(l10n.contactHoursSunday, l10n.contactHoursClosed, highlight: true),
                      ],
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

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
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
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: HestoraFigma.mutedText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

class _HoursRow extends StatelessWidget {
  const _HoursRow(this.left, this.right, {required this.highlight});

  final String left;
  final String right;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            right,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: highlight ? const Color(0xFFF97316) : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
