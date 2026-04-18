import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/auth_redirect.dart';

/// Cold-start auth deep links must be consumed before [SplashPage] routes,
/// otherwise the app navigates to login/home without a session (blank / wrong screen).
abstract final class AuthInitialSession {
  static String? _pendingRoute;
  static String? _postOnboardingRoute;

  /// Onboarding bittikten sonra açılacak rota (ör. ilk kurulum + e-posta doğrulama).
  static String? takePostOnboardingRoute() {
    final r = _postOnboardingRoute;
    _postOnboardingRoute = null;
    return r;
  }

  static void setPostOnboardingRoute(String route) {
    _postOnboardingRoute = route;
  }

  /// Next in-app route after [consumeLaunchUriIfAny], if any (consumed by splash).
  static String? takePendingRoute() {
    final r = _pendingRoute;
    _pendingRoute = null;
    return r;
  }

  static bool _isAuthRedirect(Uri u) {
    final expected = Uri.parse(kAuthDeepLinkRedirect);
    return u.scheme == expected.scheme && u.host == expected.host;
  }

  static String? _typeFromUri(Uri uri) {
    final fromQuery = uri.queryParameters['type']?.trim();
    if (fromQuery != null && fromQuery.isNotEmpty) {
      return fromQuery;
    }
    if (uri.fragment.isEmpty) {
      return null;
    }
    final params = Uri.splitQueryString(uri.fragment);
    return params['type']?.trim();
  }

  static String _routeForAuthUri(Uri uri) {
    final type = _typeFromUri(uri);
    if (type == 'recovery') {
      return '/auth/update-password';
    }
    if (type == 'signup' || type == 'invite' || type == 'email_change' || type == 'email') {
      return '/post-verify';
    }
    return '/home';
  }

  /// Establishes Supabase session from an auth callback [uri] and returns the in-app route.
  /// Returns null if [uri] is not an auth redirect.
  static Future<String?> consumeAuthUriAndResolveRoute(Uri uri) async {
    if (!_isAuthRedirect(uri)) {
      return null;
    }
    await Supabase.instance.client.auth.getSessionFromUrl(uri);
    return _routeForAuthUri(uri);
  }

  /// Call from [main] after [SupabaseBootstrap.initIfConfigured].
  static Future<void> consumeLaunchUriIfAny() async {
    try {
      final uri = await AppLinks().getInitialLink();
      if (uri == null) {
        return;
      }
      final route = await consumeAuthUriAndResolveRoute(uri);
      _pendingRoute = route;
    } catch (_) {
      _pendingRoute = null;
    }
  }
}
