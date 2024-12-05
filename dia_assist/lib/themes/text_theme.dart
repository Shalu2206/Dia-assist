import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors_theme.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextTheme get lightTextTheme => TextTheme(
      displaySmall: _headline1,
      displayMedium: _headline2,
      displayLarge: _headline3,
      headlineMedium: _headline4,
      headlineLarge: _headline5,
      headlineSmall: text,
      titleMedium: _headline7,
      titleLarge: textmajor
  );

  // Directly use GoogleFonts.openSans for the style
  static TextStyle get _headline1 => GoogleFonts.openSans(
      fontSize:12,
      fontWeight: FontWeight.w400,
      color: AppColors.secondary
  );
  static TextStyle get _headline7 => GoogleFonts.openSans(
      fontSize:15,
      fontWeight: FontWeight.w300,
      color:AppColors.secondary
  );

  static TextStyle get _headline2 => GoogleFonts.openSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.secondary
  );

  static TextStyle get _headline3 => GoogleFonts.openSans(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color:AppColors.textPrimary
  );

  static TextStyle get _headline4 => GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary
  );
  static TextStyle get _headline5 => GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color:AppColors.background
  );

  static TextStyle get text => GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color:AppColors.secondary
  );
  static TextStyle get textmajor => GoogleFonts.openSans(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color:AppColors.textPrimary
  );

}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      textTheme: AppTextStyle.lightTextTheme,
    );
  }
}
