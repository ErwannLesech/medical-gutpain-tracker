import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_service.dart';
import '../database/repositories/repositories.dart';
import '../models/models.dart';
import 'achievement_service.dart';
import 'cat_reward_service.dart';
import 'food_reward_service.dart';
import 'coin_service.dart';
import 'monthly_recap_service.dart';
import 'scene_service.dart';

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

/// Provider du repository de l'état de la liste de courses
final shoppingListStateRepositoryProvider = Provider<ShoppingListStateRepository>((ref) {
  return ShoppingListStateRepository(db: ref.watch(databaseServiceProvider));
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

/// Provider du repository des cartes de plats decouvertes
final discoveredFoodCardRepositoryProvider = Provider<DiscoveredFoodCardRepository>((ref) {
  return DiscoveredFoodCardRepository(db: ref.watch(databaseServiceProvider));
});

/// Provider du service de récompense de chats
final catRewardServiceProvider = Provider<CatRewardService>((ref) {
  return CatRewardService(
    repository: ref.watch(discoveredCatRepositoryProvider),
  );
});

/// Provider du service de recompense de plats
final foodRewardServiceProvider = Provider<FoodRewardService>((ref) {
  return FoodRewardService(
    repository: ref.watch(discoveredFoodCardRepositoryProvider),
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

// ==================== FOOD CARD REWARD PROVIDERS ====================

/// Provider des statistiques de la galerie de plats
final foodCardGalleryStatsProvider = FutureProvider<FoodCardGalleryStats>((ref) async {
  final service = ref.watch(foodRewardServiceProvider);
  return service.getGalleryStats();
});

/// Provider de toutes les cartes avec leur statut
final allFoodCardsWithStatusProvider = FutureProvider<List<FoodCardWithStatus>>((ref) async {
  final service = ref.watch(foodRewardServiceProvider);
  return service.getAllCardsWithStatus();
});

/// Provider des cartes decouvertes avec leurs donnees
final discoveredFoodCardsProvider = FutureProvider<List<DiscoveredFoodCardWithData>>((ref) async {
  final service = ref.watch(foodRewardServiceProvider);
  return service.getDiscoveredCardsWithData();
});

/// Provider pour verifier si un tirage peut etre fait pour une date
final canDrawFoodCardForDateProvider = FutureProvider.family<bool, DateTime>((ref, date) async {
  final service = ref.watch(foodRewardServiceProvider);
  return service.canDrawForDate(date);
});

// ==================== CATCOINS ====================

final coinRepositoryProvider = Provider<CoinRepository>((ref) {
  return CoinRepository(db: ref.watch(databaseServiceProvider));
});

final coinServiceProvider = Provider<CoinService>((ref) {
  return CoinService(coinRepo: ref.watch(coinRepositoryProvider));
});

/// Solde de Catcoins en temps réel
final coinBalanceProvider = StreamProvider<int>((ref) {
  return ref.watch(coinServiceProvider).watchBalance();
});

// ==================== BILAN MENSUEL ====================

final monthlyRecapServiceProvider = Provider<MonthlyRecapService>((ref) {
  return MonthlyRecapService(
    dailyRepo: ref.watch(dailyReportRepositoryProvider),
    painRepo: ref.watch(painEventRepositoryProvider),
    mealRepo: ref.watch(mealRepositoryProvider),
    catRepo: ref.watch(discoveredCatRepositoryProvider),
    foodCardRepo: ref.watch(discoveredFoodCardRepositoryProvider),
    settingsRepo: ref.watch(appSettingsRepositoryProvider),
    coinService: ref.watch(coinServiceProvider),
  );
});

/// Le bilan de ce mois a-t-il déjà été consulté jusqu'au bout ?
final recapSeenProvider = FutureProvider.family<bool, RecapMonth>((ref, month) {
  return ref.watch(coinServiceProvider).isRecapSeen(month.year, month.month);
});

// ==================== SCÈNES PUZZLE ====================

final scenePieceRepositoryProvider = Provider<ScenePieceRepository>((ref) {
  return ScenePieceRepository();
});

final sceneServiceProvider = Provider<SceneService>((ref) {
  return SceneService(
    repository: ref.watch(scenePieceRepositoryProvider),
    coinService: ref.watch(coinServiceProvider),
  );
});

/// Collection des scènes (débloquées ou « ? »)
final scenesProvider = FutureProvider<List<SceneStatus>>((ref) {
  return ref.watch(sceneServiceProvider).allScenes();
});

/// Scène en cours
/// (offre au passage les pièces de départ de la scène, une seule fois)
final currentSceneProvider = FutureProvider<SceneOverview>((ref) async {
  final service = ref.watch(sceneServiceProvider);
  final current = await service.currentScene();
  if (current.allDone || current.state.placedCount > 0 || current.state.inventoryCount > 0) {
    return current;
  }
  await service.ensureStarterPieces(current.def.id);
  return service.currentScene();
});
