import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 13 — üst beyaz hero, alt zeytin yeşili bant + küçük galeri.
class Theme13ShareCard extends StatelessWidget {
  const Theme13ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _green = Color(0xFF2E4A32);
  static const _creamFooter = Color(0xFFFFF8E1);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 50,
          child: main != null && main.isNotEmpty
              ? ColoredBox(color: Colors.white, child: codeListingImage(ctx, main, borderRadius: 0))
              : const ColoredBox(color: Colors.white),
        ),
        Expanded(
          flex: 46,
          child: ColoredBox(
            color: _green,
            child: Padding(
              padding: EdgeInsets.all(10 * s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: ctx.width * 0.22,
                    padding: EdgeInsets.only(bottom: 10 * s),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 8 * s),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8 * s),
                          padding: EdgeInsets.symmetric(vertical: 6 * s),
                          color: _green.withValues(alpha: 0.2),
                          child: Center(
                            child: Text(
                              ctx.data.listingTypeLabel,
                              style: TextStyle(color: _green, fontWeight: FontWeight.w800, fontSize: 9 * s),
                            ),
                          ),
                        ),
                        SizedBox(height: 8 * s),
                        Text(
                          ctx.data.priceLine,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _green, fontWeight: FontWeight.w900, fontSize: 12 * s),
                        ),
                        SizedBox(height: 6 * s),
                        Text(
                          ctx.data.featuresLine,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: _green, fontSize: 7.5 * s, fontWeight: FontWeight.w600, height: 1.15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8 * s),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: List.generate(
                              3,
                              (i) => Expanded(child: _gCell(ctx, i, main))),
                          ),
                        ),
                        SizedBox(height: 4 * s),
                        Expanded(
                          child: Row(
                            children: List.generate(
                              3,
                              (i) => Expanded(child: _gCell(ctx, i + 3, main))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: ColoredBox(
            color: _creamFooter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 4 * s),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ctx.data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _green, fontSize: 8.5 * s, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2 * s),
                  Text(
                    ctx.data.footerContactLine ?? ctx.data.locationLine ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _green, fontSize: 8 * s),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _gCell(CodeShareCardContext c, int i, String? main) {
    final u = pickGalleryUrl(c, i % 4) ?? main;
    if (u == null || u.isEmpty) {
      return ColoredBox(color: Colors.white12);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: codeListingImage(c, u, borderRadius: 4),
    );
  }
}
