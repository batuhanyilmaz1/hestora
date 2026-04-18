import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/customer_repository.dart';
import '../domain/customer.dart';
import '../domain/customer_form_prefill.dart';

class CustomerFormPage extends ConsumerStatefulWidget {
  const CustomerFormPage({super.key, this.prefill, this.editingCustomerId});

  final CustomerFormPrefill? prefill;
  final String? editingCustomerId;

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _notes = TextEditingController();
  final _preferredLocation = TextEditingController();
  final _budgetMin = TextEditingController();
  final _budgetMax = TextEditingController();
  final _roomCount = TextEditingController();
  final _areaMin = TextEditingController();
  final _areaMax = TextEditingController();
  String? _listingIntent;
  bool _busy = false;
  bool _hydratedFromRemote = false;

  @override
  void initState() {
    super.initState();
    final p = widget.prefill;
    if (p != null) {
      if (p.name != null) {
        _name.text = p.name!;
      }
      if (p.phone != null) {
        _phone.text = p.phone!;
      }
      if (p.notes != null) {
        _notes.text = p.notes!;
      }
      if (p.email != null) {
        _email.text = p.email!;
      }
      if (p.preferredLocation != null) {
        _preferredLocation.text = p.preferredLocation!;
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _notes.dispose();
    _preferredLocation.dispose();
    _budgetMin.dispose();
    _budgetMax.dispose();
    _roomCount.dispose();
    _areaMin.dispose();
    _areaMax.dispose();
    super.dispose();
  }

  num? _parseNum(String v) {
    final t = v.trim();
    if (t.isEmpty) {
      return null;
    }
    return num.tryParse(t.replaceAll(',', '.'));
  }

  int? _parseInt(String v) {
    final t = v.trim();
    if (t.isEmpty) {
      return null;
    }
    return int.tryParse(t);
  }

  void _applyCustomer(Customer c) {
    _name.text = c.name;
    _phone.text = c.phone ?? '';
    _email.text = c.email ?? '';
    _notes.text = c.notes ?? '';
    _preferredLocation.text = c.preferredLocation ?? '';
    _budgetMin.text = c.budgetMin != null ? '${c.budgetMin}' : '';
    _budgetMax.text = c.budgetMax != null ? '${c.budgetMax}' : '';
    _roomCount.text = c.roomCount != null ? '${c.roomCount}' : '';
    _areaMin.text = c.areaMinSqm != null ? '${c.areaMinSqm}' : '';
    _areaMax.text = c.areaMaxSqm != null ? '${c.areaMaxSqm}' : '';
    _listingIntent = c.listingIntent;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final repo = ref.read(customerRepositoryProvider);
    if (!repo.supportsRemote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.supabaseStatusNotConfigured)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final editId = widget.editingCustomerId;
      if (editId != null) {
        await repo.update(
          id: editId,
          name: _name.text.trim(),
          phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          listingIntent: _listingIntent,
          preferredLocation: _preferredLocation.text.trim().isEmpty ? null : _preferredLocation.text.trim(),
          budgetMin: _parseNum(_budgetMin.text),
          budgetMax: _parseNum(_budgetMax.text),
          roomCount: _parseInt(_roomCount.text),
          areaMinSqm: _parseNum(_areaMin.text),
          areaMaxSqm: _parseNum(_areaMax.text),
          tags: null,
        );
        ref.invalidate(customerDetailProvider(editId));
      } else {
        await repo.insert(
          name: _name.text.trim(),
          phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          listingIntent: _listingIntent,
          preferredLocation: _preferredLocation.text.trim().isEmpty ? null : _preferredLocation.text.trim(),
          budgetMin: _parseNum(_budgetMin.text),
          budgetMax: _parseNum(_budgetMax.text),
          roomCount: _parseInt(_roomCount.text),
          areaMinSqm: _parseNum(_areaMin.text),
          areaMaxSqm: _parseNum(_areaMax.text),
        );
      }
      ref.invalidate(customersListProvider);
      if (!mounted) {
        return;
      }
      context.pop();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final editId = widget.editingCustomerId;
    if (editId != null) {
      final async = ref.watch(customerDetailProvider(editId));
      async.whenData((c) {
        if (c != null && !_hydratedFromRemote) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _hydratedFromRemote) {
              return;
            }
            setState(() {
              _hydratedFromRemote = true;
              _applyCustomer(c);
            });
          });
        }
      });
    }

    final isEdit = editId != null;

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(isEdit ? l10n.editCustomerTitle : l10n.createCustomerTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _name,
                  labelText: l10n.fieldName,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? l10n.validationRequired : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _phone,
                  labelText: l10n.fieldPhone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _email,
                  labelText: l10n.emailLabel,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _listingIntent,
                  decoration: InputDecoration(labelText: l10n.fieldListingIntent),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.intentNotSet)),
                    DropdownMenuItem(value: 'sale', child: Text(l10n.chipSale)),
                    DropdownMenuItem(value: 'rent', child: Text(l10n.chipRent)),
                  ],
                  onChanged: (v) => setState(() => _listingIntent = v),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _preferredLocation,
                  labelText: l10n.fieldPreferredLocation,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _budgetMin,
                        labelText: l10n.fieldBudgetMin,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _budgetMax,
                        labelText: l10n.fieldBudgetMax,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _roomCount,
                  labelText: l10n.fieldRoomCount,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _areaMin,
                        labelText: l10n.fieldAreaMin,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _areaMax,
                        labelText: l10n.fieldAreaMax,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _notes,
                  labelText: l10n.fieldNotes,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppPrimaryButton(
                  label: l10n.save,
                  onPressed: _busy ? null : _save,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
