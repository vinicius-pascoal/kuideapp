import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle!),
          leading: leading,
          trailing: trailing,
          onTap: onTap,
        ),
      );
}
