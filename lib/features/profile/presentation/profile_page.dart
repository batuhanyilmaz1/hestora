import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/auth_session_provider.dart';
import '../../../app/providers/invalidate_user_scoped_caches.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';
import '../../properties/data/property_repository.dart';
import '../../tasks/data/task_repository.dart';
import '../data/profile_repository.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final env = ref.watch(appEnvironmentProvider);
    final clientReady = SupabaseBootstrap.isClientReady(env);
    final session = ref.watch(authSessionProvider);
    final user = session.maybeWhen(data: (u) => u, orElse: () => null);

    final propsAsync = ref.watch(propertiesListProvider);
    final customersAsync = ref.watch(customersListProvider);
    final tasksAsync = ref.watch(tasksListProvider);

    final totalListings = propsAsync.maybeWhen(
      data: (l) => l.length,
      orElse: () => 0,
    );
    final activeListings = propsAsync.maybeWhen(
      data: (l) => l.where((p) => p.active).length,
      orElse: () => 0,
    );
    final totalCustomers = customersAsync.maybeWhen(
      data: (l) => l.length,
      orElse: () => 0,
    );
    final openTasks = tasksAsync.maybeWhen(
      data: (l) => l
          .where((t) => t.status == 'open' && !t.archived)
          .length,
      orElse: () => 0,
    );

    final profileAsync = ref.watch(profileRowProvider);
    final avatarUrl = profileAsync.maybeWhen(
      data: (p) => p?.avatarUrl,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.profileTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => context.pop(),
              )
            : null,
        actions: [
          PopupMenuButton<String>(
            tooltip: l10n.profileMoreMenu,
            icon: const Icon(Icons.more_vert_rounded),
            color: AppColors.surfaceElevated,
            onSelected: (value) {
              switch (value) {
                case 'tasks':
                  context.push('/tasks');
                case 'import':
                  context.push('/properties/import');
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'tasks',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.task_alt_outlined, color: AppColors.primary),
                  title: Text(l10n.navTasks),
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.link_outlined, color: AppColors.accentTeal),
                  title: Text(l10n.listingImportTitle),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          _ProfileHeroCard(
            l10n: l10n,
            user: user,
            clientReady: clientReady,
            avatarUrl: avatarUrl,
            totalListings: totalListings,
            totalCustomers: totalCustomers,
            onAvatarTap: clientReady && user != null
                ? () => _pickProfilePhoto(context, ref, l10n)
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          _QuickStatsRow(
            l10n: l10n,
            activeListings: activeListings,
            totalCustomers: totalCustomers,
            openTasks: openTasks,
          ),
          const SizedBox(height: AppSpacing.lg),
          _GlassMenuTile(
            icon: Icons.manage_accounts_outlined,
            iconColor: AppColors.primary,
            title: l10n.accountSettingsTitle,
            onTap: () => context.push('/profile/account'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GlassMenuTile(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF38BDF8),
            title: l10n.localeRegionTitle,
            onTap: () => context.push('/profile/locale-region'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GlassMenuTile(
            icon: Icons.notifications_none_rounded,
            iconColor: const Color(0xFF34D399),
            title: l10n.profileMenuNotifications,
            onTap: () => context.push('/profile/notifications'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GlassMenuTile(
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.accentPurple,
            title: l10n.profileMenuAnalytics,
            onTap: () => context.push('/profile/analytics'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GlassMenuTile(
            icon: Icons.headset_mic_outlined,
            iconColor: const Color(0xFFFBBF24),
            title: l10n.profileMenuSupport,
            onTap: () => context.push('/profile/support'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _GlassMenuTile(
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            title: l10n.signOut,
            isDestructive: true,
            onTap: () => _confirmSignOut(context, ref, l10n, clientReady),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text(
              l10n.profileAppVersion,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textDisabled,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _pickProfilePhoto(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final repo = ref.read(profileRepositoryProvider);
    if (!repo.supportsRemote) {
      return;
    }
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null || !context.mounted) {
      return;
    }
    try {
      await repo.uploadAvatarAndSaveUrl(file);
      ref.invalidate(profileRowProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profilePhotoUpdated)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  static Future<void> _confirmSignOut(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool clientReady,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) {
      return;
    }
    if (clientReady) {
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
        }
      }
    }
    invalidateUserScopedCaches(ref);
    if (context.mounted) {
      context.go('/login');
    }
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.l10n,
    required this.user,
    required this.clientReady,
    this.avatarUrl,
    required this.totalListings,
    required this.totalCustomers,
    this.onAvatarTap,
  });

  final AppLocalizations l10n;
  final User? user;
  final bool clientReady;
  final String? avatarUrl;
  final int totalListings;
  final int totalCustomers;
  final VoidCallback? onAvatarTap;

  String get _displayName {
    final u = user;
    if (u == null) {
      return clientReady ? '—' : 'Demo';
    }
    final meta = u.userMetadata;
    final n = meta?['full_name'] ?? meta?['name'];
    if (n is String && n.trim().isNotEmpty) {
      return n.trim();
    }
    final email = u.email;
    if (email != null && email.contains('@')) {
      final local = email.split('@').first;
      return local.replaceAll('.', ' ').split('_').first;
    }
    return email ?? '—';
  }

  String get _initials {
    if (user == null) {
      return '?';
    }
    final name = _displayName;
    final parts = name.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevated.withValues(alpha: 0.95),
            AppColors.surface.withValues(alpha: 0.92),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final url = avatarUrl;
              final hasPhoto = url != null && url.isNotEmpty;
              final bubble = Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAvatarTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasPhoto
                          ? null
                          : LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withValues(alpha: 0.75),
                              ],
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                        ),
                      ],
                      image: hasPhoto
                          ? DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: hasPhoto
                        ? null
                        : Text(
                            _initials,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimary,
                            ),
                          ),
                  ),
                ),
              );
              if (onAvatarTap != null) {
                return Tooltip(
                  message: l10n.profileChangePhoto,
                  child: bubble,
                );
              }
              return bubble;
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.profileRoleConsultant,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.profileStatsLine(totalListings, totalCustomers),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textDisabled,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  user?.email ?? (clientReady ? '—' : l10n.demoModeBanner),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({
    required this.l10n,
    required this.activeListings,
    required this.totalCustomers,
    required this.openTasks,
  });

  final AppLocalizations l10n;
  final int activeListings;
  final int totalCustomers;
  final int openTasks;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        color: AppColors.surface.withValues(alpha: 0.65),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatCell(
              value: '$activeListings',
              label: l10n.profileStatActiveListings,
              valueStyle: style.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          _divider(),
          Expanded(
            child: _StatCell(
              value: '$totalCustomers',
              label: l10n.profileStatTotalCustomers,
              valueStyle: style.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          _divider(),
          Expanded(
            child: _StatCell(
              value: '$openTasks',
              label: l10n.profileStatOpenTasks,
              valueStyle: style.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: AppColors.border.withValues(alpha: 0.5),
      );
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.label,
    this.valueStyle,
  });

  final String value;
  final String label;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: valueStyle?.copyWith(color: AppColors.textPrimary) ??
              Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.2,
              ),
        ),
      ],
    );
  }
}

class _GlassMenuTile extends StatelessWidget {
  const _GlassMenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDestructive
        ? AppColors.error.withValues(alpha: 0.35)
        : Colors.white.withValues(alpha: 0.07);
    final glow = isDestructive
        ? AppColors.error.withValues(alpha: 0.12)
        : AppColors.primary.withValues(alpha: 0.06);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            color: AppColors.surface.withValues(alpha: 0.55),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: glow,
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDestructive ? AppColors.error : AppColors.textPrimary,
                        ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDestructive
                      ? AppColors.error.withValues(alpha: 0.8)
                      : AppColors.textDisabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

