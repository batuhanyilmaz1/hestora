import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/locale_controller.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Referans: Dil ve bölge ayarları — koyu tema, yeşil onay şeridi.
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
  bool _savedBanner = false;
  bool _profileHydrated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  Future<void> _loadProfile() async {
    if (_profileHydrated) {
      return;
    }
    final env = ref.read(appEnvironmentProvider);
    if (!SupabaseBootstrap.isClientReady(env)) {
      return;
    }
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) {
      return;
    }
    try {
      final row = await Supabase.instance.client
          .from('profiles')
          .select('currency_code, country_code')
          .eq('id', uid)
          .maybeSingle();
      if (!mounted || row == null) {
        return;
      }
      final c = row['currency_code'] as String?;
      final co = row['country_code'] as String?;
      setState(() {
        _profileHydrated = true;
        if (c != null && c.trim().isNotEmpty) {
          _currency = c.trim();
        }
        if (co != null && co.trim().isNotEmpty && _countryLabels.containsKey(co.trim())) {
          _countryCode = co.trim();
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _profileHydrated = true);
      }
    }
  }

  Future<void> _persist(String langCode) async {
    final env = ref.read(appEnvironmentProvider);
    if (SupabaseBootstrap.isClientReady(env)) {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid != null) {
        await Supabase.instance.client.from('profiles').update({
          'language_code': langCode,
          'currency_code': _currency,
          'country_code': _countryCode,
        }).eq('id', uid);
      }
    }
    switch (langCode) {
      case 'en':
        ref.read(localeOverrideProvider.notifier).state = const Locale('en');
        break;
      case 'ar':
        ref.read(localeOverrideProvider.notifier).state = const Locale('ar');
        break;
      default:
        ref.read(localeOverrideProvider.notifier).state = const Locale('tr');
    }
    setState(() => _savedBanner = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeOverrideProvider);
    final deviceLang = Localizations.localeOf(context).languageCode;
    final langCode = locale?.languageCode ??
        (deviceLang == 'en' || deviceLang == 'ar' || deviceLang == 'tr' ? deviceLang : 'tr');

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.localeRegionTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (_savedBanner)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.45)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success.withValues(alpha: 0.95)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.localeRegionSavedTitle,
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.localeRegionSavedBody,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              l10n.localeRegionIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.info, height: 1.4),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _label(l10n.languageSectionTitle),
          _selectCard(
            context,
            leading: const Text('🇹🇷', style: TextStyle(fontSize: 22)),
            title: langCode == 'tr'
                ? l10n.languageTurkish
                : langCode == 'en'
                    ? l10n.languageEnglish
                    : l10n.languageArabic,
            subtitle: l10n.appLanguageHint,
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: langCode,
                dropdownColor: AppColors.surfaceMuted,
                items: [
                  DropdownMenuItem(value: 'tr', child: Text(l10n.languageTurkish)),
                  DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                  DropdownMenuItem(value: 'ar', child: Text(l10n.languageArabic)),
                ],
                onChanged: (v) {
                  if (v != null) {
                    _persist(v);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _label(l10n.fieldRegionCountry),
          _selectCard(
            context,
            leading: Icon(Icons.location_on_outlined, color: AppColors.primary.withValues(alpha: 0.9)),
            title: _countryLabels[_countryCode] ?? _countryCode,
            subtitle: l10n.regionSettingHint,
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _countryCode,
                dropdownColor: AppColors.surfaceMuted,
                items: _countryLabels.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _countryCode = v);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _label(l10n.fieldCurrency),
          _selectCard(
            context,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('₺', style: TextStyle(fontSize: 22, color: AppColors.accentPurple.withValues(alpha: 0.95))),
            ),
            title: l10n.currencyTry,
            subtitle: l10n.currencySettingHint,
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currency,
                dropdownColor: AppColors.surfaceMuted,
                items: [
                  DropdownMenuItem(value: 'TRY', child: Text(l10n.currencyTry)),
                  const DropdownMenuItem(value: 'USD', child: Text('USD — US Dollar')),
                  const DropdownMenuItem(value: 'EUR', child: Text('EUR — Euro')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _currency = v);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.success.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _persist(langCode),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, color: Colors.white),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l10n.localeRegionSavedTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.info,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _selectCard(
    BuildContext context, {
    required Widget leading,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: leading,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.info)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
