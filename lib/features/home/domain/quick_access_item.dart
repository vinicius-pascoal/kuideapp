import 'package:flutter/material.dart';

class QuickAccessItem {
  const QuickAccessItem({
    required this.label,
    required this.description,
    required this.icon,
    required this.route,
  });

  final String label;
  final String description;
  final IconData icon;
  final String route;
}
