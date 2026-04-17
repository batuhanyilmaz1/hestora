import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';

Future<Alignment?> showShareCardImageAdjustSheet(
  BuildContext context, {
  required Alignment initial,
}) {
  return showModalBottomSheet<Alignment>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return _ShareCardImageAdjustBody(initial: initial);
    },
  );
}

class _ShareCardImageAdjustBody extends StatefulWidget {
  const _ShareCardImageAdjustBody({required this.initial});

  final Alignment initial;

  @override
  State<_ShareCardImageAdjustBody> createState() => _ShareCardImageAdjustBodyState();
}

class _ShareCardImageAdjustBodyState extends State<_ShareCardImageAdjustBody> {
  late double _x = widget.initial.x.clamp(-1.0, 1.0);
  late double _y = widget.initial.y.clamp(-1.0, 1.0);

  static const _presets = <Alignment>[
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pad = MediaQuery.paddingOf(context);

    return Padding(
      padding: EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md, bottom: pad.bottom + AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.shareCardAdjustPhotoTitle, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: AppSpacing.xs),
          Text(
            l10n.shareCardAdjustPhotoHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          SizedBox(height: AppSpacing.md),
          Text(l10n.shareCardAdjustPhotoHorizontal, style: Theme.of(context).textTheme.labelLarge),
          Slider(
            value: _x,
            min: -1,
            max: 1,
            divisions: 40,
            label: _x.toStringAsFixed(2),
            onChanged: (v) => setState(() => _x = v),
          ),
          Text(l10n.shareCardAdjustPhotoVertical, style: Theme.of(context).textTheme.labelLarge),
          Slider(
            value: _y,
            min: -1,
            max: 1,
            divisions: 40,
            label: _y.toStringAsFixed(2),
            onChanged: (v) => setState(() => _y = v),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(l10n.shareCardAdjustPhotoPresets, style: Theme.of(context).textTheme.labelLarge),
          SizedBox(height: AppSpacing.sm),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              for (final a in _presets)
                OutlinedButton(
                  onPressed: () => setState(() {
                    _x = a.x;
                    _y = a.y;
                  }),
                  child: Icon(_iconForAlignment(a), size: 20),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _x = widget.initial.x;
                    _y = widget.initial.y;
                  });
                },
                child: Text(l10n.shareCardAdjustPhotoReset),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.pop(context, Alignment(_x, _y)),
                child: Text(l10n.shareCardAdjustPhotoDone),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconForAlignment(Alignment a) {
    if (a.y <= -0.5) {
      if (a.x <= -0.5) {
        return Icons.north_west;
      }
      if (a.x >= 0.5) {
        return Icons.north_east;
      }
      return Icons.north;
    }
    if (a.y >= 0.5) {
      if (a.x <= -0.5) {
        return Icons.south_west;
      }
      if (a.x >= 0.5) {
        return Icons.south_east;
      }
      return Icons.south;
    }
    if (a.x <= -0.5) {
      return Icons.west;
    }
    if (a.x >= 0.5) {
      return Icons.east;
    }
    return Icons.center_focus_strong;
  }
}
