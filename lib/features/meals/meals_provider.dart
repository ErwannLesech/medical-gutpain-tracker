import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/database/repositories/repositories.dart';
import '../../core/services/providers.dart';

/// État des repas pour une journée
class MealsState {
  final List<Meal> meals;
  final bool isLoading;
  final String? error;
  final DateTime selectedDate;

  const MealsState({
    this.meals = const [],
    this.isLoading = false,
    this.error,
    required this.selectedDate,
  });

  MealsState copyWith({
    List<Meal>? meals,
    bool? isLoading,
    String? error,
    DateTime? selectedDate,
  }) {
    return MealsState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

/// Notifier pour la gestion des repas
class MealsNotifier extends StateNotifier<MealsState> {
  final MealRepository _repository;
  final FoodItemRepository _foodRepository;

  MealsNotifier(this._repository, this._foodRepository)
      : super(MealsState(selectedDate: DateTime.now())) {
    loadMeals();
  }

  /// Charge les repas de la date sélectionnée
  Future<void> loadMeals() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final meals = await _repository.getByDate(state.selectedDate);
      state = state.copyWith(meals: meals, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Change la date sélectionnée
  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date);
    await loadMeals();
  }

  /// Crée un nouveau repas
  Future<Meal?> createMeal(Meal meal) async {
    try {
      final id = await _repository.create(meal);
      
      // Enregistre les aliments pour les suggestions
      for (final food in meal.foods) {
        await _foodRepository.recordConsumption(food);
      }
      
      await loadMeals();
      return meal..id = id;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Met à jour un repas
  Future<bool> updateMeal(Meal meal) async {
    try {
      await _repository.update(meal);
      
      // Enregistre les nouveaux aliments
      for (final food in meal.foods) {
        await _foodRepository.recordConsumption(food);
      }
      
      await loadMeals();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }



  /// Supprime un repas
  Future<bool> deleteMeal(int id) async {
    try {
      await _repository.delete(id);
      await loadMeals();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Génère les repas planifiés pour le jour sélectionné
  Future<void> generatePlannedMeals(AppSettings settings) async {
    final selectedDate = state.selectedDate;
    final existing = await _repository.getByDate(selectedDate);

    // Vérifie quels types de repas manquent
    final existingTypes = existing.map((m) => m.type).toSet();

    final mealsToCreate = <Meal>[];

    if (!existingTypes.contains(MealType.breakfast)) {
      mealsToCreate.add(Meal(
        plannedDateTime: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          settings.breakfastHour,
          settings.breakfastMinute,
        ),
        type: MealType.breakfast,
      ));
    }

    if (!existingTypes.contains(MealType.lunch)) {
      mealsToCreate.add(Meal(
        plannedDateTime: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          settings.lunchHour,
          settings.lunchMinute,
        ),
        type: MealType.lunch,
      ));
    }

    if (!existingTypes.contains(MealType.dinner)) {
      mealsToCreate.add(Meal(
        plannedDateTime: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          settings.dinnerHour,
          settings.dinnerMinute,
        ),
        type: MealType.dinner,
      ));
    }

    if (mealsToCreate.isNotEmpty) {
      await _repository.createMany(mealsToCreate);
      await loadMeals();
    }
  }
}

/// Provider des repas
final mealsProvider = StateNotifierProvider<MealsNotifier, MealsState>((ref) {
  return MealsNotifier(
    ref.watch(mealRepositoryProvider),
    ref.watch(foodItemRepositoryProvider),
  );
});

/// Provider des aliments suggérés
final suggestedFoodsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(foodItemRepositoryProvider);
  final items = await repository.getMostConsumed(limit: 30);
  return items.map((i) => i.name).toList();
});

/// Provider des aliments problématiques
final problematicFoodsProvider = FutureProvider<List<FoodItem>>((ref) async {
  final repository = ref.watch(foodItemRepositoryProvider);
  return await repository.getRiskyFoods();
});
