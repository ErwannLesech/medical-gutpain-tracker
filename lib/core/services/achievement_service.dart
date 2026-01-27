import '../models/achievement.dart';
import '../database/repositories/repositories.dart';

/// Service pour gérer les achievements et leur déverrouillage
class AchievementService {
  final AchievementRepository _achievementRepo;
  final DailyReportRepository _dailyRepo;
  final MealRepository _mealRepo;
  final PainEventRepository _painRepo;

  AchievementService({
    required AchievementRepository achievementRepo,
    required DailyReportRepository dailyRepo,
    required MealRepository mealRepo,
    required PainEventRepository painRepo,
  })  : _achievementRepo = achievementRepo,
        _dailyRepo = dailyRepo,
        _mealRepo = mealRepo,
        _painRepo = painRepo;

  /// Vérifie et débloque les achievements liés aux streaks
  Future<List<BadgeType>> checkStreakAchievements(int currentStreak) async {
    final unlocked = <BadgeType>[];

    final streakBadges = {
      3: BadgeType.streak3,
      7: BadgeType.streak7,
      14: BadgeType.streak14,
      30: BadgeType.streak30,
      60: BadgeType.streak60,
      100: BadgeType.streak100,
    };

    for (final entry in streakBadges.entries) {
      if (currentStreak >= entry.key) {
        final isAlreadyUnlocked = await _achievementRepo.isUnlocked(entry.value);
        if (!isAlreadyUnlocked) {
          await _achievementRepo.unlock(entry.value);
          unlocked.add(entry.value);
        }
      }
    }

    return unlocked;
  }

  /// Vérifie et débloque les achievements liés au nombre total de journaux
  Future<List<BadgeType>> checkJournalAchievements() async {
    final unlocked = <BadgeType>[];
    final totalJournals = await _dailyRepo.getAll();
    final count = totalJournals.length;

    final journalBadges = {
      10: BadgeType.journal10,
      30: BadgeType.journal30,
      60: BadgeType.journal60,
      100: BadgeType.journal100,
    };

    for (final entry in journalBadges.entries) {
      if (count >= entry.key) {
        final isAlreadyUnlocked = await _achievementRepo.isUnlocked(entry.value);
        if (!isAlreadyUnlocked) {
          await _achievementRepo.unlock(entry.value);
          unlocked.add(entry.value);
        }
      }
    }

    return unlocked;
  }

  /// Vérifie et débloque les achievements liés aux repas
  Future<List<BadgeType>> checkMealAchievements() async {
    final unlocked = <BadgeType>[];
    final totalMeals = await _mealRepo.getAll();
    final count = totalMeals.length;

    final mealBadges = {
      50: BadgeType.meals50,
      100: BadgeType.meals100,
      250: BadgeType.meals250,
      500: BadgeType.meals500,
    };

    for (final entry in mealBadges.entries) {
      if (count >= entry.key) {
        final isAlreadyUnlocked = await _achievementRepo.isUnlocked(entry.value);
        if (!isAlreadyUnlocked) {
          await _achievementRepo.unlock(entry.value);
          unlocked.add(entry.value);
        }
      }
    }

    return unlocked;
  }

  /// Vérifie et débloque les achievements liés au suivi de douleurs
  Future<List<BadgeType>> checkPainTrackingAchievements() async {
    final unlocked = <BadgeType>[];
    final now = DateTime.now();
    
    // Vérifie sur les 7 derniers jours
    final weekStart = now.subtract(const Duration(days: 7));
    final weekEvents = await _painRepo.getByDateRange(weekStart, now);
    
    if (weekEvents.isNotEmpty) {
      final isAlreadyUnlocked = await _achievementRepo.isUnlocked(BadgeType.painTracking7);
      if (!isAlreadyUnlocked) {
        await _achievementRepo.unlock(BadgeType.painTracking7);
        unlocked.add(BadgeType.painTracking7);
      }
    }

    // Vérifie sur les 30 derniers jours
    final monthStart = now.subtract(const Duration(days: 30));
    final monthEvents = await _painRepo.getByDateRange(monthStart, now);
    
    if (monthEvents.length >= 5) {
      final isAlreadyUnlocked = await _achievementRepo.isUnlocked(BadgeType.painTracking30);
      if (!isAlreadyUnlocked) {
        await _achievementRepo.unlock(BadgeType.painTracking30);
        unlocked.add(BadgeType.painTracking30);
      }
    }

    // Vérifie sur les 60 derniers jours
    final twoMonthsStart = now.subtract(const Duration(days: 60));
    final twoMonthsEvents = await _painRepo.getByDateRange(twoMonthsStart, now);
    
    if (twoMonthsEvents.length >= 10) {
      final isAlreadyUnlocked = await _achievementRepo.isUnlocked(BadgeType.painTracking60);
      if (!isAlreadyUnlocked) {
        await _achievementRepo.unlock(BadgeType.painTracking60);
        unlocked.add(BadgeType.painTracking60);
      }
    }

    return unlocked;
  }

  /// Vérifie et débloque les achievements spéciaux
  Future<List<BadgeType>> checkSpecialAchievements() async {
    final unlocked = <BadgeType>[];
    final allReports = await _dailyRepo.getAll();
    
    if (allReports.isEmpty) return unlocked;

    // Première semaine
    final firstReport = allReports.last;
    final daysSinceFirst = DateTime.now().difference(firstReport.createdAt).inDays;
    
    if (daysSinceFirst >= 7 && allReports.length >= 5) {
      final isAlreadyUnlocked = await _achievementRepo.isUnlocked(BadgeType.firstWeek);
      if (!isAlreadyUnlocked) {
        await _achievementRepo.unlock(BadgeType.firstWeek);
        unlocked.add(BadgeType.firstWeek);
      }
    }

    // Premier mois
    if (daysSinceFirst >= 30 && allReports.length >= 20) {
      final isAlreadyUnlocked = await _achievementRepo.isUnlocked(BadgeType.firstMonth);
      if (!isAlreadyUnlocked) {
        await _achievementRepo.unlock(BadgeType.firstMonth);
        unlocked.add(BadgeType.firstMonth);
      }
    }

    // Régularité: 80% de remplissage sur le dernier mois
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));
    final monthReports = await _dailyRepo.getByDateRange(monthAgo, now);
    
    if (monthReports.length >= 24) { // 80% de 30 jours
      final isAlreadyUnlocked = await _achievementRepo.isUnlocked(BadgeType.consistent);
      if (!isAlreadyUnlocked) {
        await _achievementRepo.unlock(BadgeType.consistent);
        unlocked.add(BadgeType.consistent);
      }
    }

    return unlocked;
  }

  /// Vérifie tous les achievements possibles
  Future<List<BadgeType>> checkAllAchievements({int? currentStreak}) async {
    final allUnlocked = <BadgeType>[];

    if (currentStreak != null && currentStreak > 0) {
      allUnlocked.addAll(await checkStreakAchievements(currentStreak));
    }

    allUnlocked.addAll(await checkJournalAchievements());
    allUnlocked.addAll(await checkMealAchievements());
    allUnlocked.addAll(await checkPainTrackingAchievements());
    allUnlocked.addAll(await checkSpecialAchievements());

    return allUnlocked;
  }

  /// Obtient les statistiques d'achievements
  Future<AchievementStats> getStats() async {
    final totalUnlocked = await _achievementRepo.countUnlocked();
    final totalPossible = BadgeType.values.length;
    final unseen = await _achievementRepo.countUnseen();
    final allAchievements = await _achievementRepo.getAll();

    int commonCount = 0;
    int rareCount = 0;
    int epicCount = 0;
    int legendaryCount = 0;

    for (final achievement in allAchievements) {
      switch (achievement.badgeType.rarity) {
        case 1:
          commonCount++;
          break;
        case 2:
          rareCount++;
          break;
        case 3:
          epicCount++;
          break;
        case 4:
          legendaryCount++;
          break;
      }
    }

    return AchievementStats(
      totalUnlocked: totalUnlocked,
      totalPossible: totalPossible,
      unseenCount: unseen,
      commonCount: commonCount,
      rareCount: rareCount,
      epicCount: epicCount,
      legendaryCount: legendaryCount,
    );
  }
}

/// Statistiques d'achievements
class AchievementStats {
  final int totalUnlocked;
  final int totalPossible;
  final int unseenCount;
  final int commonCount;
  final int rareCount;
  final int epicCount;
  final int legendaryCount;

  AchievementStats({
    required this.totalUnlocked,
    required this.totalPossible,
    required this.unseenCount,
    required this.commonCount,
    required this.rareCount,
    required this.epicCount,
    required this.legendaryCount,
  });

  double get percentage => totalPossible > 0 ? (totalUnlocked / totalPossible) * 100 : 0;
}
