import 'package:flutter/widgets.dart';

import '../theme/app_spacing.dart';

/// Vertical spacing using the design system scale.
class AppGap extends StatelessWidget {
  const AppGap({super.key, this.height = AppSpacing.md, this.width = 0});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
