import 'package:flutter/material.dart';

/// CiCwtch app theme
///
/// This keeps Material 3 enabled and applies a custom brand colour palette
/// through Flutter's intended theming system.
///
/// Use:
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   themeMode: ThemeMode.system,
class AppTheme {
  const AppTheme._();

  // Brand seed/reference colours from your palette
  static const Color cariadTan = Color(0xFFD1B17A); // Primary
  static const Color hwyl = Color(0xFFE6D8C0); // Secondary
  static const Color yGofidGwyllt = Color(0xFF4C6F4F); // Tertiary
  static const Color glan = Color(0xFFF5F1EA); // Surface / Neutral
  static const Color carreg = Color(0xFF8F8C86); // Outline / Neutral

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

    background: Color(0xFFF5F1EA),
    onBackground: Color(0xFF1C1B18),

    surface: Color(0xFFF5F1EA),
    onSurface: Color(0xFF1C1B18),

    surfaceVariant: Color(0xFFE3DFD7),
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

    background: Color(0xFF141310),
    onBackground: Color(0xFFE7E2DB),

    surface: Color(0xFF141310),
    onSurface: Color(0xFFE7E2DB),

    surfaceVariant: Color(0xFF4A473F),
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

  static ThemeData get lightTheme => _buildTheme(lightColorScheme);

  static ThemeData get darkTheme => _buildTheme(darkColorScheme);

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          );
        }),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
