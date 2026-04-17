import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import 'widgets/auth_gradient_button.dart';
import 'widgets/auth_page_shell.dart';
import 'widgets/auth_ui_constants.dart';

class PasswordUpdatedPage extends StatelessWidget {
  const PasswordUpdatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageShell(
      appBarTitle: l10n.passwordUpdatedTitle,
      showBack: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.45)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                    blurRadius: 28,
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                size: 44,
                color: Color(0xFF4ADE80),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.passwordUpdatedTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.passwordUpdatedBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AuthUi.subline, fontSize: 15),
          ),
          const SizedBox(height: 24),
          _Bullet(icon: Icons.lock_outline, text: l10n.passwordUpdatedB1, color: const Color(0xFF22C55E)),
          const SizedBox(height: 12),
          _Bullet(icon: Icons.devices_other_rounded, text: l10n.passwordUpdatedB2, color: const Color(0xFF60A5FA)),
          const SizedBox(height: 12),
          _Bullet(icon: Icons.shield_moon_outlined, text: l10n.passwordUpdatedB3, color: const Color(0xFFA78BFA)),
          const SizedBox(height: 28),
          AuthGradientButton(
            label: l10n.goToLogin,
            icon: Icons.login_rounded,
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AuthUi.cardTint.withValues(alpha: 0.85),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
