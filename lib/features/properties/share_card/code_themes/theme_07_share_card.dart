import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 7 — kare, üstte geniş hero, altta bilgi bandı.
class Theme07ShareCard extends StatelessWidget {
  const Theme07ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 58,
          child: main != null && main.isNotEmpty
              ? codeListingImage(ctx, main, borderRadius: 0)
              : ColoredBox(color: Colors.grey.shade300),
        ),
        Expanded(
          flex: 42,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12 * s, 10 * s, 12 * s, 10 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctx.data.listingTypeLabel,
                  style: TextStyle(color: ctx.theme.accentColor, fontSize: 10 * s, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 6 * s),
                Text(
                  ctx.data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ctx.withShadow(TextStyle(color: Colors.black87, fontSize: 14 * s, fontWeight: FontWeight.w900)),
                ),
                SizedBox(height: 6 * s),
                Text(
                  ctx.data.priceLine,
                  style: ctx.withShadow(TextStyle(color: Colors.blue.shade900, fontSize: 16 * s, fontWeight: FontWeight.w900)),
                ),
                Text(
                  ctx.data.featuresLine,
                  style: ctx.withShadow(TextStyle(color: Colors.black54, fontSize: 11 * s)),
                ),
                if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                  SizedBox(height: 4 * s),
                  Text(
                    ctx.data.locationLine!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ctx.withShadow(TextStyle(color: Colors.black45, fontSize: 10 * s)),
                  ),
                ],
                SizedBox(height: 6 * s),
                codeDescriptionBlock(ctx, maxLines: 3, fontSize: 9.5, color: Colors.black54),
                const Spacer(),
                Row(
                  children: [
                    Expanded(child: Text(ctx.data.agentName ?? '', style: TextStyle(fontSize: 10 * s, fontWeight: FontWeight.w700))),
                    codeQrOrUrl(ctx, maxSide: 48),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
