import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';
import '../../customers/domain/customer.dart';
import '../../properties/data/property_repository.dart';
import '../../properties/domain/property.dart';

String _customerRoleLabel(AppLocalizations l10n, Customer c) {
  final intent = (c.listingIntent ?? '').toLowerCase();
  if (intent.contains('buy') || intent.contains('alıcı')) {
    return l10n.customerRoleBuyer;
  }
  if (intent.contains('rent') || intent.contains('kiracı') || intent.contains('tenant')) {
    return l10n.customerRoleTenant;
  }
  if (intent.contains('sell') || intent.contains('satıcı') || intent.contains('seller')) {
    return l10n.customerRoleSeller;
  }
  if (intent.contains('landlord') || intent.contains('owner') || intent.contains('ev sahibi')) {
    return l10n.customerRoleLandlord;
  }
  return l10n.customerRoleBuyer;
}

Future<String?> showTaskCustomerPickerSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context)!;
  final async = ref.read(customersListProvider);
  final list = async.valueOrNull ?? const <Customer>[];

  return showHestoraBottomSheet<String>(
    context,
    title: l10n.taskSheetPickCustomerTitle,
    subtitle: l10n.taskSheetPickCustomerSubtitle,
    initialChildSize: 0.62,
    body: (ctx, sc) {
      return ListView.separated(
        controller: sc,
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: HestoraFigma.divider),
        itemBuilder: (context, i) {
          final c = list[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(ctx, c.id),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person_outline, color: Colors.white.withValues(alpha: 0.65)),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          if ((c.phone ?? '').trim().isNotEmpty)
                            Text(
                              c.phone!.trim(),
                              style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _customerRoleLabel(l10n, c),
                        style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<String?> showTaskPropertyPickerSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context)!;
  final async = ref.read(propertiesListProvider);
  final list = async.valueOrNull ?? const <Property>[];

  return showHestoraBottomSheet<String>(
    context,
    title: l10n.taskSheetPickPropertyTitle,
    subtitle: l10n.taskSheetPickPropertySubtitle,
    initialChildSize: 0.62,
    body: (ctx, sc) {
      return ListView.separated(
        controller: sc,
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: HestoraFigma.divider),
        itemBuilder: (context, i) {
          final p = list[i];
          final price = p.price != null ? '${p.price} ${p.currency ?? ''}' : '—';
          final chip = p.listingType == 'rent' ? l10n.chipRent : l10n.chipSale;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(ctx, p.id),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.apartment_outlined, color: Colors.white.withValues(alpha: 0.65)),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '$price · $chip',
                            style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
