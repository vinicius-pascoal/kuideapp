import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.wine,
          brightness: Brightness.light,
          surface: AppColors.cream,
        ),
        scaffoldBackgroundColor: AppColors.cream,
        textTheme: AppTypography.textTheme,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: AppRadii.field),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadii.field,
            borderSide: BorderSide(color: AppColors.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.field,
            borderSide: BorderSide(color: AppColors.wine, width: 2),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.wine,
          indicatorColor: Colors.white24,
          iconTheme: const WidgetStatePropertyAll(
            IconThemeData(color: AppColors.white),
          ),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: AppColors.white, fontSize: 11),
          ),
        ),
      );
}
