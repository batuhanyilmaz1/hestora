import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/locale_controller.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Referans: Dil ve Bölge Ayarları — bilgi kartı, üç seçim satırı, mavi Kaydet.
class LocaleRegionSettingsPage extends ConsumerStatefulWidget {
  const LocaleRegionSettingsPage({super.key});

  @override
  ConsumerState<LocaleRegionSettingsPage> createState() => _LocaleRegionSettingsPageState();
}

class _LocaleRegionSettingsPageState extends ConsumerState<LocaleRegionSettingsPage> {
  static const Map<String, String> _countryLabels = {
    'TR': 'Türkiye',
    'US': 'United States',
    'GB': 'United Kingdom',
    'DE': 'Germany',
    'AE': 'United Arab Emirates',
    'SA': 'Saudi Arabia',
  };

  String _currency = 'TRY';
  String _countryCode = 'TR';
  String _pendingLang = 'tr';
  bool _profileHydrated = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final locale = ref.read(localeOverrideProvider);
      final deviceLang = Localizations.localeOf(context).languageCode;
      final code = locale?.languageCode ??
          (deviceLang == 'en' || deviceLang == 'ar' || deviceLang == 'tr' ? deviceLang : 'tr');
      setState(() => _pendingLang = code);
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    if (_profileHydrated) {
      return;
    }
    final env = ref.read(appEnvironmentProvider);
    if (!SupabaseBootstrap.isClientReady(env)) {
      setState(() => _profileHydrated = true);
      return;
    }
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) {
      setState(() => _profileHydrated = true);
      return;
    }
    try {
      final row = await Supabase.instance.client
          .from('profiles')
          .select('currency_code, country_code, language_code')
          .eq('id', uid)
          .maybeSingle();
      if (!mounted || row == null) {
        setState(() => _profileHydrated = true);
        return;
      }
      final c = row['currency_code'] as String?;
      final co = row['country_code'] as String?;
      final lang = row['language_code'] as String?;
      setState(() {
        _profileHydrated = true;
        if (c != null && c.trim().isNotEmpty) {
          _currency = c.trim();
        }
        if (co != null && co.trim().isNotEmpty && _countryLabels.containsKey(co.trim())) {
          _countryCode = co.trim();
        }
        if (lang != null && (lang == 'tr' || lang == 'en' || lang == 'ar')) {
          _pendingLang = lang;
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _profileHydrated = true);
      }
    }
  }

  String _langTitle(AppLocalizations l10n) {
    switch (_pendingLang) {
      case 'en':
        return l10n.languageEnglish;
      case 'ar':
        return l10n.languageArabic;
      default:
        return l10n.languageTurkish;
    }
  }

  String _langFlag() {
    switch (_pendingLang) {
      case 'en':
        return '🇬🇧';
      case 'ar':
        return '🇸🇦';
      default:
        return '🇹🇷';
    }
  }

  String _currencyLabel(AppLocalizations l10n) {
    switch (_currency) {
      case 'USD':
        return 'USD — US Dollar';
      case 'EUR':
        return 'EUR — Euro';
      default:
        return l10n.currencyTry;
    }
  }

  Future<void> _pickLanguage(AppLocalizations l10n) async {
    final v = await _showOptionsSheet<String>(
      title: l10n.languageSectionTitle,
      options: [
        (value: 'tr', label: l10n.languageTurkish, leading: const Text('🇹🇷', style: TextStyle(fontSize: 20))),
        (value: 'en', label: l10n.languageEnglish, leading: const Text('🇬🇧', style: TextStyle(fontSize: 20))),
        (value: 'ar', label: l10n.languageArabic, leading: const Text('🇸🇦', style: TextStyle(fontSize: 20))),
      ],
      selected: _pendingLang,
    );
    if (v != null && mounted) {
      setState(() => _pendingLang = v);
    }
  }

  Future<void> _pickCountry(AppLocalizations l10n) async {
    final entries = _countryLabels.entries.toList();
    final v = await _showOptionsSheet<String>(
      title: l10n.fieldRegionCountry,
      options: entries
          .map(
            (e) => (
              value: e.key,
              label: e.value,
              leading: Icon(Icons.location_on_outlined, color: HomeShellTheme.textLightBlue.withValues(alpha: 0.9)),
            ),
          )
          .toList(),
      selected: _countryCode,
    );
    if (v != null && mounted) {
      setState(() => _countryCode = v);
    }
  }

  Future<void> _pickCurrency(AppLocalizations l10n) async {
    final v = await _showOptionsSheet<String>(
      title: l10n.fieldCurrency,
      options: [
        (value: 'TRY', label: l10n.currencyTry, leading: const Text('₺', style: TextStyle(fontSize: 20, color: Color(0xFF93C5FD)))),
        (value: 'USD', label: 'USD — US Dollar', leading: const Text('\$', style: TextStyle(fontSize: 18, color: Color(0xFF86EFAC)))),
        (value: 'EUR', label: 'EUR — Euro', leading: const Text('€', style: TextStyle(fontSize: 18, color: Color(0xFFFDE047)))),
      ],
      selected: _currency,
    );
    if (v != null && mounted) {
      setState(() => _currency = v);
    }
  }

  Future<T?> _showOptionsSheet<T>({
    required String title,
    required List<({T value, String label, Widget leading})> options,
    required T selected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: HestoraFigma.sheetBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(HestoraFigma.sheetTopRadius)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
                  child: Text(
                    title,
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                const Divider(height: 1, color: HestoraFigma.divider),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, i) {
                    final o = options[i];
                    final isSel = o.value == selected;
                    return Material(
                      color: isSel ? Colors.white.withValues(alpha: 0.06) : HestoraFigma.cardFill,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.pop(ctx, o.value),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
                          child: Row(
                            children: [
                              SizedBox(width: 40, child: o.leading),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  o.label,
                                  style: TextStyle(
                                    color: isSel ? HomeShellTheme.primaryBlue : HestoraFigma.mutedText,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              if (isSel)
                                Icon(Icons.check_rounded, color: HomeShellTheme.primaryBlue, size: 22),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveAll() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      final env = ref.read(appEnvironmentProvider);
      if (SupabaseBootstrap.isClientReady(env)) {
        final uid = Supabase.instance.client.auth.currentUser?.id;
        if (uid != null) {
          await Supabase.instance.client.from('profiles').update({
            'language_code': _pendingLang,
            'currency_code': _currency,
            'country_code': _countryCode,
          }).eq('id', uid);
        }
      }
      switch (_pendingLang) {
        case 'en':
          ref.read(localeOverrideProvider.notifier).state = const Locale('en');
          break;
        case 'ar':
          ref.read(localeOverrideProvider.notifier).state = const Locale('ar');
          break;
        default:
          ref.read(localeOverrideProvider.notifier).state = const Locale('tr');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.localeRegionSavedBody)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
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
                title: l10n.localeRegionTitle,
                subtitle: l10n.localeRegionScreenSubtitle,
                onBack: () => context.pop(),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                children: [
                  HestoraFigmaCard(
                    child: Text(
                      l10n.localeRegionIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: HomeShellTheme.textLightBlue.withValues(alpha: 0.92),
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _sectionCaps(context, l10n.languageSectionTitle),
                  _LocaleSelectRow(
                    leading: Text(_langFlag(), style: const TextStyle(fontSize: 22)),
                    title: _langTitle(l10n),
                    subtitle: l10n.appLanguageHint,
                    onTap: () => _pickLanguage(l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _sectionCaps(context, l10n.fieldRegionCountry),
                  _LocaleSelectRow(
                    leading: Icon(Icons.location_on_outlined, color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95)),
                    title: _countryLabels[_countryCode] ?? _countryCode,
                    subtitle: l10n.regionSettingHint,
                    onTap: () => _pickCountry(l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _sectionCaps(context, l10n.fieldCurrency),
                  _LocaleSelectRow(
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        _currency == 'EUR' ? '€' : _currency == 'USD' ? '\$' : '₺',
                        style: TextStyle(
                          fontSize: 22,
                          color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: _currencyLabel(l10n),
                    subtitle: l10n.currencySettingHint,
                    onTap: () => _pickCurrency(l10n),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: HomeShellTheme.primaryBlue,
                  boxShadow: [
                    BoxShadow(
                      color: HomeShellTheme.primaryBlue.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _saving ? null : _saveAll,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_saving)
                            const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          else ...[
                            const Icon(Icons.save_outlined, color: Colors.white, size: 22),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              l10n.save,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCaps(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: HomeShellTheme.primaryBlue,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _LocaleSelectRow extends StatelessWidget {
  const _LocaleSelectRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: HestoraFigma.cardFill,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: leading,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 16),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: HestoraFigma.mutedText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.45)),
            ],
          ),
        ),
      ),
    );
  }
}
