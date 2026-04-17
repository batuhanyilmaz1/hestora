import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';
import '../../properties/data/property_repository.dart';
import '../../tasks/data/task_repository.dart';

class ProfileAnalyticsPage extends ConsumerWidget {
  const ProfileAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final customers = ref.watch(customersListProvider);
    final properties = ref.watch(propertiesListProvider);
    final tasks = ref.watch(tasksListProvider);

    final customerCount = customers.maybeWhen(data: (l) => l.length, orElse: () => 0);
    final listingCount = properties.maybeWhen(data: (l) => l.length, orElse: () => 0);
    final openTasks = tasks.maybeWhen(
      data: (l) => l.where((t) => t.status == 'open' && !t.archived).length,
      orElse: () => 0,
    );
    final shareClicks = properties.maybeWhen(
      data: (l) => l.fold<int>(0, (s, p) => s + p.shareClickCount),
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.profileAnalyticsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l10n.profileAnalyticsSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _MetricTile(
            label: l10n.profileAnalyticsCustomers,
            value: '$customerCount',
            color: const Color(0xFF60A5FA),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetricTile(
            label: l10n.profileAnalyticsListings,
            value: '$listingCount',
            color: AppColors.accentTeal,
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetricTile(
            label: l10n.profileAnalyticsTasksOpen,
            value: '$openTasks',
            color: AppColors.accentPurple,
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetricTile(
            label: l10n.profileAnalyticsShareClicks,
            value: '$shareClicks',
            color: AppColors.accentGold,
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        color: AppColors.surface.withValues(alpha: 0.65),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.insights_rounded, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
