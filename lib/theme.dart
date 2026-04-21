import 'package:flutter/material.dart';

class SonaColors {
  // Couleurs principales
  static const primary = Color(0xFF3DBE6E);
  static const primaryDark = Color(0xFF0F6E56);
  static const primaryLight = Color(0xFFE8F5EE);
  static const primaryBorder = Color(0xFF5DCAA5);

  // Fonds
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSecondary = Color(0xFFF1F1F1);

  // Textes
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF888888);
  static const textHint = Color(0xFFB0B0B0);

  // Sémantiques
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFE53935);
  static const premium = Color(0xFFFAC775);
}

class SonaRadius {
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const full = 100.0;
}

class SonaSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class SonaText {
  static const xs = 11.0;
  static const sm = 13.0;
  static const md = 15.0;
  static const lg = 18.0;
  static const xl = 22.0;
  static const xxl = 28.0;
}

class SonaTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: SonaColors.primary,
        scaffoldBackgroundColor: SonaColors.background,
        colorScheme: const ColorScheme.light(
          primary: SonaColors.primary,
          secondary: SonaColors.primaryDark,
          surface: SonaColors.surface,
        ),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: SonaColors.surface,
          foregroundColor: SonaColors.primaryDark,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: SonaColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SonaRadius.lg),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? SonaColors.primary
                : Colors.transparent,
          ),
        ),
      );
}
