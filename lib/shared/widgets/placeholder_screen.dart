import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
      );
}
