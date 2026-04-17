import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/auth_caps_field.dart';
import 'widgets/auth_form_card.dart';
import 'widgets/auth_gradient_button.dart';
import 'widgets/auth_page_shell.dart';
import 'widgets/auth_password_field.dart';
import 'widgets/auth_ui_constants.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
      context.go('/home');
      return;
    }
    setState(() => _busy = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) {
        return;
      }
      context.go('/home');
    } on AuthException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.authErrorGeneric)),
      );
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
      appBarTitle: l10n.loginTitle,
      showBack: context.canPop(),
      headline: l10n.loginWelcomeTitle,
      subline: l10n.loginWelcomeSubtitle,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthFormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthCapsField(
                    label: l10n.emailLabelCaps,
                    controller: _email,
                    hintText: 'ornek@email.com',
                    keyboardType: TextInputType.emailAddress,
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
                  const SizedBox(height: 18),
                  AuthPasswordField(
                    label: l10n.passwordLabelCaps,
                    controller: _password,
                    hintText: '••••••',
                    autofillHints: const [AutofillHints.password],
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l10n.validationRequired;
                      }
                      if (v.length < 6) {
                        return l10n.validationPasswordLength;
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        l10n.forgotLink,
                        style: const TextStyle(
                          color: AuthUi.subline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AuthGradientButton(
              label: l10n.loginSubmit,
              onPressed: _busy ? null : _submit,
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
                children: [
                  TextSpan(text: '${l10n.loginFooterQuestion} '),
                  TextSpan(
                    text: l10n.registerTitle,
                    style: const TextStyle(
                      color: Color(0xFF60A5FA),
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.push('/register'),
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
