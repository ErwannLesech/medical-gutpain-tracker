import 'package:flutter/material.dart';
import 'colors.dart';

/// Thèmes de l'application WakyGut
class WakyTheme {
  WakyTheme._();

  // ==================== THÈME K-POP CLAIR ====================

  static ThemeData get kpopLight => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Couleurs
    colorScheme: ColorScheme.light(
      primary: WakyColors.primary,
      primaryContainer: WakyColors.primaryLight,
      secondary: WakyColors.accent,
      secondaryContainer: WakyColors.accentLight,
      tertiary: WakyColors.electric,
      surface: WakyColors.surfaceLight,
      error: WakyColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: WakyColors.textPrimaryLight,
      onError: Colors.white,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: WakyColors.backgroundLight,
    
    // AppBar
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: WakyColors.textPrimaryLight,
      titleTextStyle: TextStyle(
        // fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: WakyColors.textPrimaryLight,
      ),
    ),
    
    // Cards
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: WakyColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: WakyColors.cardLight,
    ),
    
    // Boutons élevés
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Boutons texte
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    // Boutons outline
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: WakyColors.primary, width: 2),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: WakyColors.accent,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    
    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: WakyColors.primaryLight.withValues(alpha: 0.2),
      selectedColor: WakyColors.primary,
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WakyColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: WakyColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: WakyColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(fontFamily: 'Poppins'),
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        color: WakyColors.textHintLight,
      ),
    ),
    
    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: WakyColors.surfaceLight,
      selectedItemColor: WakyColors.primary,
      unselectedItemColor: WakyColors.textSecondaryLight,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
      ),
    ),
    
    // Slider
    sliderTheme: SliderThemeData(
      activeTrackColor: WakyColors.primary,
      inactiveTrackColor: WakyColors.primaryLight.withValues(alpha: 0.3),
      thumbColor: WakyColors.primary,
      overlayColor: WakyColors.primary.withValues(alpha: 0.2),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
    ),
    
    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: WakyColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: WakyColors.textPrimaryLight,
      ),
    ),
    
    // SnackBar
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: WakyColors.textPrimaryLight,
    ),
    
    // Typography
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: 'Poppins'),
      bodyMedium: TextStyle(fontFamily: 'Poppins'),
      bodySmall: TextStyle(fontFamily: 'Poppins'),
      labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontFamily: 'Poppins'),
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 1,
      space: 1,
    ),
  );

  // ==================== THÈME K-POP SOMBRE ====================

  static ThemeData get kpopDark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: ColorScheme.dark(
      primary: WakyColors.primaryLight,
      primaryContainer: WakyColors.primaryDark,
      secondary: WakyColors.accentLight,
      secondaryContainer: WakyColors.accent,
      tertiary: WakyColors.electricLight,
      surface: WakyColors.surfaceDark,
      error: WakyColors.errorLight,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: WakyColors.textPrimaryDark,
      onError: Colors.black,
    ),
    
    scaffoldBackgroundColor: WakyColors.backgroundDark,
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: WakyColors.textPrimaryDark,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: WakyColors.textPrimaryDark,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: WakyColors.cardDark,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: WakyColors.accentLight,
      foregroundColor: Colors.black,
      shape: CircleBorder(),
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: WakyColors.primaryDark.withValues(alpha: 0.3),
      selectedColor: WakyColors.primaryLight,
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: WakyColors.textPrimaryDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WakyColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: WakyColors.primaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: WakyColors.surfaceDark,
      selectedItemColor: WakyColors.primaryLight,
      unselectedItemColor: WakyColors.textSecondaryDark,
      showUnselectedLabels: true,
    ),
    
    sliderTheme: SliderThemeData(
      activeTrackColor: WakyColors.primaryLight,
      inactiveTrackColor: WakyColors.primaryDark.withValues(alpha: 0.3),
      thumbColor: WakyColors.primaryLight,
      overlayColor: WakyColors.primaryLight.withValues(alpha: 0.2),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
    ),
    
    dialogTheme: DialogThemeData(
      backgroundColor: WakyColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: 'Poppins'),
      bodyMedium: TextStyle(fontFamily: 'Poppins'),
      bodySmall: TextStyle(fontFamily: 'Poppins'),
      labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontFamily: 'Poppins'),
    ),
  );

  // ==================== THÈME SOBRE CLAIR ====================

  static ThemeData get soberLight => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    colorScheme: ColorScheme.light(
      primary: WakyColors.medicalBlue,
      primaryContainer: WakyColors.medicalBlueLight,
      secondary: WakyColors.medicalGray,
      surface: WakyColors.surfaceLight,
      error: WakyColors.error,
    ),
    
    scaffoldBackgroundColor: WakyColors.backgroundLight,
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: WakyColors.textPrimaryLight,
    ),
    
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: WakyColors.cardLight,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      backgroundColor: WakyColors.medicalBlue,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: WakyColors.surfaceLight,
      selectedItemColor: WakyColors.medicalBlue,
      unselectedItemColor: WakyColors.textSecondaryLight,
      showUnselectedLabels: true,
    ),
  );

  // ==================== THÈME SOBRE SOMBRE ====================

  static ThemeData get soberDark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: ColorScheme.dark(
      primary: WakyColors.medicalBlueLight,
      primaryContainer: WakyColors.medicalBlueDark,
      secondary: WakyColors.medicalGray,
      surface: WakyColors.surfaceDark,
      error: WakyColors.errorLight,
    ),
    
    scaffoldBackgroundColor: WakyColors.backgroundDark,
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: WakyColors.textPrimaryDark,
    ),
    
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: WakyColors.cardDark,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      backgroundColor: WakyColors.medicalBlueLight,
      foregroundColor: Colors.black,
      shape: CircleBorder(),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: WakyColors.surfaceDark,
      selectedItemColor: WakyColors.medicalBlueLight,
      unselectedItemColor: WakyColors.textSecondaryDark,
      showUnselectedLabels: true,
    ),
  );
}
