import 'package:flutter/material.dart';

import '../models/share_card_layout_data.dart';
import '../models/share_card_theme_definition.dart';
import 'code_share_card_context.dart';
import 'theme_01_share_card.dart';
import 'theme_02_share_card.dart';
import 'theme_03_share_card.dart';
import 'theme_04_share_card.dart';
import 'theme_05_share_card.dart';
import 'theme_06_share_card.dart';
import 'theme_07_share_card.dart';
import 'theme_08_share_card.dart';
import 'theme_09_share_card.dart';
import 'theme_10_share_card.dart';
import 'theme_11_share_card.dart';
import 'theme_12_share_card.dart';
import 'theme_13_share_card.dart';
import 'theme_14_share_card.dart';
import 'theme_15_share_card.dart';

/// `theme_01` … `theme_15` için saf Flutter kartı üretir.
Widget buildFlutterCodeShareCard({
  required ShareCardThemeDefinition theme,
  required ShareCardLayoutData data,
  required double width,
  required double height,
  required Alignment listingImageAlignment,
}) {
  final ctx = CodeShareCardContext(
    theme: theme,
    data: data,
    width: width,
    height: height,
    listingImageAlignment: listingImageAlignment,
  );
  switch (theme.id) {
    case 'theme_01':
      return Theme01ShareCard(ctx: ctx);
    case 'theme_02':
      return Theme02ShareCard(ctx: ctx);
    case 'theme_03':
      return Theme03ShareCard(ctx: ctx);
    case 'theme_04':
      return Theme04ShareCard(ctx: ctx);
    case 'theme_05':
      return Theme05ShareCard(ctx: ctx);
    case 'theme_06':
      return Theme06ShareCard(ctx: ctx);
    case 'theme_07':
      return Theme07ShareCard(ctx: ctx);
    case 'theme_08':
      return Theme08ShareCard(ctx: ctx);
    case 'theme_09':
      return Theme09ShareCard(ctx: ctx);
    case 'theme_10':
      return Theme10ShareCard(ctx: ctx);
    case 'theme_11':
      return Theme11ShareCard(ctx: ctx);
    case 'theme_12':
      return Theme12ShareCard(ctx: ctx);
    case 'theme_13':
      return Theme13ShareCard(ctx: ctx);
    case 'theme_14':
      return Theme14ShareCard(ctx: ctx);
    case 'theme_15':
      return Theme15ShareCard(ctx: ctx);
    default:
      throw ArgumentError('Not a Flutter code theme: ${theme.id}');
  }
}
