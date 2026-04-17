import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/invalidate_user_scoped_caches.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'widgets/auth_caps_field.dart';
import 'widgets/auth_form_card.dart';
import 'widgets/auth_gradient_button.dart';
import 'widgets/auth_page_shell.dart';
import 'widgets/auth_password_field.dart';
import 'widgets/auth_ui_constants.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _kvkk = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _showKvkk(AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(l10n.authKvkkDialogTitle),
        content: SingleChildScrollView(
          child: Text(
            l10n.authKvkkDialogBody,
            style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.back),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_kvkk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.validationRequired)),
      );
      return;
    }
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
      await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _password.text,
        data: {'full_name': _name.text.trim()},
      );
      invalidateUserScopedCaches(ref);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.registerSuccess)),
      );
      context.go('/login');
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
      appBarTitle: l10n.registerTitle,
      showBack: true,
      headline: l10n.registerHeadline,
      subline: l10n.registerSubtitle,
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
                    label: l10n.fieldFullName,
                    controller: _name,
                    hintText: 'Ahmet Yılmaz',
                    autofillHints: const [AutofillHints.name],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.validationRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
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
                    hintText: l10n.registerPasswordHint,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l10n.validationRequired;
                      }
                      if (v.length < 8) {
                        return l10n.validationPasswordLength8;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  AuthPasswordField(
                    label: l10n.confirmPasswordLabel,
                    controller: _confirm,
                    validator: (v) {
                      if (v != _password.text) {
                        return l10n.validationPasswordMatch;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: Checkbox(
                          value: _kvkk,
                          activeColor: const Color(0xFF2563EB),
                          side: const BorderSide(color: AuthUi.subline),
                          onChanged: (v) => setState(() => _kvkk = v ?? false),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.authKvkk,
                              style: const TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => _showKvkk(l10n),
                              child: Text(
                                l10n.authKvkkLink,
                                style: const TextStyle(
                                  color: Color(0xFF60A5FA),
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AuthGradientButton(
              label: l10n.registerSubmit,
              onPressed: _busy ? null : _submit,
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
                children: [
                  TextSpan(text: '${l10n.registerFooterQuestion} '),
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
