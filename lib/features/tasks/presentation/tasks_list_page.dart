import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_async_value.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/task_repository.dart';
import '../domain/hestora_task.dart';

class TasksListPage extends ConsumerWidget {
  const TasksListPage({super.key});

  static Future<void> _markDone(BuildContext context, WidgetRef ref, HestoraTask task) async {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(taskRepositoryProvider);
    if (!repo.supportsRemote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.supabaseStatusNotConfigured)),
      );
      return;
    }
    try {
      await repo.updateStatus(id: task.id, status: 'done');
      ref.invalidate(tasksListProvider);
      ref.invalidate(taskDetailProvider(task.id));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.taskMarkedDone)));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  String _taskStatusLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'done':
        return l10n.taskStatusDone;
      case 'closed':
        return l10n.taskStatusClosed;
      case 'open':
      default:
        return l10n.taskStatusOpen;
    }
  }

  String _taskPriorityLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'low':
        return l10n.taskPriorityLow;
      case 'high':
        return l10n.taskPriorityHigh;
      case 'urgent':
        return l10n.taskPriorityUrgent;
      case 'normal':
      default:
        return l10n.taskPriorityNormal;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(tasksListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tasksTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: Text(
              l10n.tasksSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: AppAsyncValueWidget<List<HestoraTask>>(
              value: async,
              data: (context, list) {
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.task_alt, size: 48, color: AppColors.textSecondary),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.tasksEmpty,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          FilledButton.icon(
                            onPressed: () => context.push('/tasks/new'),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.taskNewTitle),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final task = list[index];
                    final due = task.dueAt != null
                        ? MaterialLocalizations.of(context).formatShortDate(task.dueAt!.toLocal())
                        : l10n.taskNoDueDate;
                    final links = <String>[
                      _taskPriorityLabel(l10n, task.priority),
                      if (task.customerId != null) l10n.navCustomers,
                      if (task.propertyId != null) l10n.navProperties,
                    ];

                    return Material(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text('$due\n${links.join(' • ')}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(_taskStatusLabel(l10n, task.status)),
                              visualDensity: VisualDensity.compact,
                            ),
                            if (task.status == 'open')
                              IconButton(
                                tooltip: l10n.taskMarkDone,
                                icon: const Icon(Icons.check_circle_outline_rounded),
                                onPressed: () => TasksListPage._markDone(context, ref, task),
                              ),
                          ],
                        ),
                        onTap: () => context.push('/tasks/${task.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.taskNewTitle),
      ),
    );
  }
}
