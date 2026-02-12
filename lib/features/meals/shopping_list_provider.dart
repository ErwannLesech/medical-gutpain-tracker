import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repositories/repositories.dart';
import '../../core/services/providers.dart';

/// État de la liste de courses
class ShoppingListState {
  final List<String> foods;
  final bool isLoading;
  final String? error;

  const ShoppingListState({
    this.foods = const [],
    this.isLoading = false,
    this.error,
  });

  ShoppingListState copyWith({
    List<String>? foods,
    bool? isLoading,
    String? error,
  }) {
    return ShoppingListState(
      foods: foods ?? this.foods,
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
}

/// Provider de la liste de courses
final shoppingListProvider = StateNotifierProvider<ShoppingListNotifier, ShoppingListState>((ref) {
  return ShoppingListNotifier(
    ref.watch(mealRepositoryProvider),
  );
});
