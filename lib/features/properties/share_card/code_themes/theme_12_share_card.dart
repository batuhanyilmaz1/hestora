import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 12 — krem arka plan, üst şerit + hero + üç küçük görsel + avatar + metin.
class Theme12ShareCard extends StatelessWidget {
  const Theme12ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _cream = Color(0xFFFCF9F5);
  static const _brown = Color(0xFF8B7361);
  static const _header = Color(0xFFD2C1B0);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return ColoredBox(
      color: _cream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 8 * s, color: _header),
          Expanded(
            flex: 28,
            child: main != null && main.isNotEmpty
                ? codeListingImage(ctx, main, borderRadius: 0)
                : ColoredBox(color: Colors.grey.shade200),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6 * s, vertical: 4 * s),
            child: Row(
              children: [
                Expanded(child: _mini(ctx, pickGalleryUrl(ctx, 1) ?? main)),
                SizedBox(width: 4 * s),
                Expanded(child: _mini(ctx, pickGalleryUrl(ctx, 2) ?? main)),
                SizedBox(width: 4 * s),
                Expanded(child: _mini(ctx, pickGalleryUrl(ctx, 3) ?? main)),
              ],
            ),
          ),
          Expanded(
            flex: 32,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 38,
                  child: ColoredBox(
                    color: _brown,
                    child: Center(child: codeAgentAvatar(ctx, diameter: minSide(ctx) * 0.22)),
                  ),
                ),
                Expanded(
                  flex: 62,
                  child: Padding(
                    padding: EdgeInsets.all(10 * s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ${ctx.data.featuresLine}', style: TextStyle(color: Colors.black87, fontSize: 10 * s)),
                        if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                          SizedBox(height: 4 * s),
                          Text(
                            ctx.data.locationLine!.trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black54, fontSize: 9.5 * s),
                          ),
                        ],
                        SizedBox(height: 6 * s),
                        codeDescriptionBlock(ctx, maxLines: 4, fontSize: 9, color: Colors.black87),
                        const Spacer(),
                        Text(ctx.data.title, maxLines: 2, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12 * s)),
                        Text(ctx.data.priceLine, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14 * s, color: Colors.brown.shade900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: _header,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 6 * s),
            child: Text(
              ctx.data.footerContactLine ?? '${ctx.data.agentPhone ?? ''} · ${ctx.data.websiteFallbackLine ?? ''}'.trim(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.brown.shade800, fontSize: 9 * s, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mini(CodeShareCardContext c, String? u) {
    final h = 36 * c.scale;
    if (u == null || u.isEmpty) {
      return SizedBox(height: h, child: ColoredBox(color: Colors.grey.shade300));
    }
    return SizedBox(height: h, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: codeListingImage(c, u, borderRadius: 4)));
  }
}
