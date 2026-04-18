import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../data/profile_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Figma: Hesap Bilgileri — Kişisel / Marka kartı sekmeleri.
class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HestoraFigmaHeader(
              title: l10n.accountInfoTitle,
              subtitle: l10n.accountInfoSubtitle,
              onBack: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: HestoraFigma.cardFill,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: TabBar(
                  controller: _tabs,
                  indicator: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: HestoraFigma.mutedText,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: l10n.accountTabPersonal),
                    Tab(text: l10n.accountTabBrand),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _PersonalHubTab(l10n: l10n),
                  const _BrandCardTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalHubTab extends StatelessWidget {
  const _PersonalHubTab({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
      children: [
        _HubTile(
          icon: Icons.person_outline_rounded,
          iconColor: AppColors.primary,
          title: l10n.accountHubProfileTitle,
          subtitle: l10n.accountHubProfileSubtitle,
          onTap: () => context.push('/profile/account/profile'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _HubTile(
          icon: Icons.lock_outline_rounded,
          iconColor: const Color(0xFF34D399),
          title: l10n.accountHubChangePasswordTitle,
          subtitle: l10n.accountHubChangePasswordSubtitle,
          onTap: () => context.push('/auth/update-password'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _HubTile(
          icon: Icons.alternate_email_rounded,
          iconColor: const Color(0xFF38BDF8),
          title: l10n.accountHubChangeEmailTitle,
          subtitle: l10n.accountHubChangeEmailSubtitle,
          onTap: () => context.push('/profile/account/profile?focus=email'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _HubTile(
          icon: Icons.language_rounded,
          iconColor: const Color(0xFF818CF8),
          title: l10n.localeRegionTitle,
          subtitle: l10n.localeRegionIntro,
          onTap: () => context.push('/profile/locale-region'),
        ),
      ],
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.md),
            color: HestoraFigma.cardFill,
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(color: HestoraFigma.mutedText, height: 1.25, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.35)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandCardTab extends ConsumerStatefulWidget {
  const _BrandCardTab();

  @override
  ConsumerState<_BrandCardTab> createState() => _BrandCardTabState();
}

class _BrandCardTabState extends ConsumerState<_BrandCardTab> {
  final _slogan = TextEditingController();
  final _website = TextEditingController();
  int _template = 0;
  bool _busy = false;
  ProfileRow? _profileRow;

  @override
  void initState() {
    super.initState();
    _hydrateFromAuth();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repo = ref.read(profileRepositoryProvider);
      if (!repo.supportsRemote || !mounted) {
        return;
      }
      try {
        final row = await repo.fetchCurrent();
        if (mounted) {
          setState(() => _profileRow = row);
        }
      } catch (_) {}
    });
  }

  void _hydrateFromAuth() {
    final u = Supabase.instance.client.auth.currentUser;
    final m = u?.userMetadata;
    if (m == null) {
      return;
    }
    final slogan = m['brand_slogan'];
    if (slogan is String && slogan.isNotEmpty) {
      _slogan.text = slogan;
    }
    final web = m['brand_website'];
    if (web is String && web.isNotEmpty) {
      _website.text = web;
    }
    final t = m['brand_template'];
    if (t is int) {
      _template = t.clamp(0, 3);
    } else if (t is num) {
      _template = t.toInt().clamp(0, 3);
    }
  }

  String _displayName(AppLocalizations l10n) {
    final n = _profileRow?.displayName?.trim();
    if (n != null && n.isNotEmpty) {
      return n;
    }
    final email = Supabase.instance.client.auth.currentUser?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return l10n.brandPreviewName;
  }

  String _initials() {
    final n = _profileRow?.displayName?.trim();
    if (n == null || n.isEmpty) {
      final e = Supabase.instance.client.auth.currentUser?.email;
      if (e != null && e.isNotEmpty) {
        return e.substring(0, 1).toUpperCase();
      }
      return '?';
    }
    final parts = n.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.length >= 2) {
      final a = parts[0].isNotEmpty ? parts[0][0] : '';
      final b = parts[1].isNotEmpty ? parts[1][0] : '';
      return ('$a$b').toUpperCase();
    }
    if (n.length >= 2) {
      return n.substring(0, 2).toUpperCase();
    }
    return n.substring(0, 1).toUpperCase();
  }

  String _emailLine() {
    final e = Supabase.instance.client.auth.currentUser?.email?.trim();
    if (e != null && e.isNotEmpty) {
      return e;
    }
    return '—';
  }

  String _websiteLine() {
    final w = _website.text.trim();
    if (w.isEmpty) {
      return '—';
    }
    return w;
  }

  @override
  void dispose() {
    _slogan.dispose();
    _website.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    final env = ref.read(appEnvironmentProvider);
    if (!SupabaseBootstrap.isClientReady(env)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.supabaseStatusNotConfigured)));
      return;
    }
    setState(() => _busy = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'brand_slogan': _slogan.text.trim(),
            'brand_website': _website.text.trim(),
            'brand_template': _template,
          },
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.save)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final swatches = [
      (const Color(0xFF1E3A8A), l10n.brandTemplateDarkBlue),
      (const Color(0xFF0F172A), l10n.brandTemplateNight),
      (const Color(0xFF064E3B), l10n.brandTemplateEmerald),
      (const Color(0xFF713F12), l10n.brandTemplateGold),
    ];
    final base = swatches[_template.clamp(0, swatches.length - 1)].$1;
    final previewGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(base, Colors.white, 0.06)!,
        Color.lerp(base, Colors.black, 0.35)!,
      ],
    );
    const accentSoft = Color(0xFFBFDBFE);

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
      children: [
        Text(l10n.brandCardPreview, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 13)),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: previewGradient,
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: base.withValues(alpha: 0.45),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      child: Text(
                        _initials(),
                        style: const TextStyle(color: accentSoft, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayName(l10n),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          Text(
                            l10n.brandPreviewRole,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.72), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _slogan.text.isEmpty ? l10n.brandPreviewSloganPlaceholder : _slogan.text,
                  style: const TextStyle(color: Color(0xFF93C5FD), fontStyle: FontStyle.italic, fontSize: 13, height: 1.35),
                ),
                const SizedBox(height: 12),
                if ((_profileRow?.phone ?? '').trim().isNotEmpty)
                  _BrandContactLine(icon: Icons.phone_outlined, text: _profileRow!.phone!.trim())
                else
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () async {
                        await context.push<void>('/profile/account/profile');
                        if (!mounted) {
                          return;
                        }
                        ref.invalidate(profileRowProvider);
                        final repo = ref.read(profileRepositoryProvider);
                        if (!repo.supportsRemote) {
                          return;
                        }
                        try {
                          final row = await ref.read(profileRowProvider.future);
                          if (mounted) {
                            setState(() => _profileRow = row);
                          }
                        } catch (_) {}
                      },
                      icon: Icon(Icons.add_circle_outline_rounded, size: 20, color: accentSoft.withValues(alpha: 0.95)),
                      label: Text(
                        l10n.brandCardAddPhoneAction,
                        style: TextStyle(color: accentSoft.withValues(alpha: 0.95), fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: accentSoft,
                      ),
                    ),
                  ),
                _BrandContactLine(icon: Icons.mail_outline_rounded, text: _emailLine()),
                _BrandContactLine(icon: Icons.language_rounded, text: _websiteLine()),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      l10n.brandCardWatermark,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.qr_code_2_rounded, size: 16, color: Colors.white.withValues(alpha: 0.55)),
                    const SizedBox(width: 4),
                    Text(
                      l10n.brandCardQr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.brandPickTemplate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(swatches.length, (i) {
            final sel = _template == i;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < swatches.length - 1 ? 8 : 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => setState(() => _template = i),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: swatches[i].$1,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: sel ? Colors.white : Colors.white.withValues(alpha: 0.14),
                                width: sel ? 2.5 : 1,
                              ),
                            ),
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: sel ? 1 : 0,
                                duration: const Duration(milliseconds: 160),
                                child: const Icon(Icons.check_circle, color: Colors.white, size: 26),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      swatches[i].$2,
                      style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 11),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.brandSloganLabel, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: _slogan,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: Colors.white),
          maxLines: 2,
          decoration: InputDecoration(
            filled: true,
            fillColor: HestoraFigma.cardFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.brandWebsiteLabel, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: _website,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: HestoraFigma.cardFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.brandShareSoon)),
                  );
                },
                icon: const Icon(Icons.share_outlined, color: Colors.white70),
                label: Text(l10n.brandShare, style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton(
                onPressed: _busy ? null : () => _save(l10n),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(l10n.save),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrandContactLine extends StatelessWidget {
  const _BrandContactLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.55)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
