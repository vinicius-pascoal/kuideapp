import 'package:flutter/material.dart';

import 'app_buttons.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.title,
    super.key,
    this.onBack,
    this.action,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (onBack != null)
            IconActionButton(
              icon: Icons.arrow_back,
              semanticLabel: 'Voltar',
              onPressed: onBack,
            )
          else
            const SizedBox(width: 48),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)),
          action ?? const SizedBox(width: 48),
        ],
      );
}
