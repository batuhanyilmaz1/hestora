import 'package:flutter/material.dart';

import 'code_share_card_bits.dart';
import 'code_share_card_context.dart';

/// Tema 11 — yatay: sol beyaz panel (köşe bordo + avatar + başlık/fiyat),
/// sağ sütunda emlakçı iletişim kartları, tam alan ilan görseli, ortada ikon şeridi.
class Theme11ShareCard extends StatelessWidget {
  const Theme11ShareCard({super.key, required this.ctx});

  final CodeShareCardContext ctx;

  static const _wine = Color(0xFF6D1F2A);
  static const _sand = Color(0xFFE8D8C5);

  @override
  Widget build(BuildContext context) {
    final s = ctx.scale;
    final main = ctx.data.effectiveMainImageUrl;
    final cardR = 18.0 * s;

    return ClipRRect(
      borderRadius: BorderRadius.circular(cardR),
      child: ColoredBox(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 34,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: ctx.width * 0.14,
                      height: ctx.height * 0.22,
                      decoration: const BoxDecoration(
                        color: _wine,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(28)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10 * s, 14 * s, 8 * s, 12 * s),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 56 * s,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 4 * s,
                                child: codeAgentAvatar(ctx, diameter: 52 * s),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(height: 2.5 * s, color: _sand),
                        SizedBox(height: 8 * s),
                        Text(
                          ctx.data.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _wine, fontSize: 11 * s, fontWeight: FontWeight.w800, height: 1.15),
                        ),
                        SizedBox(height: 4 * s),
                        Text(
                          ctx.data.priceLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87, fontSize: 13 * s, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 6 * s),
                        codeFeaturesCaption(ctx, fontSize: 8.8, color: _wine, align: TextAlign.center, maxLines: 3),
                        if ((ctx.data.locationLine ?? '').trim().isNotEmpty) ...[
                          SizedBox(height: 4 * s),
                          Text(
                            ctx.data.locationLine!.trim(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black54, fontSize: 8.5 * s),
                          ),
                        ],
                        SizedBox(height: 4 * s),
                        codeDescriptionBlock(ctx, maxLines: 3, fontSize: 8.2, color: Colors.black54, align: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 66,
              child: Container(
                margin: EdgeInsets.only(left: 4 * s, top: 6 * s, right: 6 * s, bottom: 6 * s),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: _wine, width: 2)),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(cardR * 0.6),
                    bottomRight: Radius.circular(cardR * 0.6),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(6 * s, 6 * s, 6 * s, 4 * s),
                      child: Column(
                        children: [
                          _agentContactCard(ctx, s),
                          SizedBox(height: 4 * s),
                          _agentContactCard(ctx, s),
                          SizedBox(height: 4 * s),
                          _agentContactCard(ctx, s),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8 * s),
                            child: main != null && main.isNotEmpty
                                ? codeListingImage(ctx, main, borderRadius: 8 * s)
                                : ColoredBox(color: Colors.grey.shade200),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 10 * s,
                            child: Center(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: _sand,
                                  borderRadius: BorderRadius.circular(22 * s),
                                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6 * s)],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 7 * s),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _pillIcon(Icons.king_bed_outlined, s),
                                      SizedBox(width: 8 * s),
                                      _pillIcon(Icons.bathtub_outlined, s),
                                      SizedBox(width: 8 * s),
                                      _pillIcon(Icons.directions_car_filled_outlined, s),
                                      SizedBox(width: 8 * s),
                                      _pillIcon(Icons.straighten_rounded, s),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  /// Siyah emlakçı kartı: avatar + telefon + e-posta + küçük logo.
  Widget _agentContactCard(CodeShareCardContext c, double s) {
    final phone = (c.data.agentPhone ?? '').trim();
    final email = (c.data.agentEmail ?? '').trim();
    final name = (c.data.agentName ?? '').trim();
    final avatar = c.data.agentAvatarUrl?.trim() ?? '';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 6 * s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 32 * s,
                height: 32 * s,
                child: avatar.isNotEmpty
                    ? Image.network(avatar, fit: BoxFit.cover, errorBuilder: (_, _, _) => _avatarFallback(s))
                    : _avatarFallback(s),
              ),
            ),
            SizedBox(width: 8 * s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (phone.isNotEmpty)
                    Text(
                      phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 10 * s, fontWeight: FontWeight.w700),
                    )
                  else if (name.isNotEmpty)
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 10 * s, fontWeight: FontWeight.w700),
                    ),
                  if (email.isNotEmpty) ...[
                    SizedBox(height: 2 * s),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 8.5 * s, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.apartment_rounded, color: Colors.white38, size: 18 * s),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(double s) {
    return ColoredBox(
      color: Colors.white24,
      child: Icon(Icons.person_outline_rounded, color: Colors.white54, size: 18 * s),
    );
  }

  Widget _pillIcon(IconData d, double s) {
    return Container(
      padding: EdgeInsets.all(6 * s),
      decoration: const BoxDecoration(color: _wine, shape: BoxShape.circle),
      child: Icon(d, color: Colors.white, size: 14 * s),
    );
  }
}
