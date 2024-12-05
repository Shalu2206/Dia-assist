import 'package:flutter/material.dart';

/// Define custom colors used throughout the app.
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF190485); // main blue color
  static const Color primaryVariant = Color(0xFFD9D9D9); // blur color

  // Secondary Colors
  static const Color secondary = Color(0xFF000000); //black
  static const Color secondaryVariant = Color(0xFFFFA000);
  static const Color blacklite = Colors.black26;
  static const Color blacktextfield = Colors.black54;

  // Background and Surface Colors
  static const Color background = Color(0xFFFFFFFF);//white
  static const Color surface = Color(0xFFF3F1FF); // text field

  // Text Colors
  static const Color textPrimary = Color(0xFF190485); //blue text
  static const Color textSecondary = Color(0xFFFF0000); //red text

  // Additional Colors
  static const Color error = Color(0xFFD32F2F);
}

/// Create a color scheme using the custom colors.
final  ColorScheme appColorScheme = ColorScheme(
  primary: AppColors.primary,
  primaryContainer: AppColors.primaryVariant,
  secondary: AppColors.secondary,
  secondaryContainer: AppColors.secondaryVariant,
  surface: AppColors.surface,
  error: AppColors.error,
  onPrimary: Colors.white, // Text on primary color
  onSecondary: Colors.black, // Text on secondary color
  onSurface: AppColors.textPrimary,
  onError: Colors.white, // Text on error color
  brightness: Brightness.light,
);
