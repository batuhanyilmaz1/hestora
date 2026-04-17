import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/providers/app_environment_provider.dart';
import '../../../core/services/openai_customer_extraction_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../customers/data/customer_repository.dart';

class AiCustomerImportPage extends ConsumerStatefulWidget {
  const AiCustomerImportPage({super.key});

  @override
  ConsumerState<AiCustomerImportPage> createState() => _AiCustomerImportPageState();
}

class _AiCustomerImportPageState extends ConsumerState<AiCustomerImportPage> {
  final _picker = ImagePicker();
  final _suggestedPhone = TextEditingController();
  final _suggestedName = TextEditingController();
  Uint8List? _imageBytes;
  bool _busyAi = false;
  bool _busySave = false;

  @override
  void dispose() {
    _suggestedPhone.dispose();
    _suggestedName.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) {
      return;
    }
    final bytes = await image.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _suggestedPhone.clear();
      _suggestedName.clear();
    });
  }

  String _normalizePhone(String value) {
    final raw = value.trim();
    if (raw.isEmpty) {
      return '';
    }
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }
    if (raw.startsWith('+')) {
      return '+$digits';
    }
    if (digits.startsWith('90')) {
      return '+$digits';
    }
    if (digits.length == 10 && digits.startsWith('5')) {
      return '+90$digits';
    }
    if (digits.length == 11 && digits.startsWith('0')) {
      return '+90${digits.substring(1)}';
    }
    return raw;
  }

  Future<void> _runOpenAi() async {
    final l10n = AppLocalizations.of(context)!;
    final env = ref.read(appEnvironmentProvider);
    if (!env.hasOpenAiCredentials) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aiExtractNoApiKey)),
      );
      return;
    }
    final imageBytes = _imageBytes;
    if (imageBytes == null || imageBytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aiExtractNeedInput)),
      );
      return;
    }

    setState(() => _busyAi = true);
    try {
      final result = await OpenAiCustomerExtractionService.extract(
        apiKey: env.openAiApiKey.trim(),
        imageBytes: imageBytes,
      );
      if (!mounted) {
        return;
      }
      _suggestedName.text = result.name?.trim() ?? '';
      _suggestedPhone.text = _normalizePhone(result.phone ?? '');
      setState(() {});
    } on OpenAiCustomerExtractException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.aiExtractFailed}: $error')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.aiExtractFailed}: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _busyAi = false);
      }
    }
  }

  Future<void> _createCustomer() async {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(customerRepositoryProvider);
    if (!repo.supportsRemote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.supabaseStatusNotConfigured)),
      );
      return;
    }

    final phone = _normalizePhone(_suggestedPhone.text);
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aiCreateNeedsPhone)),
      );
      return;
    }

    final name = _suggestedName.text.trim().isEmpty
        ? l10n.customerUnknownName
        : _suggestedName.text.trim();

    setState(() => _busySave = true);
    try {
      final id = await repo.insert(name: name, phone: phone);
      ref.invalidate(customersListProvider);
      ref.invalidate(customerDetailProvider(id));
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aiCustomerCreated)),
      );
      context.go('/customers/$id');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    } finally {
      if (mounted) {
        setState(() => _busySave = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final env = ref.watch(appEnvironmentProvider);
    final hasKey = env.hasOpenAiCredentials;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiImportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.aiImportSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.memory(_imageBytes!, fit: BoxFit.cover),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.photo_library_outlined, size: 36),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.aiImportSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: _busyAi || _busySave ? null : _pick,
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(l10n.aiPickGallery),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: (!hasKey || _busyAi || _busySave) ? null : _runOpenAi,
            icon: _busyAi
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.auto_awesome_outlined),
            label: Text(l10n.aiExtractWithOpenAi),
          ),
          if (!hasKey)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                l10n.aiExtractNoApiKey,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.warning,
                    ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _suggestedPhone,
            labelText: l10n.aiSuggestedPhone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _suggestedName,
            labelText: l10n.fieldName,
            helperText: l10n.aiDetectedNameHint,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: l10n.aiCreateCustomer,
            icon: Icons.person_add_alt_1_outlined,
            onPressed: (_busyAi || _busySave) ? null : _createCustomer,
          ),
        ],
      ),
    );
  }
}
