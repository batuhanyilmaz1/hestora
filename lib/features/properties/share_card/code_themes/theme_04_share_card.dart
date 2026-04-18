import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 4 — kare, sol fotoğraf + sağ koyu panel.
class Theme04ShareCard extends StatelessWidget {
  const Theme04ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return Row(
      children: [
        Expanded(
          flex: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(22 * s)),
            child: main != null && main.isNotEmpty
                ? SizedBox.expand(child: codeListingImage(ctx, main, borderRadius: 0, fit: BoxFit.cover))
                : ColoredBox(color: Colors.grey.shade800),
          ),
        ),
        Expanded(
          flex: 52,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF444440), Color(0xFF222222)],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10 * s, 18 * s, 10 * s, 10 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 36 * s,
                      height: 8 * s,
                      color: const Color(0xFF8B6B4F),
                    ),
                  ),
                  SizedBox(height: 10 * s),
                  Text(
                    ctx.data.listingTypeLabel,
                    style: TextStyle(color: ctx.theme.accentColor, fontSize: 10 * s, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6 * s),
                  Text(
                    ctx.data.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 13 * s, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8 * s),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20 * s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 8 * s),
                      child: Text(
                        ctx.data.priceLine,
                        style: TextStyle(color: Colors.white, fontSize: 14 * s, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(ctx.data.featuresLine, style: TextStyle(color: Colors.white70, fontSize: 10 * s)),
                  if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                    SizedBox(height: 4 * s),
                    Text(
                      ctx.data.locationLine!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white60, fontSize: 9 * s),
                    ),
                  ],
                  SizedBox(height: 6 * s),
                  codeDescriptionBlock(ctx, maxLines: 3, fontSize: 8.8, color: Colors.white54),
                  SizedBox(height: 8 * s),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.phone_in_talk_outlined, color: Colors.white, size: 18 * s),
                      SizedBox(width: 10 * s),
                      Icon(Icons.language_rounded, color: Colors.white, size: 18 * s),
                    ],
                  ),
                  SizedBox(height: 8 * s),
                  codeQrOrUrl(ctx, maxSide: 52),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
