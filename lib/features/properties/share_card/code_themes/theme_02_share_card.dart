import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 2 — kare, sol lacivert metin + sağ büyük fotoğraf.
class Theme02ShareCard extends StatelessWidget {
  const Theme02ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _navy = Color(0xFF0D2149);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return Row(
      children: [
        Expanded(
          flex: 42,
          child: ColoredBox(
            color: _navy,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10 * s, 14 * s, 8 * s, 10 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ctx.data.listingTypeLabel,
                    style: TextStyle(color: ctx.theme.accentColor, fontSize: 10 * s, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8 * s),
                  Text(
                    ctx.data.title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12 * s, fontWeight: FontWeight.w800, height: 1.1),
                  ),
                  SizedBox(height: 8 * s),
                  Text(
                    ctx.data.priceLine,
                    style: TextStyle(color: ctx.theme.priceColor, fontSize: 14 * s, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 6 * s),
                  Text(
                    ctx.data.featuresLine,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white70, fontSize: 9 * s),
                  ),
                  SizedBox(height: 6 * s),
                  codeDescriptionBlock(ctx, maxLines: 3, fontSize: 8.5, color: Colors.white60),
                  const Spacer(),
                  Text(
                    ctx.data.locationLine ?? '',
                    maxLines: 2,
                    style: TextStyle(color: Colors.white54, fontSize: 9 * s),
                  ),
                  SizedBox(height: 6 * s),
                  Text(ctx.data.agentName ?? '', style: TextStyle(color: Colors.white, fontSize: 10 * s, fontWeight: FontWeight.w700)),
                  Text(ctx.data.agentPhone ?? '', style: TextStyle(color: Colors.white70, fontSize: 9 * s)),
                  if ((ctx.data.agentEmail ?? '').trim().isNotEmpty)
                    Text(
                      ctx.data.agentEmail!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white60, fontSize: 8.5 * s),
                    ),
                  SizedBox(height: 8 * s),
                  codeQrOrUrl(ctx, maxSide: 56),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 58,
          child: ColoredBox(
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10 * s),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: main != null && main.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18 * s),
                            child: codeListingImage(ctx, main, borderRadius: 18 * s),
                          )
                        : DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(18 * s),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 16 * s,
                  right: 16 * s,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D4D),
                      borderRadius: BorderRadius.circular(20 * s),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 4 * s),
                      child: Text(
                        ctx.data.listingTypeLabel,
                        style: TextStyle(color: Colors.white, fontSize: 9 * s, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14 * s,
                  left: 18 * s,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10 * s),
                    child: SizedBox(
                      width: ctx.width * 0.18,
                      height: ctx.width * 0.18,
                      child: pickGalleryUrl(ctx, 1) != null
                          ? codeListingImage(ctx, pickGalleryUrl(ctx, 1)!, borderRadius: 10 * s)
                          : ColoredBox(color: Colors.grey.shade300),
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
}
