import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Standard back row plus expanded [child] for detail pages while async data loads or errors.
class AsyncDetailFrame extends StatelessWidget {
  const AsyncDetailFrame({super.key, required this.child});

  final Widget child;

  void _pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => _pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
