import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../l10n/generated/app_localizations.dart';

/// E-posta doğrulandıktan sonra ödeme / abonelik adımı.
class PostVerifyCheckoutPage extends StatefulWidget {
  const PostVerifyCheckoutPage({super.key});

  @override
  State<PostVerifyCheckoutPage> createState() => _PostVerifyCheckoutPageState();
}

class _PostVerifyCheckoutPageState extends State<PostVerifyCheckoutPage> {
  bool _checked = false;
  bool _sessionMissing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _verifySession());
  }

  Future<void> _verifySession() async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    if (!mounted) {
      return;
    }
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _checked = true;
      _sessionMissing = session == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(l10n.postVerifyTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: !_checked
              ? const Center(child: CircularProgressIndicator.adaptive())
              : _sessionMissing
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.link_off_outlined, size: 56, color: AppColors.error.withValues(alpha: 0.9)),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.postVerifySessionMissing,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                        ),
                        const Spacer(),
                        AppPrimaryButton(
                          label: l10n.loginTitle,
                          onPressed: () => context.go('/login'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.mark_email_read_outlined, size: 56, color: AppColors.primary.withValues(alpha: 0.95)),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.postVerifyHeadline,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.postVerifyBody,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.45,
                              ),
                        ),
                        const Spacer(),
                        AppPrimaryButton(
                          label: l10n.postVerifyContinue,
                          onPressed: () => context.go('/billing/packages'),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
