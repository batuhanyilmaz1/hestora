import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/app_async_value.dart';
import '../../../core/widgets/async_detail_frame.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/customer_activity_logger.dart';
import '../data/customer_activity_repository.dart';
import '../domain/customer_activity.dart';
import '../../matching/data/match_providers.dart';
import '../../matching/data/match_repository.dart';
import '../../matching/domain/match_engine.dart';
import '../../matching/domain/scored_property.dart';
import '../data/customer_repository.dart';
import '../domain/customer.dart';
import 'customer_detail_tabs.dart';

/// Müşteri detay mockup: çok koyu lacivert zemin (#0A0E1A bandı).
const Color _kCustomerDetailScaffold = Color(0xFF0A0E1A);

class CustomerDetailPage extends ConsumerStatefulWidget {
  const CustomerDetailPage({super.key, required this.customerId});

  final String customerId;

  @override
  ConsumerState<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends ConsumerState<CustomerDetailPage> {
  /// Geçmiş / Notlar / Eşleşme — tek kaydırmada birlikte hareket eder.
  int _contentTab = 1;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Future<void> _launchUri(String url) async {
    final u = Uri.parse(url);
    if (await canLaunchUrl(u)) {
      await launchUrl(u, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _call(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      return;
    }
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    await _launchUri('tel:$digits');
  }

  Future<void> _whatsapp(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      return;
    }
    var digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (!digits.startsWith('90')) {
      digits = '90$digits';
    }
    await _launchUri('https://wa.me/$digits');
  }

  Future<void> _sms(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      return;
    }
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    await _launchUri('sms:$digits');
  }

  Future<void> _syncMatchesToCloud(BuildContext context, AppLocalizations l10n) async {
    final scored = await ref.read(customerMatchesProvider(widget.customerId).future);
    final topMatches = scored.take(15).toList();
    final repo = ref.read(matchRepositoryProvider);
    if (!repo.supportsRemote) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.supabaseStatusNotConfigured)),
        );
      }
      return;
    }
    await repo.replaceForCustomer(widget.customerId, topMatches);
    await ref.read(customerActivityLoggerProvider).logMatchedProperties(
          customerId: widget.customerId,
          scoredProperties: topMatches,
        );
    ref.invalidate(customerActivitiesProvider(widget.customerId));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.save)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final async = ref.watch(customerDetailProvider(widget.customerId));
    final matchesAsync = ref.watch(customerMatchesProvider(widget.customerId));
    final activitiesAsync = ref.watch(customerActivitiesProvider(widget.customerId));
    final lastActivityLine = _lastActivitySummaryLine(activitiesAsync, l10n, localeName);

    return Scaffold(
      backgroundColor: _kCustomerDetailScaffold,
      body: AppAsyncValueWidget<Customer?>(
        value: async,
        loading: (context) => const AsyncDetailFrame(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        error: (context, e, _) => AsyncDetailFrame(
          child: Center(child: Text('$e', textAlign: TextAlign.center)),
        ),
        data: (context, c) {
          if (c == null) {
            return AsyncDetailFrame(
              child: Center(child: Text(l10n.emptyCustomersTitle)),
            );
          }
          final initials = _initials(c.name);
          final badge = switch (c.listingIntent) {
            'sale' => l10n.customerBadgeBuyer,
            'rent' => l10n.customerBadgeTenant,
            _ => l10n.intentNotSet,
          };

          return Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.md),
                  child: Row(
                    children: [
                      _CustomerDetailGlowIconButton(
                        onPressed: () => context.pop(),
                        icon: Icons.arrow_back_ios_new_rounded,
                        iconSize: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            Text(
                              l10n.customerDetailSubtitle,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: HomeShellTheme.textLightBlue.withValues(alpha: 0.92),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      _CustomerDetailGlowIconButton(
                        onPressed: () => context.push('/customers/${widget.customerId}/edit'),
                        icon: Icons.edit_outlined,
                        iconSize: 20,
                      ),
                      const SizedBox(width: 12),
                      PopupMenuButton<String>(
                        tooltip: '',
                        padding: EdgeInsets.zero,
                        offset: const Offset(0, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: AppColors.surfaceElevated,
                        onSelected: (value) {
                          if (value == 'sync') {
                            _syncMatchesToCloud(context, l10n);
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem<String>(
                            value: 'sync',
                            child: Text(l10n.syncMatchesToCloud),
                          ),
                        ],
                        child: _CustomerDetailGlowIconButton(
                          onPressed: null,
                          icon: Icons.more_vert_rounded,
                          iconSize: 22,
                          forMenuAnchor: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileCard(
                          initials: initials,
                          name: c.name,
                          phone: c.phone,
                          email: c.email,
                          lastActivityLine: lastActivityLine,
                          badge: badge,
                          tags: c.tags,
                          onCall: () => _call(c.phone),
                          onWhatsapp: () => _whatsapp(c.phone),
                          onSms: () => _sms(c.phone),
                          l10n: l10n,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _SearchCriteriaCard(c: c, l10n: l10n),
                        const SizedBox(height: AppSpacing.sm),
                        _CustomerDetailTabStrip(
                          selectedIndex: _contentTab,
                          onSelect: (i) => setState(() => _contentTab = i),
                          l10n: l10n,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        RepaintBoundary(
                          child: switch (_contentTab) {
                            0 => CustomerHistoryTimelineTab(
                                customerId: widget.customerId,
                                l10n: l10n,
                                nestInParentScroll: true,
                              ),
                            1 => CustomerNotesHistoryTab(
                                customerId: widget.customerId,
                                summaryNote: c.notes,
                                nestInParentScroll: true,
                              ),
                            _ => CustomerMatchingTab(
                                customerId: widget.customerId,
                                matchesAsync: matchesAsync,
                                l10n: l10n,
                                nestInParentScroll: true,
                              ),
                          },
                        ),
                        SizedBox(height: AppSpacing.lg + MediaQuery.paddingOf(context).bottom),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Üst bar: koyu lacivert zemin + ince mavi çerçeve + hafif mavi parlama.
class _CustomerDetailGlowIconButton extends StatelessWidget {
  const _CustomerDetailGlowIconButton({
    required this.icon,
    this.iconSize = 20,
    this.onPressed,
    this.forMenuAnchor = false,
  });

  final IconData icon;
  final double iconSize;
  final VoidCallback? onPressed;
  final bool forMenuAnchor;

  static const double _kSize = 48;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(_kSize / 2),
      color: const Color(0xFF0E1624),
      border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.42)),
      boxShadow: [
        BoxShadow(
          color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.38),
          blurRadius: 16,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF1E3A5F).withValues(alpha: 0.55),
          blurRadius: 8,
          spreadRadius: -3,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final iconWidget = Icon(icon, size: iconSize, color: HomeShellTheme.textLightBlue);

    if (forMenuAnchor) {
      return SizedBox(
        width: _kSize,
        height: _kSize,
        child: DecoratedBox(
          decoration: decoration,
          child: Center(child: iconWidget),
        ),
      );
    }

    return SizedBox(
      width: _kSize,
      height: _kSize,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_kSize / 2),
          splashFactory: InkRipple.splashFactory,
          splashColor: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.22),
          highlightColor: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.08),
          child: DecoratedBox(
            decoration: decoration,
            child: Center(child: iconWidget),
          ),
        ),
      ),
    );
  }
}

String _formatActivityRecency(DateTime at, AppLocalizations l10n, String localeName) {
  final localAt = at.toLocal();
  final diff = DateTime.now().difference(localAt);
  if (diff.inMinutes < 1) {
    return l10n.customerLastActivityJustNow;
  }
  if (diff.inHours < 1) {
    return l10n.customerLastActivityMinutesAgo(diff.inMinutes);
  }
  if (diff.inHours < 24) {
    return l10n.customerLastActivityHoursAgo(diff.inHours);
  }
  if (diff.inDays < 30) {
    return l10n.customerLastActivityDaysAgo(diff.inDays);
  }
  return DateFormat.yMMMd(localeName).format(localAt);
}

String? _lastActivitySummaryLine(
  AsyncValue<List<CustomerActivity>> activitiesAsync,
  AppLocalizations l10n,
  String localeName,
) {
  return activitiesAsync.maybeWhen(
    data: (items) {
      if (items.isEmpty) {
        return null;
      }
      final latest = items.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
      final when = _formatActivityRecency(latest.createdAt, l10n, localeName);
      return l10n.customerLastActivitySummary(when);
    },
    orElse: () => null,
  );
}

/// Material [TabBar] özel `indicator: BoxDecoration` + gölgeler bazı GPU/emülatörlerde bozulma üretiyor; özel şerit kullan.
class _CustomerDetailTabStrip extends StatelessWidget {
  const _CustomerDetailTabStrip({
    required this.selectedIndex,
    required this.onSelect,
    required this.l10n,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0C1220),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.14),
              blurRadius: 22,
              spreadRadius: -8,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                child: _CustomerDetailTabPill(
                  selected: selectedIndex == 0,
                  icon: Icons.history_rounded,
                  label: l10n.tabCustomerHistory,
                  onTap: () => onSelect(0),
                ),
              ),
              Expanded(
                child: _CustomerDetailTabPill(
                  selected: selectedIndex == 1,
                  icon: Icons.description_outlined,
                  label: l10n.tabCustomerNotes,
                  onTap: () => onSelect(1),
                ),
              ),
              Expanded(
                child: _CustomerDetailTabPill(
                  selected: selectedIndex == 2,
                  icon: Icons.favorite_border_rounded,
                  label: l10n.tabCustomerMatching,
                  onTap: () => onSelect(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerDetailTabPill extends StatelessWidget {
  const _CustomerDetailTabPill({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashFactory: NoSplash.splashFactory,
        highlightColor: HomeShellTheme.primaryBlue.withValues(alpha: 0.12),
        // Sabit yükseklik: isabet testi sıfır boyut vermesin; Row stretch ile tüm hücre aynı yükseklikte.
        child: SizedBox(
          height: 42,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF1D4ED8) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? HomeShellTheme.borderBlue.withValues(alpha: 0.85)
                    : Colors.transparent,
                width: 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: HomeShellTheme.primaryBlue.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                        color: selected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDisplayPhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) {
    return '—';
  }
  final raw = phone.trim();
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 10 && digits.startsWith('5')) {
    return '+90 ${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 8)} ${digits.substring(8)}';
  }
  if (digits.length == 11 && digits.startsWith('0')) {
    final d = digits.substring(1);
    return '+90 ${d.substring(0, 3)} ${d.substring(3, 6)} ${d.substring(6, 8)} ${d.substring(8)}';
  }
  return raw;
}

String _formatBudgetLine(Customer c, String localeName) {
  final min = c.budgetMin;
  final max = c.budgetMax;
  if (min == null && max == null) {
    return '—';
  }
  String fmtM(num n) {
    if (n >= 1000000) {
      final m = n / 1000000;
      final s = (m == m.roundToDouble()) ? '${m.toInt()}' : m.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
      return '${s}M';
    }
    return NumberFormat.decimalPattern(localeName).format(n);
  }

  if (min != null && max != null) {
    return '${fmtM(min)} – ${fmtM(max)} TL';
  }
  if (min != null) {
    return '${fmtM(min)} TL';
  }
  return '${fmtM(max!)} TL';
}

String _formatRoomsLine(Customer c) {
  if (c.roomCount == null) {
    return '—';
  }
  return '${c.roomCount}+1';
}

String _formatAreaLine(Customer c, AppLocalizations l10n) {
  final min = c.areaMinSqm;
  final max = c.areaMaxSqm;
  if (min == null && max == null) {
    return '—';
  }
  if (min != null && max != null) {
    return '$min – $max m²';
  }
  if (min != null) {
    return l10n.customerAreaAtLeast(min.toString());
  }
  return '$max m²';
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.initials,
    required this.name,
    required this.phone,
    this.email,
    this.lastActivityLine,
    required this.badge,
    required this.tags,
    required this.onCall,
    required this.onWhatsapp,
    required this.onSms,
    required this.l10n,
  });

  final String initials;
  final String name;
  final String? phone;
  final String? email;
  final String? lastActivityLine;
  final String badge;
  final List<String> tags;
  final VoidCallback onCall;
  final VoidCallback onWhatsapp;
  final VoidCallback onSms;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final emailLine = email?.trim();
    final hasUrgentTag = tags.any((t) => t.toLowerCase().contains('acil'));
    final nonUrgentTags = tags.where((x) => !x.toLowerCase().contains('acil')).toList();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF151C2E), Color(0xFF12192B)],
        ),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.07),
            blurRadius: 22,
            spreadRadius: -6,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFF0A1F48),
                  border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.55)),
                  boxShadow: [
                    BoxShadow(
                      color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.18),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: HomeShellTheme.textLightBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF334155),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDisplayPhone(phone),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (emailLine != null && emailLine.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        emailLine,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: HomeShellTheme.textLightBlue.withValues(alpha: 0.82),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (hasUrgentTag)
                          _ProfileTagChip(
                            l10n: l10n,
                            label: '',
                            urgent: true,
                          ),
                        for (final t in nonUrgentTags)
                          _ProfileTagChip(
                            l10n: l10n,
                            label: t,
                            urgent: false,
                          ),
                        if (lastActivityLine != null)
                          Text(
                            lastActivityLine!,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFF7C8CA5),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        if (!hasUrgentTag && nonUrgentTags.isEmpty && lastActivityLine == null)
                          Text(
                            l10n.customerNoLastCallInfo,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textDisabled),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _CompactActionButton(
                  onPressed: onCall,
                  icon: Icons.phone_in_talk_outlined,
                  label: l10n.customerCall,
                  variant: _ActionButtonVariant.call,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactActionButton(
                  onPressed: onWhatsapp,
                  icon: Icons.chat_rounded,
                  label: l10n.customerWhatsapp,
                  variant: _ActionButtonVariant.whatsapp,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactActionButton(
                  onPressed: onSms,
                  icon: Icons.sms_outlined,
                  label: l10n.customerMessage,
                  variant: _ActionButtonVariant.message,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileTagChip extends StatelessWidget {
  const _ProfileTagChip({
    required this.l10n,
    required this.label,
    required this.urgent,
  });

  final AppLocalizations l10n;
  final String label;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    if (urgent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.45)),
        ),
        child: Text(
          l10n.customerUrgentTag,
          style: TextStyle(
            color: AppColors.error.withValues(alpha: 0.95),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: HomeShellTheme.textLightBlue.withValues(alpha: 0.88),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

enum _ActionButtonVariant { call, whatsapp, message }

class _CompactActionButton extends StatelessWidget {
  const _CompactActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.variant,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final _ActionButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 1.1,
    );
    Widget content(Color fg) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: fg),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: labelStyle.copyWith(color: fg),
            ),
          ),
        ],
      );
    }

    switch (variant) {
      case _ActionButtonVariant.call:
        return SizedBox(
          height: 52,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: onPressed,
            child: content(Colors.white),
          ),
        );
      case _ActionButtonVariant.whatsapp:
        return SizedBox(
          height: 52,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF166534),
              foregroundColor: const Color(0xFFDCFCE7),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: const Color(0xFF22C55E).withValues(alpha: 0.45)),
              ),
            ),
            onPressed: onPressed,
            child: content(const Color(0xFFDCFCE7)),
          ),
        );
      case _ActionButtonVariant.message:
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.28),
                blurRadius: 14,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1A3354),
                foregroundColor: HomeShellTheme.textLightBlue,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: HomeShellTheme.borderBlue.withValues(alpha: 0.35)),
                ),
              ),
              onPressed: onPressed,
              child: content(HomeShellTheme.textLightBlue),
            ),
          ),
        );
    }
  }
}

class _SearchCriteriaCard extends StatelessWidget {
  const _SearchCriteriaCard({required this.c, required this.l10n});

  final Customer c;
  final AppLocalizations l10n;

  static const Color _kLoc = Color(0xFF60A5FA);
  static const Color _kBudget = Color(0xFF34D399);
  static const Color _kRooms = Color(0xFFC084FC);
  static const Color _kArea = Color(0xFFFBBF24);

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final budget = _formatBudgetLine(c, localeName);
    final rooms = _formatRoomsLine(c);
    final area = _formatAreaLine(c, l10n);
    final location = (c.preferredLocation != null && c.preferredLocation!.trim().isNotEmpty)
        ? c.preferredLocation!
        : '—';
    final labelColor = HomeShellTheme.textLightBlue.withValues(alpha: 0.55);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF151C2E), Color(0xFF101624)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 22,
                color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.searchCriteriaTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _criteriaCell(
                  context,
                  Icons.location_on_outlined,
                  _kLoc,
                  labelColor,
                  l10n.criteriaLabelLocation,
                  location,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _criteriaCell(
                  context,
                  Icons.attach_money_rounded,
                  _kBudget,
                  labelColor,
                  l10n.criteriaLabelBudget,
                  budget,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _criteriaCell(
                  context,
                  Icons.cottage_outlined,
                  _kRooms,
                  labelColor,
                  l10n.criteriaLabelRooms,
                  rooms,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _criteriaCell(
                  context,
                  Icons.straighten_rounded,
                  _kArea,
                  labelColor,
                  l10n.criteriaLabelArea,
                  area,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _criteriaCell(
    BuildContext context,
    IconData icon,
    Color iconTint,
    Color labelColor,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: iconTint.withValues(alpha: 0.14),
            ),
            child: Icon(icon, size: 20, color: iconTint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
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

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.c, required this.l10n});

  final Customer c;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = <_Act>[];
    final note = c.notes?.trim();
    if (note != null && note.isNotEmpty) {
      final preview = note.length > 96 ? '${note.substring(0, 96)}…' : note;
      items.add(
        _Act(
          Icons.sticky_note_2_outlined,
          AppColors.warning,
          l10n.customerActivityNoteAdded,
          preview,
          l10n.customerActivityTimeUnknown,
        ),
      );
    }
    items.add(
      _Act(
        Icons.person_add_alt_1_outlined,
        AppColors.primary,
        l10n.customerActivityRegistration,
        l10n.customerActivityRegistrationBody,
        l10n.customerActivityTimeUnknown,
      ),
    );

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return ListView(
      primary: false,
      padding: EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, AppSpacing.lg + bottomInset),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.activityHistoryTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    l10n.activityRecordsCount(items.length),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textDisabled),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(items.length, (i) {
                final a = items[i];
                final isLast = i == items.length - 1;
                return _TimelineRow(act: a, isLast: isLast);
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.act,
    required this.isLast,
  });

  final _Act act;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: act.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: act.color.withValues(alpha: 0.45)),
                  ),
                  child: Icon(act.icon, color: act.color, size: 18),
                ),
                if (!isLast)
                  SizedBox(
                    height: 36,
                    width: 40,
                    child: Center(
                      child: Container(
                        width: 1,
                        height: 36,
                        color: AppColors.border.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        act.title,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                    Text(
                      act.time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textDisabled),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  act.body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Act {
  _Act(this.icon, this.color, this.title, this.body, this.time);
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
}

class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.c, required this.customerId});

  final Customer c;
  final String customerId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = c.notes?.trim();

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return ListView(
      primary: false,
      padding: EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, AppSpacing.lg + bottomInset),
      children: [
        OutlinedButton.icon(
          onPressed: () => context.push('/customers/$customerId/edit'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.55)),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
            backgroundColor: AppColors.surface.withValues(alpha: 0.5),
          ),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
          label: Text(l10n.customerQuickAddNote, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: AppSpacing.md),
        if (text != null && text.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.warning.withValues(alpha: 0.2),
                  ),
                  child: Icon(Icons.description_outlined, color: AppColors.warning, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.45,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.customerActivityTimeUnknown,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.info.withValues(alpha: 0.75)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            l10n.customerNotesEmpty,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
      ],
    );
  }
}

class _MatchingTab extends ConsumerWidget {
  const _MatchingTab({
    required this.matchesAsync,
    required this.l10n,
  });

  final AsyncValue<List<ScoredProperty>> matchesAsync;
  final AppLocalizations l10n;

  String _priceLine(ScoredProperty s, String localeName) {
    final p = s.property.price;
    if (p == null) {
      return '—';
    }
    final formatted = NumberFormat.decimalPattern(localeName).format(p);
    final cur = s.property.currency?.trim();
    if (cur == null || cur.isEmpty || cur.toUpperCase() == 'TRY') {
      return '$formatted TL';
    }
    return '$formatted $cur';
  }

  Future<void> _shareListing(BuildContext context, ScoredProperty s) async {
    final url = s.property.listingUrl?.trim();
    final title = s.property.title;
    final text = (url != null && url.isNotEmpty) ? '$title\n$url' : title;
    await SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppAsyncValueWidget<List<ScoredProperty>>(
      value: matchesAsync,
      data: (context, scored) {
        if (scored.isEmpty) {
          return Center(
            child: Text(
              l10n.emptyPropertiesBody,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          );
        }
        final strong = scored.where((e) => e.score >= MatchEngine.strongMatchThreshold).length;
        final localeName = Localizations.localeOf(context).toLanguageTag();

        return ListView(
          primary: false,
          padding: EdgeInsets.fromLTRB(
            0,
            AppSpacing.sm,
            0,
            AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            Row(
              children: [
                Icon(Icons.favorite_border_rounded, size: 18, color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95)),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.customerStrongMatchesTitle(MatchEngine.strongMatchThreshold.toInt()),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    l10n.customerListingCountBadge(strong),
                    style: TextStyle(
                      color: AppColors.error.withValues(alpha: 0.95),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...scored.take(12).map((s) {
              final img = s.property.imageUrls.isNotEmpty ? s.property.imageUrls.first : null;
              final roomTag = s.property.roomCount != null ? '${s.property.roomCount}+1' : null;
              final areaTag = s.property.areaSqm != null ? '${s.property.areaSqm} m²' : null;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 88,
                              height: 72,
                              child: img != null
                                  ? Image.network(
                                      img,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                                        color: AppColors.surfaceMuted,
                                        child: Icon(Icons.home_work_outlined, color: AppColors.textDisabled, size: 32),
                                      ),
                                    )
                                  : ColoredBox(
                                      color: AppColors.surfaceMuted,
                                      child: Icon(Icons.home_work_outlined, color: AppColors.textDisabled, size: 32),
                                    ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.22),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: AppColors.success.withValues(alpha: 0.45)),
                                    ),
                                    child: Text(
                                      '%${s.score.round()}',
                                      style: const TextStyle(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  s.property.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _priceLine(s, localeName),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                if (s.property.location != null && s.property.location!.trim().isNotEmpty)
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, size: 14, color: AppColors.textDisabled),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          s.property.location!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (roomTag != null || areaTag != null) ...[
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      if (roomTag != null)
                                        _smallChip(context, roomTag),
                                      if (areaTag != null)
                                        _smallChip(context, areaTag),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () => context.push('/properties/${s.property.id}'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A5F),
                                foregroundColor: HomeShellTheme.textLightBlue,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                              ),
                              child: Text(l10n.customerViewListingDetail, style: const TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _shareListing(context, s),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFBBF7D0),
                                side: BorderSide(color: const Color(0xFF0F766E).withValues(alpha: 0.85)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(l10n.customerSendToClient, style: const TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _smallChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
