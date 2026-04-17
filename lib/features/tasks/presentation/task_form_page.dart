import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_async_value.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import '../../properties/data/property_repository.dart';
import '../../properties/domain/property.dart';
import '../data/task_repository.dart';
import '../domain/hestora_task.dart';

class TaskFormPage extends ConsumerStatefulWidget {
  const TaskFormPage({super.key, this.editingTaskId});

  final String? editingTaskId;

  @override
  ConsumerState<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  DateTime? _due;
  String? _customerId;
  String? _propertyId;
  String _priority = 'normal';
  String _status = 'open';
  bool _busy = false;
  bool _hydratedFromRemote = false;

  bool get _isEdit => widget.editingTaskId != null;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _applyTask(HestoraTask task) {
    _title.text = task.title;
    _body.text = task.body ?? '';
    _due = task.dueAt?.toLocal();
    _customerId = task.customerId;
    _propertyId = task.propertyId;
    _priority = task.priority;
    _status = task.status;
  }

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_due ?? now),
      );
      if (time != null && mounted) {
        setState(() {
          _due = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repo = ref.read(taskRepositoryProvider);
    if (!repo.supportsRemote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.supabaseStatusNotConfigured)),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      final title = _title.text.trim();
      final body = _body.text.trim().isEmpty ? null : _body.text.trim();
      final editId = widget.editingTaskId;

      if (editId != null) {
        await repo.update(
          id: editId,
          title: title,
          body: body,
          dueAt: _due,
          priority: _priority,
          status: _status,
          customerId: _customerId,
          propertyId: _propertyId,
        );
        ref.invalidate(taskDetailProvider(editId));
      } else {
        await repo.insert(
          title: title,
          body: body,
          dueAt: _due,
          priority: _priority,
          status: _status,
          customerId: _customerId,
          propertyId: _propertyId,
        );
      }

      ref.invalidate(tasksListProvider);
      if (!mounted) {
        return;
      }
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  String _dueLabel(BuildContext context, AppLocalizations l10n) {
    final due = _due;
    if (due == null) {
      return l10n.taskFieldDue;
    }

    final localizations = MaterialLocalizations.of(context);
    final date = localizations.formatFullDate(due);
    final time = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(due));
    return '$date • $time';
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

  Widget _buildForm(
    BuildContext context,
    AppLocalizations l10n, {
    required AsyncValue<List<Customer>> customersAsync,
    required AsyncValue<List<Property>> propertiesAsync,
  }) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _title,
                labelText: l10n.taskFieldTitle,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? l10n.validationRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _body,
                labelText: l10n.fieldNotes,
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: InputDecoration(
                        labelText: l10n.taskFieldPriority,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        for (final value in const ['low', 'normal', 'high', 'urgent'])
                          DropdownMenuItem<String>(
                            value: value,
                            child: Text(_taskPriorityLabel(l10n, value)),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _priority = value);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(
                        labelText: l10n.taskFieldStatus,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        for (final value in const ['open', 'done', 'closed'])
                          DropdownMenuItem<String>(
                            value: value,
                            child: Text(_taskStatusLabel(l10n, value)),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() => _status = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppAsyncValueWidget<List<Customer>>(
                value: customersAsync,
                data: (context, customers) {
                  return DropdownButtonFormField<String?>(
                    value: _customerId,
                    decoration: InputDecoration(
                      labelText: l10n.taskLinkedCustomer,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.taskNoneSelected),
                      ),
                      ...customers.map(
                        (customer) => DropdownMenuItem<String?>(
                          value: customer.id,
                          child: Text(customer.name, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _customerId = value),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppAsyncValueWidget<List<Property>>(
                value: propertiesAsync,
                data: (context, properties) {
                  return DropdownButtonFormField<String?>(
                    value: _propertyId,
                    decoration: InputDecoration(
                      labelText: l10n.taskLinkedProperty,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.taskNoneSelected),
                      ),
                      ...properties.map(
                        (property) => DropdownMenuItem<String?>(
                          value: property.id,
                          child: Text(property.title, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _propertyId = value),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: _pickDue,
                icon: const Icon(Icons.event_outlined),
                label: Text(_dueLabel(context, l10n)),
              ),
              if (_due != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _busy ? null : () => setState(() => _due = null),
                    icon: const Icon(Icons.clear),
                    label: Text(l10n.taskClearDueDate),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                label: l10n.save,
                onPressed: _busy ? null : _save,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customersAsync = ref.watch(customersListProvider);
    final propertiesAsync = ref.watch(propertiesListProvider);
    final editId = widget.editingTaskId;

    Widget body;
    if (editId == null) {
      body = _buildForm(
        context,
        l10n,
        customersAsync: customersAsync,
        propertiesAsync: propertiesAsync,
      );
    } else {
      final taskAsync = ref.watch(taskDetailProvider(editId));
      taskAsync.whenData((task) {
        if (task != null && !_hydratedFromRemote) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _hydratedFromRemote) {
              return;
            }
            setState(() {
              _hydratedFromRemote = true;
              _applyTask(task);
            });
          });
        }
      });

      body = taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) => _TaskStateView(
          title: l10n.taskLoadErrorTitle,
          body: '$error',
          primaryLabel: l10n.taskRetryLoad,
          onPrimaryTap: () => ref.invalidate(taskDetailProvider(editId)),
        ),
        data: (task) {
          if (task == null) {
            return _TaskStateView(
              title: l10n.taskNotFoundTitle,
              body: l10n.taskNotFoundBody,
              primaryLabel: l10n.back,
              onPrimaryTap: () => context.pop(),
            );
          }

          return _buildForm(
            context,
            l10n,
            customersAsync: customersAsync,
            propertiesAsync: propertiesAsync,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.taskEditTitle : l10n.taskNewTitle),
      ),
      body: body,
    );
  }
}

class _TaskStateView extends StatelessWidget {
  const _TaskStateView({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimaryTap,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimaryTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.task_outlined, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: onPrimaryTap,
              child: Text(primaryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
