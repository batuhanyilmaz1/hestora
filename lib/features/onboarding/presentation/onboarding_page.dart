import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/assets/hestora_image_assets.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/onboarding/onboarding_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Full-screen carousel matching `assets/onboarding/onboarding_*.jpg` handoff.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

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

  void _next() {
    if (_index < HestoraImageAssets.onboardingSlideCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slides = HestoraImageAssets.onboardingSlides;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              return ColoredBox(
                color: Colors.black,
                child: Image.asset(
                  slides[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: Colors.black,
                      child: Center(child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48)),
                    );
                  },
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
                      child: Text(
                        l10n.onboardingSkip,
                        style: const TextStyle(
                          shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                        ),
                      ),
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
                    Colors.black.withOpacity(0.82),
                    Colors.black.withOpacity(0.45),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.45, 1],
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
                                color: i == _index ? AppColors.primary : AppColors.textSecondary.withOpacity(0.45),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppPrimaryButton(
                        label: _index == slides.length - 1 ? l10n.onboardingStart : l10n.onboardingNext,
                        onPressed: _next,
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
}
