import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/auth_initial_session.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';

/// Yakalanan auth URI → oturum + doğru sayfaya yönlendirme (çalışırken gelen linkler).
class AuthDeepLinkHandler extends ConsumerStatefulWidget {
  const AuthDeepLinkHandler({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AuthDeepLinkHandler> createState() => _AuthDeepLinkHandlerState();
}

class _AuthDeepLinkHandlerState extends ConsumerState<AuthDeepLinkHandler> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> _handleUri(Uri? uri) async {
    if (uri == null) {
      return;
    }
    try {
      final route = await AuthInitialSession.consumeAuthUriAndResolveRoute(uri);
      if (!mounted || route == null) {
        return;
      }
      ref.read(goRouterProvider).go(route);
    } catch (_) {
      if (!mounted) {
        return;
      }
      final messenger = ScaffoldMessenger.maybeOf(context);
      String message = 'Invalid sign-in link';
      try {
        message = AppLocalizations.of(context)!.authLinkInvalid;
      } catch (_) {}
      messenger?.showSnackBar(SnackBar(content: Text(message)));
      ref.read(goRouterProvider).go('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _sub = _appLinks.uriLinkStream.listen(_handleUri, onError: (_) {});
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
