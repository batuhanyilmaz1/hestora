import 'package:flutter/material.dart';

import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';

const _provincesTr = <String>[
  'İstanbul',
  'Ankara',
  'İzmir',
  'Bursa',
  'Antalya',
  'Adana',
  'Konya',
];

const _listingLayouts = <String>[
  '1+1',
  '2+1',
  '3+1',
  '4+1',
  '5+1',
  'Daire',
  'Villa',
  'Arsa',
];

Future<String?> showProvincePickerSheet(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  return showHestoraBottomSheet<String>(
    context,
    title: l10n.provincePickTitle,
    initialChildSize: 0.5,
    body: (ctx, sc) {
      return ListView.separated(
        controller: sc,
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _provincesTr.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, i) {
          final name = _provincesTr[i];
          return Material(
            color: HestoraFigma.cardFill,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.pop(ctx, name),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 16),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: HestoraFigma.mutedText,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<String?> showListingLayoutPickerSheet(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  return showHestoraBottomSheet<String>(
    context,
    title: l10n.listingLayoutPickTitle,
    initialChildSize: 0.45,
    body: (ctx, sc) {
      return ListView(
        controller: sc,
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (final label in _listingLayouts)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HestoraFigma.mutedText,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: Colors.white.withValues(alpha: 0.03),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    minimumSize: const Size(0, 48),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => Navigator.pop(ctx, label),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
    },
  );
}
