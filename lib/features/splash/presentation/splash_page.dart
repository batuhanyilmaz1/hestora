import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routeNext());
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.textSecondary.withValues(alpha: 0.85),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Text(
                l10n.splashLoading,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
