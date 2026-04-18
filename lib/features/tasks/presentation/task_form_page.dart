import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import '../../properties/data/property_repository.dart';
import '../../properties/domain/property.dart';
import '../data/task_repository.dart';
import '../domain/hestora_task.dart';
import 'task_picker_sheets.dart';

class TaskFormPage extends ConsumerStatefulWidget {
  const TaskFormPage({super.key, this.editingTaskId});

  final String? editingTaskId;

  @override
  ConsumerState<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  DateTime? _due;
  TimeOfDay? _dueTime;
  String? _customerId;
  String? _propertyId;
  String _priority = 'normal';
  String _status = 'open';
  bool _busy = false;
  bool _hydratedFromRemote = false;
  bool _notifyOn = true;

  static const int _titleMax = 80;

  bool get _isEdit => widget.editingTaskId != null;

  @override
  void initState() {
    super.initState();
    _title.addListener(() {
      if (_title.text.length > _titleMax) {
        _title.text = _title.text.substring(0, _titleMax);
        _title.selection = TextSelection.collapsed(offset: _title.text.length);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _applyTask(HestoraTask task) {
    _title.text = task.title;
    final d = task.dueAt?.toLocal();
    _due = d;
    _dueTime = d != null ? TimeOfDay.fromDateTime(d) : null;
    _customerId = task.customerId;
    _propertyId = task.propertyId;
    _priority = task.priority;
    _status = task.status;
  }

  DateTime? _combinedDue() {
    final d = _due;
    if (d == null) {
      return null;
    }
    final t = _dueTime ?? const TimeOfDay(hour: 9, minute: 0);
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null && mounted) {
      setState(() => _due = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (time != null && mounted) {
      setState(() => _dueTime = time);
    }
  }

  int _todayOpenCount(List<HestoraTask> tasks) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return tasks.where((t) {
      if (!hestoraTaskIsOpen(t)) {
        return false;
      }
      final d = t.dueAt;
      if (d == null) {
        return false;
      }
      return !d.isBefore(start) && d.isBefore(end);
    }).length;
  }

  String? _customerName(List<Customer> customers, String? id) {
    if (id == null) {
      return null;
    }
    for (final c in customers) {
      if (c.id == id) {
        return c.name;
      }
    }
    return null;
  }

  String? _propertyTitle(List<Property> properties, String? id) {
    if (id == null) {
      return null;
    }
    for (final p in properties) {
      if (p.id == id) {
        return p.title;
      }
    }
    return null;
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
      final due = _combinedDue();
      final editId = widget.editingTaskId;

      if (editId != null) {
        await repo.update(
          id: editId,
          title: title,
          body: null,
          dueAt: due,
          priority: _priority,
          status: _status,
          customerId: _customerId,
          propertyId: _propertyId,
        );
        ref.invalidate(taskDetailProvider(editId));
      } else {
        await repo.insert(
          title: title,
          body: null,
          dueAt: due,
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

  Widget _badge(String text, {required bool requiredField}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: requiredField ? const Color(0x33EF4444) : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: requiredField ? const Color(0x88EF4444) : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: requiredField ? const Color(0xFFF87171) : HestoraFigma.mutedText,
        ),
      ),
    );
  }

  Widget _linkRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, color: Colors.white.withValues(alpha: 0.75), size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onClear != null)
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, color: Color(0xFFF87171), size: 22),
                ),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.35)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    AppLocalizations l10n, {
    required int todayCount,
    required List<Customer> customers,
    required List<Property> properties,
  }) {
    final theme = Theme.of(context);
    final dateStr = _due != null ? DateFormat('dd.MM.yyyy').format(_due!) : '—';
    final timeStr = _dueTime != null
        ? '${_dueTime!.hour.toString().padLeft(2, '0')}:${_dueTime!.minute.toString().padLeft(2, '0')}'
        : '—';
    final cName = _customerName(customers, _customerId);
    final pTitle = _propertyTitle(properties, _propertyId);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          Row(
            children: [
              Text(l10n.taskFieldTitle, style: theme.textTheme.labelLarge?.copyWith(color: HestoraFigma.mutedText)),
              const SizedBox(width: 8),
              _badge(l10n.taskBadgeRequired, requiredField: true),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _title,
            maxLength: _titleMax,
            maxLines: 1,
            buildCounter: (_, {required currentLength, required isFocused, maxLength}) => Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$currentLength/$_titleMax',
                style: theme.textTheme.labelSmall?.copyWith(color: HestoraFigma.mutedText),
              ),
            ),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              filled: true,
              fillColor: HestoraFigma.cardFill,
              counterText: '',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.sm),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
            validator: (v) => v == null || v.trim().isEmpty ? l10n.validationRequired : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text(
                '${l10n.taskDateShort} & ${l10n.taskTimeShort}',
                style: theme.textTheme.labelLarge?.copyWith(color: HestoraFigma.mutedText),
              ),
              const SizedBox(width: 8),
              _badge(l10n.taskBadgeOptional, requiredField: false),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _dateTimeBox(
                  icon: Icons.calendar_today_outlined,
                  label: l10n.taskDateShort,
                  value: dateStr,
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _dateTimeBox(
                  icon: Icons.schedule_outlined,
                  label: l10n.taskTimeShort,
                  value: timeStr,
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.taskNotifySectionTitle,
            style: theme.textTheme.labelLarge?.copyWith(color: HestoraFigma.mutedText),
          ),
          const SizedBox(height: 8),
          HestoraFigmaCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _notifyOn,
              onChanged: (v) => setState(() => _notifyOn = v),
              secondary: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.white70),
              ),
              title: Text(l10n.taskNotifyOnTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              subtitle: Text(
                l10n.taskNotifyOnSubtitle,
                style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 13),
              ),
              activeTrackColor: AppColors.primary.withValues(alpha: 0.45),
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.taskLinkSectionTitle,
            style: theme.textTheme.labelLarge?.copyWith(color: HestoraFigma.mutedText),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.taskBadgeOptional,
            style: theme.textTheme.labelSmall?.copyWith(color: HestoraFigma.mutedText),
          ),
          const SizedBox(height: 8),
          HestoraFigmaCard(
            child: Column(
              children: [
                _linkRow(
                  icon: Icons.person_outline,
                  label: l10n.taskLinkCustomerRow,
                  value: cName ?? l10n.taskPickCustomerHint,
                  onTap: () async {
                    final id = await showTaskCustomerPickerSheet(context, ref);
                    if (id != null && mounted) {
                      setState(() => _customerId = id);
                    }
                  },
                  onClear: _customerId != null ? () => setState(() => _customerId = null) : null,
                ),
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                _linkRow(
                  icon: Icons.home_work_outlined,
                  label: l10n.taskLinkPropertyRow,
                  value: pTitle ?? l10n.taskPickPropertyHint,
                  onTap: () async {
                    final id = await showTaskPropertyPickerSheet(context, ref);
                    if (id != null && mounted) {
                      setState(() => _propertyId = id);
                    }
                  },
                  onClear: _propertyId != null ? () => setState(() => _propertyId = null) : null,
                ),
              ],
            ),
          ),
          if (_isEdit) ...[
            const SizedBox(height: AppSpacing.md),
            // Edit modunda öncelik/durum — kompakt
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _priority,
                    decoration: _dropdownDeco(l10n.taskFieldPriority),
                    items: [
                      DropdownMenuItem(value: 'low', child: Text(l10n.taskPriorityLow)),
                      DropdownMenuItem(value: 'normal', child: Text(l10n.taskPriorityNormal)),
                      DropdownMenuItem(value: 'high', child: Text(l10n.taskPriorityHigh)),
                      DropdownMenuItem(value: 'urgent', child: Text(l10n.taskPriorityUrgent)),
                    ],
                    onChanged: (v) => setState(() => _priority = v ?? 'normal'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _dropdownDeco(l10n.taskFieldStatus),
                    items: [
                      DropdownMenuItem(value: 'open', child: Text(l10n.taskStatusOpen)),
                      DropdownMenuItem(value: 'done', child: Text(l10n.taskStatusDone)),
                      DropdownMenuItem(value: 'closed', child: Text(l10n.taskStatusClosed)),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? 'open'),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(l10n.save),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dropdownDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: HestoraFigma.mutedText),
      filled: true,
      fillColor: HestoraFigma.cardFill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
    );
  }

  Widget _dateTimeBox({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: HestoraFigma.cardFill,
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: HestoraFigma.mutedText),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(tasksListProvider);
    final customersAsync = ref.watch(customersListProvider);
    final propertiesAsync = ref.watch(propertiesListProvider);
    final todayCount = tasksAsync.maybeWhen(data: _todayOpenCount, orElse: () => 0);
    final customers = customersAsync.valueOrNull ?? const [];
    final properties = propertiesAsync.valueOrNull ?? const [];

    final editId = widget.editingTaskId;
    Widget body;
    if (editId == null) {
      body = _buildForm(context, l10n, todayCount: todayCount, customers: customers, properties: properties);
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
        error: (e, __) => Center(child: Text('$e')),
        data: (task) {
          if (task == null) {
            return Center(child: Text(l10n.taskNotFoundTitle));
          }
          return _buildForm(context, l10n, todayCount: todayCount, customers: customers, properties: properties);
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HestoraFigmaHeader(
              title: l10n.taskRemindTitle,
              subtitle: l10n.taskRemindSubtitle,
              onBack: () => context.pop(),
              trailing: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.taskTodayCount(todayCount),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: HestoraFigma.mutedText),
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
