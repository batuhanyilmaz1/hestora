import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/auth/auth_initial_session.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/onboarding/first_run_register_gate_prefs.dart';
import '../../../core/onboarding/initial_setup_prefs.dart';
import '../../../core/onboarding/onboarding_prefs.dart';
import '../../../core/onboarding/post_login_flow_prefs.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  static const Color _splashBg = Color(0xFF000000);
  static const String _logoAsset = 'assets/logo/LOGO.png';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _precacheAndRoute());
  }

  Future<void> _precacheAndRoute() async {
    if (!mounted) {
      return;
    }
    await precacheImage(const AssetImage(_logoAsset), context);
    if (!mounted) {
      return;
    }
    await _routeNext();
  }

  Future<void> _routeNext() async {
    if (!mounted) {
      return;
    }

    final pending = AuthInitialSession.takePendingRoute();
    final env = ref.read(appEnvironmentProvider);
    final onboarded = await OnboardingPrefs.isComplete();
    final registerGatePassed = await FirstRunRegisterGatePrefs.isPassed();
    final localeSetupDone = await InitialSetupPrefs.isComplete();

    if (onboarded && localeSetupDone && !registerGatePassed) {
      await FirstRunRegisterGatePrefs.setPassed();
    }

    final gate = await FirstRunRegisterGatePrefs.isPassed();
    if (!mounted) {
      return;
    }

    if (pending != null && onboarded && gate && localeSetupDone) {
      context.go(pending);
      return;
    }
    if (!onboarded && (pending == '/post-verify' || pending == '/auth/update-password')) {
      AuthInitialSession.setPostOnboardingRoute(pending!);
    }

    if (!onboarded) {
      context.go('/onboarding');
      return;
    }
    if (!gate) {
      context.go('/register');
      return;
    }
    if (!localeSetupDone) {
      context.go('/setup/locale');
      return;
    }

    final clientReady = SupabaseBootstrap.isClientReady(env);
    if (clientReady) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        context.go('/login');
        return;
      }
      if (await PostLoginFlowPrefs.isSetupRequired()) {
        if (!await PostLoginFlowPrefs.isRegionalDone()) {
          if (mounted) {
            context.go('/post-login/locale');
          }
          return;
        }
        if (!await PostLoginFlowPrefs.isBillingDone()) {
          if (mounted) {
            context.go('/billing/packages');
          }
          return;
        }
      }
    }
    if (!mounted) {
      return;
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _splashBg,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth * 0.82;
              return SizedBox(
                width: maxW,
                height: 200,
                child: Image.asset(
                  _logoAsset,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
