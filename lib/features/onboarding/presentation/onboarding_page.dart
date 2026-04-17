import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/onboarding/onboarding_content.dart';
import '../../../core/onboarding/onboarding_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/hestora_ambient_background.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Onboarding uses layout + typography only; copy is loaded from
/// `assets/onboarding/onboarding_content.json`.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;
  String? _loadedLang;
  Future<OnboardingContentBundle>? _contentFuture;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await OnboardingPrefs.setComplete();
    if (!mounted) {
      return;
    }
    final env = ref.read(appEnvironmentProvider);
    final clientReady = SupabaseBootstrap.isClientReady(env);
    if (clientReady && Supabase.instance.client.auth.currentUser == null) {
      context.go('/login');
    } else {
      context.go('/home');
    }
  }

  void _next(int slideCount) {
    if (_index < slideCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  static IconData _iconForSlide(int i) {
    return switch (i) {
      0 => Icons.groups_2_outlined,
      1 => Icons.maps_home_work_outlined,
      _ => Icons.task_alt_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (_loadedLang != lang) {
      _loadedLang = lang;
      _contentFuture = OnboardingContentLoader.load(lang);
    }

    return FutureBuilder<OnboardingContentBundle>(
      future: _contentFuture,
      builder: (context, snap) {
        final l10n = AppLocalizations.of(context)!;
        if (snap.hasError) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                const HestoraAmbientBackground(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.authErrorGeneric,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppPrimaryButton(
                          label: l10n.taskRetryLoad,
                          onPressed: () => setState(() {
                            _contentFuture = OnboardingContentLoader.load(lang);
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (!snap.hasData) {
          return const Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                HestoraAmbientBackground(),
                Center(child: CircularProgressIndicator(color: AppColors.primary)),
              ],
            ),
          );
        }
        final bundle = snap.data!;
        final slides = bundle.slides;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const HestoraAmbientBackground(),
              PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final slide = slides[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 2),
                        Icon(
                          _iconForSlide(i),
                          size: 72,
                          color: AppColors.primary.withValues(alpha: 0.95),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.45,
                              ),
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _finish,
                          style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
                          child: Text(bundle.skipLabel),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.background.withValues(alpha: 0.94),
                        AppColors.background.withValues(alpha: 0.55),
                        Colors.transparent,
                      ],
                      stops: const [0, 0.42, 1],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.md,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              slides.length,
                              (i) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: i == _index ? 18 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: i == _index
                                        ? AppColors.primary
                                        : AppColors.textSecondary.withValues(alpha: 0.45),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppPrimaryButton(
                            label: _index == slides.length - 1 ? bundle.startLabel : bundle.nextLabel,
                            onPressed: () => _next(slides.length),
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
      },
    );
  }
}
