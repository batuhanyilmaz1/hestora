import 'package:flutter/material.dart';

import '../models/share_card_layout_data.dart';
import '../models/share_card_theme_definition.dart';

/// Saf Flutter temaları için ortak ölçek ve renk bağlamı.
class CodeShareCardContext {
  CodeShareCardContext({
    required this.theme,
    required this.data,
    required this.width,
    required this.height,
    required this.listingImageAlignment,
  });

  final ShareCardThemeDefinition theme;
  final ShareCardLayoutData data;
  final double width;
  final double height;
  final Alignment listingImageAlignment;

  double get scale => (width / theme.designWidth).clamp(0.55, 1.45);

  TextStyle withShadow(TextStyle base) {
    if (!theme.textShadows) {
      return base;
    }
    return base.copyWith(
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 3 * scale,
          offset: Offset(0, 1 * scale),
        ),
      ],
    );
  }
}

bool isFlutterCodeShareTheme(String id) {
  final m = RegExp(r'^theme_(\d{2})$').firstMatch(id);
  if (m == null) {
    return false;
  }
  final n = int.tryParse(m.group(1)!);
  return n != null && n >= 1 && n <= 15;
}
