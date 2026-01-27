import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repositories/repositories.dart';
import '../../core/services/providers.dart';
import '../../core/services/achievement_service.dart';
import '../../core/models/achievement.dart';

/// Provider pour le nombre de jours consécutifs avec journal rempli
final consecutiveDaysProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(dailyReportRepositoryProvider);
  
  int streak = 0;
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  
  // Vérifie d'abord si le journal d'aujourd'hui est rempli
  final todayReport = await repository.getByDate(today);
  if (todayReport != null) {
    streak++;
  }
  
  // Compte les jours consécutifs à partir d'hier
  DateTime currentDate = today.subtract(const Duration(days: 1));
  
  while (true) {
    final report = await repository.getByDate(currentDate);
    
    if (report == null) {
      break;
    }
    
    streak++;
    currentDate = currentDate.subtract(const Duration(days: 1));
  }
  
  return streak;
});

/// Provider pour le nombre de repas programmés à partir d'aujourd'hui
final upcomingMealsCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(mealRepositoryProvider);
  
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  // Récupère tous les repas
  final allMeals = await repository.getAll();
  
  // Compte les repas programmés (date future)
  int count = 0;
  for (final meal in allMeals) {
    final mealDate = DateTime(meal.plannedDateTime.year, meal.plannedDateTime.month, meal.plannedDateTime.day);
    if (mealDate.isAfter(today) || (mealDate.isAtSameMomentAs(today) && meal.plannedDateTime.isAfter(now))) {
      count++;
    }
  }
  
  return count;
});

/// Provider pour tous les achievements
final allAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final repository = ref.watch(achievementRepositoryProvider);
  return await repository.getAll();
});

/// Provider pour les achievements non vus
final unseenAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final repository = ref.watch(achievementRepositoryProvider);
  return await repository.getUnseen();
});

/// Provider pour les statistiques d'achievements
final achievementStatsProvider = FutureProvider<AchievementStats>((ref) async {
  final service = ref.watch(achievementServiceProvider);
  return await service.getStats();
});

/// Provider pour vérifier et déverrouiller les achievements après une action
final checkAchievementsProvider = FutureProvider.family<List<BadgeType>, int?>((ref, currentStreak) async {
  final service = ref.watch(achievementServiceProvider);
  return await service.checkAllAchievements(currentStreak: currentStreak);
});

/// Notifier pour marquer les achievements comme vus
class AchievementNotifier extends StateNotifier<AsyncValue<void>> {
  final AchievementRepository _repository;

  AchievementNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> markAsSeen(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAsSeen(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsSeen() async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAllAsSeen();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final achievementNotifierProvider = StateNotifierProvider<AchievementNotifier, AsyncValue<void>>((ref) {
  return AchievementNotifier(ref.watch(achievementRepositoryProvider));
});
