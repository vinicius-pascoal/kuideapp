import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const card = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(3, 4),
      blurRadius: 4,
    ),
  ];
}
