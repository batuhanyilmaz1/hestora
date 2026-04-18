import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 10 — kare, tam ekran görsel hissi + turuncu etiket + montaj kutuları.
class Theme10ShareCard extends StatelessWidget {
  const Theme10ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _brown = Color(0xFF3E2723);
  static const _gold = Color(0xFFD88C2D);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (main != null && main.isNotEmpty)
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.25), BlendMode.darken),
            child: codeListingImage(ctx, main, borderRadius: 0),
          )
        else
          const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF5D4037), Color(0xFF212121)]))),
        Positioned(
          left: 10 * s,
          top: 10 * s,
          child: DecoratedBox(
            decoration: BoxDecoration(color: _gold, borderRadius: BorderRadius.circular(10 * s)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 8 * s),
              child: Text(
                ctx.data.listingTypeLabel,
                style: TextStyle(color: Colors.white, fontSize: 11 * s, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10 * s,
          top: 10 * s,
          width: ctx.width * 0.48,
          height: ctx.height * 0.38,
          child: _framed(ctx, main),
        ),
        Positioned(
          left: 10 * s,
          bottom: ctx.height * 0.22,
          child: Row(
            children: [
              _smallFramed(ctx, pickGalleryUrl(ctx, 1) ?? main),
              SizedBox(width: 6 * s),
              _smallFramed(ctx, pickGalleryUrl(ctx, 2) ?? main),
            ],
          ),
        ),
        Positioned(
          right: 10 * s,
          bottom: ctx.height * 0.18,
          width: ctx.width * 0.48,
          height: ctx.height * 0.28,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _brown,
              borderRadius: BorderRadius.circular(14 * s),
              border: Border.all(color: Colors.white54, width: 1.5),
            ),
            child: Padding(
              padding: EdgeInsets.all(10 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ctx.data.title, maxLines: 2, style: TextStyle(color: Colors.white, fontSize: 11 * s, fontWeight: FontWeight.w800)),
                  SizedBox(height: 6 * s),
                  codeFeaturesCaption(ctx, fontSize: 9.5, color: Colors.white70, align: TextAlign.start),
                  SizedBox(height: 4 * s),
                  codeDescriptionBlock(ctx, maxLines: 1, fontSize: 8.5, color: Colors.white60),
                  const Spacer(),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 2.2,
                    children: [
                      Icons.king_bed_outlined,
                      Icons.bathtub_outlined,
                      Icons.square_foot_rounded,
                      Icons.layers_outlined,
                    ]
                        .map(
                          (e) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white38),
                            ),
                            child: Center(child: Icon(e, color: Colors.white54, size: 14 * s)),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 36 * s,
          child: ColoredBox(
            color: _brown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.only(left: 12 * s), child: Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18 * s)),
                Icon(Icons.location_on_outlined, color: Colors.white, size: 18 * s),
                Icon(Icons.language_rounded, color: Colors.white, size: 18 * s),
                Padding(
                  padding: EdgeInsets.only(right: 10 * s),
                  child: Container(
                    width: 40 * s,
                    height: 22 * s,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6 * s),
                      border: Border.all(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _framed(CodeShareCardContext c, String? url) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(16 * c.scale),
        border: Border.all(color: Colors.white54, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12 * c.scale),
        child: url != null && url.isNotEmpty ? codeListingImage(c, url, borderRadius: 12 * c.scale) : ColoredBox(color: Colors.grey.shade400),
      ),
    );
  }

  Widget _smallFramed(CodeShareCardContext c, String? url) {
    return SizedBox(
      width: c.width * 0.22,
      height: c.width * 0.18,
      child: _framed(c, url),
    );
  }
}
