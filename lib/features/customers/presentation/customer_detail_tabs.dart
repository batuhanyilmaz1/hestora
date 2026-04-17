import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart' show ShareParams, SharePlus;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/app_async_value.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../matching/domain/match_engine.dart';
import '../../matching/domain/scored_property.dart';
import '../data/customer_activity_logger.dart';
import '../data/customer_activity_repository.dart';
import '../data/customer_note_repository.dart';
import '../domain/customer_activity.dart';
import '../domain/customer_note.dart';

class CustomerHistoryTimelineTab extends ConsumerWidget {
  const CustomerHistoryTimelineTab({
    super.key,
    required this.customerId,
    required this.l10n,
    this.nestInParentScroll = false,
  });

  final String customerId;
  final AppLocalizations l10n;

  /// [true]: üstteki [SingleChildScrollView] ile birlikte kayar; iç [ListView] kullanılmaz.
  final bool nestInParentScroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(customerActivitiesProvider(customerId));
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AppAsyncValueWidget<List<CustomerActivity>>(
      value: async,
      data: (context, items) {
        final card = Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF151C2E), Color(0xFF12192B)],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.22)),
            boxShadow: [
              BoxShadow(
                color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.06),
                blurRadius: 18,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.activityHistoryTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    l10n.activityRecordsCount(items.length),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textDisabled,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (items.isEmpty)
                Text(
                  l10n.customerActivityEmpty,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                )
              else
                ...List.generate(items.length, (index) {
                  final activity = items[index];
                  return _TimelineRow(
                    item: _TimelineItem.fromActivity(
                      activity,
                      l10n,
                      Localizations.localeOf(context).toLanguageTag(),
                    ),
                    isLast: index == items.length - 1,
                  );
                }),
            ],
          ),
        );

        if (nestInParentScroll) {
          return card;
        }
        return ListView(
          primary: false,
          padding: EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, AppSpacing.lg + bottomInset),
          children: [card],
        );
      },
    );
  }
}

class CustomerNotesHistoryTab extends ConsumerStatefulWidget {
  const CustomerNotesHistoryTab({
    super.key,
    required this.customerId,
    this.summaryNote,
    this.nestInParentScroll = false,
  });

  final String customerId;
  final String? summaryNote;

  /// [true]: üstteki [SingleChildScrollView] ile birlikte kayar.
  final bool nestInParentScroll;

  @override
  ConsumerState<CustomerNotesHistoryTab> createState() => _CustomerNotesHistoryTabState();
}

class _CustomerNotesHistoryTabState extends ConsumerState<CustomerNotesHistoryTab> {
  final _note = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<bool> _saveNote() async {
    final body = _note.text.trim();
    if (body.isEmpty) {
      return false;
    }

    final repo = ref.read(customerNoteRepositoryProvider);
    if (!repo.supportsRemote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.supabaseStatusNotConfigured)),
      );
      return false;
    }

    setState(() => _saving = true);
    try {
      await repo.insert(customerId: widget.customerId, body: body);
      _note.clear();
      ref.invalidate(customerNotesProvider(widget.customerId));
      ref.invalidate(customerActivitiesProvider(widget.customerId));
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      return false;
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _openQuickNoteComposer() async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            bottomInset + AppSpacing.md,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF16233D), Color(0xFF101827)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: HomeShellTheme.borderBlue.withValues(alpha: 0.24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.customerQuickAddNote,
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _note,
                  labelText: l10n.fieldNotes,
                  hintText: l10n.customerNoteInputHint,
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.md),
                AppPrimaryButton(
                  label: l10n.save,
                  icon: Icons.check_rounded,
                  onPressed: _saving
                      ? null
                      : () async {
                          final saved = await _saveNote();
                          if (saved && mounted && sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notesAsync = ref.watch(customerNotesProvider(widget.customerId));
    final summaryNote = widget.summaryNote?.trim();
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final nest = widget.nestInParentScroll;

    final children = <Widget>[
        InkWell(
          onTap: _saving ? null : _openQuickNoteComposer,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF10214B), Color(0xFF0C1731)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.32)),
              boxShadow: [
                BoxShadow(
                  color: HomeShellTheme.primaryBlueGlow.withValues(alpha: 0.16),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF15377C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: HomeShellTheme.borderBlue.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: HomeShellTheme.textLightBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.customerQuickAddNote,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: HomeShellTheme.textLightBlue,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (summaryNote != null && summaryNote.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _LegacySummaryNoteCard(
            title: l10n.customerSummaryNoteTitle,
            body: summaryNote,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppAsyncValueWidget<List<CustomerNote>>(
          value: notesAsync,
          data: (context, notes) {
            if (notes.isEmpty) {
              return Text(
                l10n.customerNotesEmpty,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              );
            }

            return Column(
              children: [
                for (final note in notes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _CustomerNoteCard(note: note),
                  ),
              ],
            );
          },
        ),
    ];

    if (nest) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }

    return ListView(
      primary: false,
      padding: EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, AppSpacing.lg + bottomInset),
      children: children,
    );
  }
}

class CustomerMatchingTab extends ConsumerWidget {
  const CustomerMatchingTab({
    super.key,
    required this.customerId,
    required this.matchesAsync,
    required this.l10n,
    this.nestInParentScroll = false,
  });

  final String customerId;
  final AsyncValue<List<ScoredProperty>> matchesAsync;
  final AppLocalizations l10n;

  /// [true]: üstteki [SingleChildScrollView] ile birlikte kayar.
  final bool nestInParentScroll;

  String _priceLine(ScoredProperty score, String localeName) {
    final price = score.property.price;
    if (price == null) {
      return '—';
    }
    final formatted = NumberFormat.decimalPattern(localeName).format(price);
    final currency = score.property.currency?.trim();
    if (currency == null || currency.isEmpty || currency.toUpperCase() == 'TRY') {
      return '$formatted TL';
    }
    return '$formatted $currency';
  }

  Future<void> _shareListing(
    BuildContext context,
    WidgetRef ref,
    ScoredProperty score,
  ) async {
    final url = score.property.listingUrl?.trim();
    final title = score.property.title;
    final text = (url != null && url.isNotEmpty) ? '$title\n$url' : title;
    await SharePlus.instance.share(ShareParams(text: text));
    await ref.read(customerActivityLoggerProvider).logPropertyShared(
          customerId: customerId,
          propertyId: score.property.id,
          propertyTitle: score.property.title,
          source: 'customer_matching',
        );
    ref.invalidate(customerActivitiesProvider(customerId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nest = nestInParentScroll;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AppAsyncValueWidget<List<ScoredProperty>>(
      value: matchesAsync,
      data: (context, scored) {
        if (scored.isEmpty) {
          final empty = Text(
            l10n.emptyPropertiesBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          );
          if (nest) {
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: empty,
              ),
            );
          }
          return Center(child: empty);
        }
        final strong =
            scored.where((item) => item.score >= MatchEngine.strongMatchThreshold).length;
        final localeName = Localizations.localeOf(context).toLanguageTag();

        final listChildren = <Widget>[
            Row(
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 18,
                  color: HomeShellTheme.textLightBlue.withValues(alpha: 0.95),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.customerStrongMatchesTitle(
                      MatchEngine.strongMatchThreshold.toInt(),
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
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
            ...scored.take(12).map((score) {
              final image = score.property.imageUrls.isNotEmpty
                  ? score.property.imageUrls.first
                  : null;
              final roomTag =
                  score.property.roomCount != null ? '${score.property.roomCount}+1' : null;
              final areaTag =
                  score.property.areaSqm != null ? '${score.property.areaSqm} m²' : null;

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
                              child: image != null
                                  ? Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                                        color: AppColors.surfaceMuted,
                                        child: Icon(
                                          Icons.home_work_outlined,
                                          color: AppColors.textDisabled,
                                          size: 32,
                                        ),
                                      ),
                                    )
                                  : ColoredBox(
                                      color: AppColors.surfaceMuted,
                                      child: Icon(
                                        Icons.home_work_outlined,
                                        color: AppColors.textDisabled,
                                        size: 32,
                                      ),
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
                                      border: Border.all(
                                        color: AppColors.success.withValues(alpha: 0.45),
                                      ),
                                    ),
                                    child: Text(
                                      '%${score.score.round()}',
                                      style: const TextStyle(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  score.property.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _priceLine(score, localeName),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                if (score.property.location != null &&
                                    score.property.location!.trim().isNotEmpty)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: AppColors.textDisabled,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          score.property.location!,
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
                                      if (roomTag != null) _smallChip(context, roomTag),
                                      if (areaTag != null) _smallChip(context, areaTag),
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
                              onPressed: () => context.push('/properties/${score.property.id}'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A5F),
                                foregroundColor: HomeShellTheme.textLightBlue,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                              ),
                              child: Text(
                                l10n.customerViewListingDetail,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _shareListing(context, ref, score),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFBBF7D0),
                                side: BorderSide(
                                  color: const Color(0xFF0F766E).withValues(alpha: 0.85),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(
                                l10n.customerSendToClient,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ];

        if (nest) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: listChildren,
          );
        }

        return ListView(
          primary: false,
          padding: EdgeInsets.fromLTRB(
            0,
            AppSpacing.sm,
            0,
            AppSpacing.lg + bottomInset,
          ),
          children: listChildren,
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
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}

class _LegacySummaryNoteCard extends StatelessWidget {
  const _LegacySummaryNoteCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141F34), Color(0xFF101827)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}

class _CustomerNoteCard extends StatelessWidget {
  const _CustomerNoteCard({required this.note});

  final CustomerNote note;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141F34), Color(0xFF101827)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF4A3612),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.28)),
            ),
            child: Icon(Icons.description_outlined, color: AppColors.warning, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  DateFormat('dd MMM', localeName).format(note.createdAt.toLocal()),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: HomeShellTheme.textLightBlue.withValues(alpha: 0.78),
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

class _TimelineItem {
  const _TimelineItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
  });

  factory _TimelineItem.fromActivity(
    CustomerActivity activity,
    AppLocalizations l10n,
    String localeName,
  ) {
    final formattedTime =
        DateFormat('dd MMM yyyy, HH:mm', localeName).format(activity.createdAt.toLocal());

    switch (activity.type) {
      case CustomerActivityType.customerCreated:
        return _TimelineItem(
          icon: Icons.person_add_alt_1_outlined,
          color: AppColors.primary,
          title: l10n.customerActivityRegistration,
          body: l10n.customerActivityRegistrationBody,
          time: formattedTime,
        );
      case CustomerActivityType.noteAdded:
        return _TimelineItem(
          icon: Icons.sticky_note_2_outlined,
          color: AppColors.warning,
          title: l10n.customerActivityNoteAdded,
          body: activity.body?.trim().isNotEmpty == true
              ? activity.body!.trim()
              : l10n.customerActivityNoteAdded,
          time: formattedTime,
        );
      case CustomerActivityType.taskLinked:
        return _TimelineItem(
          icon: Icons.task_alt_outlined,
          color: AppColors.accentTeal,
          title: l10n.customerActivityTaskLinked,
          body: activity.body?.trim().isNotEmpty == true
              ? activity.body!.trim()
              : l10n.navTasks,
          time: formattedTime,
        );
      case CustomerActivityType.propertyMatched:
        final score = activity.metadata['score'];
        final scoreLine = score is num ? l10n.matchScoreLabel(score.round().toString()) : null;
        return _TimelineItem(
          icon: Icons.favorite_border_rounded,
          color: AppColors.success,
          title: l10n.customerActivityPropertyMatched,
          body: [
            if (activity.body?.trim().isNotEmpty == true) activity.body!.trim(),
            if (scoreLine != null) scoreLine,
          ].join(' • '),
          time: formattedTime,
        );
      case CustomerActivityType.propertyShared:
        return _TimelineItem(
          icon: Icons.share_outlined,
          color: AppColors.info,
          title: l10n.customerActivityPropertyShared,
          body: activity.body?.trim().isNotEmpty == true
              ? activity.body!.trim()
              : l10n.shareCard,
          time: formattedTime,
        );
    }
  }

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.isLast,
  });

  final _TimelineItem item;
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
                    color: item.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: item.color.withValues(alpha: 0.45)),
                  ),
                  child: Icon(item.icon, color: item.color, size: 18),
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
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textDisabled,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
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
