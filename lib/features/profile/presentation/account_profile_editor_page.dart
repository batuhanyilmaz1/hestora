import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../app/providers/auth_session_provider.dart';
import '../../../core/config/supabase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/profile_repository.dart';

class AccountProfileEditorPage extends ConsumerStatefulWidget {
  const AccountProfileEditorPage({super.key, this.focusEmailOnOpen = false});

  final bool focusEmailOnOpen;

  @override
  ConsumerState<AccountProfileEditorPage> createState() => _AccountProfileEditorPageState();
}

class _AccountProfileEditorPageState extends ConsumerState<AccountProfileEditorPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _seeded) {
        return;
      }
      final u = ref.read(authSessionProvider).valueOrNull;
      if (u == null) {
        return;
      }
      ProfileRow? profile;
      try {
        profile = await ref.read(profileRowProvider.future);
      } catch (_) {
        profile = null;
      }
      if (!mounted || _seeded) {
        return;
      }
      setState(() {
        _name.text = _displayNameFrom(u, profile);
        _email.text = u.email ?? '';
        _phone.text = profile?.phone?.trim() ?? '';
        _seeded = true;
      });
      if (widget.focusEmailOnOpen && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _emailFocus.requestFocus();
          }
        });
      }
    });
  }

  static String _displayNameFrom(User? user, ProfileRow? profile) {
    final fromProfile = profile?.displayName?.trim();
    if (fromProfile != null && fromProfile.isNotEmpty) {
      return fromProfile;
    }
    if (user == null) {
      return '';
    }
    final meta = user.userMetadata;
    final n = meta?['full_name'] ?? meta?['name'];
    if (n is String && n.trim().isNotEmpty) {
      return n.trim();
    }
    final email = user.email;
    if (email != null && email.contains('@')) {
      final local = email.split('@').first;
      return local.replaceAll('.', ' ').split('_').first;
    }
    return email ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(AppLocalizations l10n) async {
    final repo = ref.read(profileRepositoryProvider);
    if (!repo.supportsRemote) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.supabaseStatusNotConfigured)),
        );
      }
      return;
    }
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null || !mounted) {
      return;
    }
    setState(() => _busy = true);
    try {
      await repo.uploadAvatarAndSaveUrl(file);
      ref.invalidate(profileRowProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profilePhotoUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final env = ref.read(appEnvironmentProvider);
    if (!SupabaseBootstrap.isClientReady(env)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.supabaseStatusNotConfigured)),
        );
      }
      return;
    }
    final repo = ref.read(profileRepositoryProvider);
    if (!repo.supportsRemote) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.supabaseStatusNotConfigured)),
        );
      }
      return;
    }
    setState(() => _busy = true);
    try {
      await repo.updateDisplayName(_name.text);
      await repo.updatePhone(_phone.text);
      final currentEmail = ref.read(authSessionProvider).valueOrNull?.email?.trim() ?? '';
      final nextEmail = _email.text.trim();
      if (nextEmail.isNotEmpty && nextEmail != currentEmail) {
        await repo.updateEmail(nextEmail);
      }
      ref.invalidate(profileRowProvider);
      ref.invalidate(authSessionProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.save)));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.accountProfileEditorTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _EditorGlassSection(
                  child: Row(
                    children: [
                      Icon(Icons.photo_camera_outlined, color: AppColors.primary.withValues(alpha: 0.9)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          l10n.profileChangePhoto,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(backgroundColor: AppColors.surfaceMuted),
                        onPressed: _busy ? null : () => _pickPhoto(l10n),
                        icon: const Icon(Icons.add_photo_alternate_outlined, size: 22),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _EditorGlassSection(
                  child: AppTextField(
                    controller: _name,
                    labelText: l10n.profileDisplayNameLabel,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return l10n.validationRequired;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _EditorGlassSection(
                  child: AppTextField(
                    controller: _email,
                    focusNode: _emailFocus,
                    labelText: l10n.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
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
                const SizedBox(height: AppSpacing.sm),
                _EditorGlassSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _phone,
                        labelText: l10n.fieldPhone,
                        keyboardType: TextInputType.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.accountProfilePhoneHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary.withValues(alpha: 0.9),
                              height: 1.35,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _busy ? null : () => _save(l10n),
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        color: AppColors.primary.withValues(alpha: 0.92),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Center(
                          child: _busy
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  l10n.save,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppColors.onPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorGlassSection extends StatelessWidget {
  const _EditorGlassSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.md),
        color: AppColors.surface.withValues(alpha: 0.55),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
