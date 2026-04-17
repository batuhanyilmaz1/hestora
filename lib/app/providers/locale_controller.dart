import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `null` = [MaterialApp] uses cihaz / [localeListResolutionCallback] (desteklenen dil).
/// Profilden veya kullanıcı seçiminden sonra TR/EN/AR’ye sabitlenebilir.
final localeOverrideProvider = StateProvider<Locale?>((ref) => null);
