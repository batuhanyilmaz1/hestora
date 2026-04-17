import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/auth_redirect.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/auth_caps_field.dart';
import 'widgets/auth_form_card.dart';
import 'widgets/auth_gradient_button.dart';
import 'widgets/auth_page_shell.dart';
import 'widgets/auth_ui_constants.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final env = ref.read(appEnvironmentProvider);
    if (!SupabaseBootstrap.isClientReady(env)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.supabaseStatusNotConfigured)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _email.text.trim(),
        redirectTo: kAuthDeepLinkRedirect,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.resetEmailSent)),
      );
      if (mounted) {
        context.pop();
      }
    } on AuthException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageShell(
      appBarTitle: l10n.forgotTitle,
      appBarSubtitle: l10n.forgotHeaderSubtitle,
      showBack: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 40,
                  color: Color(0xFF60A5FA),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.forgotHeroTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.forgotHeroBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AuthUi.subline,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            AuthFormCard(
              child: AuthCapsField(
                label: l10n.forgotEmailLabelCaps,
                controller: _email,
                hintText: 'ornek@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline_rounded, color: Colors.white54),
                autofillHints: const [AutofillHints.email],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.validationRequired;
                  }
                  if (!v.contains('@')) {
                    return l10n.validationEmail;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 22),
            AuthGradientButton(
              label: l10n.forgotSubmit,
              icon: Icons.send_rounded,
              onPressed: _busy ? null : _submit,
            ),
            const SizedBox(height: 28),
            Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
                children: [
                  TextSpan(text: '${l10n.forgotRememberedLogin} '),
                  TextSpan(
                    text: l10n.loginTitle,
                    style: const TextStyle(
                      color: Color(0xFF60A5FA),
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.go('/login'),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
