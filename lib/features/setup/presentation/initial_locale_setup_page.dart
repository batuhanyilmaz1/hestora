import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/locale_controller.dart';
import '../../../core/onboarding/initial_setup_prefs.dart';
import '../../../core/onboarding/post_login_flow_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/hestora_ambient_background.dart';
import '../../../l10n/generated/app_localizations.dart';

/// İlk kurulum: onboarding + kayıt adımından sonra dil / bölge / para birimi.
///
/// [postLoginFlow]: Yeni hesap kaydı sonrası ilk girişte paket seçiminden önce aynı tema.
class InitialLocaleSetupPage extends ConsumerStatefulWidget {
  const InitialLocaleSetupPage({super.key, this.postLoginFlow = false});

  final bool postLoginFlow;

  @override
  ConsumerState<InitialLocaleSetupPage> createState() => _InitialLocaleSetupPageState();
}

class _InitialLocaleSetupPageState extends ConsumerState<InitialLocaleSetupPage> {
  static const List<String> _countryCodesOrdered = ['TR', 'AE', 'US', 'GB', 'DE'];
  static const List<String> _currencyCodesOrdered = ['TRY', 'USD', 'AED', 'EUR', 'GBP'];

  String _langCode = 'tr';
  String _currency = 'TRY';
  String _countryCode = 'TR';

  void _applyLocale(String code) {
    switch (code) {
      case 'en':
        ref.read(localeOverrideProvider.notifier).state = const Locale('en');
        break;
      case 'ar':
        ref.read(localeOverrideProvider.notifier).state = const Locale('ar');
        break;
      default:
        ref.read(localeOverrideProvider.notifier).state = const Locale('tr');
    }
  }

  String _countryName(AppLocalizations l10n, String code) {
    return switch (code) {
      'TR' => l10n.regionTurkey,
      'AE' => l10n.regionCountryAE,
      'US' => l10n.regionCountryUS,
      'GB' => l10n.regionCountryGB,
      'DE' => l10n.regionCountryDE,
      _ => code,
    };
  }

  String _currencyLabel(AppLocalizations l10n, String code) {
    return switch (code) {
      'USD' => l10n.currencyOptionUsd,
      'AED' => l10n.currencyOptionAed,
      'EUR' => l10n.currencyOptionEur,
      'GBP' => l10n.currencyOptionGbp,
      _ => l10n.currencyTry,
    };
  }

  String _currencySymbol(String code) {
    return switch (code) {
      'USD' => r'$',
      'EUR' => '€',
      'GBP' => '£',
      'AED' => 'د.إ',
      _ => '₺',
    };
  }

  Future<void> _continue() async {
    _applyLocale(_langCode);
    if (widget.postLoginFlow) {
      await PostLoginFlowPrefs.setRegionalDone();
      if (!mounted) {
        return;
      }
      context.go('/billing/packages');
      return;
    }
    await InitialSetupPrefs.setComplete();
    if (await PostLoginFlowPrefs.isSetupRequired()) {
      await PostLoginFlowPrefs.setRegionalDone();
    }
    if (!mounted) {
      return;
    }
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      if (await PostLoginFlowPrefs.isSetupRequired() && !await PostLoginFlowPrefs.isBillingDone()) {
        if (mounted) {
          context.go('/billing/packages');
        }
        return;
      }
      if (mounted) {
        context.go('/home');
      }
      return;
    }
    if (mounted) {
      context.go('/login');
    }
  }

  Future<void> _openCountryPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    const sheetBg = Color(0xFF1A1C2E);
    const selectedFill = Color(0x331E3A5F);
    const selectedText = Color(0xFF60A5FA);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _countryCodesOrdered.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
            itemBuilder: (context, i) {
              final code = _countryCodesOrdered[i];
              final sel = code == _countryCode;
              final label = _countryName(l10n, code);
              return Material(
                color: sel ? selectedFill : Colors.transparent,
                child: ListTile(
                  title: Text(
                    label,
                    style: TextStyle(
                      color: sel ? selectedText : const Color(0xFF94A3B8),
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  trailing: sel ? const Icon(Icons.check_rounded, color: selectedText, size: 22) : null,
                  onTap: () {
                    setState(() => _countryCode = code);
                    Navigator.pop(ctx);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openCurrencyPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    const sheetBg = Color(0xFF1A1C2E);
    const selectedFill = Color(0xFF2D2B4A);
    const accent = Color(0xFFA78BFA);
    const muted = Color(0xFF94A3B8);
    const nameMuted = Color(0xFF64748B);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _currencyCodesOrdered.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
            itemBuilder: (context, i) {
              final code = _currencyCodesOrdered[i];
              final sel = code == _currency;
              final full = _currencyLabel(l10n, code);
              final parts = full.split(' — ');
              final codeLine = parts.isNotEmpty ? parts.first : code;
              final nameLine = parts.length > 1 ? parts.sublist(1).join(' — ') : '';

              return Material(
                color: sel ? selectedFill : Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() => _currency = code);
                    Navigator.pop(ctx);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36,
                          child: Text(
                            _currencySymbol(code),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: sel ? accent : muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                codeLine,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: sel ? accent : muted,
                                ),
                              ),
                              if (nameLine.isNotEmpty)
                                Text(
                                  nameLine,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: sel ? accent.withValues(alpha: 0.85) : nameMuted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (sel) const Icon(Icons.check_rounded, color: accent, size: 22),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final content = SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.initialSetupTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.initialSetupSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _label(l10n.languageSectionTitle),
          _selectCard(
            context,
            leading: const Text('🌐', style: TextStyle(fontSize: 22)),
            title: switch (_langCode) {
              'en' => l10n.languageEnglish,
              'ar' => l10n.languageArabic,
              _ => l10n.languageTurkish,
            },
            subtitle: l10n.appLanguageHint,
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _langCode,
                dropdownColor: AppColors.surfaceMuted,
                items: [
                  DropdownMenuItem(value: 'tr', child: Text(l10n.languageTurkish)),
                  DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                  DropdownMenuItem(value: 'ar', child: Text(l10n.languageArabic)),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _langCode = v);
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
            title: _countryName(l10n, _countryCode),
            subtitle: l10n.regionSettingHint,
            trailing: IconButton(
              onPressed: () => _openCountryPicker(context),
              icon: const Icon(Icons.expand_more_rounded),
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _label(l10n.fieldCurrency),
          _selectCard(
            context,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                _currencySymbol(_currency),
                style: TextStyle(fontSize: 22, color: AppColors.accentPurple.withValues(alpha: 0.95)),
              ),
            ),
            title: _currencyLabel(l10n, _currency),
            subtitle: l10n.currencySettingHint,
            trailing: IconButton(
              onPressed: () => _openCurrencyPicker(context),
              icon: const Icon(Icons.expand_more_rounded),
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppPrimaryButton(
            label: l10n.initialSetupContinue,
            onPressed: _continue,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: widget.postLoginFlow ? Colors.transparent : AppColors.background,
      body: widget.postLoginFlow
          ? Stack(
              fit: StackFit.expand,
              children: [
                const HestoraAmbientBackground(),
                content,
              ],
            )
          : content,
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
        borderRadius: BorderRadius.circular(AppRadii.sm),
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
