import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/share_card_watermark_style.dart';

/// Large diagonal “HESTORA” mark for default / minimal templates.
class ShareCardBrandWatermark extends StatelessWidget {
  const ShareCardBrandWatermark({super.key, required this.style});

  final ShareCardWatermarkStyle style;

  @override
  Widget build(BuildContext context) {
    if (style == ShareCardWatermarkStyle.none) {
      return const SizedBox.shrink();
    }
    final base = style == ShareCardWatermarkStyle.light ? Colors.white : const Color(0xFF0F172A);
    return IgnorePointer(
      child: ClipRect(
        child: Opacity(
          opacity: style == ShareCardWatermarkStyle.light ? 0.09 : 0.07,
          child: LayoutBuilder(
            builder: (context, c) {
              final side = math.max(c.maxWidth, c.maxHeight);
              return Transform.rotate(
                angle: -0.38,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: side * 1.35,
                      height: side * 0.45,
                      child: Center(
                        child: Text(
                          'HESTORA',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: base,
                            fontSize: side * 0.22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: side * 0.018,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
