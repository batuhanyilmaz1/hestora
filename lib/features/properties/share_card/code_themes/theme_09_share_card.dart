import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 9 — kare, solda dikey daireler, sağda degrade bilgi bloğu.
class Theme09ShareCard extends StatelessWidget {
  const Theme09ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _olive = Color(0xFF8D8B5A);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: ctx.width * 0.22,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _oval(ctx, main, 0),
              SizedBox(height: 8 * s),
              _oval(ctx, pickGalleryUrl(ctx, 1), 1),
              SizedBox(height: 8 * s),
              _oval(ctx, pickGalleryUrl(ctx, 2), 2),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(6 * s, 12 * s, 12 * s, 10 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: _olive, borderRadius: BorderRadius.circular(20 * s)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 6 * s),
                      child: Text(
                        ctx.data.listingTypeLabel,
                        style: TextStyle(color: Colors.white, fontSize: 10 * s, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8 * s),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14 * s),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2C2C2C), Color(0xFF0A0A0A)],
                      ),
                    ),
                    padding: EdgeInsets.all(12 * s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54),
                            borderRadius: BorderRadius.circular(10 * s),
                          ),
                          child: Text(
                            ctx.data.priceLine,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(height: 10 * s),
                        Text(
                          ctx.data.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 12 * s, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 6 * s),
                        codeFeaturesCaption(ctx, fontSize: 9.5, color: Colors.white70, align: TextAlign.start),
                        if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                          SizedBox(height: 4 * s),
                          Text(
                            ctx.data.locationLine!.trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white60, fontSize: 9 * s),
                          ),
                        ],
                        SizedBox(height: 4 * s),
                        codeDescriptionBlock(ctx, maxLines: 3, fontSize: 8.8, color: Colors.white54),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.white70, size: 18 * s),
                            SizedBox(width: 8 * s),
                            Icon(Icons.phone_in_talk_outlined, color: Colors.white70, size: 18 * s),
                            SizedBox(width: 8 * s),
                            Icon(Icons.language_rounded, color: Colors.white70, size: 18 * s),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8 * s),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFE0C89A), Color(0xFFD4B87A)]),
                    borderRadius: BorderRadius.circular(22 * s),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 8 * s),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            ctx.data.featuresLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black87, fontSize: 10 * s, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                          child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16 * s),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6 * s),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.king_bed_outlined, size: 16 * s),
                    Icon(Icons.directions_car_filled_outlined, size: 16 * s),
                    Icon(Icons.bathtub_outlined, size: 16 * s),
                    Icon(Icons.open_in_full_rounded, size: 16 * s),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _oval(CodeShareCardContext c, String? url, int idx) {
    final u = url ?? pickGalleryUrl(c, idx);
    return ClipOval(
      child: SizedBox(
        width: c.width * 0.16,
        height: c.width * 0.16,
        child: u != null && u.isNotEmpty
            ? codeListingImage(c, u, borderRadius: c.width * 0.08)
            : Container(color: Colors.grey.shade300),
      ),
    );
  }
}
