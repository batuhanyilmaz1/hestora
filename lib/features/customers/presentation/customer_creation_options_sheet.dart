import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

enum _CustomerCreationMode { manual, ai }

Future<void> showCustomerCreationOptionsSheet(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final mode = await showModalBottomSheet<_CustomerCreationMode>(
    context: context,
    backgroundColor: HomeShellTheme.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.customerCreateMethodTitle,
                style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              _CreationOptionCard(
                icon: Icons.edit_note_rounded,
                title: l10n.customerCreateOptionManual,
                body: l10n.customerCreateOptionManualBody,
                onTap: () => Navigator.of(sheetContext).pop(_CustomerCreationMode.manual),
              ),
              const SizedBox(height: AppSpacing.md),
              _CreationOptionCard(
                icon: Icons.auto_awesome_rounded,
                title: l10n.customerCreateOptionAi,
                body: l10n.customerCreateOptionAiBody,
                onTap: () => Navigator.of(sheetContext).pop(_CustomerCreationMode.ai),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (!context.mounted || mode == null) {
    return;
  }

  switch (mode) {
    case _CustomerCreationMode.manual:
      context.push('/customers/new');
      return;
    case _CustomerCreationMode.ai:
      context.push('/customers/ai-import');
      return;
  }
}

class _CreationOptionCard extends StatelessWidget {
  const _CreationOptionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: HomeShellTheme.secondaryButtonFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: HomeShellTheme.borderBlue.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: HomeShellTheme.primaryBlue.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: HomeShellTheme.borderBlue.withValues(alpha: 0.45),
                ),
              ),
              child: Icon(icon, color: HomeShellTheme.textLightBlue),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HomeShellTheme.textLightBlue.withValues(alpha: 0.92),
                          height: 1.4,
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
}
