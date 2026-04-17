import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/hestora_ambient_background.dart';
import '../l10n/generated/app_localizations.dart';
import 'auth_deep_link_handler.dart';
import 'auth_recovery_wrapper.dart';
import 'providers/locale_controller.dart';
import 'providers/user_scoped_cache_listener.dart';
import 'router/app_router.dart';

class HestoraApp extends ConsumerWidget {
  const HestoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final localeOverride = ref.watch(localeOverrideProvider);

    return UserScopedCacheListener(
      child: AuthDeepLinkHandler(
        child: AuthRecoveryWrapper(
          router: router,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            theme: AppTheme.dark(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.dark,
            builder: (context, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  const HestoraAmbientBackground(),
                  child ?? const SizedBox.shrink(),
                ],
              );
            },
            locale: localeOverride,
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            localeListResolutionCallback: (locales, supported) {
              if (locales == null || locales.isEmpty) {
                return const Locale('tr');
              }
              for (final deviceLocale in locales) {
                for (final supportedLocale in supported) {
                  if (supportedLocale.languageCode != deviceLocale.languageCode) {
                    continue;
                  }
                  if (supportedLocale.countryCode == null ||
                      supportedLocale.countryCode == deviceLocale.countryCode) {
                    return supportedLocale;
                  }
                }
              }
              return const Locale('tr');
            },
          ),
        ),
      ),
    );
  }
}
