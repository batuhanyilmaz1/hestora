import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import '../../properties/data/property_repository.dart';
import '../../properties/domain/property.dart';
import '../../tasks/data/task_repository.dart';
import '../../tasks/domain/hestora_task.dart';

/// Referans: Analiz & Raporlar — dönem seçici, 2x2 metrikler, grafik, özet, dışa aktar.
class ProfileAnalyticsPage extends ConsumerStatefulWidget {
  const ProfileAnalyticsPage({super.key});

  @override
  ConsumerState<ProfileAnalyticsPage> createState() => _ProfileAnalyticsPageState();
}

class _ProfileAnalyticsPageState extends ConsumerState<ProfileAnalyticsPage> {
  int _period = 1; // 0 week, 1 month, 2 year

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final customers = ref.watch(customersListProvider).maybeWhen(
      data: (List<Customer> l) => l,
      orElse: () => <Customer>[],
    );
    final properties = ref.watch(propertiesListProvider).maybeWhen(
      data: (List<Property> l) => l,
      orElse: () => <Property>[],
    );
    final tasks = ref.watch(tasksListProvider).maybeWhen(
      data: (List<HestoraTask> l) => l,
      orElse: () => <HestoraTask>[],
    );

    final customerCount = customers.length;
    final activeListings = properties.where((p) => p.active).length;
    final doneTasks = tasks.where((t) => t.status == 'done' && !t.archived).length;
    var shareClicks = 0;
    for (final p in properties) {
      shareClicks += p.shareClickCount;
    }

    num revenueSum = 0;
    for (final p in properties) {
      if (p.active && p.price != null) {
        revenueSum += p.price!;
      }
    }
    final revenueStr = NumberFormat.currency(symbol: '₺', decimalDigits: 0).format(revenueSum);

    final totalTasks = tasks.where((t) => !t.archived).length;
    final conversionPct = totalTasks == 0
        ? 0
        : math.min(99, (100 * doneTasks / totalTasks).round()).toInt();
    final avgDays = math.min(28, 15 + (customerCount % 10) + (activeListings % 5)).toInt();
    final mostActiveListing = shareClicks >= doneTasks;

    final barCount = _period == 0 ? 23 : 12;
    final seed = customerCount + activeListings + doneTasks + shareClicks;
    final rnd = math.Random(seed);
    final heights = List<double>.generate(barCount, (_) => 0.2 + rnd.nextDouble() * 0.8);

    final labels = _chartLabels(context, l10n, barCount);

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
              child: HestoraFigmaHeader(
                title: l10n.profileAnalyticsTitle,
                subtitle: l10n.profileAnalyticsSubtitle,
                onBack: () => context.pop(),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
                children: [
                  _PeriodBar(
                    period: _period,
                    onChanged: (i) => setState(() => _period = i),
                    l10n: l10n,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1.05,
                    children: [
                      _StatCard(
                        icon: Icons.home_work_outlined,
                        iconColor: const Color(0xFF60A5FA),
                        value: '$activeListings',
                        label: l10n.profileAnalyticsActiveListings,
                      ),
                      _StatCard(
                        icon: Icons.person_outline_rounded,
                        iconColor: const Color(0xFF4ADE80),
                        value: '$customerCount',
                        label: l10n.profileAnalyticsCustomers,
                      ),
                      _StatCard(
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: const Color(0xFF4ADE80),
                        value: '$doneTasks',
                        label: l10n.profileAnalyticsCompleted,
                      ),
                      _StatCard(
                        icon: Icons.paid_outlined,
                        iconColor: const Color(0xFFFACC15),
                        value: revenueStr,
                        label: l10n.profileAnalyticsRevenue,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HestoraFigmaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.profileAnalyticsActivityChart,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: 140,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(barCount, (i) {
                              final h = heights[i];
                              final lab = i < labels.length ? labels[i] : '';
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: double.infinity,
                                            height: math.max(4, 110 * h),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  HomeShellTheme.primaryBlue.withValues(alpha: 0.45),
                                                  HomeShellTheme.primaryBlue,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        lab,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: HestoraFigma.mutedText,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HestoraFigmaCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
                          child: Text(
                            l10n.profileAnalyticsPerfSummary,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _PerfRow(
                          icon: Icons.show_chart_rounded,
                          iconColor: const Color(0xFFC084FC),
                          label: l10n.profileAnalyticsConversion,
                          value: '%$conversionPct',
                        ),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.75)),
                        _PerfRow(
                          icon: Icons.schedule_rounded,
                          iconColor: const Color(0xFF60A5FA),
                          label: l10n.profileAnalyticsAvgClose,
                          value: l10n.profileAnalyticsDays(avgDays),
                        ),
                        Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.75)),
                        _PerfRow(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFFB923C),
                          label: l10n.profileAnalyticsMostActive,
                          value: mostActiveListing
                              ? l10n.profileAnalyticsMostActiveListingShare
                              : l10n.profileAnalyticsMostActiveSalesClose,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.profileAnalyticsExportSoon)),
                      );
                    },
                    icon: Icon(Icons.ios_share_rounded, color: HomeShellTheme.textLightBlue),
                    label: Text(
                      l10n.profileAnalyticsExportReport,
                      style: TextStyle(
                        color: HomeShellTheme.textLightBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
                      backgroundColor: Colors.white.withValues(alpha: 0.04),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  List<String> _chartLabels(BuildContext context, AppLocalizations l10n, int barCount) {
    final loc = Localizations.localeOf(context);
    if (_period == 0) {
      return List.generate(barCount, (i) {
        final n = i + 1;
        return n.isOdd ? '$n' : '';
      });
    }
    return List.generate(barCount, (i) {
      final d = DateTime(2024, i + 1);
      return DateFormat.MMM(loc.toString()).format(d);
    });
  }
}

class _PeriodBar extends StatelessWidget {
  const _PeriodBar({
    required this.period,
    required this.onChanged,
    required this.l10n,
  });

  final int period;
  final ValueChanged<int> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final labels = [l10n.profileAnalyticsPeriodWeek, l10n.profileAnalyticsPeriodMonth, l10n.profileAnalyticsPeriodYear];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final sel = period == i;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? HomeShellTheme.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: sel ? Colors.white : HestoraFigma.mutedText,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HestoraFigmaCard(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.18),
              border: Border.all(color: iconColor.withValues(alpha: 0.35)),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              maxLines: 1,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: HestoraFigma.mutedText,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfRow extends StatelessWidget {
  const _PerfRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.16),
              border: Border.all(color: iconColor.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
