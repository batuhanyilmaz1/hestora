import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 15 — bej arka plan, sol üst görsel + sağ sütun galeri + ikon ızgarası hissi.
class Theme15ShareCard extends StatelessWidget {
  const Theme15ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _beige = Color(0xFFF2EEE9);
  static const _brown = Color(0xFF3E3631);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    return ColoredBox(
      color: _beige,
      child: Padding(
        padding: EdgeInsets.all(10 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 52,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 4 * s,
                        width: 40 * s,
                        color: _brown,
                      ),
                      SizedBox(height: 8 * s),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10 * s),
                        child: SizedBox(
                          height: ctx.height * 0.22,
                          width: double.infinity,
                          child: main != null && main.isNotEmpty
                              ? codeListingImage(ctx, main, borderRadius: 10 * s)
                              : ColoredBox(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8 * s),
                Expanded(
                  flex: 40,
                  child: ColoredBox(
                    color: _brown,
                    child: Padding(
                      padding: EdgeInsets.all(6 * s),
                      child: Column(
                        children: [
                          Expanded(child: _stripInner(ctx, pickGalleryUrl(ctx, 1) ?? main)),
                          SizedBox(height: 4 * s),
                          Expanded(child: _stripInner(ctx, pickGalleryUrl(ctx, 2) ?? main)),
                          SizedBox(height: 4 * s),
                          Expanded(child: _stripInner(ctx, pickGalleryUrl(ctx, 3) ?? main)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10 * s),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 52,
                    child: Wrap(
                      spacing: 8 * s,
                      runSpacing: 8 * s,
                      children: [
                        _feat(Icons.king_bed_outlined, s),
                        _feat(Icons.bathtub_outlined, s),
                        _feat(Icons.park_rounded, s),
                        _feat(Icons.directions_car_filled_outlined, s),
                        _feat(Icons.pool_rounded, s),
                        _feat(Icons.forest_rounded, s),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 44,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone_in_talk_outlined, size: 16 * s, color: _brown),
                            SizedBox(width: 6 * s),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ctx.data.agentPhone ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9 * s)),
                                  if ((ctx.data.agentEmail ?? '').trim().isNotEmpty)
                                    Text(
                                      ctx.data.agentEmail!.trim(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 8 * s, color: Colors.black54),
                                    ),
                                  Text(ctx.data.agentName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9 * s)),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6 * s),
                              child: SizedBox(
                                width: 36 * s,
                                height: 36 * s,
                                child: ctx.data.agentAvatarUrl != null && ctx.data.agentAvatarUrl!.isNotEmpty
                                    ? Image.network(
                                        ctx.data.agentAvatarUrl!,
                                        fit: BoxFit.cover,
                                        width: 36 * s,
                                        height: 36 * s,
                                        errorBuilder: (_, _, _) => ColoredBox(color: Colors.white),
                                      )
                                    : ColoredBox(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        codeFeaturesCaption(ctx, fontSize: 9.5, color: _brown, align: TextAlign.end),
                        SizedBox(height: 4 * s),
                        codeDescriptionBlock(ctx, maxLines: 3, fontSize: 8.8, color: Colors.black54, align: TextAlign.end),
                        SizedBox(height: 6 * s),
                        Text(ctx.data.title, maxLines: 2, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12 * s)),
                        Text(ctx.data.priceLine, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14 * s, color: _brown)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stripInner(CodeShareCardContext c, String? u) {
    if (u == null || u.isEmpty) {
      return ColoredBox(color: Colors.white12);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(6 * c.scale),
      child: codeListingImage(c, u, borderRadius: 6 * c.scale),
    );
  }

  Widget _feat(IconData d, double s) {
    return Container(
      width: 36 * s,
      height: 36 * s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * s),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade300],
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3 * s, offset: Offset(0, 2 * s))],
      ),
      child: Icon(d, color: _brown, size: 18 * s),
    );
  }
}
