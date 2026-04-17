import 'package:flutter/material.dart';

/// Normalized rectangle (0–1) inside the **content** area after safe padding is applied.
class ShareCardRegion {
  const ShareCardRegion({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  Rect toRect({
    required Size cardSize,
    required EdgeInsets safePadding,
  }) {
    final innerLeft = safePadding.left;
    final innerTop = safePadding.top;
    final innerW = cardSize.width - safePadding.horizontal;
    final innerH = cardSize.height - safePadding.vertical;
    return Rect.fromLTWH(
      innerLeft + left * innerW,
      innerTop + top * innerH,
      width * innerW,
      height * innerH,
    );
  }
}
