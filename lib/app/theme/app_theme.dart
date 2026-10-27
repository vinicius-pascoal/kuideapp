import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.wine,
      onPrimary: AppColors.white,
      secondary: AppColors.wineText,
      onSecondary: AppColors.white,
      surface: AppColors.cream,
      onSurface: AppColors.darkText,
      surfaceContainerHighest: AppColors.lightCream,
      outline: AppColors.cardBorder,
      error: AppColors.error,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: AppTypography.textTheme,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.formField,
      contentPadding: EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      labelStyle: TextStyle(color: AppColors.wineText, fontSize: 18),
      hintStyle: TextStyle(color: AppColors.wineText, fontSize: 18),
      floatingLabelStyle: TextStyle(color: AppColors.wineText),
      border: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.formFieldBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.formFieldBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.wine, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadii.field,
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.wine,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
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
