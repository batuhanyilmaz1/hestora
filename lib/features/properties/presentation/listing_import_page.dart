import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/open_graph_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/property_form_prefill.dart';

class ListingImportPage extends ConsumerStatefulWidget {
  const ListingImportPage({super.key});

  @override
  ConsumerState<ListingImportPage> createState() => _ListingImportPageState();
}

class _ListingImportPageState extends ConsumerState<ListingImportPage> {
  final _url = TextEditingController();
  bool _loading = false;
  bool _attempted = false;
  OgMetadata? _preview;
  String? _fallbackMessage;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    final raw = _url.text.trim();
    if (raw.isEmpty) {
      return;
    }
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.validationUrl)),
      );
      return;
    }
    setState(() {
      _loading = true;
      _attempted = true;
      _preview = null;
      _fallbackMessage = null;
    });
    try {
      final meta = await OpenGraphService.fetch(uri);
      if (!mounted) {
        return;
      }
      setState(() {
        _preview = meta;
        if (!meta.hasAny) {
          _fallbackMessage = AppLocalizations.of(context)!.listingImportFallbackBody;
        }
      });
      if (!meta.hasAny) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.listingImportFallbackBody)),
        );
      }
    } on OgFetchException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _fallbackMessage = AppLocalizations.of(context)!.listingImportFallbackBody;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.ogFetchError} ($e)')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _fallbackMessage = AppLocalizations.of(context)!.listingImportFallbackBody;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.ogFetchError)),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _openForm() {
    final uri = _url.text.trim();
    final p = _preview;
    context.push(
      '/properties/new',
      extra: PropertyFormPrefill(
        title: p?.title,
        description: p?.description,
        listingUrl: uri.isNotEmpty ? uri : p?.canonicalUrl,
        ogImageUrl: p?.imageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = _preview;
    final showFallback = _attempted && !_loading && (_fallbackMessage != null || !(p?.hasAny ?? false));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.listingImportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.listingImportHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _url,
            labelText: l10n.listingUrlLabel,
            hintText: l10n.listingImportHint,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: l10n.listingImportAction,
            icon: Icons.cloud_download_outlined,
            onPressed: _loading ? null : _fetch,
          ),
          if (_loading) const Padding(
            padding: EdgeInsets.only(top: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
          if (p != null && p.hasAny) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.listingTitleLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(p.title ?? '—', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.md),
            if (p.description != null && p.description!.isNotEmpty) ...[
              Text(l10n.listingDescriptionLabel, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(p.description!, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
            ],
            if (p.imageUrl != null && p.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    p.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            AppPrimaryButton(
              label: l10n.createPropertyTitle,
              icon: Icons.edit_outlined,
              onPressed: _openForm,
            ),
          ],
          if (showFallback) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note_outlined, color: AppColors.warning),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.listingImportFallbackTitle,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _fallbackMessage ?? l10n.listingImportFallbackBody,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppPrimaryButton(
                    label: l10n.listingImportContinueManual,
                    icon: Icons.edit_outlined,
                    onPressed: _openForm,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
