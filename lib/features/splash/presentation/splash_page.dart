import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/assets/hestora_image_assets.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/onboarding/onboarding_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runSequence());
  }

  Future<void> _runSequence() async {
    for (var i = 0; i < HestoraImageAssets.splashSequence.length; i++) {
      if (!mounted) {
        return;
      }
      setState(() => _index = i);
      await Future<void>.delayed(const Duration(milliseconds: 900));
    }
    await _routeNext();
  }

  Future<void> _routeNext() async {
    if (!mounted) {
      return;
    }
    final env = ref.read(appEnvironmentProvider);
    final onboarded = await OnboardingPrefs.isComplete();
    if (!mounted) {
      return;
    }
    if (!onboarded) {
      context.go('/onboarding');
      return;
    }
    final clientReady = SupabaseBootstrap.isClientReady(env);
    if (clientReady) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        context.go('/login');
        return;
      }
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final path = HestoraImageAssets.splashSequence[_index.clamp(0, HestoraImageAssets.splashSequence.length - 1)];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: KeyedSubtree(
              key: ValueKey<String>(path),
              child: Image.asset(
                path,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) {
                  return ColoredBox(
                    color: AppColors.background,
                    child: Center(
                      child: Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary, size: 48),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: SafeArea(
              top: false,
              child: Text(
                l10n.splashLoading,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      shadows: const [
                        Shadow(blurRadius: 8, color: Colors.black87),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
