import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/home_shell_theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/property_repository.dart';
import '../domain/property.dart';
import '../domain/property_form_prefill.dart';

class PropertyFormPage extends ConsumerStatefulWidget {
  const PropertyFormPage({super.key, this.prefill, this.editingPropertyId});

  final PropertyFormPrefill? prefill;
  /// Doluysa ilan güncelleme modu (`insert` yerine `update`).
  final String? editingPropertyId;

  @override
  ConsumerState<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends ConsumerState<PropertyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _listingUrl = TextEditingController();
  final _roomCount = TextEditingController();
  final _bathroomCount = TextEditingController();
  final _areaSqm = TextEditingController();
  String _listingType = 'sale';
  bool _busy = false;
  final List<XFile> _pickedImages = [];
  bool _hydratedFromRemote = false;
  final List<String> _existingImageUrls = [];

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
  }

  @override
  void dispose() {
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
      final editId = widget.editingPropertyId;
      if (editId != null) {
        await repo.update(
          id: editId,
          title: _title.text.trim(),
          listingType: _listingType,
          location: _location.text.trim().isEmpty ? null : _location.text.trim(),
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
          title: _title.text.trim(),
          listingType: _listingType,
          location: _location.text.trim().isEmpty ? null : _location.text.trim(),
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
                                borderRadius: BorderRadius.circular(AppRadii.md),
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
                                    borderRadius: BorderRadius.circular(AppRadii.md),
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
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _listingUrl,
                        labelText: l10n.listingUrlLabel,
                        keyboardType: TextInputType.url,
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
