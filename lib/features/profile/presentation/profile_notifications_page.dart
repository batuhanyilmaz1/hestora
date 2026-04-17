import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/notification_prefs.dart';

class ProfileNotificationsPage extends StatefulWidget {
  const ProfileNotificationsPage({super.key});

  @override
  State<ProfileNotificationsPage> createState() => _ProfileNotificationsPageState();
}

class _ProfileNotificationsPageState extends State<ProfileNotificationsPage> {
  bool _matches = true;
  bool _tasks = true;
  bool _marketing = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final m = await NotificationPrefs.getMatches();
    final t = await NotificationPrefs.getTasks();
    final k = await NotificationPrefs.getMarketing();
    if (mounted) {
      setState(() {
        _matches = m;
        _tasks = t;
        _marketing = k;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.profileNotificationsTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  l10n.profileNotificationsSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SwitchListTile.adaptive(
                  value: _matches,
                  onChanged: (v) async {
                    setState(() => _matches = v);
                    await NotificationPrefs.setMatches(v);
                  },
                  title: Text(l10n.profileNotifyMatches),
                  subtitle: Text(
                    l10n.profileNotifyMatchesSubtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                ),
                SwitchListTile.adaptive(
                  value: _tasks,
                  onChanged: (v) async {
                    setState(() => _tasks = v);
                    await NotificationPrefs.setTasks(v);
                  },
                  title: Text(l10n.profileNotifyTasks),
                  subtitle: Text(
                    l10n.profileNotifyTasksSubtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                ),
                SwitchListTile.adaptive(
                  value: _marketing,
                  onChanged: (v) async {
                    setState(() => _marketing = v);
                    await NotificationPrefs.setMarketing(v);
                  },
                  title: Text(l10n.profileNotifyMarketing),
                  subtitle: Text(
                    l10n.profileNotifyMarketingSubtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                ),
              ],
            ),
    );
  }
}
