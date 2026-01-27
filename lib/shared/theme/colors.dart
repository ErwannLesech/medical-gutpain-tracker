import 'package:flutter/material.dart';

/// Couleurs du thème K-pop inspiré Stray Kids/Felix
/// Palette moderne avec des accents vibrants
class WakyColors {
  WakyColors._();

  // ==================== COULEURS PRINCIPALES K-POP ====================
  
  /// Violet principal (inspiré des lightsticks)
  static const Color primary = Color(0xFF9C27B0);
  static const Color primaryLight = Color(0xFFCE93D8);
  static const Color primaryDark = Color(0xFF7B1FA2);

  /// Rose accent (énergie K-pop)
  static const Color accent = Color(0xFFFF4081);
  static const Color accentLight = Color(0xFFFF80AB);

  /// Bleu électrique (moderne)
  static const Color electric = Color(0xFF00BCD4);
  static const Color electricLight = Color(0xFF80DEEA);

  /// Or/Jaune (Felix sunshine)
  static const Color gold = Color(0xFFFFD700);
  static const Color sunshine = Color(0xFFFFC107);

  // ==================== COULEURS SOBRES (MODE MÉDICAL) ====================

  /// Bleu médical
  static const Color medicalBlue = Color(0xFF1976D2);
  static const Color medicalBlueLight = Color(0xFF64B5F6);
  static const Color medicalBlueDark = Color(0xFF0D47A1);

  /// Gris neutre
  static const Color medicalGray = Color(0xFF607D8B);

  // ==================== COULEURS SÉMANTIQUES ====================

  /// Succès / Bon
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);

  /// Avertissement
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);

  /// Erreur / Danger
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);

  /// Information
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // ==================== COULEURS DE FOND ====================

  /// Fond clair
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Fond sombre
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);

  // ==================== COULEURS DE TEXTE ====================

  /// Texte clair
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textHintLight = Color(0xFFBDBDBD);

  /// Texte sombre
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textHintDark = Color(0xFF6E6E6E);

  // ==================== COULEURS D'INTENSITÉ DOULEUR ====================

  static const Color intensity1 = Color(0xFF4CAF50); // Légère - Vert
  static const Color intensity2 = Color(0xFF8BC34A); // Modérée - Vert clair
  static const Color intensity3 = Color(0xFFFFEB3B); // Moyenne - Jaune
  static const Color intensity4 = Color(0xFFFF9800); // Forte - Orange
  static const Color intensity5 = Color(0xFFF44336); // Intense - Rouge

  /// Retourne la couleur d'intensité
  static Color getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return intensity1;
      case 2:
        return intensity2;
      case 3:
        return intensity3;
      case 4:
        return intensity4;
      case 5:
        return intensity5;
      default:
        return Colors.grey;
    }
  }

  // ==================== COULEURS DE STATUT JOURNÉE ====================

  static const Color dayExcellent = Color(0xFF4CAF50);
  static const Color dayGood = Color(0xFF8BC34A);
  static const Color dayAverage = Color(0xFFFFEB3B);
  static const Color dayDifficult = Color(0xFFFF9800);
  static const Color dayTerrible = Color(0xFFF44336);

  // ==================== GRADIENTS ====================

  /// Gradient principal K-pop
  static const LinearGradient kpopGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient sunset (Felix vibes)
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFD93D), Color(0xFF6BCB77)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient sobre médical
  static const LinearGradient medicalGradient = LinearGradient(
    colors: [medicalBlue, medicalBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
