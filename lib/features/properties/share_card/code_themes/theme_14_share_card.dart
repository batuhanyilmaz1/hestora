import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 14 — yeşil çerçeveli üst görsel, ortada üç küçük kart, krem metin alanı.
class Theme14ShareCard extends StatelessWidget {
  const Theme14ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _green = Color(0xFF1B5E20);
  static const _cream = Color(0xFFFFF8E1);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return ColoredBox(
      color: _cream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10 * s, 10 * s, 10 * s, 0),
            padding: EdgeInsets.all(5 * s),
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10 * s)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6 * s),
              child: SizedBox(
                height: ctx.height * 0.28,
                child: main != null && main.isNotEmpty
                    ? codeListingImage(ctx, main, borderRadius: 6 * s)
                    : ColoredBox(color: Colors.white24),
              ),
            ),
          ),
          SizedBox(height: 18 * s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12 * s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _overlapThumb(ctx, pickGalleryUrl(ctx, 1) ?? main, 0.22, -4 * s),
                _overlapThumb(ctx, pickGalleryUrl(ctx, 2) ?? main, 0.26, 0),
                _overlapThumb(ctx, pickGalleryUrl(ctx, 3) ?? main, 0.22, -4 * s),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(14 * s, 16 * s, 14 * s, 8 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ctx.data.listingTypeLabel, style: TextStyle(color: _green, fontWeight: FontWeight.w800, fontSize: 10 * s)),
                  Text(ctx.data.title, maxLines: 2, style: TextStyle(fontSize: 14 * s, fontWeight: FontWeight.w900)),
                  SizedBox(height: 6 * s),
                  Text(ctx.data.priceLine, style: TextStyle(fontSize: 16 * s, fontWeight: FontWeight.w900, color: _green)),
                  Text(ctx.data.featuresLine, style: TextStyle(fontSize: 11 * s, color: Colors.black54)),
                  if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                    SizedBox(height: 4 * s),
                    Text(
                      ctx.data.locationLine!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10 * s, color: Colors.black45),
                    ),
                  ],
                  SizedBox(height: 6 * s),
                  codeDescriptionBlock(ctx, maxLines: 3, fontSize: 9.5, color: Colors.black54),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(child: Text(ctx.data.agentPhone ?? '', style: TextStyle(fontSize: 10 * s))),
                      codeQrOrUrl(ctx, maxSide: 44),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36 * s,
                  color: _green,
                  child: Center(child: Container(width: 40 * s, height: 2 * s, color: Colors.white54)),
                ),
              ),
              Expanded(
                child: Container(
                  height: 36 * s,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF81C784)]),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 8 * s),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 28 * s,
                          height: 28 * s,
                          child: pickGalleryUrl(ctx, 1) != null
                              ? codeListingImage(ctx, pickGalleryUrl(ctx, 1)!, borderRadius: 4)
                              : ColoredBox(color: Colors.white24),
                        ),
                      ),
                      SizedBox(width: 8 * s),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _cream,
                            borderRadius: BorderRadius.circular(16 * s),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 4 * s),
                            child: Row(
                              children: [
                                Icon(Icons.phone_in_talk_rounded, color: _green, size: 16 * s),
                                SizedBox(width: 4 * s),
                                Expanded(
                                  child: Text(
                                    ctx.data.agentPhone ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 9 * s, color: _green, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8 * s),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overlapThumb(CodeShareCardContext c, String? u, double fracW, double dy) {
    final w = c.width * fracW;
    return Transform.translate(
      offset: Offset(0, dy),
      child: Container(
        width: w,
        height: w * 0.72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8 * c.scale),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6 * c.scale)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6 * c.scale),
          child: u != null && u.isNotEmpty ? codeListingImage(c, u, borderRadius: 6 * c.scale) : ColoredBox(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
