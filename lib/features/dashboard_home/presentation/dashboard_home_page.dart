import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/app_gap.dart';
import '../../../core/widgets/hestora_gradient_filled_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/presentation/customer_creation_options_sheet.dart';

class DashboardHomePage extends ConsumerWidget {
  const DashboardHomePage({super.key});

  static List<TextSpan> _tipSpans(String tip, Locale locale, TextStyle base, TextStyle highlight) {
    final mark = switch (locale.languageCode) {
      'tr' => '+ butonuyla',
      'ar' => 'زر +',
      _ => '+ button',
    };
    final i = tip.indexOf(mark);
    if (i < 0) {
      return [TextSpan(text: tip, style: base)];
    }
    return [
      TextSpan(text: tip.substring(0, i), style: base),
      TextSpan(text: mark, style: highlight),
      TextSpan(text: tip.substring(i + mark.length), style: base),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final env = ref.watch(appEnvironmentProvider);
    final demo = !SupabaseBootstrap.isClientReady(env);
    final customersAsync = ref.watch(customersListProvider);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          children: [
            if (demo)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Material(
                  color: HomeShellTheme.card.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      l10n.demoModeBanner,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: HomeShellTheme.textLightBlue.withValues(alpha: 0.85),
                          ),
                    ),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeShort,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: HomeShellTheme.welcomeCyan,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.dashboardHeadline,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                ),
              ],
            ),
            const AppGap(height: AppSpacing.lg),
            _HeroCard(
              title: l10n.heroCardTitle,
              body: l10n.heroCardBody,
              primaryLabel: l10n.ctaAddFirstCustomer,
              onPrimary: () => showCustomerCreationOptionsSheet(context),
              secondaryLeftLabel: l10n.ctaAddListing,
              secondaryRightLabel: l10n.ctaReminder,
              onSecondaryLeft: () => context.push('/properties/new'),
              onSecondaryRight: () => context.push('/tasks'),
            ),
            const AppGap(height: AppSpacing.md),
            _TipRow(
              spans: _tipSpans(
                l10n.fabTip,
                locale,
                TextStyle(
                  color: HomeShellTheme.textLightBlue.withValues(alpha: 0.92),
                  height: 1.4,
                  fontSize: 13,
                ),
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
            ),
            const AppGap(height: AppSpacing.lg),
            Text(
              customersAsync.maybeWhen(
                data: (list) => l10n.customersSubtitle(list.length),
                orElse: () => l10n.customersSubtitle(0),
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLeftLabel,
    required this.secondaryRightLabel,
    required this.onSecondaryLeft,
    required this.onSecondaryRight,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String secondaryLeftLabel;
  final String secondaryRightLabel;
  final VoidCallback onSecondaryLeft;
  final VoidCallback onSecondaryRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: HomeShellTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: HomeShellTheme.primaryBlue.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFF0F172A),
                border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(
                    color: HomeShellTheme.primaryBlue.withValues(alpha: 0.45),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.apartment_outlined,
                  size: 28,
                  color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95),
                ),
              ),
            ),
          ),
          const AppGap(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
          ),
          const AppGap(height: AppSpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95),
                  height: 1.45,
                  fontSize: 14,
                ),
          ),
          const AppGap(height: AppSpacing.lg),
          HestoraGradientFilledButton(
            onPressed: onPrimary,
            icon: Icons.person_add_alt_1_outlined,
            label: Text(primaryLabel, textAlign: TextAlign.center),
          ),
          const AppGap(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSecondaryLeft,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HomeShellTheme.textLightBlue,
                    side: BorderSide(color: HomeShellTheme.borderBlue.withValues(alpha: 0.65)),
                    backgroundColor: HomeShellTheme.secondaryButtonFill,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.add_home_work_outlined, size: 20),
                  label: Text(secondaryLeftLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSecondaryRight,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HomeShellTheme.textLightBlue,
                    side: BorderSide(color: HomeShellTheme.borderBlue.withValues(alpha: 0.65)),
                    backgroundColor: HomeShellTheme.secondaryButtonFill,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.schedule_outlined, size: 20),
                  label: Text(secondaryRightLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.spans});

  final List<TextSpan> spans;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: HomeShellTheme.tipBarFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HomeShellTheme.primaryBlue.withValues(alpha: 0.22),
              border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.35)),
            ),
            child: Icon(Icons.lightbulb_outline, color: HomeShellTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text.rich(
              TextSpan(children: spans),
            ),
          ),
        ],
      ),
    );
  }
}
