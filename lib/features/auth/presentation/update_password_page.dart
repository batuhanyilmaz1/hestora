import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../l10n/generated/app_localizations.dart';
import 'widgets/auth_form_card.dart';
import 'widgets/auth_gradient_button.dart';
import 'widgets/auth_page_shell.dart';
import 'widgets/auth_password_field.dart';
import 'widgets/auth_ui_constants.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _p1.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  ({bool len, bool num, bool upper}) _req(String p) {
    return (
      len: p.length >= 8,
      num: RegExp(r'\d').hasMatch(p),
      upper: RegExp(r'[A-ZÇĞİÖŞÜ]').hasMatch(p),
    );
  }

  int _strength(String p) {
    final r = _req(p);
    var s = 0;
    if (r.len) {
      s++;
    }
    if (r.num) {
      s++;
    }
    if (r.upper) {
      s++;
    }
    if (p.length >= 12) {
      s++;
    }
    return s.clamp(0, 4);
  }

  String _strengthLabel(AppLocalizations l10n, int s) {
    if (s <= 1) {
      return l10n.strengthWeak;
    }
    if (s == 2 || s == 3) {
      return l10n.strengthMedium;
    }
    return l10n.strengthStrong;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final r = _req(_p1.text);
    if (!r.len || !r.num || !r.upper) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.validationPasswordLength8)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _p1.text),
      );
      await Supabase.instance.client.auth.signOut();
      if (!mounted) {
        return;
      }
      context.go('/auth/password-updated');
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
    final p = _p1.text;
    final str = _strength(p);
    final req = _req(p);

    return AuthPageShell(
      appBarTitle: l10n.updatePasswordScreenTitle,
      appBarSubtitle: l10n.updatePasswordScreenSubtitle,
      showBack: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E3A8A).withValues(alpha: 0.8),
                      const Color(0xFF0F172A),
                    ],
                  ),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Icon(Icons.password_rounded, size: 36, color: Color(0xFF93C5FD)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.updatePasswordScreenTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.updatePasswordHero,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AuthUi.subline, fontSize: 14),
            ),
            const SizedBox(height: 20),
            AuthFormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthPasswordField(
                    label: l10n.newPasswordLabel,
                    controller: _p1,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l10n.validationRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(4, (i) {
                      final on = i < str;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: on
                                  ? const Color(0xFF22C55E)
                                  : Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _strengthLabel(l10n, str),
                    style: TextStyle(
                      color: str >= 3 ? const Color(0xFF22C55E) : AuthUi.subline,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    label: l10n.repeatNewPasswordLabel,
                    controller: _p2,
                    validator: (v) {
                      if (v != _p1.text) {
                        return l10n.validationPasswordMatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AuthFormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.passwordReqTitle,
                    style: const TextStyle(
                      color: AuthUi.labelCaps,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ReqRow(ok: req.len, text: l10n.reqMin8),
                  _ReqRow(ok: req.num, text: l10n.reqOneNumber),
                  _ReqRow(ok: req.upper, text: l10n.reqOneUpper),
                ],
              ),
            ),
            const SizedBox(height: 22),
            AuthGradientButton(
              label: l10n.updatePasswordCta,
              icon: Icons.verified_user_outlined,
              onPressed: _busy ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReqRow extends StatelessWidget {
  const _ReqRow({required this.ok, required this.text});

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: ok ? const Color(0xFF22C55E) : Colors.white38,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
