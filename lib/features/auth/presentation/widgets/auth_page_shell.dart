import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_ui_constants.dart';

/// Ortak auth düzeni: gradient arka plan, üst başlık, isteğe bağlı kahraman metni, form kartı.
class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    super.key,
    required this.appBarTitle,
    required this.body,
    this.showBack = true,
    this.headline,
    this.subline,
    this.appBarSubtitle,
    this.brandHeader,
  });

  final String appBarTitle;
  final Widget body;
  final bool showBack;
  final String? headline;
  final String? subline;
  final String? appBarSubtitle;
  /// Örn. mail giriş sayfasında marka logosu.
  final Widget? brandHeader;

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && context.canPop();

    return DecoratedBox(
      decoration: AuthUi.scaffoldDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: canPop
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    color: const Color(0xFF132447),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF93C5FD),
                      ),
                    ),
                  ),
                )
              : null,
          title: Column(
            children: [
              Text(
                appBarTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              if (appBarSubtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  appBarSubtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AuthUi.subline,
                  ),
                ),
              ],
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              if (brandHeader != null) ...[
                const SizedBox(height: 4),
                Center(child: brandHeader!),
                const SizedBox(height: 16),
              ],
              if (headline != null) ...[
                const SizedBox(height: 8),
                Text(
                  headline!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                ),
              ],
              if (subline != null) ...[
                const SizedBox(height: 8),
                Text(
                  subline!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AuthUi.subline,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ],
              if (headline != null || subline != null) const SizedBox(height: 24),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
