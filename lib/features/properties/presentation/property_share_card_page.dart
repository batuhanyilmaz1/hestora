import 'dart:async';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../app/providers/auth_session_provider.dart';
import '../../../core/widgets/app_async_value.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../profile/data/profile_repository.dart';
import '../data/property_repository.dart';
import '../domain/property.dart';
import '../share_card/models/share_card_layout_data.dart';
import '../share_card/models/share_card_theme_definition.dart';
import '../share_card/share_card_focal_heuristic.dart';
import '../share_card/share_card_themes.dart';
import '../share_card/widgets/property_share_card_template_view.dart';
import '../share_card/widgets/share_card_image_adjust_sheet.dart';
import '../share_card/widgets/share_card_theme_thumbnail_strip.dart';

class PropertyShareCardPage extends ConsumerStatefulWidget {
  const PropertyShareCardPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyShareCardPage> createState() => _PropertyShareCardPageState();
}

class _PropertyShareCardPageState extends ConsumerState<PropertyShareCardPage> {
  final GlobalKey _repaintKey = GlobalKey();
  ShareCardThemeDefinition _theme = shareCardListingThemes.first;
  bool _exporting = false;
  bool _useMockPreview = false;

  String? _focalScheduledKey;
  Alignment? _userImageAlignment;
  Alignment? _autoImageAlignment;

  Alignment _listingImageAlignment(ShareCardThemeDefinition t) {
    return _userImageAlignment ?? _autoImageAlignment ?? t.mainImage.templateAlignment();
  }

  void _bumpFocalIfNeeded(String url, String themeId) {
    if (!mounted) {
      return;
    }
    final key = '$themeId|$url';
    if (_focalScheduledKey == key) {
      return;
    }
    _focalScheduledKey = key;
    unawaited(_loadFocal(url, key));
  }

  Future<void> _loadFocal(String url, String expectedKey) async {
    try {
      final resp = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 14));
      if (!mounted || _focalScheduledKey != expectedKey) {
        return;
      }
      if (resp.statusCode != 200 || resp.bodyBytes.isEmpty) {
        setState(() => _autoImageAlignment = null);
        return;
      }
      final a = await shareCardFocalSuggestAlignmentAsync(resp.bodyBytes);
      if (!mounted || _focalScheduledKey != expectedKey) {
        return;
      }
      setState(() => _autoImageAlignment = a);
    } catch (_) {
      if (!mounted || _focalScheduledKey != expectedKey) {
        return;
      }
      setState(() => _autoImageAlignment = null);
    }
  }

  Future<void> _exportPng() async {
    final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.shareCardExportNotReady)),
        );
      }
      return;
    }
    setState(() => _exporting = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 32));
      if (!mounted) {
        return;
      }
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final image = await boundary.toImage(pixelRatio: dpr.clamp(2.0, 3.5));
      final bd = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bd == null || !mounted) {
        return;
      }
      final bytes = bd.buffer.asUint8List();
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'image/png',
              name: 'hestora-${widget.propertyId}.png',
            ),
          ],
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.shareCardExportFailed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _exporting = false);
      }
    }
  }

  String _priceLine(Property p) {
    if (p.price == null) {
      return '—';
    }
    final cur = (p.currency ?? '').trim();
    return cur.isEmpty ? '${p.price}' : '${p.price} $cur';
  }

  /// Oda / banyo / m² — ilan formundaki alanlar etiketli tek satır (marka kartlarında ortak kullanım).
  String _featuresLine(AppLocalizations l10n, Property p) {
    final parts = <String>[];
    if (p.roomCount != null) {
      parts.add('${l10n.fieldRoomCountShort} ${p.roomCount}+');
    }
    if (p.bathroomCount != null) {
      parts.add('${l10n.fieldBathroomCountShort} ${p.bathroomCount}');
    }
    if (p.areaSqm != null) {
      parts.add(l10n.shareCardAreaSqmShort(p.areaSqm.toString()));
    }
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  String? _footerContactLine(ShareCardLayoutData layout) {
    final parts = <String>[];
    final phone = layout.agentPhone?.trim();
    if (phone != null && phone.isNotEmpty) {
      parts.add(phone);
    }
    final web = layout.websiteFallbackLine?.trim();
    if (web != null && web.isNotEmpty) {
      parts.add(web);
    }
    final email = ref.read(authSessionProvider).valueOrNull?.email?.trim();
    if (email != null && email.isNotEmpty) {
      parts.add(email);
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(propertyDetailProvider(widget.propertyId));
    final profileAsync = ref.watch(profileRowProvider);
    ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shareCardTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: AppAsyncValueWidget<Property?>(
        value: async,
        loading: (context) => const Center(child: CircularProgressIndicator.adaptive()),
        error: (context, e, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$e', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: Text(l10n.back),
                ),
              ],
            ),
          ),
        ),
        data: (context, p) {
          if (p == null) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.emptyPropertiesTitle, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                      child: Text(l10n.back),
                    ),
                  ],
                ),
              ),
            );
          }

          final ShareCardLayoutData layout;
          if (_useMockPreview) {
            layout = ShareCardLayoutData.mockSample();
          } else {
            final layoutBase = ShareCardLayoutData.fromProperty(
              p,
              priceLine: _priceLine(p),
              featuresLine: _featuresLine(l10n, p),
              listingTypeLabel: p.listingType == 'rent' ? l10n.chipRent : l10n.chipSale,
              description: p.description?.trim(),
              agentName: profileAsync.maybeWhen(
                data: (row) => row?.displayName?.trim(),
                orElse: () => null,
              ),
              agentPhone: profileAsync.maybeWhen(
                data: (row) => row?.phone?.trim(),
                orElse: () => null,
              ),
            );
            layout = layoutBase.copyWith(
              footerContactLine: _footerContactLine(layoutBase),
              agentEmail: ref.read(authSessionProvider).valueOrNull?.email?.trim(),
              agentAvatarUrl: profileAsync.maybeWhen(
                data: (row) => row?.avatarUrl?.trim(),
                orElse: () => null,
              ),
            );
          }

          final imageUrl = layout.effectiveMainImageUrl;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            if (imageUrl == null || imageUrl.isEmpty) {
              if (_autoImageAlignment != null) {
                setState(() => _autoImageAlignment = null);
              }
              return;
            }
            _bumpFocalIfNeeded(imageUrl, _theme.id);
          });

          final hasListingImage = imageUrl != null && imageUrl.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              ShareCardThemeThumbnailStrip(
                title: l10n.shareCardAllThemesSample,
                selected: _theme,
                onSelect: (t) => setState(() {
                  _theme = t;
                  _userImageAlignment = null;
                  _focalScheduledKey = null;
                }),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _theme.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.shareCardMockOverlay),
                value: _useMockPreview,
                onChanged: (v) => setState(() {
                  _useMockPreview = v;
                  _userImageAlignment = null;
                  _focalScheduledKey = null;
                }),
              ),
              if (hasListingImage) ...[
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showShareCardImageAdjustSheet(
                      context,
                      initial: _listingImageAlignment(_theme),
                    );
                    if (picked != null && mounted) {
                      setState(() => _userImageAlignment = picked);
                    }
                  },
                  icon: const Icon(Icons.crop_rotate_outlined, size: 20),
                  label: Text(l10n.shareCardTuneListingPhoto),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth.clamp(280.0, 420.0);
                  final w = maxW;
                  final h = w / _theme.aspectRatio;
                  return Center(
                    child: Container(
                      width: w,
                      height: h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: RepaintBoundary(
                        key: _repaintKey,
                        child: PropertyShareCardTemplateView(
                          theme: _theme,
                          data: layout,
                          width: w,
                          height: h,
                          listingImageAlignment: _listingImageAlignment(_theme),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _exporting ? null : _exportPng,
                icon: _exporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.image_outlined),
                label: Text(l10n.exportPng),
              ),
            ],
          );
        },
      ),
    );
  }
}
