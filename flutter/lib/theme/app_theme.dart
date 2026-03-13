import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFF8F6A32),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD1B17A),
    onPrimaryContainer: Color(0xFF3A2604),

    secondary: Color(0xFF7D6E5A),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE6D8C0),
    onSecondaryContainer: Color(0xFF3B2F1E),

    tertiary: Color(0xFF4C6F4F),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFA8C5A8),
    onTertiaryContainer: Color(0xFF0F2B12),

    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    surface: Color(0xFFF5F1EA),
    onSurface: Color(0xFF1C1B18),

    surfaceDim: Color(0xFFE6E1DA),
    surfaceBright: Color(0xFFFCF8F1),

    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF7F3EC),
    surfaceContainer: Color(0xFFF1ECE5),
    surfaceContainerHigh: Color(0xFFEBE6DF),
    surfaceContainerHighest: Color(0xFFE3DFD7),

    onSurfaceVariant: Color(0xFF4A473F),

    outline: Color(0xFF8F8C86),
    outlineVariant: Color(0xFFC9C5BD),

    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFF31302D),
    onInverseSurface: Color(0xFFF4F0E9),
    inversePrimary: Color(0xFFD1B17A),

    surfaceTint: Color(0xFFD1B17A),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFFE7C892),
    onPrimary: Color(0xFF4F3A12),
    primaryContainer: Color(0xFF6A4F20),
    onPrimaryContainer: Color(0xFFFFDEA8),

    secondary: Color(0xFFD1C3AC),
    onSecondary: Color(0xFF493C2B),
    secondaryContainer: Color(0xFF615240),
    onSecondaryContainer: Color(0xFFEEDFC7),

    tertiary: Color(0xFFB3D1B1),
    onTertiary: Color(0xFF1E3922),
    tertiaryContainer: Color(0xFF355338),
    onTertiaryContainer: Color(0xFFCEECCA),

    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    surface: Color(0xFF141310),
    onSurface: Color(0xFFE7E2DB),

    surfaceDim: Color(0xFF141310),
    surfaceBright: Color(0xFF3A3835),

    surfaceContainerLowest: Color(0xFF0F0E0C),
    surfaceContainerLow: Color(0xFF1C1B18),
    surfaceContainer: Color(0xFF201F1C),
    surfaceContainerHigh: Color(0xFF2B2927),
    surfaceContainerHighest: Color(0xFF4A473F),

    onSurfaceVariant: Color(0xFFCAC5BC),

    outline: Color(0xFF948F88),
    outlineVariant: Color(0xFF4A473F),

    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFFE7E2DB),
    onInverseSurface: Color(0xFF31302C),
    inversePrimary: Color(0xFF8F6A32),

    surfaceTint: Color(0xFFE7C892),
  );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: lightColorScheme.surface,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: darkColorScheme.surface,
      );
}
