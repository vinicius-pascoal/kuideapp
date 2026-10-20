import 'package:flutter/material.dart';

import 'app_buttons.dart';

class MockActionDialog extends StatelessWidget {
  const MockActionDialog({
    required this.title,
    required this.message,
    super.key,
    this.confirmLabel = 'Entendi',
    this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback? onConfirm;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Entendi',
  }) => showDialog<void>(
    context: context,
    builder: (context) => MockActionDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      onConfirm: () => Navigator.of(context).pop(),
    ),
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          SizedBox(
            width: 150,
            child: PrimaryButton(label: confirmLabel, onPressed: onConfirm),
          ),
        ],
      );
}
