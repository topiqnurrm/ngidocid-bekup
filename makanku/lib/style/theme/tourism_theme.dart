// lib/style/theme/tourism_theme.dart
import 'package:flutter/material.dart';
import '../typography/tourism_text_styles.dart';
import '../colors/tourism_colors.dart';

class TourismTheme {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: TourismTextStyles.displayLarge,
      displayMedium: TourismTextStyles.displayMedium,
      displaySmall: TourismTextStyles.displaySmall,
      headlineLarge: TourismTextStyles.headlineLarge,
      headlineMedium: TourismTextStyles.headlineMedium,
      headlineSmall: TourismTextStyles.headlineSmall,
      titleLarge: TourismTextStyles.titleLarge,
      titleMedium: TourismTextStyles.titleMedium,
      titleSmall: TourismTextStyles.titleSmall,
      bodyLarge: TourismTextStyles.bodyLargeBold,
      bodyMedium: TourismTextStyles.bodyLargeMedium,
      bodySmall: TourismTextStyles.bodyLargeRegular,
      labelLarge: TourismTextStyles.labelLarge,
      labelMedium: TourismTextStyles.labelMedium,
      labelSmall: TourismTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      backgroundColor: TourismColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: TourismColors.primary,
        onPrimary: Colors.white,
        secondary: TourismColors.secondary,
        onSecondary: Colors.white,
        error: TourismColors.error,
        onError: Colors.white,
        background: TourismColors.backgroundLight,
        onBackground: TourismColors.textPrimaryLight,
        surface: TourismColors.surfaceLight,
        onSurface: TourismColors.textPrimaryLight,
      ),
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: TourismColors.primaryDark,
        onPrimary: Colors.white,
        secondary: TourismColors.secondaryDark,
        onSecondary: Colors.black,
        error: TourismColors.error,
        onError: Colors.black,
        background: TourismColors.backgroundDark,
        onBackground: TourismColors.textPrimaryDark,
        surface: TourismColors.surfaceDark,
        onSurface: TourismColors.textPrimaryDark,
      ),
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}
