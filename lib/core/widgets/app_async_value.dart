import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Small helper for rendering [AsyncValue] states consistently.
class AppAsyncValueWidget<T> extends StatelessWidget {
  const AppAsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) data;
  final WidgetBuilder? loading;
  final Widget Function(BuildContext context, Object err, StackTrace? st)?
      error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (d) => data(context, d),
      loading: () =>
          loading?.call(context) ??
          const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) =>
          error?.call(context, e, st) ??
          Center(child: Text(e.toString(), textAlign: TextAlign.center)),
    );
  }
}
