import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme get textTheme => TextTheme(
        displaySmall: const TextStyle(
          fontFamily: 'Source Serif Pro',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.wine,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'Source Serif Pro',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.wine,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Source Serif Pro',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.wine,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.darkText,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppColors.darkText,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.darkText,
        ),
        bodySmall: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          color: AppColors.darkText,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      );
}
