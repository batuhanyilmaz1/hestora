import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_async_value.dart';
import '../../../core/widgets/async_detail_frame.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_activity_logger.dart';
import '../../customers/data/customer_activity_repository.dart';
import '../../customers/domain/customer.dart';
import '../../matching/data/match_providers.dart';
import '../../matching/data/match_repository.dart';
import '../../matching/domain/scored_customer.dart';
import '../../redirect/data/redirect_providers.dart';
import '../../redirect/data/redirect_repository.dart';
import '../../redirect/domain/redirect_link.dart';
import '../data/property_repository.dart';
import '../domain/property.dart';

const Color _kPropertyDetailScaffold = Color(0x00000000);

String _nameInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  if (name.length >= 2) {
    return name.substring(0, 2).toUpperCase();
  }
  return name.isNotEmpty ? name[0].toUpperCase() : '?';
}

Color _avatarAccentForIndex(int index) {
  const colors = [AppColors.primary, AppColors.error, AppColors.accentPurple, AppColors.accentTeal];
  return colors[index % colors.length];
}

String _customerRoleBadge(AppLocalizations l10n, Customer c) {
  final i = (c.listingIntent ?? '').toLowerCase();
  if (i.contains('rent') || i.contains('kira')) {
    return l10n.customerBadgeTenant;
  }
  if (i.contains('sale') || i.contains('sat')) {
    return l10n.customerBadgeSeller;
  }
  return l10n.customerBadgeBuyer;
}

String _customerSeekingLine(AppLocalizations l10n, Customer c) {
  final loc = (c.preferredLocation ?? '').trim();
  final rooms = c.roomCount != null ? '${c.roomCount}+1' : '';
  if (loc.isNotEmpty && rooms.isNotEmpty) {
    return l10n.propertyCustomerSeekingBoth(loc, rooms);
  }
  if (rooms.isNotEmpty) {
    return l10n.propertyCustomerSeekingRoomsOnly(rooms);
  }
  if (loc.isNotEmpty) {
    return l10n.propertyCustomerSeekingLocationOnly(loc);
  }
  return l10n.propertyCustomerSeekingUnknown;
}

Future<void> _launchTel(String? phone) async {
  if (phone == null || phone.trim().isEmpty) {
    return;
  }
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  final u = Uri.parse('tel:$digits');
  if (await canLaunchUrl(u)) {
    await launchUrl(u, mode: LaunchMode.externalApplication);
  }
}

class PropertyDetailPage extends ConsumerStatefulWidget {
  const PropertyDetailPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends ConsumerState<PropertyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _copyTrackingUrl(
    BuildContext context,
    WidgetRef ref,
    String shortCode,
  ) async {
    final env = ref.read(appEnvironmentProvider);
    final base = env.supabaseFunctionsV1Base;
    if (base == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.supabaseStatusNotConfigured)),
      );
      return;
    }
    final url = '$base/redirect?c=$shortCode';
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.copyTrackingLink)),
      );
    }
  }

  Future<void> _onMarkSold(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(propertyRepositoryProvider);
    if (!repo.supportsRemote) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.supabaseStatusNotConfigured)));
      return;
    }
    try {
      await repo.markAsSold(widget.propertyId);
      ref.invalidate(propertyDetailProvider(widget.propertyId));
      ref.invalidate(propertiesListProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.save)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(propertyDetailProvider(widget.propertyId));
    final matchesAsync = ref.watch(propertyMatchesProvider(widget.propertyId));
    final redirectAsync = ref.watch(redirectLinkForPropertyProvider(widget.propertyId));

    return Scaffold(
      backgroundColor: _kPropertyDetailScaffold,
      body: AppAsyncValueWidget<Property?>(
        value: async,
        loading: (context) => const AsyncDetailFrame(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        error: (context, e, _) => AsyncDetailFrame(
          child: Center(child: Text('$e', textAlign: TextAlign.center)),
        ),
        data: (context, p) {
          if (p == null) {
            return AsyncDetailFrame(
              child: Center(child: Text(l10n.emptyPropertiesTitle)),
            );
          }
          return Column(
            children: [
              _PropertyHeroHeader(
                p: p,
                onBack: () => context.pop(),
                onShare: () => context.push('/properties/${widget.propertyId}/share'),
                onEdit: () => context.push('/properties/${widget.propertyId}/edit'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primary.withValues(alpha: 0.22),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.65)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.22),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textSecondary,
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    tabs: [
                      Tab(height: 48, icon: const Icon(Icons.info_outline, size: 20), text: l10n.tabPropertyInfo),
                      Tab(height: 48, icon: const Icon(Icons.people_outline, size: 20), text: l10n.tabPropertyCustomers),
                      Tab(height: 48, icon: const Icon(Icons.bolt_outlined, size: 20), text: l10n.tabPropertyActions),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _InfoTabContent(
                      p: p,
                      propertyId: widget.propertyId,
                      redirectAsync: redirectAsync,
                      copyTracking: _copyTrackingUrl,
                    ),
                    _CustomersTabContent(
                      matchesAsync: matchesAsync,
                      propertyId: widget.propertyId,
                      property: p,
                    ),
                    _ActionsTabContent(
                      p: p,
                      propertyId: widget.propertyId,
                      redirectAsync: redirectAsync,
                      onCopyTracking: _copyTrackingUrl,
                      onMarkSold: () => _onMarkSold(context, ref),
                      onOpenCustomersTab: () {
                        if (_tabController.index != 1) {
                          _tabController.animateTo(1);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PropertyHeroHeader extends StatefulWidget {
  const _PropertyHeroHeader({
    required this.p,
    required this.onBack,
    required this.onShare,
    required this.onEdit,
  });

  final Property p;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onEdit;

  @override
  State<_PropertyHeroHeader> createState() => _PropertyHeroHeaderState();
}

class _PropertyHeroHeaderState extends State<_PropertyHeroHeader> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _priceLine(Property p) {
    final price = p.price;
    if (price == null) {
      return '—';
    }
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatted = NumberFormat.decimalPattern(locale).format(price);
    final cur = (p.currency ?? 'TL').trim();
    if (cur.isEmpty || cur.toUpperCase() == 'TRY' || cur.toUpperCase() == 'TL') {
      return '$formatted TL';
    }
    return '$formatted $cur';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = widget.p;
    final price = _priceLine(p);
    final images = p.imageUrls;

    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (images.isNotEmpty)
            PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              itemCount: images.length,
              itemBuilder: (context, i) => Image.network(
                images[i],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ColoredBox(color: AppColors.surfaceElevated),
              ),
            )
          else
            Container(
              color: AppColors.surfaceElevated,
              alignment: Alignment.center,
              child: Icon(Icons.photo_outlined, size: 64, color: AppColors.textDisabled),
            ),
          // Must not absorb drags — otherwise [PageView] never receives horizontal pans.
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.62),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              child: Row(
                children: [
                  _circleBtn(Icons.arrow_back_ios_new_rounded, widget.onBack),
                  const Spacer(),
                  _circleBtn(Icons.ios_share_rounded, widget.onShare),
                  const SizedBox(width: AppSpacing.sm),
                  _circleBtn(Icons.edit_outlined, widget.onEdit),
                ],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            top: 88,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  p.listingType == 'rent' ? l10n.chipRent : l10n.chipSale,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.md,
            bottom: 56,
            child: IgnorePointer(
              child: Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                ),
              ),
            ),
          ),
          if (images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 36,
              child: IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (i) {
                    final active = i == _pageIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white.withValues(alpha: active ? 1 : 0.38),
                      ),
                    );
                  }),
                ),
              ),
            ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: IgnorePointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                    ),
                  ),
                  Text(
                    l10n.propertyDetailSubtitle,
                    style: TextStyle(
                      color: AppColors.info.withValues(alpha: 0.95),
                      fontSize: 13,
                      shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  if (p.location != null && p.location!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: AppColors.info.withValues(alpha: 0.95)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              p.location!,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _InfoTabContent extends ConsumerWidget {
  const _InfoTabContent({
    required this.p,
    required this.propertyId,
    required this.redirectAsync,
    required this.copyTracking,
  });

  final Property p;
  final String propertyId;
  final AsyncValue<RedirectLink?> redirectAsync;
  final Future<void> Function(BuildContext, WidgetRef, String) copyTracking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          l10n.propertyFeaturesTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        _featureGrid(context, l10n, p),
        const SizedBox(height: AppSpacing.lg),
        if (p.description != null && p.description!.isNotEmpty) ...[
          Text(
            l10n.listingDescriptionLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              p.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.45),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Text(l10n.redirectLinkTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.trackingLinkHelp,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppAsyncValueWidget<RedirectLink?>(
          value: redirectAsync,
          data: (context, link) {
            final redirect = ref.read(redirectRepositoryProvider);
            if (link != null) {
              final base = ref.read(appEnvironmentProvider).supabaseFunctionsV1Base ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText(
                    '$base/redirect?c=${link.shortCode}',
                    style: const TextStyle(color: AppColors.info, fontSize: 12),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: () => copyTracking(context, ref, link.shortCode),
                    icon: const Icon(Icons.copy),
                    label: Text(l10n.copyTrackingLink),
                  ),
                ],
              );
            }
            return FilledButton.tonalIcon(
              onPressed: p.listingUrl == null || p.listingUrl!.isEmpty || !redirect.supportsRemote
                  ? null
                  : () async {
                      try {
                        await redirect.createOrGet(
                          propertyId: propertyId,
                          targetUrl: p.listingUrl!,
                        );
                        ref.invalidate(redirectLinkForPropertyProvider(propertyId));
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                        }
                      }
                    },
              icon: const Icon(Icons.link),
              label: Text(l10n.createTrackingLink),
            );
          },
        ),
        if (p.listingUrl != null && p.listingUrl!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.listingUrlLabel),
            subtitle: Text(p.listingUrl!, style: const TextStyle(color: AppColors.info)),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () async {
                final u = Uri.tryParse(p.listingUrl!);
                if (u != null && await canLaunchUrl(u)) {
                  await launchUrl(u, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _featureGrid(BuildContext context, AppLocalizations l10n, Property p) {
    Widget cell(IconData icon, Color c, String label, String value) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: c, size: 20),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final room = p.roomCount != null ? '${p.roomCount}+1' : l10n.featureUnknown;
    final area = p.areaSqm != null ? '${p.areaSqm} m²' : l10n.featureUnknown;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 0.82,
      children: [
        cell(Icons.cottage_outlined, AppColors.primary, l10n.featureRoom, room),
        cell(Icons.square_foot_outlined, AppColors.success, l10n.featureArea, area),
        cell(Icons.apartment_outlined, AppColors.accentPurple, l10n.featureFloor, l10n.featureUnknown),
        cell(Icons.calendar_month_outlined, AppColors.warning, l10n.featureAge, l10n.featureUnknown),
        cell(Icons.local_parking_outlined, AppColors.primary, l10n.featureParking, l10n.featureUnknown),
        cell(Icons.local_fire_department_outlined, AppColors.error, l10n.featureHeating, l10n.featureUnknown),
      ],
    );
  }
}

class _CustomersTabContent extends ConsumerWidget {
  const _CustomersTabContent({
    required this.matchesAsync,
    required this.propertyId,
    required this.property,
  });

  final AsyncValue<List<ScoredCustomer>> matchesAsync;
  final String propertyId;
  final Property property;

  Future<void> _shareListingToCustomer(
    BuildContext context,
    WidgetRef ref,
    ScoredCustomer s,
  ) async {
    final url = property.listingUrl?.trim();
    final title = property.title;
    final body = (url != null && url.isNotEmpty) ? '${s.customer.name}\n$title\n$url' : '${s.customer.name}\n$title';
    await SharePlus.instance.share(ShareParams(text: body));
    await ref.read(customerActivityLoggerProvider).logPropertyShared(
          customerId: s.customer.id,
          propertyId: property.id,
          propertyTitle: property.title,
          source: 'property_customers',
        );
    ref.invalidate(customerActivitiesProvider(s.customer.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return AppAsyncValueWidget<List<ScoredCustomer>>(
      value: matchesAsync,
      data: (context, scored) {
        if (scored.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                l10n.emptyCustomersBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }
        final list = scored.take(12).toList();
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Row(
              children: [
                Icon(Icons.people_outline, size: 20, color: AppColors.primary.withValues(alpha: 0.95)),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.propertySuitableCustomersTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.45)),
                  ),
                  child: Text(
                    l10n.propertySuitableCustomerCountBadge(list.length),
                    style: const TextStyle(
                      color: AppColors.accentTeal,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...list.asMap().entries.map((entry) {
              final i = entry.key;
              final s = entry.value;
              final c = s.customer;
              final initials = _nameInitials(c.name);
              final accent = _avatarAccentForIndex(i);
              final role = _customerRoleBadge(l10n, c);
              final seeking = _customerSeekingLine(l10n, c);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Material(
                  color: AppColors.surfaceElevated.withValues(alpha: 0.96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: AppColors.border.withValues(alpha: 0.55)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => context.push('/customers/${c.id}'),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: accent.withValues(alpha: 0.22),
                                          border: Border.all(color: accent.withValues(alpha: 0.45)),
                                        ),
                                        child: Text(
                                          initials,
                                          style: TextStyle(
                                            color: accent,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    c.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                      color: AppColors.textPrimary,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.accentTeal.withValues(alpha: 0.2),
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(color: AppColors.accentTeal.withValues(alpha: 0.45)),
                                                  ),
                                                  child: Text(
                                                    '%${s.score.round()}',
                                                    style: const TextStyle(
                                                      color: AppColors.accentTeal,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.surfaceMuted,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      role,
                                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                            color: AppColors.textSecondary,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    seeking,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.info.withValues(alpha: 0.85),
                                          height: 1.35,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => _launchTel(c.phone),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F766E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.phone_in_talk_outlined, size: 18),
                                  label: Text(l10n.customerCall, style: const TextStyle(fontWeight: FontWeight.w600)),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => _shareListingToCustomer(context, ref, s),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF172554),
                                    foregroundColor: const Color(0xFF93C5FD),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.send_outlined, size: 18),
                                  label: Text(
                                    l10n.propertyListingSend,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _ActionsTabContent extends ConsumerWidget {
  const _ActionsTabContent({
    required this.p,
    required this.propertyId,
    required this.redirectAsync,
    required this.onCopyTracking,
    required this.onMarkSold,
    required this.onOpenCustomersTab,
  });

  final Property p;
  final String propertyId;
  final AsyncValue<RedirectLink?> redirectAsync;
  final Future<void> Function(BuildContext, WidgetRef, String) onCopyTracking;
  final VoidCallback onMarkSold;
  final VoidCallback onOpenCustomersTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final matchesAsync = ref.watch(propertyMatchesProvider(propertyId));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            Icon(Icons.bolt_outlined, size: 20, color: AppColors.primary.withValues(alpha: 0.95)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              l10n.propertyQuickActionsTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _QuickActionCard(
          icon: Icons.send_rounded,
          iconBackground: AppColors.primary.withValues(alpha: 0.22),
          iconColor: AppColors.primary,
          title: l10n.propertyActionSendCustomersTitle,
          subtitle: l10n.propertyActionSendCustomersSubtitle,
          onTap: onOpenCustomersTab,
        ),
        const SizedBox(height: AppSpacing.sm),
        _QuickActionCard(
          icon: Icons.share_rounded,
          iconBackground: AppColors.accentTeal.withValues(alpha: 0.22),
          iconColor: AppColors.accentTeal,
          title: l10n.propertyActionShareTitle,
          subtitle: l10n.propertyActionShareSubtitle,
          onTap: () => context.push('/properties/$propertyId/share'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _QuickActionCard(
          icon: Icons.edit_outlined,
          iconBackground: AppColors.accentPurple.withValues(alpha: 0.22),
          iconColor: AppColors.accentPurple,
          title: l10n.propertyActionEditTitle,
          subtitle: l10n.propertyActionEditSubtitle,
          onTap: () => context.push('/properties/$propertyId/edit'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _QuickActionCard(
          icon: Icons.alarm_add_outlined,
          iconBackground: const Color(0xFF14532D).withValues(alpha: 0.55),
          iconColor: const Color(0xFFBBF7D0),
          title: l10n.propertyActionNoteTitle,
          subtitle: l10n.propertyActionNoteSubtitle,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.propertyNoteComingSoon)));
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        AppAsyncValueWidget<List<ScoredCustomer>>(
          value: matchesAsync,
          data: (context, scored) {
            return _QuickActionCard(
              icon: Icons.cloud_upload_outlined,
              iconBackground: AppColors.primary.withValues(alpha: 0.18),
              iconColor: AppColors.primary,
              title: l10n.propertyActionSyncMatchesTitle,
              subtitle: l10n.propertyActionSyncMatchesSubtitle,
              onTap: () async {
                final repo = ref.read(matchRepositoryProvider);
                if (!repo.supportsRemote) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.supabaseStatusNotConfigured)),
                  );
                  return;
                }
                await repo.replaceForProperty(propertyId, scored.take(15).toList());
                await ref.read(customerActivityLoggerProvider).logMatchedCustomersForProperty(
                      propertyId: propertyId,
                      propertyTitle: p.title,
                      scoredCustomers: scored.take(15).toList(),
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.save)));
                }
              },
            );
          },
        ),
        AppAsyncValueWidget<RedirectLink?>(
          value: redirectAsync,
          data: (context, link) {
            if (link == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: _QuickActionCard(
                icon: Icons.link_rounded,
                iconBackground: AppColors.info.withValues(alpha: 0.2),
                iconColor: AppColors.info,
                title: l10n.copyTrackingLink,
                subtitle: l10n.trackingLinkHelp,
                onTap: () => onCopyTracking(context, ref, link.shortCode),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: p.active ? onMarkSold : null,
            icon: const Icon(Icons.check_circle_outline),
            label: Text(l10n.markAsSold),
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated.withValues(alpha: 0.96),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: iconBackground,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textDisabled.withValues(alpha: 0.9)),
            ],
          ),
        ),
      ),
    );
  }
}
