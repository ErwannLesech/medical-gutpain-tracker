import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repositories/repositories.dart';
import '../../core/models/models.dart';
import '../../core/services/providers.dart';

/// État de la liste de courses
class ShoppingListState {
  final Map<String, int> foods; // Map avec aliment -> nombre d'occurrences
  final Set<String> checkedItems; // Aliments marqués comme achetés
  final bool isLoading;
  final String? error;

  const ShoppingListState({
    this.foods = const {},
    this.checkedItems = const {},
    this.isLoading = false,
    this.error,
  });

  ShoppingListState copyWith({
    Map<String, int>? foods,
    Set<String>? checkedItems,
    bool? isLoading,
    String? error,
  }) {
    return ShoppingListState(
      foods: foods ?? this.foods,
      checkedItems: checkedItems ?? this.checkedItems,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier pour la liste de courses
class ShoppingListNotifier extends StateNotifier<ShoppingListState> {
  final MealRepository _repository;

  ShoppingListNotifier(this._repository) : super(const ShoppingListState()) {
    loadShoppingList();
  }

  /// Charge la liste de courses (tous les aliments des repas futurs)
  Future<void> loadShoppingList() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final foods = await _repository.getFutureFoods();
      state = state.copyWith(foods: foods, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Bascule l'état coché d'un aliment
  void toggleCheckedItem(String food) {
    final updatedChecked = Set<String>.from(state.checkedItems);
    if (updatedChecked.contains(food)) {
      updatedChecked.remove(food);
    } else {
      updatedChecked.add(food);
    }
    state = state.copyWith(checkedItems: updatedChecked);
  }

  /// Récupère les repas futurs qui contiennent l'aliment donné
  Future<List<Meal>> getMealsForFood(String food) async {
    return await _repository.getByFood(food)
        .then((meals) => meals
            .where((meal) => meal.plannedDateTime.isAfter(DateTime.now()))
            .toList()
            ..sort((a, b) => a.plannedDateTime.compareTo(b.plannedDateTime)));
  }
}

/// Provider de la liste de courses
final shoppingListProvider = StateNotifierProvider<ShoppingListNotifier, ShoppingListState>((ref) {
  return ShoppingListNotifier(
    ref.watch(mealRepositoryProvider),
  );
});
