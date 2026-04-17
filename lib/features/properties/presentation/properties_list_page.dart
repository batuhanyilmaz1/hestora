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
import '../data/property_repository.dart';
import '../domain/property.dart';
import '../../customers/data/customer_repository.dart';

enum _PropFilter { all, sale, rent, active, inactive }

class PropertiesListPage extends ConsumerStatefulWidget {
  const PropertiesListPage({super.key});

  @override
  ConsumerState<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends ConsumerState<PropertiesListPage> {
  final _search = TextEditingController();
  _PropFilter _filter = _PropFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Property> _apply(List<Property> raw) {
    var list = raw;
    final q = _search.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.title.toLowerCase().contains(q) ||
                (p.location?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    switch (_filter) {
      case _PropFilter.all:
        return list;
      case _PropFilter.sale:
        return list.where((p) => p.listingType == 'sale').toList();
      case _PropFilter.rent:
        return list.where((p) => p.listingType == 'rent').toList();
      case _PropFilter.active:
        return list.where((p) => p.active).toList();
      case _PropFilter.inactive:
        return list.where((p) => !p.active).toList();
    }
  }

  Widget _chip(BuildContext context, _PropFilter value, String label) {
    final selected = _filter == value;
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
        onSelected: (_) => setState(() => _filter = value),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final propsAsync = ref.watch(propertiesListProvider);
    final customersAsync = ref.watch(customersListProvider);
    final count = customersAsync.maybeWhen(data: (c) => c.length, orElse: () => 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.propertiesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.link_outlined),
            tooltip: l10n.listingImportTitle,
            onPressed: () => context.push('/properties/import'),
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: Text(
              l10n.propertiesSubtitle(count),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.searchListingsHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                _chip(context, _PropFilter.all, l10n.chipAll),
                _chip(context, _PropFilter.sale, l10n.chipSale),
                _chip(context, _PropFilter.rent, l10n.chipRent),
                _chip(context, _PropFilter.active, l10n.chipActive),
                _chip(context, _PropFilter.inactive, l10n.chipPassive),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: AppAsyncValueWidget<List<Property>>(
              value: propsAsync,
              data: (context, list) {
                final filtered = _apply(list);
                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadii.md),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.4),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: Icon(Icons.apartment_rounded, size: 40, color: HomeShellTheme.textLightBlue),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            l10n.heroCardTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.heroCardBody,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95),
                                ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          HestoraGradientFilledButton(
                            onPressed: () => context.push('/properties/new'),
                            icon: Icons.add_home_work_outlined,
                            label: Text(l10n.ctaAddFirstListing, textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    final price = p.price != null ? '${p.price} ${p.currency ?? ''}' : '—';
                    return Material(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      child: ListTile(
                        leading: p.imageUrls.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  p.imageUrls.first,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.home_work_outlined),
                                ),
                              )
                            : const Icon(Icons.home_work_outlined),
                        title: Text(p.title),
                        subtitle: Text(
                          '${p.listingType == 'rent' ? l10n.chipRent : l10n.chipSale} · $price',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/properties/${p.id}'),
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
