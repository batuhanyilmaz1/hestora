import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Şifre sıfırlama e-postasındaki oturum (recovery) açıldığında güncelleme sayfasına yönlendirir.
class AuthRecoveryWrapper extends StatefulWidget {
  const AuthRecoveryWrapper({
    super.key,
    required this.router,
    required this.child,
  });

  final GoRouter router;
  final Widget child;

  @override
  State<AuthRecoveryWrapper> createState() => _AuthRecoveryWrapperState();
}

class _AuthRecoveryWrapperState extends State<AuthRecoveryWrapper> {
  StreamSubscription<AuthState>? _sub;

  @override
  void initState() {
    super.initState();
    try {
      _sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        final e = data.event;
        final isRecovery = e == AuthChangeEvent.passwordRecovery ||
            e.toString().contains('passwordRecovery');
        if (isRecovery && mounted) {
          widget.router.go('/auth/update-password');
        }
      });
    } catch (_) {
      // Supabase başlatılmadıysa (ör. widget test) dinleyici kurulmaz.
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
