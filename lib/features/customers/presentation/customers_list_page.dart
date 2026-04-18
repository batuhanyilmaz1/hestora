import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/app_async_value.dart';
import '../../../core/widgets/hestora_gradient_filled_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../matching/data/match_providers.dart';
import '../data/customer_contacts_service.dart';
import '../data/customer_repository.dart';
import '../domain/customer.dart';
import 'customer_creation_options_sheet.dart';

enum _RoleFilter { all, buyer, tenant, seller, landlord }

enum _SortMode { nameAsc, nameDesc }

class CustomersListPage extends ConsumerStatefulWidget {
  const CustomersListPage({super.key});

  @override
  ConsumerState<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends ConsumerState<CustomersListPage> {
  final _search = TextEditingController();
  _RoleFilter _role = _RoleFilter.all;
  _SortMode _sort = _SortMode.nameAsc;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _tagsMatch(Customer c, List<String> keys) {
    for (final t in c.tags) {
      final tl = t.toLowerCase();
      for (final k in keys) {
        if (tl.contains(k.toLowerCase())) {
          return true;
        }
      }
    }
    return false;
  }

  bool _customerMatchesRole(Customer c, _RoleFilter f) {
    switch (f) {
      case _RoleFilter.all:
        return true;
      case _RoleFilter.buyer:
        return c.listingIntent == 'sale';
      case _RoleFilter.tenant:
        return c.listingIntent == 'rent';
      case _RoleFilter.seller:
        return _tagsMatch(c, ['satici', 'satıcı', 'seller']);
      case _RoleFilter.landlord:
        return _tagsMatch(c, ['landlord', 'evsahibi', 'ev sahibi', 'kiralayan', 'malik']);
    }
  }

  List<Customer> _searchFilter(List<Customer> all, String q) {
    if (q.trim().isEmpty) {
      return all;
    }
    final lower = q.toLowerCase();
    return all
        .where(
          (c) =>
              c.name.toLowerCase().contains(lower) ||
              (c.phone?.toLowerCase().contains(lower) ?? false) ||
              (c.email?.toLowerCase().contains(lower) ?? false) ||
              (c.notes?.toLowerCase().contains(lower) ?? false),
        )
        .toList();
  }

  List<Customer> _apply(List<Customer> raw) {
    var list = _searchFilter(raw, _search.text);
    list = list.where((c) => _customerMatchesRole(c, _role)).toList();
    list = [...list]..sort((a, b) {
        switch (_sort) {
          case _SortMode.nameAsc:
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          case _SortMode.nameDesc:
            return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        }
      });
    return list;
  }

  void _openSortSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: HomeShellTheme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  l10n.customersSortTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(
                  _sort == _SortMode.nameAsc ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: HomeShellTheme.textLightBlue,
                ),
                title: Text(l10n.customersSortNameAsc, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() => _sort = _SortMode.nameAsc);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(
                  _sort == _SortMode.nameDesc ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: HomeShellTheme.textLightBlue,
                ),
                title: Text(l10n.customersSortNameDesc, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() => _sort = _SortMode.nameDesc);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(BuildContext context, _RoleFilter value, String label) {
    final selected = _role == value;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: selected,
        onSelected: (_) => setState(() => _role = value),
        selectedColor: HomeShellTheme.primaryBlue,
        checkmarkColor: Colors.white,
        showCheckmark: true,
        backgroundColor: HomeShellTheme.secondaryButtonFill,
        side: BorderSide(
          color: selected ? HomeShellTheme.borderBlue : AppColors.border,
          width: selected ? 1.4 : 1,
        ),
      ),
    );
  }

  String? _roleSubtitle(AppLocalizations l10n, Customer c) {
    if (_tagsMatch(c, ['satici', 'satıcı', 'seller'])) {
      return l10n.chipSeller;
    }
    if (_tagsMatch(c, ['landlord', 'evsahibi', 'ev sahibi', 'kiralayan', 'malik'])) {
      return l10n.chipLandlord;
    }
    if (c.listingIntent == 'rent') {
      return l10n.chipTenant;
    }
    if (c.listingIntent == 'sale') {
      return l10n.chipBuyer;
    }
    return null;
  }

  Future<void> _importFromContacts() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref.read(customerContactsServiceProvider).loadContacts();
    if (!mounted) {
      return;
    }

    switch (result.status) {
      case CustomerContactImportStatus.denied:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.customerImportPermissionDenied)),
        );
        return;
      case CustomerContactImportStatus.unsupported:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.customerImportUnsupported)),
        );
        return;
      case CustomerContactImportStatus.empty:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.customerImportNoContacts)),
        );
        return;
      case CustomerContactImportStatus.success:
        final selected = await showModalBottomSheet<CustomerContactOption>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => _CustomerContactPickerSheet(
            contacts: result.contacts,
            title: l10n.customerImportPickerTitle,
          ),
        );
        if (!mounted || selected == null) {
          return;
        }
        context.push('/customers/new', extra: selected.toPrefill());
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(customersListProvider);
    final matchesAsync = ref.watch(customersTotalStrongMatchesProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.customersTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                  ),
                ),
                matchesAsync.when(
                  data: (n) => Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm, top: 2),
                    child: Text(
                      l10n.customersMatchesCount(n),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  loading: () => const SizedBox(width: 24, height: 16),
                  error: (Object e, StackTrace s) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              async.maybeWhen(
                data: (list) => l10n.customersSubtitle(list.length),
                orElse: () => l10n.customersSubtitle(0),
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts_outlined),
            tooltip: l10n.customerImportContacts,
            onPressed: _importFromContacts,
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: l10n.customersFilterTooltip,
            onPressed: _openSortSheet,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.searchCustomersHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                _chip(context, _RoleFilter.all, l10n.chipAll),
                _chip(context, _RoleFilter.buyer, l10n.chipBuyer),
                _chip(context, _RoleFilter.tenant, l10n.chipTenant),
                _chip(context, _RoleFilter.seller, l10n.chipSeller),
                _chip(context, _RoleFilter.landlord, l10n.chipLandlord),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: AppAsyncValueWidget<List<Customer>>(
              value: async,
              data: (context, list) {
                final filtered = _apply(list);
                if (filtered.isEmpty) {
                  if (list.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondary),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              l10n.customersFilteredEmpty,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            OutlinedButton(
                              onPressed: () => setState(() {
                                _role = _RoleFilter.all;
                                _search.clear();
                              }),
                              child: Text(l10n.customersFilteredEmptyClear),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadii.sm),
                              border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.65)),
                              boxShadow: [
                                BoxShadow(
                                  color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.4),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: Icon(Icons.groups_2_outlined, size: 40, color: HomeShellTheme.textLightBlue),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            l10n.heroCardTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.heroCardBody,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95),
                                  height: 1.45,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          HestoraGradientFilledButton(
                            onPressed: () => showCustomerCreationOptionsSheet(context),
                            icon: Icons.person_add_alt_1_outlined,
                            label: Text(l10n.ctaAddFirstCustomer, textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          OutlinedButton.icon(
                            onPressed: _importFromContacts,
                            icon: const Icon(Icons.contacts_outlined),
                            label: Text(l10n.customerImportContacts),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, i) {
                    final c = filtered[i];
                    final roleLine = _roleSubtitle(l10n, c);
                    final phone = c.phone;
                    final Widget? subtitle = phone != null && roleLine != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(phone),
                              Text(
                                roleLine,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: HomeShellTheme.textLightBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          )
                        : phone != null
                            ? Text(phone)
                            : roleLine != null
                                ? Text(
                                    roleLine,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: HomeShellTheme.textLightBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )
                                : null;
                    return Material(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                      child: ListTile(
                        title: Text(c.name),
                        subtitle: subtitle,
                        isThreeLine: phone != null && roleLine != null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/customers/${c.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerContactPickerSheet extends StatefulWidget {
  const _CustomerContactPickerSheet({
    required this.contacts,
    required this.title,
  });

  final List<CustomerContactOption> contacts;
  final String title;

  @override
  State<_CustomerContactPickerSheet> createState() => _CustomerContactPickerSheetState();
}

class _CustomerContactPickerSheetState extends State<_CustomerContactPickerSheet> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.contacts
        : widget.contacts.where((contact) {
            return contact.name.toLowerCase().contains(query) ||
                (contact.phone?.toLowerCase().contains(query) ?? false);
          }).toList(growable: false);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final contact = filtered[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Text(contact.name.substring(0, 1).toUpperCase()),
                      ),
                      title: Text(contact.name),
                      subtitle: contact.phone != null ? Text(contact.phone!) : null,
                      onTap: () => Navigator.of(context).pop(contact),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
