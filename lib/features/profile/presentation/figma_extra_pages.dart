import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/onboarding/post_login_flow_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/hestora_figma_ui.dart';
import '../../../l10n/generated/app_localizations.dart';

Future<void> _handlePackagesPopOrGo(BuildContext context) async {
  if (!context.mounted) {
    return;
  }
  if (context.canPop()) {
    context.pop();
    return;
  }
  if (await PostLoginFlowPrefs.isSetupRequired() && await PostLoginFlowPrefs.isRegionalDone()) {
    if (!context.mounted) {
      return;
    }
    context.go('/post-login/locale');
    return;
  }
  if (!context.mounted) {
    return;
  }
  context.go('/home');
}

Future<void> _handlePaymentSummaryPopOrGo(BuildContext context) async {
  if (!context.mounted) {
    return;
  }
  if (context.canPop()) {
    context.pop();
    return;
  }
  if (await PostLoginFlowPrefs.isSetupRequired()) {
    if (!context.mounted) {
      return;
    }
    context.go('/billing/packages');
    return;
  }
  if (!context.mounted) {
    return;
  }
  context.go('/home');
}

class KvkkPrivacyPage extends StatelessWidget {
  const KvkkPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = [
      (l10n.kvkkSection1Title, l10n.kvkkSection1Body),
      (l10n.kvkkSection2Title, l10n.kvkkSection2Body),
      (l10n.kvkkSection3Title, l10n.kvkkSection3Body),
      (l10n.kvkkSection4Title, l10n.kvkkSection4Body),
      (l10n.kvkkSection5Title, l10n.kvkkSection5Body),
      (l10n.kvkkSection6Title, l10n.kvkkSection6Body),
    ];

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HestoraFigmaHeader(
              title: l10n.kvkkTitle,
              subtitle: l10n.kvkkSubtitle,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  HestoraFigmaCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield_outlined, color: AppColors.primary.withValues(alpha: 0.95)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.kvkkSafeTitle,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.kvkkSafeBody,
                                style: const TextStyle(color: HestoraFigma.mutedText, height: 1.45),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...List.generate(sections.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          backgroundColor: HestoraFigma.cardFill,
                          collapsedBackgroundColor: HestoraFigma.cardFill,
                          leading: Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                          title: Text(sections[i].$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                              child: Text(sections[i].$2, style: const TextStyle(color: HestoraFigma.mutedText, height: 1.45)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Text(
                      l10n.kvkkFooterContact,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: HestoraFigma.mutedText),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (l10n.faqQ1, l10n.faqA1),
      (l10n.faqQ2, l10n.faqA2),
      (l10n.faqQ3, l10n.faqA3),
      (l10n.faqQ4, l10n.faqA4),
      (l10n.faqQ5, l10n.faqA5),
      (l10n.faqQ6, l10n.faqA6),
    ];

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HestoraFigmaHeader(
              title: l10n.faqTitle,
              subtitle: l10n.faqSubtitle,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final open = _open == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Material(
                      color: HestoraFigma.cardFill,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => setState(() => _open = open ? null : i),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.22),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      items[i].$1,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Icon(open ? Icons.expand_less : Icons.expand_more, color: Colors.white54),
                                ],
                              ),
                              if (open) ...[
                                const SizedBox(height: AppSpacing.sm),
                                Text(items[i].$2, style: const TextStyle(color: HestoraFigma.mutedText, height: 1.45)),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            HestoraFigmaHeader(
              title: l10n.deleteAccountTitle,
              subtitle: l10n.deleteAccountDanger,
              onBack: () => context.pop(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0x22EF4444),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x55EF4444)),
                  boxShadow: [BoxShadow(color: const Color(0x33EF4444), blurRadius: 24)],
                ),
                child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFF87171), size: 40),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.deleteAccountQuestion,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.w900, fontSize: 20, height: 1.25),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.deleteAccountWarning,
              textAlign: TextAlign.center,
              style: const TextStyle(color: HestoraFigma.mutedText, height: 1.45),
            ),
            const SizedBox(height: AppSpacing.xl),
            HestoraFigmaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.deleteAccountListTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: AppSpacing.sm),
                  ...[
                    l10n.deleteAccountList1,
                    l10n.deleteAccountList2,
                    l10n.deleteAccountList3,
                    l10n.deleteAccountList4,
                    l10n.deleteAccountList5,
                  ].map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.cancel_outlined, color: Color(0xFFF87171), size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(t, style: const TextStyle(color: HestoraFigma.mutedText, height: 1.35))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.deleteAccountComingSoon)));
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(l10n.deleteAccountCta),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: HestoraFigma.mutedText,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageSelectionPage extends StatefulWidget {
  const PackageSelectionPage({super.key});

  @override
  State<PackageSelectionPage> createState() => _PackageSelectionPageState();
}

class _PackageSelectionPageState extends State<PackageSelectionPage> {
  int _sel = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HestoraFigmaHeader(
              title: l10n.packagePickTitle,
              subtitle: l10n.packagePickSubtitle,
              onBack: () => _handlePackagesPopOrGo(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Column(
                children: [
                  Text(l10n.packageHeadline, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                  const SizedBox(height: 6),
                  Text(l10n.packageSubline, style: const TextStyle(color: HestoraFigma.mutedText)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  _planCard(
                    context,
                    selected: _sel == 0,
                    badge: l10n.packageTrialBadge,
                    title: l10n.packageTrialTitle,
                    price: l10n.packageTrialPrice,
                    desc: l10n.packageTrialDesc,
                    onTap: () => setState(() => _sel = 0),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _planCard(
                    context,
                    selected: _sel == 1,
                    title: l10n.packageMonthlyTitle,
                    price: l10n.packageMonthlyPrice,
                    desc: l10n.packageMonthlyDesc,
                    onTap: () => setState(() => _sel = 1),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _planCard(
                    context,
                    selected: _sel == 2,
                    badge: l10n.packageYearlyBadge,
                    title: l10n.packageYearlyTitle,
                    price: l10n.packageYearlyPrice,
                    desc: l10n.packageYearlyDesc,
                    onTap: () => setState(() => _sel = 2),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: FilledButton(
                onPressed: () => context.push('/billing/summary'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(l10n.packageCta),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required bool selected,
    String? badge,
    required String title,
    required String price,
    required String desc,
    required VoidCallback onTap,
  }) {
    return Material(
      color: HestoraFigma.cardFill,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? const Color(0xFF22C55E) : Colors.white.withValues(alpha: 0.08),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14532D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(badge, style: const TextStyle(color: Color(0xFF86EFAC), fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  const Spacer(),
                  Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? const Color(0xFF22C55E) : Colors.white24),
                ],
              ),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 13)),
              const SizedBox(height: 8),
              Text(price, style: const TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentSummaryPage extends StatelessWidget {
  const PaymentSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            HestoraFigmaHeader(
              title: l10n.paymentSummaryTitle,
              subtitle: l10n.paymentSummarySubtitle,
              onBack: () => _handlePaymentSummaryPopOrGo(context),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user_outlined, color: Colors.green.withValues(alpha: 0.85), size: 18),
                  const SizedBox(width: 4),
                  Text('SSL', style: TextStyle(color: HestoraFigma.mutedText, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            HestoraFigmaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFBBF24)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.paymentPlanName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                            Text(l10n.paymentPlanSub, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x33451A03),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(l10n.paymentBestValue, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 11)),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: HestoraFigma.divider),
                  _payRow(l10n.paymentLineYear, l10n.paymentLineYearValue),
                  _payRow(l10n.paymentLineDiscount, l10n.paymentLineDiscountValue, green: true),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.paymentTotal, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      Text(l10n.paymentTotalValue, style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w900, fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.paymentVatNote, style: const TextStyle(color: HestoraFigma.mutedText, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.paymentIncludedTitle, style: const TextStyle(color: HestoraFigma.mutedText, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(6, (i) => _featureLine(context, i)),
            const SizedBox(height: AppSpacing.lg),
            HestoraFigmaCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.verified_outlined, color: Colors.green.withValues(alpha: 0.9)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(l10n.paymentGuarantee, style: const TextStyle(color: Color(0xFF4ADE80), height: 1.35))),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () async {
                await PostLoginFlowPrefs.markPostLoginFullyComplete();
                if (context.mounted) {
                  context.go('/home');
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(l10n.paymentProcessingCta),
            ),
          ],
        ),
      ),
    );
  }

  Widget _payRow(String a, String b, {bool green = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(a, style: const TextStyle(color: HestoraFigma.mutedText)),
          Text(b, style: TextStyle(color: green ? const Color(0xFF4ADE80) : Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _featureLine(BuildContext context, int i) {
    final l10n = AppLocalizations.of(context)!;
    final lines = [
      l10n.paymentFeat1,
      l10n.paymentFeat2,
      l10n.paymentFeat3,
      l10n.paymentFeat4,
      l10n.paymentFeat5,
      l10n.paymentFeat6,
    ];
    final icons = [Icons.people_outline, Icons.apartment_outlined, Icons.auto_awesome, Icons.schedule, Icons.insights, Icons.headset_mic_outlined];
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.amber, Colors.greenAccent, Colors.orange];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icons[i], color: colors[i % colors.length].withValues(alpha: 0.9), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(lines[i], style: const TextStyle(color: HestoraFigma.mutedText))),
        ],
      ),
    );
  }
}

class ProfileCreatePage extends StatelessWidget {
  const ProfileCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.profileCreateTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(l10n.profileCreateSubtitle, style: TextStyle(fontSize: 12, color: HestoraFigma.mutedText)),
          ],
        ),
        actions: [TextButton(onPressed: () => context.go('/home'), child: Text(l10n.onboardingSkip))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.profileCreateHeadline, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
          const SizedBox(height: 6),
          Text(l10n.profileCreateSubline, style: const TextStyle(color: HestoraFigma.mutedText)),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.profileCreateComingSoon, style: const TextStyle(color: HestoraFigma.mutedText, height: 1.4)),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () => context.go('/home'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(l10n.profileCreateCompleteCta),
          ),
        ],
      ),
    );
  }
}
