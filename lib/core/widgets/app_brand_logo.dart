import 'package:flutter/material.dart';

/// Safe wordmark fallback for environments where bundled SVG branding is absent.
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({super.key, this.height = 40});

  final double height;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: const Color(0xFFF8FAFC),
        );

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: height * 0.32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.3),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
        ),
        border: Border.all(color: const Color(0x3347B5FF)),
      ),
      alignment: Alignment.center,
      child: Text(
        'HESTORA',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      ),
    );
  }
}
