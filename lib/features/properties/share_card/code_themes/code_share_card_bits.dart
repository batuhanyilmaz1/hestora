import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/share_card_main_image.dart';
import 'code_share_card_context.dart';

/// Basit gökyüzü + tepeler (PNG yerine).
class CodeShareSkyHillsLayer extends StatelessWidget {
  const CodeShareSkyHillsLayer({super.key, this.skyBottomFraction = 0.62});

  final double skyBottomFraction;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SkyHillsPainter(skyBottomFraction: skyBottomFraction),
      size: Size.infinite,
    );
  }
}

class _SkyHillsPainter extends CustomPainter {
  _SkyHillsPainter({required this.skyBottomFraction});

  final double skyBottomFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height * skyBottomFraction;
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, h), sky);

    final hill1 = Path()
      ..moveTo(0, h)
      ..quadraticBezierTo(size.width * 0.25, h - size.height * 0.12, size.width * 0.5, h - size.height * 0.06)
      ..quadraticBezierTo(size.width * 0.75, h, size.width, h - size.height * 0.04)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill1, Paint()..color = const Color(0xFF9CCC65));
    final hill2 = Path()
      ..moveTo(0, h + 6)
      ..quadraticBezierTo(size.width * 0.35, h - size.height * 0.05, size.width, h + 10)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill2, Paint()..color = const Color(0xFF689F38));
  }

  @override
  bool shouldRepaint(covariant _SkyHillsPainter oldDelegate) =>
      oldDelegate.skyBottomFraction != skyBottomFraction;
}

Widget codeListingImage(
  CodeShareCardContext c,
  String url, {
  required double borderRadius,
  BoxFit fit = BoxFit.cover,
}) {
  return ShareCardMainImage(
    url: url,
    theme: c.theme,
    alignment: c.listingImageAlignment,
    cornerRadius: borderRadius,
    scale: c.scale,
  );
}

Widget codeGalleryThumb(
  CodeShareCardContext c,
  String url, {
  required double size,
  double radius = 8,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius * c.scale),
    child: SizedBox(
      width: size,
      height: size,
      child: ShareCardMainImage(
        url: url,
        theme: c.theme,
        alignment: Alignment.center,
        cornerRadius: radius * c.scale,
        scale: c.scale,
      ),
    ),
  );
}

Widget codeQrOrUrl(CodeShareCardContext c, {double maxSide = 72}) {
  final payload = c.data.qrPayload?.trim() ?? '';
  if (payload.isNotEmpty) {
    final side = maxSide * c.scale;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6 * c.scale),
      ),
      child: Padding(
        padding: EdgeInsets.all(3 * c.scale),
        child: SizedBox(
          width: side,
          height: side,
          child: QrImageView(data: payload, version: QrVersions.auto, gapless: true),
        ),
      ),
    );
  }
  final web = c.data.websiteFallbackLine?.trim() ?? '';
  if (web.isEmpty) {
    return const SizedBox.shrink();
  }
  return Text(
    web,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    style: c.withShadow(
      TextStyle(
        color: c.theme.subtitleColor,
        fontSize: 9 * c.scale,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

List<String> galleryUrls(CodeShareCardContext c) => c.data.normalizedListingImageUrls;

String? pickGalleryUrl(CodeShareCardContext c, int index) {
  final urls = galleryUrls(c);
  if (urls.isEmpty) {
    return null;
  }
  if (index < urls.length) {
    return urls[index];
  }
  return urls[index % urls.length];
}

Widget codeAgentAvatar(CodeShareCardContext c, {required double diameter}) {
  final u = c.data.agentAvatarUrl?.trim() ?? '';
  if (u.isEmpty) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
      child: Icon(Icons.person_outline_rounded, size: diameter * 0.45, color: c.theme.subtitleColor),
    );
  }
  return ClipOval(
    child: SizedBox(
      width: diameter,
      height: diameter,
      child: Image.network(
        u,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Icon(Icons.person_outline_rounded, color: c.theme.subtitleColor),
      ),
    ),
  );
}

Row codeFeatureIconRow(CodeShareCardContext c) {
  final s = 18 * c.scale;
  Widget icon(IconData d) => Icon(d, size: s, color: Colors.white);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      icon(Icons.king_bed_outlined),
      icon(Icons.bathtub_outlined),
      icon(Icons.directions_car_filled_outlined),
      icon(Icons.weekend_outlined),
    ],
  );
}

double rScale(CodeShareCardContext c, double v) => v * c.scale;

EdgeInsets padScale(CodeShareCardContext c, double h, [double? v]) =>
    EdgeInsets.symmetric(horizontal: h * c.scale, vertical: (v ?? h) * c.scale);

double minSide(CodeShareCardContext c) => math.min(c.width, c.height);

/// Oda / banyo / m² metni (ikon altı veya ince bant).
Widget codeFeaturesCaption(
  CodeShareCardContext c, {
  double fontSize = 9,
  Color? color,
  TextAlign align = TextAlign.center,
  int maxLines = 2,
}) {
  final t = c.data.featuresLine.trim();
  if (t.isEmpty || t == '—') {
    return const SizedBox.shrink();
  }
  return Text(
    t,
    maxLines: maxLines,
    textAlign: align,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: color ?? Colors.black87,
      fontSize: fontSize * c.scale,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
  );
}

/// İlan açıklaması (boşsa hiç yer kaplamaz).
Widget codeDescriptionBlock(
  CodeShareCardContext c, {
  int maxLines = 4,
  double fontSize = 9.5,
  Color? color,
  TextAlign align = TextAlign.start,
}) {
  final t = c.data.description?.trim() ?? '';
  if (t.isEmpty) {
    return const SizedBox.shrink();
  }
  return Text(
    t,
    maxLines: maxLines,
    textAlign: align,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: color ?? Colors.black54,
      fontSize: fontSize * c.scale,
      height: 1.25,
    ),
  );
}
