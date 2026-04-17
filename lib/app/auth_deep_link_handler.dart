import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/auth_redirect.dart';

/// E-postadaki şifre sıfırlama / magic link URI'sini yakalayıp oturumu kurar.
/// [AuthRecoveryWrapper] ile birlikte recovery ekranına yönlendirme yapılır.
class AuthDeepLinkHandler extends StatefulWidget {
  const AuthDeepLinkHandler({super.key, required this.child});

  final Widget child;

  @override
  State<AuthDeepLinkHandler> createState() => _AuthDeepLinkHandlerState();
}

class _AuthDeepLinkHandlerState extends State<AuthDeepLinkHandler> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  static bool _isAuthRedirect(Uri u) {
    final expected = Uri.parse(kAuthDeepLinkRedirect);
    return u.scheme == expected.scheme && u.host == expected.host;
  }

  Future<void> _consumeAuthUri(Uri? uri) async {
    if (uri == null || !_isAuthRedirect(uri)) {
      return;
    }
    try {
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
    } catch (_) {
      // Supabase yok veya URI auth formatında değil.
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _consumeAuthUri(await _appLinks.getInitialLink());
      } catch (_) {}
    });
    _sub = _appLinks.uriLinkStream.listen(_consumeAuthUri, onError: (_) {});
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
