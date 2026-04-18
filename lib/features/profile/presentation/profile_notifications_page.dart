import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/notification_prefs.dart';

/// Referans: Bildirim Ayarları — ana anahtar + tür kartı + dip not.
class ProfileNotificationsPage extends StatefulWidget {
  const ProfileNotificationsPage({super.key});

  @override
  State<ProfileNotificationsPage> createState() => _ProfileNotificationsPageState();
}

class _ProfileNotificationsPageState extends State<ProfileNotificationsPage> {
  bool _master = true;
  bool _tasks = true;
  bool _reminders = true;
  bool _matches = true;
  bool _system = true;
  bool _marketing = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final m = await NotificationPrefs.getMaster();
    final t = await NotificationPrefs.getTasks();
    final r = await NotificationPrefs.getReminders();
    final c = await NotificationPrefs.getMatches();
    final s = await NotificationPrefs.getSystem();
    final k = await NotificationPrefs.getMarketing();
    if (mounted) {
      setState(() {
        _master = m;
        _tasks = t;
        _reminders = r;
        _matches = c;
        _system = s;
        _marketing = k;
        _loading = false;
      });
    }
  }

  Future<void> _setMaster(bool v) async {
    setState(() => _master = v);
    await NotificationPrefs.setMaster(v);
  }

  Future<void> _setTasks(bool v) async {
    setState(() => _tasks = v);
    await NotificationPrefs.setTasks(v);
  }

  Future<void> _setReminders(bool v) async {
    setState(() => _reminders = v);
    await NotificationPrefs.setReminders(v);
  }

  Future<void> _setMatches(bool v) async {
    setState(() => _matches = v);
    await NotificationPrefs.setMatches(v);
  }

  Future<void> _setSystem(bool v) async {
    setState(() => _system = v);
    await NotificationPrefs.setSystem(v);
  }

  Future<void> _setMarketing(bool v) async {
    setState(() => _marketing = v);
    await NotificationPrefs.setMarketing(v);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
              child: HestoraFigmaHeader(
                title: l10n.profileNotificationsTitle,
                subtitle: l10n.profileNotificationsSubtitle,
                onBack: () => context.pop(),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
                      children: [
                        HestoraFigmaCard(
                          child: Row(
                            children: [
                              _GlowIcon(
                                icon: Icons.notifications_none_rounded,
                                color: HomeShellTheme.primaryBlue,
                                glow: HomeShellTheme.primaryBlue.withValues(alpha: 0.35),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.profileNotifyMasterTitle,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _master ? l10n.profileNotifyMasterOn : l10n.profileNotifyMasterOff,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: HestoraFigma.mutedText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _ColoredSwitch(
                                value: _master,
                                onChanged: _setMaster,
                                activeColor: HomeShellTheme.primaryBlue,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        HestoraFigmaCard(
                          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.profileNotifyTypesSection,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: HestoraFigma.mutedText,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.05,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              _NotifyTypeRow(
                                icon: Icons.task_alt_rounded,
                                title: l10n.profileNotifyTaskTitle,
                                subtitle: l10n.profileNotifyTaskSubtitle,
                                value: _tasks,
                                onChanged: _setTasks,
                                color: const Color(0xFF60A5FA),
                              ),
                              Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.75)),
                              _NotifyTypeRow(
                                icon: Icons.schedule_rounded,
                                title: l10n.profileNotifyReminderTitle,
                                subtitle: l10n.profileNotifyReminderSubtitle,
                                value: _reminders,
                                onChanged: _setReminders,
                                color: const Color(0xFF4ADE80),
                              ),
                              Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.75)),
                              _NotifyTypeRow(
                                icon: Icons.person_add_alt_1_rounded,
                                title: l10n.profileNotifyCustomerTitle,
                                subtitle: l10n.profileNotifyCustomerSubtitle,
                                value: _matches,
                                onChanged: _setMatches,
                                color: const Color(0xFFC084FC),
                              ),
                              Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.75)),
                              _NotifyTypeRow(
                                icon: Icons.settings_suggest_outlined,
                                title: l10n.profileNotifySystemTitle,
                                subtitle: l10n.profileNotifySystemSubtitle,
                                value: _system,
                                onChanged: _setSystem,
                                color: const Color(0xFFFACC15),
                              ),
                              Divider(height: 1, color: HestoraFigma.divider.withValues(alpha: 0.75)),
                              _NotifyTypeRow(
                                icon: Icons.campaign_outlined,
                                title: l10n.profileNotifyCampaignTitle,
                                subtitle: l10n.profileNotifyCampaignSubtitle,
                                value: _marketing,
                                onChanged: _setMarketing,
                                color: const Color(0xFFFB923C),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.profileNotifyDeviceNote,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: HestoraFigma.mutedText.withValues(alpha: 0.9),
                            height: 1.45,
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

class _GlowIcon extends StatelessWidget {
  const _GlowIcon({
    required this.icon,
    required this.color,
    required this.glow,
  });

  final IconData icon;
  final Color color;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.35),
        boxShadow: [
          BoxShadow(color: glow, blurRadius: 18, spreadRadius: 0),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}

class _NotifyTypeRow extends StatelessWidget {
  const _NotifyTypeRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _GlowIcon(icon: icon, color: color, glow: color.withValues(alpha: 0.35)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: HestoraFigma.mutedText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          _ColoredSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }
}

class _ColoredSwitch extends StatelessWidget {
  const _ColoredSwitch({
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: activeColor.withValues(alpha: 0.95),
      inactiveThumbColor: Colors.white.withValues(alpha: 0.75),
      inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
    );
  }
}
