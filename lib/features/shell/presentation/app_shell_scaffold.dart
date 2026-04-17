import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/presentation/customer_creation_options_sheet.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({super.key, required this.shell});

  final StatefulNavigationShell shell;

  int _visualIndexFromBranch(int branch) {
    if (branch <= 1) {
      return branch;
    }
    return branch + 1;
  }

  int _branchFromVisual(int visual) {
    if (visual <= 1) {
      return visual;
    }
    return visual - 1;
  }

  void _openQuickActions(BuildContext context) {
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
                  l10n.quickActionsTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person_add_alt_1_outlined, color: HomeShellTheme.textLightBlue),
                title: Text(l10n.quickAddCustomer, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Future<void>.delayed(Duration.zero, () {
                    if (context.mounted) {
                      showCustomerCreationOptionsSheet(context);
                    }
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.add_home_work_outlined, color: HomeShellTheme.textLightBlue),
                title: Text(l10n.quickAddProperty, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/properties/new');
                },
              ),
              ListTile(
                leading: Icon(Icons.task_alt_outlined, color: HomeShellTheme.textLightBlue),
                title: Text(l10n.navTasks, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/tasks');
                },
              ),
              ListTile(
                leading: Icon(Icons.link_outlined, color: HomeShellTheme.textLightBlue),
                title: Text(l10n.listingImportTitle, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/properties/import');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedVisual = _visualIndexFromBranch(shell.currentIndex);

    Widget item(int visualIndex, IconData icon, IconData selectedIcon, String tooltip) {
      final selected = selectedVisual == visualIndex;
      final inactive = const Color(0xFF64748B);
      final iconColor = selected ? Colors.white : inactive;

      return Expanded(
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final branch = _branchFromVisual(visualIndex);
                shell.goBranch(branch);
              },
              splashColor: HomeShellTheme.primaryBlue.withValues(alpha: 0.28),
              highlightColor: HomeShellTheme.primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: selected
                      ? Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: HomeShellTheme.borderBlue, width: 1.6),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF1E3A8A).withValues(alpha: 0.55),
                                const Color(0xFF0F172A),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: HomeShellTheme.primaryBlue.withValues(alpha: 0.35),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Icon(selectedIcon, color: iconColor, size: 24),
                        )
                      : SizedBox(
                          height: 46,
                          width: 46,
                          child: Icon(icon, color: iconColor, size: 24),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: HomeShellTheme.navBar,
          border: Border(
            top: BorderSide(color: HomeShellTheme.borderBlue.withValues(alpha: 0.18)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                item(0, Icons.home_outlined, Icons.home_rounded, l10n.navHome),
                item(1, Icons.people_outline, Icons.people_rounded, l10n.navCustomers),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: HomeShellTheme.primaryBlue.withValues(alpha: 0.55),
                                blurRadius: 22,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.35),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            elevation: 0,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              splashColor: Colors.white.withValues(alpha: 0.22),
                              highlightColor: Colors.white.withValues(alpha: 0.08),
                              onTap: () => _openQuickActions(context),
                              child: Ink(
                                width: 58,
                                height: 58,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF60A5FA),
                                      Color(0xFF2563EB),
                                      Color(0xFF1D4ED8),
                                      Color(0xFF1E3A8A),
                                    ],
                                    stops: [0.0, 0.35, 0.65, 1.0],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add, color: Colors.white, size: 30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                item(3, Icons.apartment_outlined, Icons.apartment_rounded, l10n.navProperties),
                item(4, Icons.person_outline, Icons.person_rounded, l10n.navProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
