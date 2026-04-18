import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 3 — taupe arka plan, ortada fotoğraf, altta ikon şeridi.
class Theme03ShareCard extends StatelessWidget {
  const Theme03ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _bg = Color(0xFFB8A99A);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return ColoredBox(
      color: _bg,
      child: Padding(
        padding: EdgeInsets.all(10 * s),
        child: Column(
          children: [
            Text(ctx.data.listingTypeLabel, style: TextStyle(color: const Color(0xFF3E322B), fontSize: 10 * s, fontWeight: FontWeight.w800)),
            SizedBox(height: 8 * s),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: main != null && main.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20 * s),
                          child: codeListingImage(ctx, main, borderRadius: 20 * s),
                        )
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBECEE),
                            borderRadius: BorderRadius.circular(20 * s),
                          ),
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.king_bed_outlined, color: const Color(0xFF3E322B), size: 22 * s),
                Icon(Icons.bathtub_outlined, color: const Color(0xFF3E322B), size: 22 * s),
                Icon(Icons.directions_car_filled_outlined, color: const Color(0xFF3E322B), size: 22 * s),
                Icon(Icons.weekend_outlined, color: const Color(0xFF3E322B), size: 22 * s),
              ],
            ),
            SizedBox(height: 6 * s),
            codeFeaturesCaption(ctx, fontSize: 10, color: const Color(0xFF3E322B)),
            if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
              SizedBox(height: 4 * s),
              Text(
                ctx.data.locationLine!.trim(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: const Color(0xFF3E322B), fontSize: 9.5 * s, fontWeight: FontWeight.w600),
              ),
            ],
            SizedBox(height: 8 * s),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF3E322B), width: 1.2),
                borderRadius: BorderRadius.circular(8 * s),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 10 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      ctx.data.priceLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: const Color(0xFF2D241F), fontSize: 16 * s, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 4 * s),
                    Text(
                      ctx.data.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: const Color(0xFF3E322B), fontSize: 11 * s, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8 * s),
                    codeDescriptionBlock(
                      ctx,
                      maxLines: 4,
                      fontSize: 9,
                      color: const Color(0xFF4E4039),
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
