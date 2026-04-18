import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/open_graph_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/property_repository.dart';
import '../domain/property.dart';
import '../domain/property_form_prefill.dart';
import 'property_form_sheets.dart';

class PropertyFormPage extends ConsumerStatefulWidget {
  const PropertyFormPage({
    super.key,
    this.prefill,
    this.editingPropertyId,
    this.openLinkFlowFirst = false,
  });

  final PropertyFormPrefill? prefill;
  /// Doluysa ilan güncelleme modu (`insert` yerine `update`).
  final String? editingPropertyId;
  /// `true` ise form açılınca “link ile doldur” bölümüne kaydırılır (`?entry=link`).
  final bool openLinkFlowFirst;

  @override
  ConsumerState<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends ConsumerState<PropertyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _linkSectionKey = GlobalKey();
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _listingUrl = TextEditingController();
  final _roomCount = TextEditingController();
  final _bathroomCount = TextEditingController();
  final _areaSqm = TextEditingController();
  String _listingType = 'sale';
  String? _provinceLabel;
  String? _layoutLabel;
  bool _busy = false;
  final List<XFile> _pickedImages = [];
  bool _hydratedFromRemote = false;
  final List<String> _existingImageUrls = [];
  bool _ogLoading = false;
  OgMetadata? _ogPreview;
  bool _ogAttempted = false;

  @override
  void initState() {
    super.initState();
    final p = widget.prefill;
    if (p != null) {
      if (p.title != null) {
        _title.text = p.title!;
      }
      if (p.description != null) {
        _description.text = p.description!;
      }
      if (p.listingUrl != null) {
        _listingUrl.text = p.listingUrl!;
      }
    }
    if (widget.openLinkFlowFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final ctx = _linkSectionKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            alignment: 0.02,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _title.dispose();
    _location.dispose();
    _price.dispose();
    _description.dispose();
    _listingUrl.dispose();
    _roomCount.dispose();
    _bathroomCount.dispose();
    _areaSqm.dispose();
    super.dispose();
  }

  int? _parseInt(String v) {
    final t = v.trim();
    if (t.isEmpty) {
      return null;
    }
    return int.tryParse(t);
  }

  num? _parseNum(String v) {
    final t = v.trim();
    if (t.isEmpty) {
      return null;
    }
    return num.tryParse(t.replaceAll(',', '.'));
  }

  Future<void> _fetchListingOg() async {
    final l10n = AppLocalizations.of(context)!;
    final raw = _listingUrl.text.trim();
    if (raw.isEmpty) {
      return;
    }
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.validationUrl)),
      );
      return;
    }
    setState(() {
      _ogLoading = true;
      _ogAttempted = true;
      _ogPreview = null;
    });
    try {
      final meta = await OpenGraphService.fetch(uri);
      if (!mounted) {
        return;
      }
      setState(() => _ogPreview = meta);
      if (!meta.hasAny) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.listingImportFallbackBody)),
        );
      }
    } on OgFetchException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.ogFetchError} ($e)')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ogFetchError)),
      );
    } finally {
      if (mounted) {
        setState(() => _ogLoading = false);
      }
    }
  }

  void _applyOgToForm() {
    final p = _ogPreview;
    final l10n = AppLocalizations.of(context)!;
    if (p == null || !p.hasAny) {
      return;
    }
    final t = p.title?.trim();
    if (t != null && t.isNotEmpty) {
      _title.text = t;
    }
    final d = p.description?.trim();
    if (d != null && d.isNotEmpty) {
      _description.text = d;
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.propertyFormApplyDone)),
    );
  }

  void _applyProperty(Property p) {
    _title.text = p.title;
    _listingType = p.listingType;
    _location.text = p.location ?? '';
    _price.text = p.price != null ? p.price.toString() : '';
    _description.text = p.description ?? '';
    _listingUrl.text = p.listingUrl ?? '';
    _roomCount.text = p.roomCount != null ? '${p.roomCount}' : '';
    _bathroomCount.text = p.bathroomCount != null ? '${p.bathroomCount}' : '';
    _areaSqm.text = p.areaSqm != null ? '${p.areaSqm}' : '';
    _existingImageUrls
      ..clear()
      ..addAll(p.imageUrls);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final repo = ref.read(propertyRepositoryProvider);
    if (!repo.supportsRemote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.supabaseStatusNotConfigured)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final priceText = _price.text.trim();
      num? price;
      if (priceText.isNotEmpty) {
        price = num.tryParse(priceText.replaceAll(',', '.'));
      }
      var titleOut = _title.text.trim();
      if ((_layoutLabel ?? '').trim().isNotEmpty) {
        titleOut = '[${_layoutLabel!.trim()}] $titleOut';
      }
      final locParts = <String>[
        if ((_provinceLabel ?? '').trim().isNotEmpty) _provinceLabel!.trim(),
        if (_location.text.trim().isNotEmpty) _location.text.trim(),
      ];
      final locationOut = locParts.isEmpty ? null : locParts.join(' ');
      final editId = widget.editingPropertyId;
      if (editId != null) {
        await repo.update(
          id: editId,
          title: titleOut,
          listingType: _listingType,
          location: locationOut,
          price: price,
          description: _description.text.trim().isEmpty ? null : _description.text.trim(),
          listingUrl: _listingUrl.text.trim().isEmpty ? null : _listingUrl.text.trim(),
          roomCount: _parseInt(_roomCount.text),
          bathroomCount: _parseInt(_bathroomCount.text),
          areaSqm: _parseNum(_areaSqm.text),
          newImages: List<XFile>.from(_pickedImages),
        );
      } else {
        await repo.insert(
          title: titleOut,
          listingType: _listingType,
          location: locationOut,
          price: price,
          description: _description.text.trim().isEmpty ? null : _description.text.trim(),
          listingUrl: _listingUrl.text.trim().isEmpty ? null : _listingUrl.text.trim(),
          roomCount: _parseInt(_roomCount.text),
          bathroomCount: _parseInt(_bathroomCount.text),
          areaSqm: _parseNum(_areaSqm.text),
          images: List<XFile>.from(_pickedImages),
        );
      }
      ref.invalidate(propertiesListProvider);
      if (editId != null) {
        ref.invalidate(propertyDetailProvider(editId));
      }
      if (!mounted) {
        return;
      }
      context.pop();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final og = widget.prefill?.ogImageUrl;
    final editId = widget.editingPropertyId;
    if (editId != null) {
      final asyncProp = ref.watch(propertyDetailProvider(editId));
      asyncProp.whenData((p) {
        if (p != null && !_hydratedFromRemote) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _hydratedFromRemote) {
              return;
            }
            setState(() {
              _hydratedFromRemote = true;
              _applyProperty(p);
            });
          });
        }
      });
    }

    final isEdit = editId != null;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.profileScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        toolbarHeight: isEdit ? 76 : kToolbarHeight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: isEdit
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.propertyEditTitle, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    l10n.propertyEditSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.info),
                  ),
                ],
              )
            : Text(l10n.createPropertyTitle),
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (og != null && og.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    og,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KeyedSubtree(
                  key: _linkSectionKey,
                  child: _PropertySectionCard(
                    title: l10n.propertyFormLinkSection,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.listingImportHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: HomeShellTheme.textLightBlue.withValues(alpha: 0.88),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _listingUrl,
                        labelText: l10n.listingUrlLabel,
                        hintText: l10n.listingImportHint,
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: _ogLoading ? null : _fetchListingOg,
                        icon: _ogLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.cloud_download_outlined),
                        label: Text(l10n.listingImportAction),
                      ),
                      if (_ogPreview != null && _ogPreview!.hasAny) ...[
                        const SizedBox(height: AppSpacing.md),
                        if (_ogPreview!.imageUrl != null && _ogPreview!.imageUrl!.trim().isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                _ogPreview!.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        if (_ogPreview!.imageUrl != null && _ogPreview!.imageUrl!.trim().isNotEmpty)
                          const SizedBox(height: AppSpacing.sm),
                        if (_ogPreview!.title != null && _ogPreview!.title!.trim().isNotEmpty)
                          Text(
                            _ogPreview!.title!.trim(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (_ogPreview!.description != null && _ogPreview!.description!.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _ogPreview!.description!.trim(),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: HomeShellTheme.textLightBlue.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        FilledButton(
                          onPressed: _applyOgToForm,
                          child: Text(l10n.propertyFormApplyPreview),
                        ),
                      ],
                      if (_ogAttempted &&
                          !_ogLoading &&
                          (_ogPreview == null || !(_ogPreview?.hasAny ?? false))) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.listingImportFallbackBody,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: HomeShellTheme.textLightBlue.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PropertySectionCard(
                  title: l10n.propertyFormQuickPickSection,
                  child: Column(
                    children: [
                      _FormPickRow(
                        label: l10n.provincePickTitle,
                        value: _provinceLabel ?? l10n.propertyFormPickEmpty,
                        onTap: () async {
                          final v = await showProvincePickerSheet(context);
                          if (v != null && mounted) {
                            setState(() => _provinceLabel = v);
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _FormPickRow(
                        label: l10n.listingLayoutPickTitle,
                        value: _layoutLabel ?? l10n.propertyFormPickEmpty,
                        onTap: () async {
                          final v = await showListingLayoutPickerSheet(context);
                          if (v != null && mounted) {
                            setState(() => _layoutLabel = v);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PropertySectionCard(
                  title: l10n.listingTypeLabel,
                  child: SegmentedButton<String>(
                    style: SegmentedButton.styleFrom(
                      side: BorderSide(color: HomeShellTheme.borderBlue.withValues(alpha: 0.45)),
                      selectedBackgroundColor: AppColors.surfaceElevated,
                      selectedForegroundColor: theme.colorScheme.onSurface,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    segments: [
                      ButtonSegment(value: 'sale', label: Text(l10n.chipSale)),
                      ButtonSegment(value: 'rent', label: Text(l10n.chipRent)),
                    ],
                    selected: {_listingType},
                    onSelectionChanged: (s) => setState(() => _listingType = s.first),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PropertySectionCard(
                  title: l10n.propertySectionBasics,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _title,
                        labelText: l10n.listingTitleLabel,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? l10n.validationRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _price,
                        labelText: l10n.listingPriceLabel,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _location,
                        labelText: l10n.listingLocationLabel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PropertySectionCard(
                  title: l10n.propertySectionFeatures,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _roomCount,
                              labelText: l10n.fieldRoomCountShort,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppTextField(
                              controller: _areaSqm,
                              labelText: l10n.fieldAreaSqmShort,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _bathroomCount,
                        labelText: l10n.fieldBathroomCountShort,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PropertySectionCard(
                  title: l10n.listingDescriptionLabel,
                  child: AppTextField(
                    controller: _description,
                    maxLines: 8,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PropertySectionCard(
                  title: l10n.propertySectionMedia,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.listingPhotosHint,
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (_existingImageUrls.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.listingExistingPhotos,
                            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _existingImageUrls.length,
                            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                            itemBuilder: (context, i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadii.sm),
                                child: Image.network(
                                  _existingImageUrls[i],
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const ColoredBox(
                                    color: AppColors.surfaceMuted,
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      if (_pickedImages.isNotEmpty)
                        SizedBox(
                          height: 88,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _pickedImages.length,
                            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                            itemBuilder: (context, i) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppRadii.sm),
                                    child: kIsWeb
                                        ? const SizedBox(
                                            width: 88,
                                            height: 88,
                                            child: ColoredBox(color: AppColors.surfaceMuted),
                                          )
                                        : Image.file(
                                            File(_pickedImages[i].path),
                                            width: 88,
                                            height: 88,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Material(
                                      color: AppColors.surfaceElevated,
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                                        padding: EdgeInsets.zero,
                                        iconSize: 16,
                                        onPressed: () => setState(() => _pickedImages.removeAt(i)),
                                        icon: const Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      if (_pickedImages.isNotEmpty) const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () async {
                                final picker = ImagePicker();
                                final list = await picker.pickMultiImage(imageQuality: 85);
                                if (list.isEmpty) {
                                  return;
                                }
                                setState(() {
                                  const maxPhotos = 12;
                                  _pickedImages.addAll(list);
                                  if (_pickedImages.length > maxPhotos) {
                                    _pickedImages.removeRange(maxPhotos, _pickedImages.length);
                                  }
                                });
                              },
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: Text(l10n.addListingPhotos),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8B5CF6), Color(0xFF5B21B6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _busy ? null : _save,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save_outlined, color: Colors.white, size: 22),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              l10n.save,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
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

class _FormPickRow extends StatelessWidget {
  const _FormPickRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppColors.surface.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: HomeShellTheme.textLightBlue.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: HomeShellTheme.textLightBlue.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertySectionCard extends StatelessWidget {
  const _PropertySectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomeShellTheme.borderBlue.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: HomeShellTheme.textLightBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
