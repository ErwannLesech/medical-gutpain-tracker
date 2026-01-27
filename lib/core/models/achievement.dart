import 'package:isar/isar.dart';

part 'achievement.g.dart';

/// Type de badge
enum BadgeType {
  /// Badges de streak (jours consécutifs)
  streak3,
  streak7,
  streak14,
  streak30,
  streak60,
  streak100,
  
  /// Badges de régularité journal
  journal10,
  journal30,
  journal60,
  journal100,
  
  /// Badges de repas
  meals50,
  meals100,
  meals250,
  meals500,
  
  /// Badges de suivi douleur
  painTracking7,
  painTracking30,
  painTracking60,
  
  /// Badges spéciaux
  firstWeek,
  firstMonth,
  consistent,
  explorer,
  champion,
}

/// Extension pour obtenir les détails d'un badge
extension BadgeTypeExtension on BadgeType {
  String get title {
    switch (this) {
      case BadgeType.streak3:
        return '3 jours d\'affilée';
      case BadgeType.streak7:
        return '1 semaine de suivi';
      case BadgeType.streak14:
        return '2 semaines consécutives';
      case BadgeType.streak30:
        return '1 mois complet';
      case BadgeType.streak60:
        return '2 mois de détermination';
      case BadgeType.streak100:
        return '100 jours de légende';
      case BadgeType.journal10:
        return '10 journaux';
      case BadgeType.journal30:
        return '30 journaux';
      case BadgeType.journal60:
        return '60 journaux';
      case BadgeType.journal100:
        return '100 journaux';
      case BadgeType.meals50:
        return '50 repas suivis';
      case BadgeType.meals100:
        return '100 repas';
      case BadgeType.meals250:
        return '250 repas';
      case BadgeType.meals500:
        return '500 repas';
      case BadgeType.painTracking7:
        return 'Suivi douleur - 1 semaine';
      case BadgeType.painTracking30:
        return 'Suivi douleur - 1 mois';
      case BadgeType.painTracking60:
        return 'Suivi douleur - 2 mois';
      case BadgeType.firstWeek:
        return 'Première semaine';
      case BadgeType.firstMonth:
        return 'Premier mois';
      case BadgeType.consistent:
        return 'Régulier·ère';
      case BadgeType.explorer:
        return 'Explorateur·rice';
      case BadgeType.champion:
        return 'Champion·ne';
    }
  }

  String get description {
    switch (this) {
      case BadgeType.streak3:
        return 'Rempli ton journal 3 jours de suite';
      case BadgeType.streak7:
        return 'Une semaine complète de suivi !';
      case BadgeType.streak14:
        return 'Deux semaines sans interruption';
      case BadgeType.streak30:
        return 'Un mois entier de suivi quotidien';
      case BadgeType.streak60:
        return 'Deux mois de détermination';
      case BadgeType.streak100:
        return 'Cent jours consécutifs, incroyable !';
      case BadgeType.journal10:
        return 'Tu as rempli 10 journaux';
      case BadgeType.journal30:
        return 'Tu as rempli 30 journaux';
      case BadgeType.journal60:
        return 'Tu as rempli 60 journaux';
      case BadgeType.journal100:
        return 'Tu as rempli 100 journaux !';
      case BadgeType.meals50:
        return 'Tu as suivi 50 repas';
      case BadgeType.meals100:
        return 'Tu as suivi 100 repas';
      case BadgeType.meals250:
        return 'Tu as suivi 250 repas';
      case BadgeType.meals500:
        return 'Tu as suivi 500 repas !';
      case BadgeType.painTracking7:
        return 'Une semaine de suivi de douleurs';
      case BadgeType.painTracking30:
        return 'Un mois de suivi de douleurs';
      case BadgeType.painTracking60:
        return 'Deux mois de suivi de douleurs';
      case BadgeType.firstWeek:
        return 'Bienvenue ! Ta première semaine';
      case BadgeType.firstMonth:
        return 'Un mois avec WakyGut !';
      case BadgeType.consistent:
        return '80% de remplissage sur un mois';
      case BadgeType.explorer:
        return 'Tu as exploré toutes les fonctionnalités';
      case BadgeType.champion:
        return 'Maître du suivi !';
    }
  }

  String get emoji {
    switch (this) {
      case BadgeType.streak3:
        return '🔥';
      case BadgeType.streak7:
        return '⭐';
      case BadgeType.streak14:
        return '🌟';
      case BadgeType.streak30:
        return '💫';
      case BadgeType.streak60:
        return '✨';
      case BadgeType.streak100:
        return '🏆';
      case BadgeType.journal10:
        return '📝';
      case BadgeType.journal30:
        return '📚';
      case BadgeType.journal60:
        return '📖';
      case BadgeType.journal100:
        return '📘';
      case BadgeType.meals50:
        return '🍽️';
      case BadgeType.meals100:
        return '🍴';
      case BadgeType.meals250:
        return '👨‍🍳';
      case BadgeType.meals500:
        return '🌟';
      case BadgeType.painTracking7:
        return '💊';
      case BadgeType.painTracking30:
        return '🏥';
      case BadgeType.painTracking60:
        return '❤️';
      case BadgeType.firstWeek:
        return '🎉';
      case BadgeType.firstMonth:
        return '🎊';
      case BadgeType.consistent:
        return '🎯';
      case BadgeType.explorer:
        return '🧭';
      case BadgeType.champion:
        return '👑';
    }
  }

  int get rarity {
    // 1 = commun, 2 = rare, 3 = épique, 4 = légendaire
    switch (this) {
      case BadgeType.streak3:
      case BadgeType.firstWeek:
      case BadgeType.journal10:
        return 1;
      case BadgeType.streak7:
      case BadgeType.journal30:
      case BadgeType.meals50:
      case BadgeType.painTracking7:
        return 2;
      case BadgeType.streak14:
      case BadgeType.streak30:
      case BadgeType.journal60:
      case BadgeType.meals100:
      case BadgeType.firstMonth:
      case BadgeType.painTracking30:
      case BadgeType.consistent:
        return 3;
      case BadgeType.streak60:
      case BadgeType.streak100:
      case BadgeType.journal100:
      case BadgeType.meals250:
      case BadgeType.meals500:
      case BadgeType.painTracking60:
      case BadgeType.explorer:
      case BadgeType.champion:
        return 4;
    }
  }
}

/// Modèle pour un achievement débloqué
@collection
class Achievement {
  Id id = Isar.autoIncrement;

  /// Type de badge
  @enumerated
  late BadgeType badgeType;

  /// Date de déverrouillage
  late DateTime unlockedAt;

  /// Vu par l'utilisateur
  late bool seen;

  Achievement();
}
