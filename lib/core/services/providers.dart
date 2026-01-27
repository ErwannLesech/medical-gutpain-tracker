import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_service.dart';
import '../database/repositories/repositories.dart';
import '../models/models.dart';
import 'achievement_service.dart';
import 'cat_reward_service.dart';

/// Provider du service de base de données
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

/// Provider du repository des repas
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du repository des événements de douleur
final painEventRepositoryProvider = Provider<PainEventRepository>((ref) {
  return PainEventRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du repository des rapports journaliers
final dailyReportRepositoryProvider = Provider<DailyReportRepository>((ref) {
  return DailyReportRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du repository des aliments
final foodItemRepositoryProvider = Provider<FoodItemRepository>((ref) {
  return FoodItemRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du repository des paramètres
final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du repository des achievements
final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du service des achievements
final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService(
    achievementRepo: ref.watch(achievementRepositoryProvider),
    dailyRepo: ref.watch(dailyReportRepositoryProvider),
    mealRepo: ref.watch(mealRepositoryProvider),
    painRepo: ref.watch(painEventRepositoryProvider),
  );
});

/// Provider for app settings (async)
final appSettingsProvider = FutureProvider<AppSettings?>((ref) async {
  final repository = ref.watch(appSettingsRepositoryProvider);
  return repository.get();
});

/// Provider for updating app settings
final appSettingsNotifierProvider = StateNotifierProvider<AppSettingsNotifier, AsyncValue<AppSettings?>>((ref) {
  return AppSettingsNotifier(ref.watch(appSettingsRepositoryProvider));
});

class AppSettingsNotifier extends StateNotifier<AsyncValue<AppSettings?>> {
  final AppSettingsRepository _repository;
  
  AppSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _repository.get();
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> updateSettings(AppSettings settings) async {
    try {
      await _repository.save(settings);
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Change le mode de thème
  Future<void> setThemeMode(ThemeMode mode) async {
    final current = state.valueOrNull ?? AppSettings();
    await updateSettings(current.copyWith(themeMode: mode));
  }
  
  /// Active/désactive le retour haptique
  Future<void> setHapticFeedback(bool enabled) async {
    final current = state.valueOrNull ?? AppSettings();
    await updateSettings(current.copyWith(hapticFeedback: enabled));
  }
  
  /// Réinitialise les paramètres
  Future<void> resetSettings() async {
    try {
      final settings = await _repository.reset();
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ==================== CAT REWARD PROVIDERS ====================

/// Provider du repository des chats découverts
final discoveredCatRepositoryProvider = Provider<DiscoveredCatRepository>((ref) {
  return DiscoveredCatRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du service de récompense de chats
final catRewardServiceProvider = Provider<CatRewardService>((ref) {
  return CatRewardService(
    repository: ref.watch(discoveredCatRepositoryProvider),
  );
});

/// Provider des statistiques de la galerie de chats
final catGalleryStatsProvider = FutureProvider<CatGalleryStats>((ref) async {
  final service = ref.watch(catRewardServiceProvider);
  return service.getGalleryStats();
});

/// Provider de tous les chats avec leur statut
final allCatsWithStatusProvider = FutureProvider<List<CatWithStatus>>((ref) async {
  final service = ref.watch(catRewardServiceProvider);
  return service.getAllCatsWithStatus();
});

/// Provider des chats découverts avec leurs données
final discoveredCatsProvider = FutureProvider<List<DiscoveredCatWithData>>((ref) async {
  final service = ref.watch(catRewardServiceProvider);
  return service.getDiscoveredCatsWithData();
});

/// Provider pour vérifier si un tirage peut être fait pour une date
final canDrawForDateProvider = FutureProvider.family<bool, DateTime>((ref, date) async {
  final service = ref.watch(catRewardServiceProvider);
  return service.canDrawForDate(date);
});
