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
import '../../properties/presentation/property_creation_options_sheet.dart';
import '../../tasks/data/task_repository.dart';
import '../../tasks/domain/hestora_task.dart';

class DashboardHomePage extends ConsumerWidget {
  const DashboardHomePage({super.key});

  static bool _sameCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int _openTaskSortScore(HestoraTask t, DateTime now) {
    final startOfToday = DateTime(now.year, now.month, now.day);
    final d = t.dueAt;
    if (d == null) {
      return 2;
    }
    if (d.isBefore(startOfToday)) {
      return 0;
    }
    if (_sameCalendarDay(d, now)) {
      return 1;
    }
    return 3;
  }

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
    final tasksAsync = ref.watch(tasksListProvider);
    final locale = Localizations.localeOf(context);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox(
                height: 48,
                child: Image.asset(
                  'assets/logo/LOGO-1.png',
                  fit: BoxFit.contain,
                  alignment: AlignmentDirectional.centerStart,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),
              ),
            ),
            const AppGap(height: AppSpacing.md),
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
              onSecondaryLeft: () => showPropertyCreationOptionsSheet(context),
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
              l10n.dashboardTasksToday,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const AppGap(height: AppSpacing.sm),
            tasksAsync.when(
              data: (tasks) {
                final open = tasks.where(hestoraTaskIsOpen).toList()
                  ..sort((a, b) => _openTaskSortScore(a, now).compareTo(_openTaskSortScore(b, now)));
                final shown = open.take(10).toList();
                if (shown.isEmpty) {
                  return Text(
                    l10n.dashboardTasksEmptyOpen,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF94A3B8)),
                  );
                }
                return Column(
                  children: [
                    for (final t in shown) _DashboardTaskRow(task: t),
                    TextButton(
                      onPressed: () => context.push('/tasks'),
                      child: Text(l10n.dashboardViewAllTasks),
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(minHeight: 3),
              ),
              error: (_, __) => Text(
                l10n.authErrorGeneric,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF94A3B8)),
              ),
            ),
            const AppGap(height: AppSpacing.lg),
            Text(
              l10n.dashboardTasksCompleted,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const AppGap(height: AppSpacing.sm),
            tasksAsync.when(
              data: (tasks) {
                final done = tasks.where(hestoraTaskIsDone).take(8).toList();
                if (done.isEmpty) {
                  return Text(
                    l10n.dashboardTasksEmptyDone,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF94A3B8)),
                  );
                }
                return Column(
                  children: [for (final t in done) _DashboardTaskRow(task: t, dim: true)],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
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

class _DashboardTaskRow extends StatelessWidget {
  const _DashboardTaskRow({required this.task, this.dim = false});

  final HestoraTask task;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final subtitle = task.dueAt != null ? MaterialLocalizations.of(context).formatShortDate(task.dueAt!) : '';
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: HomeShellTheme.card.withValues(alpha: dim ? 0.55 : 0.92),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/tasks/${task.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
            child: Row(
              children: [
                Icon(
                  dim ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                  size: 22,
                  color: dim ? const Color(0xFF34D399) : HomeShellTheme.textLightBlue.withValues(alpha: 0.9),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: HomeShellTheme.textLightBlue.withValues(alpha: 0.85),
                              ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: HomeShellTheme.textLightBlue.withValues(alpha: 0.65)),
              ],
            ),
          ),
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg + 2, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        color: HomeShellTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.42)),
        boxShadow: [
          BoxShadow(
            color: HomeShellTheme.primaryBlue.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.55), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: HomeShellTheme.primaryBlue.withValues(alpha: 0.35),
                    blurRadius: 18,
                    spreadRadius: 0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0A1220),
                ),
                alignment: Alignment.center,
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
                  fontSize: 17,
                  height: 1.25,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.28)),
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
